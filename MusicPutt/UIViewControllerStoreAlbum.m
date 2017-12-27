//
//  UIViewControllerStoreAlbum.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-07-24.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerStoreAlbum.h"
#import "UITableViewCellAlbumStoreSong.h"
#import "iCarousel.h"
#import "ITunesSearchApi.h"
#import "MONActivityIndicatorView.h"
#import "UIColor+CreateMethods.h"
#import "AppDelegate.h"

#import <AVFoundation/AVFoundation.h>

#define _QUALITY_IMAGE_ @"200x200-75"

@interface UIViewControllerStoreAlbum () <  ITunesSearchApiDelegate,
                                            iCarouselDataSource,
                                            iCarouselDelegate,
                                            UITableViewDataSource,
                                            UITableViewDelegate,
                                            AVAudioPlayerDelegate,
                                            MONActivityIndicatorViewDelegate>
{
    NSArray* result;
    NSArray* currentAlbumSongs;
    AVAudioPlayer* audioPlayer;

    ITunesAlbum* currentAlbum;
    UIActivityIndicatorView *activityIndicator;
    
    NSInteger currentSongIndex;
    NSInteger currentDownloadingIndex;
    NSInteger currentPlayingIndex;
}

/**
 *  App delegate
 */
@property AppDelegate* del;

/**
 *  Album list in carousel view
 */
@property (nonatomic, strong) IBOutlet iCarousel *albumlist;

/**
 *  Artist name of the current selected album
 */
@property (nonatomic, weak) IBOutlet UILabel* artistname;

/**
 *  Album name of the current selected album
 */
@property (nonatomic, weak) IBOutlet UILabel* albumname;

/**
 *  Nb tracks on the current selected album
 */
@property (nonatomic, weak) IBOutlet UILabel* tracks;

/**
 *  Primary genre of the current selected album
 */
@property (nonatomic, weak) IBOutlet UILabel* genre;

/**
 *  Release date of the current selected album
 */
@property (nonatomic, weak) IBOutlet UILabel* date;

/**
 *  Price of the current selected album
 */
@property (nonatomic, weak) IBOutlet UILabel* price;

/**
 *  View content album information
 */
@property (nonatomic, weak) IBOutlet UIView* viewalbum;

/**
 *  tableview of the songs of the current selected album
 */
@property (nonatomic, weak) IBOutlet UITableView* songstable;

@end



@implementation UIViewControllerStoreAlbum


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
    self.del = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    // start loading annimations
    activityIndicator= [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    activityIndicator.opaque = YES;
    activityIndicator.backgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    activityIndicator.center = self.view.center;
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview: activityIndicator];
    [activityIndicator startAnimating];
     
    // query store for album information
    ITunesSearchApi *store = [[ITunesSearchApi alloc]init];
    [store setDelegate:self];
    [store queryAlbumWithArtistId:_storeArtistId asynchronizationMode:true];
    
    // setup album carousel
    _albumlist.type = iCarouselTypeCoverFlow;
    
    // Initialize AVAudioPLayer
    [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryError];
    if (setCategoryError)
        NSLog(@"Error setting category! %@", setCategoryError);
    
    // init current downloading displaying
    currentDownloadingIndex = -1;
    currentPlayingIndex = -1;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  Share button was pressed by the user.
 *
 *  @param sender sender of event.
 */
- (IBAction)sharePressed:(id)sender
{
    NSString* sharedString = [NSString stringWithFormat:@"I'm listening : %@ - %@ @musicputt!", [currentAlbum artistName], [currentAlbum collectionName]];
    NSURL* sharedUrl = [NSURL URLWithString:[currentAlbum collectionViewUrl]];
    
    id path = [currentAlbum getArtworkUrlCustomQuality:@"300x300-100"];
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *sharedImage = [[UIImage alloc] initWithData:data];

    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[sharedString, sharedUrl, sharedImage] applicationActivities:nil];
    controller.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact];
    [self presentViewController:controller animated:YES completion:nil];
}


/**
 *  Click on itunes button.
 *
 *  @param sender <#sender description#>
 */
- (IBAction)itunesButtonPressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[result objectAtIndex:0] artistLinkUrl]]];
}

