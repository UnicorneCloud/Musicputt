//
//  UIViewControllerStoreFeature
//
//  Created by Eric Pinet on 2014-07-01.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerFeature.h"
#import "UIScrollView+EmptyDataSet.h"
#import "UIViewControllerPlaylist.h"
#import "UITableViewCellFeature.h"
#import "ITunesAlbum.h"
#import "ITunesFeedsApi.h"
#import "AppDelegate.h"

#define MUSICPUTT_PLAY_PREFERED         @"Play with my prefered"
#define MUSICPUTT_PLAY_LASTEST          @"Play lastest playlist"
#define MUSICPUTT_CREATE_NEW_PLAYLIST   @"Create new playlist"

#define DISCOVER_SEE_WHATS_NEW          @"See what's hot"
#define DISCOVER_PLAY_WHATS_NEW         @"Play what's hot"



@interface UIViewControllerFeature ()  <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, ITunesFeedsApiDelegate, UIActionSheetDelegate>
{
    UIBarButtonItem* editButton;
    NSArray *sortedSongsArray;
    NSArray *topRates;
    
    NSInteger currentMusicPuttUpdate;
    NSInteger currentMusicPuttStep;
    
    NSInteger currentTopRateUpdate;
    NSInteger currentTopRateStep;
    
    NSTimer *timerMusicPutt;
    NSTimer *timerTopRate;
}

@property (weak, nonatomic) IBOutlet UITableView*            tableView;
@property AppDelegate* del;
@property ITunesFeedsApi* itunes;

@end

@implementation UIViewControllerFeature

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // setup app delegate
    self.del = [[UIApplication sharedApplication] delegate];
    
    // setup title
    [self setTitle:@"Feature"];
    
    // setup tableview
    toolbarTableView = _tableView;
    
    // init itunes feeds api
    _itunes = [[ITunesFeedsApi alloc] init];
    [_itunes setDelegate:self];
    [_itunes queryFeedType:QueryTopAlbums forCountry:[[NSLocale currentLocale] objectForKey: NSLocaleCountryCode] size:25 genre:0 asynchronizationMode:true];
    
    // load most recent songs
    sortedSongsArray = [[NSArray alloc] init];
    [self loadMostRecentSongs];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    timerMusicPutt = [NSTimer scheduledTimerWithTimeInterval:4.5
                                             target:self
                                           selector:@selector(nextMusicputt)
                                           userInfo: nil
                                            repeats:YES];
    
    timerTopRate = [NSTimer scheduledTimerWithTimeInterval:10
                                                      target:self
                                                    selector:@selector(nextTopRate)
                                                    userInfo: nil
                                                     repeats:YES];
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [timerMusicPutt invalidate];
    [timerTopRate invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadMostRecentSongs
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Start order");
    
    NSTimeInterval start  = [[NSDate date] timeIntervalSince1970];
    
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    NSArray *songsArray = [songsQuery items];
    
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:MPMediaItemPropertyLastPlayedDate
                                                             ascending:NO];
    sortedSongsArray = [songsArray sortedArrayUsingDescriptors:@[sorter]];
    
    NSTimeInterval finish = [[NSDate date] timeIntervalSince1970];
    
    
    NSLog(@" %s - %@ %f secondes\n", __PRETTY_FUNCTION__, @"Finish ordering took", finish - start);
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"End order");
}

