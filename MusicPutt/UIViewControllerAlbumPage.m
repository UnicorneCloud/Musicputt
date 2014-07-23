//
//  UIViewControllerAlbumPage.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-07-19.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerAlbumPage.h"
#import "AppDelegate.h"
#import "UITableViewCellAlbumPageSong.h"
#import "MPServiceStore.h"

#import <MediaPlayer/MediaPlayer.h>

@interface UIViewControllerAlbumPage () <UITableViewDelegate, UITableViewDataSource, MPServiceStoreDelegate>
{
    MPMediaQuery* everything;                   // result of current query
    NSNumber *fullLength;
    MPMediaItem* currentplayingitem;
}

@property AppDelegate* del;

@property (weak, nonatomic) IBOutlet UIImageView* imageview;

@property (weak, nonatomic) IBOutlet UILabel* albumname;

@property (weak, nonatomic) IBOutlet UILabel* albumlink;

@property (weak, nonatomic) IBOutlet UILabel* trackandduration;

@property (weak, nonatomic) IBOutlet UILabel* year;

@property (weak, nonatomic) IBOutlet UILabel* price;

@property (weak, nonatomic) IBOutlet UILabel* genre;

@property (weak, nonatomic) IBOutlet UITableView* songstable;

@end

@implementation UIViewControllerAlbumPage

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
    
    // Create blur effect
    UIToolbar *blurtoolbar = [[UIToolbar alloc] initWithFrame:self.view.frame];
    self.view.backgroundColor = [UIColor clearColor];
    blurtoolbar.autoresizingMask = self.view.autoresizingMask;
    [self.view insertSubview:blurtoolbar atIndex:0];
    
    [_songstable setBackgroundColor:[UIColor clearColor]];
    
    _albumname.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureAlbum = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(albumPressed)];
    [_albumname addGestureRecognizer:tapGestureAlbum];
    
    _albumlink.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureLink = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(albumPressed)];
    [_albumlink addGestureRecognizer:tapGestureLink];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // set current playing media
    currentplayingitem = [[[self.del mpdatamanager] musicplayer] nowPlayingItem];
    
    // reset information from store
    _year.text = @"";
    _genre.text = @"";
    _price.text = @"";
    
    // query store for album information
    MPServiceStore *store = [[MPServiceStore alloc]init];
    NSString* searchTerm = [store buildSearchTermFromMediaItem:currentplayingitem];
    [store queryMusicTrackWithSearchTerm:searchTerm setDelegate:self];
    
    // query album media on device
    everything = [MPMediaQuery albumsQuery];
    MPMediaPropertyPredicate *albumPredicate =  [MPMediaPropertyPredicate predicateWithValue:[currentplayingitem valueForProperty:MPMediaItemPropertyAlbumPersistentID]
                                                                                 forProperty:MPMediaItemPropertyAlbumPersistentID
                                                                              comparisonType:MPMediaPredicateComparisonEqualTo];
    [everything addFilterPredicate:albumPredicate];
    
    
    // Image of album's cover.
    UIImage* image;
    MPMediaItemArtwork *artwork = [currentplayingitem valueForProperty:MPMediaItemPropertyArtwork];
    if (artwork)
        image = [artwork imageWithSize:[_imageview frame].size];
    if (image.size.height>0 && image.size.width>0) // check if image present
        [_imageview setImage:image];
    else
        [_imageview setImage:[UIImage imageNamed:@"empty"]];
    
    
    // Album's name.
    _albumname.text = [currentplayingitem valueForProperty:MPMediaItemPropertyAlbumTitle];
    
    NSNumber *trackCount = [NSNumber numberWithInteger:([[[everything collections][0] items] count])];
    if (trackCount > 0)
    {
        _trackandduration.text = [trackCount.stringValue stringByAppendingString:@" tracks"];
    }
    else
    {
        _trackandduration.text = @"";
    }
    
    // Album's duration.
    NSString *strLength = [self fullAlbumLength:0];
    if (strLength != nil)
    {
        if(trackCount > 0)
        {
            _trackandduration.text = [_trackandduration.text stringByAppendingString: @", "];
        }
        _trackandduration.text = [_trackandduration.text stringByAppendingString: strLength];
    }
    
    [_songstable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  Number of section in the table view.
 *
 *  @param tableView :
 *
 *  @return          : Number of section.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[everything collections] count];
}