#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    //return [items 3];
    return result.count-1;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    id path = [[[result objectAtIndex:index+1] artworkUrl100] stringByReplacingOccurrencesOfString:@"100x100-75" withString:_QUALITY_IMAGE_];
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    
    UIImageView* imageview = [[UIImageView alloc] initWithImage:img];
    imageview.frame = CGRectMake(0, 0, 110.0f, 110.0f);
    return imageview;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSNumber *item = (result)[index+1];
    NSLog(@"Tapped view number: %@", item);
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    [self updateCurrentAlbumShow:carousel.currentItemIndex];
}

-(void) updateCurrentAlbumShow:(NSInteger) index
{
    currentAlbum = result[index+1];
    
    // update display of the current album selected
    _artistname.text = [result[index+1] artistName];
    _albumname.text = [result[index+1] collectionName];
    
    NSInteger nbTracks = [[result[index+1] trackCount] integerValue];
    if (nbTracks > 1)
    {
        _tracks.text = [NSString stringWithFormat: @"%lu tracks", (unsigned long)nbTracks];
    }
    else if(nbTracks > 0)
    {
        _tracks.text = [NSString stringWithFormat: @"%lu track", (unsigned long)nbTracks];
    }
    
    _genre.text = [result[index+1] primaryGenreName];
    
    // releasedate
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM yyyy"];
    _date.text = [[formatter stringFromDate:[result[index+1] releaseDate]] capitalizedString];

    _price.text = [NSString stringWithFormat:@"%@$", [result[index+1] collectionPrice]];
    
    // query store for album songs
    ITunesSearchApi *store = [[ITunesSearchApi alloc]init];
    [store setDelegate:self];
    [store queryMusicTrackWithAlbumId:[result[index+1] collectionId] asynchronizationMode:true];
    
    // Stop donwload or playing progress icon
    [self stopDownloadProgress:[NSNumber numberWithInteger:currentSongIndex]];
    [self stopPlayingProgress:[NSNumber numberWithInteger:currentSongIndex]];
}

/**
 *  Ensure that playing preview song is ended
 */
- (void) stopPlaying
{
    [audioPlayer stop];
}

/**
 *  Start playing item a this index
 *
 *  @param index <#index description#>
 */
- (void) startPlayingAtIndex:(NSInteger) index
{
    if (currentAlbumSongs.count>index) {
        currentSongIndex = index;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentSongIndex-1 inSection:0];
        [_songstable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Start playing ", (long)currentSongIndex);
        
        [self startDownloadProgress:currentSongIndex-1];
        
        NSURL *url = [NSURL URLWithString: [[currentAlbumSongs objectAtIndex:index] previewUrl]];
        if (url) {
            NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
                audioPlayer.delegate = self;
                [audioPlayer prepareToPlay];
                [audioPlayer play];
                
                NSNumber *param = [NSNumber numberWithInteger:currentDownloadingIndex];
                [self performSelectorOnMainThread:@selector(stopDownloadProgress:) withObject:param waitUntilDone:NO];
                
                NSNumber *param2 = [NSNumber numberWithInteger:currentDownloadingIndex];
                [self performSelectorOnMainThread:@selector(startPlayingProgress:) withObject:param2 waitUntilDone:NO];
            }];
            [task resume];
            
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"There is no preview for this song!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil,nil];
            [alert show];
            
            [self stopDownloadProgress: [NSNumber numberWithInteger:currentSongIndex-1]];
        }
    }
}

-(void) startDownloadProgress:(NSInteger) index
{
    if (currentDownloadingIndex != -1) {
        // stop already downloding progress
        [self stopDownloadProgress:[NSNumber numberWithInteger:index]];
    }
    
    currentDownloadingIndex = index;
    
    //NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Start downloading progress ", (long)index);
    
    UITableViewCellAlbumStoreSong *cell = (UITableViewCellAlbumStoreSong*)[_songstable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    if (cell) {
        [cell startDownloadProgress];
    }
}

-(void) stopDownloadProgress:(NSNumber*) index
{
    //NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Stop downloading progress ", (long)[index integerValue]);
    
    UITableViewCellAlbumStoreSong *cell = (UITableViewCellAlbumStoreSong*)[_songstable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[index integerValue] inSection:0]];
    if (cell) {
        [cell stopDownloadProgress];
    }
    currentDownloadingIndex = -1;
}

/**
 *  <#Description#>
 *
 *  @param index <#index description#>
 */