-(void) updateMusicPuttImage:(UITableViewCellFeature*)currentLoadingCell
{
    UITableViewCellFeature* cell = nil;
    
    // check if there is at less 4 songs for display
    if (sortedSongsArray.count>=4)
    {
        currentMusicPuttUpdate = 4;
        currentMusicPuttStep = 0;
        
        if (currentLoadingCell != nil)
        {
            cell = currentLoadingCell;
        }
        else
        {
            cell = (UITableViewCellFeature*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
        
        if (cell)
        {
            int nbtry = 0;
            int nbtrymax = 64;
            bool accept = false;
            // image 1
            MPMediaItem* song1 = [sortedSongsArray objectAtIndex:0];
            UIImage* image1;
            MPMediaItemArtwork *artwork1 = [song1 valueForProperty:MPMediaItemPropertyArtwork];
            if (artwork1)
                image1 = [artwork1 imageWithSize:[[cell image1] frame].size];
            if (image1.size.height>0 && image1.size.width>0) // check if image present
                [[cell image1] setImage:image1];
            else
                [[cell image1] setImage:[UIImage imageNamed:@"empty"]];
            
            // albumUid 1
            cell.albumUid1 = [song1 valueForProperty:MPMediaItemPropertyAlbumPersistentID];
            
            // image 2
            MPMediaItem* song2 = [sortedSongsArray objectAtIndex:1];
            do {
                // check if album artwork is already display in other image
                // in this cell. If album is already display, skip the songs
                if ([cell.albumUid1 isEqualToNumber: [song2 valueForProperty:MPMediaItemPropertyAlbumPersistentID]] ||
                    [cell.albumUid2 isEqualToNumber: [song2 valueForProperty:MPMediaItemPropertyAlbumPersistentID]] ||
                    [cell.albumUid3 isEqualToNumber: [song2 valueForProperty:MPMediaItemPropertyAlbumPersistentID]] ||
                    [cell.albumUid4 isEqualToNumber: [song2 valueForProperty:MPMediaItemPropertyAlbumPersistentID]])
                {
                    // skip songs
                    nbtry++;
                    if (currentMusicPuttUpdate + currentMusicPuttStep + nbtry < sortedSongsArray.count) {
                        song2 = [sortedSongsArray objectAtIndex:currentMusicPuttUpdate + currentMusicPuttStep + nbtry];
                    }
                    else{
                        // accept song because no more
                        // song in the array
                        accept = true;
                    }
                }
                else
                {
                    // accept song
                    accept =true;
                }
            } while (accept == false && nbtry<=nbtrymax);
            
            accept = false;
            nbtry = 0;
            
            UIImage* image2;
            MPMediaItemArtwork *artwork2 = [song2 valueForProperty:MPMediaItemPropertyArtwork];
            if (artwork2)
                image2 = [artwork2 imageWithSize:[[cell image2] frame].size];
            if (image2.size.height>0 && image2.size.width>0) // check if image present
                [[cell image2] setImage:image2];
            else
                [[cell image2] setImage:[UIImage imageNamed:@"empty"]];
            
            // albumUid 2
            cell.albumUid2 = [song2 valueForProperty:MPMediaItemPropertyAlbumPersistentID];
            
            // image 3
            MPMediaItem* song3 = [sortedSongsArray objectAtIndex:2];
            do {
                // check if album artwork is already display in other image
                // in this cell. If album is already display, skip the songs
                if ([cell.albumUid1 isEqualToNumber: [song3 valueForProperty:MPMediaItemPropertyAlbumPersistentID]] ||
                    [cell.albumUid2 isEqualToNumber: [song3 valueForProperty:MPMediaItemPropertyAlbumPersistentID]] ||
                    [cell.albumUid3 isEqualToNumber: [song3 valueForProperty:MPMediaItemPropertyAlbumPersistentID]] ||
                    [cell.albumUid4 isEqualToNumber: [song3 valueForProperty:MPMediaItemPropertyAlbumPersistentID]])
                {
                    // skip songs
                    nbtry++;
                    if (currentMusicPuttUpdate + currentMusicPuttStep + nbtry < sortedSongsArray.count) {
                        song3 = [sortedSongsArray objectAtIndex:currentMusicPuttUpdate + currentMusicPuttStep + nbtry];
                    }
                    else{
                        // accept song because no more
                        // song in the array
                        accept = true;
                    }
                }
                else
                {
                    // accept song
                    accept =true;
                }
            } while (accept == false && nbtry<=nbtrymax);
            
            accept = false;
            nbtry = 0;
        
            UIImage* image3;
            MPMediaItemArtwork *artwork3 = [song3 valueForProperty:MPMediaItemPropertyArtwork];
            if (artwork3)
                image3 = [artwork3 imageWithSize:[[cell image3] frame].size];
            if (image3.size.height>0 && image3.size.width>0) // check if image present
                [[cell image3] setImage:image3];
            else
                [[cell image3] setImage:[UIImage imageNamed:@"empty"]];
            
            // albumUid 3
            cell.albumUid3 = [song3 valueForProperty:MPMediaItemPropertyAlbumPersistentID];
            
            // image 4
            MPMediaItem* song4 = [sortedSongsArray objectAtIndex:3];
            do {
                // check if album artwork is already display in other image
                // in this cell. If album is already display, skip the songs
                if ([cell.albumUid1 isEqualToNumber: [song4 valueForProperty:MPMediaItemPropertyAlbumPersistentID]] ||
                    [cell.albumUid2 isEqualToNumber: [song4 valueForProperty:MPMediaItemPropertyAlbumPersistentID]] ||
                    [cell.albumUid3 isEqualToNumber: [song4 valueForProperty:MPMediaItemPropertyAlbumPersistentID]] ||
                    [cell.albumUid4 isEqualToNumber: [song4 valueForProperty:MPMediaItemPropertyAlbumPersistentID]])
                {
                    // skip songs
                    nbtry++;
                    if (currentMusicPuttUpdate + currentMusicPuttStep + nbtry < sortedSongsArray.count) {
                        song4 = [sortedSongsArray objectAtIndex:currentMusicPuttUpdate + currentMusicPuttStep + nbtry];
                    }
                    else{
                        // accept song because no more
                        // song in the array
                        accept = true;
                    }
                }
                else
                {
                    // accept song
                    accept =true;
                }
            } while (accept == false && nbtry<=nbtrymax);
            
            accept = false;
            nbtry = 0;
            
            UIImage* image4;
            MPMediaItemArtwork *artwork4 = [song4 valueForProperty:MPMediaItemPropertyArtwork];
            if (artwork4)
                image4 = [artwork4 imageWithSize:[[cell image4] frame].size];
            if (image4.size.height>0 && image4.size.width>0) // check if image present
                [[cell image4] setImage:image4];
            else
                [[cell image4] setImage:[UIImage imageNamed:@"empty"]];
            
            // albumUid 4
            cell.albumUid4 = [song4 valueForProperty:MPMediaItemPropertyAlbumPersistentID];
        }
    }
}

- (void) nextMusicputt
{
    UITableViewCellFeature* cell = (UITableViewCellFeature*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if(cell && sortedSongsArray.count>=4)
    {
        bool accept = false;
        int nbtry = 0;
        int nbtrymax = 64;
        
        if(currentMusicPuttUpdate == 64){
            currentMusicPuttUpdate = 4;
        }
        
        if (currentMusicPuttStep==4) {
            currentMusicPuttStep = 1;
            currentMusicPuttUpdate = currentMusicPuttUpdate + 4;
        }
        else{
            currentMusicPuttStep++;
        }
        
        if (currentMusicPuttUpdate + currentMusicPuttStep > sortedSongsArray.count) {
            currentMusicPuttUpdate = 4;
            currentMusicPuttStep = 1;
        }
        MPMediaItem* song = [sortedSongsArray objectAtIndex:currentMusicPuttUpdate + currentMusicPuttStep];
        UIImage* image;
        MPMediaItemArtwork *artwork = nil;
        
        do {
            // check if album artwork is already display in other image
            // in this cell. If album is already display, skip the songs
            if ([cell.albumUid1 isEqualToNumber: [song valueForProperty:MPMediaItemPropertyAlbumPersistentID]] ||
                [cell.albumUid2 isEqualToNumber: [song valueForProperty:MPMediaItemPropertyAlbumPersistentID]] ||
                [cell.albumUid3 isEqualToNumber: [song valueForProperty:MPMediaItemPropertyAlbumPersistentID]] ||
                [cell.albumUid4 isEqualToNumber: [song valueForProperty:MPMediaItemPropertyAlbumPersistentID]])
            {
                // skip songs
                nbtry++;
                if (currentMusicPuttUpdate + currentMusicPuttStep + nbtry < sortedSongsArray.count) {
                    song = [sortedSongsArray objectAtIndex:currentMusicPuttUpdate + currentMusicPuttStep + nbtry];
                }
                else{
                    // accept song because no more
                    // song in the array
                    accept = true;
                }
            }
            else
            {
                // accept song
                accept =true;
            }
        } while (accept == false && nbtry<=nbtrymax);
        
        
        
        // cell update
        UIImageView* imageToUpdate = nil;
        if (currentMusicPuttStep==1) {
            imageToUpdate = cell.image1;
        }
        else if (currentMusicPuttStep==2){
            imageToUpdate = cell.image2;
        }
        else if (currentMusicPuttStep==3){
            imageToUpdate = cell.image3;
        }
        else if (currentMusicPuttStep==4){
            imageToUpdate = cell.image4;
        }
        
        artwork = [song valueForProperty:MPMediaItemPropertyArtwork];
        if (artwork)
            image = [artwork imageWithSize:[imageToUpdate frame].size];
        
        UIImage* newImage = nil;
        if (image.size.height>0 && image.size.width>0) // check if image present
            newImage = image;
        else
            newImage = [UIImage imageNamed:@"empty"];
        
        
        [UIView transitionWithView:imageToUpdate
                          duration:0.6
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            //  Set the new image
                            //  Since its done in animation block, the change will be animated
                            imageToUpdate.image = newImage;
                        } completion:^(BOOL finished) {
                            //  Do whatever when the animation is finished
                        }];
        
        // albumUid
        if (currentMusicPuttStep==1) {
            cell.albumUid1 = [song valueForProperty:MPMediaItemPropertyAlbumPersistentID];
        }
        else if (currentMusicPuttStep==2){
            cell.albumUid2 = [song valueForProperty:MPMediaItemPropertyAlbumPersistentID];
        }
        else if (currentMusicPuttStep==3){
            cell.albumUid3= [song valueForProperty:MPMediaItemPropertyAlbumPersistentID];
        }
        else if (currentMusicPuttStep==4){
            cell.albumUid4 = [song valueForProperty:MPMediaItemPropertyAlbumPersistentID];
        }
        
    }
}

- (void) nextTopRate
{
    UITableViewCellFeature* cell = (UITableViewCellFeature*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if(cell)
    {
        if(currentTopRateUpdate == 16){
            currentTopRateUpdate = 4;
        }
        
        if (currentTopRateStep==4) {
            currentTopRateStep = 1;
            currentTopRateUpdate = currentTopRateUpdate + 4;
        }
        else{
            currentTopRateStep++;
        }
        
        if (currentTopRateUpdate + currentTopRateStep <= sortedSongsArray.count) {
            
        }
        else{
            currentTopRateUpdate = 4;
            currentTopRateStep = 1;
        }
        
        // cell update
        UIImageView* imageToUpdate = nil;
        if (currentTopRateStep==1) {
            imageToUpdate = cell.image1;
        }
        else if (currentTopRateStep==2){
            imageToUpdate = cell.image2;
        }
        else if (currentTopRateStep==3){
            imageToUpdate = cell.image3;
        }
        else if (currentTopRateStep==4){
            imageToUpdate = cell.image4;
        }
        
        ITunesAlbum* album = [topRates objectAtIndex:currentTopRateUpdate + currentTopRateStep];
        id path = [album artworkUrl100];
        NSURL *url = [NSURL URLWithString:path];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *newImage = [[UIImage alloc] initWithData:data];
        
        [UIView transitionWithView:imageToUpdate
                          duration:0.6
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            //  Set the new image
                            //  Since its done in animation block, the change will be animated
                            imageToUpdate.image = newImage;
                        } completion:^(BOOL finished) {
                            //  Do whatever when the animation is finished
                        }];
        
        // albumUid
        if (currentTopRateStep==1) {
            cell.collectionId1 = [album collectionId];
        }
        else if (currentTopRateStep==2){
            cell.collectionId1 = [album collectionId];
        }
        else if (currentTopRateStep==3){
            cell.collectionId1 = [album collectionId];
        }
        else if (currentTopRateStep==4){
            cell.collectionId1 = [album collectionId];
        }
    }
}


#pragma mark - AMWaveViewController

- (NSArray*)visibleCells
{
    return [self.tableView visibleCells];
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


- (UITableViewCellFeature*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Start cellForRowAtIndexPath");
    
    UITableViewCellFeature* cell = [tableView dequeueReusableCellWithIdentifier:@"CellFeature"];
    if (indexPath.row==0)
    {
        [[cell title] setText:@"+ musicputt"];
        [[cell desc] setText:@"Click here for more action ...\nYou can create custom playlist."];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.parentView = self.view;
        cell.parentNavCtrl = self.navigationController;
        cell.type = TypeMusicPutt;
        
        [self updateMusicPuttImage:cell];
        
    }
    else if (indexPath.row==1)
    {
        [[cell title] setText:@"+ discover"];
        [[cell desc] setText:@"Click here for more action ...\nYou can listen what's hot today."];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.parentView = self.view;
        cell.parentNavCtrl = self.navigationController;
        cell.type = TypeDiscover;
    }
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"End cellForRowAtIndexPath");
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

#pragma mark - ITunesFeedsApiDelegate

-(void) queryResult:(ITunesFeedsApiQueryStatus)status type:(ITunesFeedsQueryType)type results:(NSArray*)results
{
    if (status == StatusSucceed) {
        
        // load images from itunes store
        UITableViewCellFeature* cell = (UITableViewCellFeature*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        if (cell && results.count>=4) {
            
            currentTopRateUpdate = 4;
            currentTopRateStep = 0;
            
            topRates = results;
            
            // image 1
            ITunesAlbum* album = [results objectAtIndex:0];
            id path = [album artworkUrl100];
            NSURL *url = [NSURL URLWithString:path];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *sharedImage = [[UIImage alloc] initWithData:data];
            [[cell image1] setImage:sharedImage];
            cell.collectionId1 = [album collectionId];
            
            // image 2
            ITunesAlbum* album2 = [results objectAtIndex:1];
            id path2 = [album2 artworkUrl100];
            NSURL *url2 = [NSURL URLWithString:path2];
            NSData *data2 = [NSData dataWithContentsOfURL:url2];
            UIImage *sharedImage2 = [[UIImage alloc] initWithData:data2];
            [[cell image2] setImage:sharedImage2];
            cell.collectionId2 = [album2 collectionId];
            
            // image 3
            ITunesAlbum* album3 = [results objectAtIndex:2];
            id path3 = [album3 artworkUrl100];
            NSURL *url3 = [NSURL URLWithString:path3];
            NSData *data3 = [NSData dataWithContentsOfURL:url3];
            UIImage *sharedImage3 = [[UIImage alloc] initWithData:data3];
            [[cell image3] setImage:sharedImage3];
            cell.collectionId3 = [album3 collectionId];
            
            // image 4
            ITunesAlbum* album4 = [results objectAtIndex:3];
            id path4 = [album4 artworkUrl100];
            NSURL *url4 = [NSURL URLWithString:path4];
            NSData *data4 = [NSData dataWithContentsOfURL:url4];
            UIImage *sharedImage4 = [[UIImage alloc] initWithData:data4];
            [[cell image4] setImage:sharedImage4];
            cell.collectionId4 = [album4 collectionId];
        }
    }
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