/**
 *  The number of rows in the specified section.
 *
 *  @param tableView <#tableView description#>
 *  @param section   : Section's index.
 *
 *  @return          : Number of row of this section.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[everything collections][section] count] ;
}

/**
 *  Return the cell at a specified location in the talbe view.
 *
 *  @param tableView :
 *  @param indexPath : The path to the cell.
 *
 *  @return
 */
- (UITableViewCellAlbumPageSong*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellAlbumPageSong* cell = [tableView dequeueReusableCellWithIdentifier:@"CellSong"];
    [cell setMediaItem:[[everything collections][indexPath.section] items][indexPath.row]];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}
 
/**
 *  Calculate the playback duration of full album.
 *
 *  @param indexAlbum : Album index or section.
 *
 *  @return           : The full duration of the album.
 */
- (NSString*)fullAlbumLength:(NSInteger)indexAlbum
{
    fullLength = 0;
    [[[everything collections][indexAlbum] items] enumerateObjectsUsingBlock:^(MPMediaItem *songItem, NSUInteger idx, BOOL *stop) {
        fullLength = @([fullLength floatValue] + [[songItem valueForProperty:MPMediaItemPropertyPlaybackDuration] floatValue]);
    }];
    
    int fullMinutes = trunc([fullLength floatValue]) / 60;
    
    NSString* length = [NSString stringWithFormat:@"%d mins",fullMinutes];
    return length;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    UITableViewCellAlbumPageSong* cell = (UITableViewCellAlbumPageSong*)[self tableView:_songstable cellForRowAtIndexPath:indexPath];
    
    NSMutableArray* list = [[NSMutableArray alloc] init];
    NSInteger step = 0;
    NSInteger maxstep = [[everything collections][indexPath.section] count];
    NSInteger pos = indexPath.row;
    
    while (step<maxstep) {
        [list addObject: [[[everything collections][indexPath.section] items] objectAtIndex:pos]];
        step++;
        pos++;
        if(pos == [[everything collections][indexPath.section] count])
            pos=0;
    }
    
    [[[self.del mpdatamanager] musicplayer] stop];
    
    BOOL shuffleWasOn = NO;
    if ([[self.del mpdatamanager] musicplayer].shuffleMode != MPMusicShuffleModeOff &&
        [[self.del mpdatamanager] musicplayer].shuffleMode != MPMusicShuffleModeDefault)
    {
        [[self.del mpdatamanager] musicplayer].shuffleMode = MPMusicShuffleModeOff;
        shuffleWasOn = YES;
    }
    [[[self.del mpdatamanager] musicplayer] setQueueWithItemCollection:[MPMediaItemCollection collectionWithItems:list]];
    [[[self.del mpdatamanager] musicplayer] setNowPlayingItem:[cell getMediaItem]];
    if (shuffleWasOn)
        [[self.del mpdatamanager] musicplayer].shuffleMode = MPMusicShuffleModeSongs;
    
    [[[self.del mpdatamanager] musicplayer] play];
    
    self.del.mpdatamanager.currentSonglist = list;
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Completed");
    
    return indexPath;
}

-(void) albumPressed
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Completed");
    
    
}

/**
 *  Implement this methode for recieve result after query.
 *
 *  @param status  Status of the querys
 *  @param type    Type of query sender
 *  @param results resultset of the query
 */
-(void) queryResult:(MPServiceStoreQueryStatus)status type:(MPServiceStoreQueryType)type results:(NSArray*)results
{
    if (status!=MPServiceStoreStatusSucceed || [results count]==0) {
        
            UIAlertView *message = [[UIAlertView alloc]
                                    initWithTitle:@"Not found!"
                                    message:@"Unable to found this album on the iTunes Store."
                                    delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
            
            [message show];
    }
    else
    {
        MPMusicTrack* result = results[0];
        NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, [result collectionViewUrl]);
        
        
        // year
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM yyyy"];
        _year.text = [[formatter stringFromDate:[result releaseDate]] capitalizedString];
        
        // genre
        _genre.text = [result primaryGenreName];
        
        // price
        _price.text = [NSString stringWithFormat:@"%@$", [result collectionPrice]];
        
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