-(void) startPlayingProgress:(NSInteger) index
{
    if (currentPlayingIndex != -1) {
        // stop already downloding progress
        [self stopPlayingProgress:[NSNumber numberWithInteger:currentPlayingIndex]];
    }
    
    currentPlayingIndex = currentSongIndex;
    
    UITableViewCellAlbumStoreSong *cell = (UITableViewCellAlbumStoreSong*)[_songstable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentPlayingIndex-1 inSection:0]];
    if (cell) {
        [cell startPlayingProgress];
    }
}

/**
 *  <#Description#>
 *
 *  @param index <#index description#>
 */
-(void) stopPlayingProgress:(NSNumber*) index
{
    //NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Stop downloading progress ", (long)[index integerValue]);
    
    UITableViewCellAlbumStoreSong *cell = (UITableViewCellAlbumStoreSong*)[_songstable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[index integerValue]-1 inSection:0]];
    if (cell) {
        [cell stopPlayingProgress];
    }
    currentPlayingIndex = -1;
}


#pragma mark MPServiceStoreDelegate
/**
 *  Implement this methode for recieve result after query.
 *
 *  @param status  Status of the querys
 *  @param type    Type of query sender
 *  @param results resultset of the query
 */
-(void) queryResult:(ITunesSearchApiQueryStatus)status type:(ITunesSearchApiQueryType)type results:(NSArray*)results
{
    if (status!=ITunesSearchApiStatusSucceed || [results count]==0)
    {
        /*
         UIAlertView *message = [[UIAlertView alloc]
         initWithTitle:@"Not found!"
         message:@"Unable to found this album on the iTunes Store."
         delegate:nil
         cancelButtonTitle:@"OK"
         otherButtonTitles:nil];
         
         [message show];
         */
    }
    else
    {
        if (type == QueryAlbumWithArtistId)
        {
            result = results;
            [_albumlist reloadData];
            [self updateCurrentAlbumShow:0];
        }
        else if (type == QueryMusicTrackWithAlbumId)
        {
            currentAlbumSongs = results;
            
            // reload table data
            [_songstable reloadData];
            
            // stop annimation
            _albumlist.alpha = 1.0;
            _viewalbum.alpha = 1.0;
            _songstable.alpha = 1.0;
            [activityIndicator stopAnimating];
        }
    }
}


#pragma mark - UITableViewDataSource
/**
 *  Number of section in the table view.
 *
 *  @param tableView :
 *
 *  @return          : Number of section.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1; // always 1 section for the current album display
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
    // get current album select
    if (currentAlbumSongs!=nil && currentAlbumSongs.count>0) {
        return currentAlbumSongs.count-1;
    }
    return 0;
}

/**
 *  Return the cell at a specified location in the talbe view.
 *
 *  @param tableView :
 *  @param indexPath : The path to the cell.
 *
 *  @return
 */
- (UITableViewCellAlbumStoreSong*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellAlbumStoreSong* cell = [tableView dequeueReusableCellWithIdentifier:@"CellStoreSong"];
    [cell setMediaItem:[currentAlbumSongs objectAtIndex:indexPath.row+1]];
    
    if (currentPlayingIndex == indexPath.row) {
        [cell startPlayingProgress];
        
        if (currentDownloadingIndex == indexPath.row) {
            [cell stopPlayingProgress];
            [cell startDownloadProgress];
        }
    }
    else{
        [cell stopPlayingProgress];
        [cell stopDownloadProgress];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row+1 == currentSongIndex && [audioPlayer isPlaying]) {
        NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Stop playing ", (long)currentSongIndex);
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentSongIndex-1 inSection:0];
        [self.songstable deselectRowAtIndexPath:indexPath animated:YES];
        
        [audioPlayer stop];
        
        [self stopPlayingProgress:[NSNumber numberWithInteger:currentSongIndex]];
    }
    else
    {
        [self startPlayingAtIndex:indexPath.row+1];
    }
    return indexPath;
}


#pragma mark - AVAudioPlayerDelegate

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Playing ended ", (long)currentSongIndex);
    [audioPlayer stop];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentSongIndex-1 inSection:0];
    [self.songstable deselectRowAtIndexPath:indexPath animated:YES];
    
    [self startPlayingAtIndex:currentSongIndex+1];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"Error occured");
}


#pragma mark - MONActivityIndicatorViewDelegate

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView circleBackgroundColorAtIndex:(NSUInteger)index {

    return [UIColor colorWithHex:@"#750300" alpha:1.0];
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
