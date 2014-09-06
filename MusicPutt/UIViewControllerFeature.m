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

@interface UIViewControllerFeature ()  <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, ITunesFeedsApiDelegate>
{
    UIBarButtonItem* editButton;
    NSArray *sortedSongsArray;
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
    [_itunes queryFeedType:QueryTopAlbums forCountry:@"ca" size:10 genre:0 asynchronizationMode:true];
    
    // load most recent songs
    sortedSongsArray = [[NSArray alloc] init];
    [self loadMostRecentSongs];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // load most recent songs
    [self loadMostRecentSongs];
    
    // itunes feeds load
    [_itunes queryFeedType:QueryTopAlbums forCountry:@"ca" size:10 genre:0 asynchronizationMode:true];
    
    [_tableView reloadData];
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
        [[cell desc] setText:@"Create custom playlist based on your preference"];
        
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
        
        // image 2
        MPMediaItem* song2 = [sortedSongsArray objectAtIndex:1];
        UIImage* image2;
        MPMediaItemArtwork *artwork2 = [song2 valueForProperty:MPMediaItemPropertyArtwork];
        if (artwork2)
            image2 = [artwork2 imageWithSize:[[cell image2] frame].size];
        if (image2.size.height>0 && image2.size.width>0) // check if image present
            [[cell image2] setImage:image2];
        else
            [[cell image2] setImage:[UIImage imageNamed:@"empty"]];
        
        // image 3
        MPMediaItem* song3 = [sortedSongsArray objectAtIndex:2];
        UIImage* image3;
        MPMediaItemArtwork *artwork3 = [song3 valueForProperty:MPMediaItemPropertyArtwork];
        if (artwork3)
            image3 = [artwork3 imageWithSize:[[cell image3] frame].size];
        if (image3.size.height>0 && image3.size.width>0) // check if image present
            [[cell image3] setImage:image3];
        else
            [[cell image3] setImage:[UIImage imageNamed:@"empty"]];
        
        // image 4
        MPMediaItem* song4 = [sortedSongsArray objectAtIndex:3];
        UIImage* image4;
        MPMediaItemArtwork *artwork4 = [song4 valueForProperty:MPMediaItemPropertyArtwork];
        if (artwork4)
            image4 = [artwork4 imageWithSize:[[cell image4] frame].size];
        if (image4.size.height>0 && image4.size.width>0) // check if image present
            [[cell image4] setImage:image4];
        else
            [[cell image4] setImage:[UIImage imageNamed:@"empty"]];
        
    }
    else if (indexPath.row==1)
    {
        [[cell title] setText:@"Discover"];
        [[cell desc] setText:@"Music popular right now in the world"];
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
        if (cell) {
            
            // image 1
            ITunesAlbum* album = [results objectAtIndex:0];
            id path = [album artworkUrl100];
            NSURL *url = [NSURL URLWithString:path];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *sharedImage = [[UIImage alloc] initWithData:data];
            [[cell image1] setImage:sharedImage];
            
            // image 2
            ITunesAlbum* album2 = [results objectAtIndex:1];
            id path2 = [album2 artworkUrl100];
            NSURL *url2 = [NSURL URLWithString:path2];
            NSData *data2 = [NSData dataWithContentsOfURL:url2];
            UIImage *sharedImage2 = [[UIImage alloc] initWithData:data2];
            [[cell image2] setImage:sharedImage2];
            
            // image 3
            ITunesAlbum* album3 = [results objectAtIndex:2];
            id path3 = [album3 artworkUrl100];
            NSURL *url3 = [NSURL URLWithString:path3];
            NSData *data3 = [NSData dataWithContentsOfURL:url3];
            UIImage *sharedImage3 = [[UIImage alloc] initWithData:data3];
            [[cell image3] setImage:sharedImage3];
            
            // image 4
            ITunesAlbum* album4 = [results objectAtIndex:3];
            id path4 = [album4 artworkUrl100];
            NSURL *url4 = [NSURL URLWithString:path4];
            NSData *data4 = [NSData dataWithContentsOfURL:url4];
            UIImage *sharedImage4 = [[UIImage alloc] initWithData:data4];
            [[cell image4] setImage:sharedImage4];
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
