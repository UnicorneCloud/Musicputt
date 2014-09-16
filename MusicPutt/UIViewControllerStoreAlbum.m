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
    MONActivityIndicatorView *indicatorView;
    ITunesAlbum* currentAlbum;
    NSInteger currentAlbumIndex;
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
    self.del = [[UIApplication sharedApplication] delegate];
    
    // start loading annimations
    indicatorView = [[MONActivityIndicatorView alloc] init];
    indicatorView.delegate = self;
    indicatorView.numberOfCircles = 5;
    indicatorView.radius = 15;
    indicatorView.internalSpacing = 3;
    indicatorView.duration = 0.5;
    indicatorView.delay = 0.2;
    indicatorView.center = self.view.center;
    _albumlist.alpha = 0.1;
    _viewalbum.alpha = 0.1;
    _songstable.alpha = 0.1;
    
    [self.view addSubview:indicatorView];
    [indicatorView startAnimating];
    
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
    
    id path = [currentAlbum artworkUrl100];
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
    id path = [[result objectAtIndex:index+1] artworkUrl100];
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    
    UIImageView* imageview = [[UIImageView alloc] initWithImage:img];
    imageview.frame = CGRectMake(0, 0, 100.0f, 100.0f);
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
    currentAlbumIndex = index + 1;
    
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
        currentAlbumIndex = index;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentAlbumIndex-1 inSection:0];
        [_songstable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        //[self.songstable.delegate tableView:self.songstable didSelectRowAtIndexPath:indexPath];
        
        NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Start playing ", (long)currentAlbumIndex);
        
        NSURL *url = [NSURL URLWithString: [[currentAlbumSongs objectAtIndex:index] previewUrl]];
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
            audioPlayer.delegate = self;
            [audioPlayer prepareToPlay];
            [audioPlayer play];
        }];
        [task resume];
    }
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
            [indicatorView stopAnimating];
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
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row+1 == currentAlbumIndex && [audioPlayer isPlaying]) {
        NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Stop playing ", (long)currentAlbumIndex);
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentAlbumIndex-1 inSection:0];
        [self.songstable deselectRowAtIndexPath:indexPath animated:YES];
        
        [audioPlayer stop];
    }
    else{
        [self startPlayingAtIndex:indexPath.row+1];
    }
    return indexPath;
}


#pragma mark - AVAudioPlayerDelegate

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Playing ended ", (long)currentAlbumIndex);
    [audioPlayer stop];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentAlbumIndex-1 inSection:0];
    [self.songstable deselectRowAtIndexPath:indexPath animated:YES];
    
    [self startPlayingAtIndex:currentAlbumIndex+1];
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
