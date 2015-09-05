//
//  UIViewControllerFeatureMusicPutt.m
//  MusicPutt
//
//  Created by Eric Pinet on 2015-09-04.
//  Copyright (c) 2015 Eric Pinet. All rights reserved.
//

#import "UIViewControllerFeatureMusicPutt.h"

#import "AppDelegate.h"
#import "MusicputtApi.h"
#import "MPListening.h"
#import "UITableViewCellFeatureMusicPutt.h"
#import "UIColor+CreateMethods.h"

#import <AVFoundation/AVAudioSession.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface UIViewControllerFeatureMusicPutt () <UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate>
{
    NSArray *topMusic;
    AVAudioPlayer* audioPlayer;
    
    NSInteger currentSongIndex;
    NSInteger currentDownloadingIndex;
    NSInteger currentPlayingIndex;
    
    UIActivityIndicatorView *activityIndicator;
}

@property (weak, nonatomic) IBOutlet UITableView* tableView;

@property AppDelegate* del;

@property MusicPuttApi* musicputt;

@end

@implementation UIViewControllerFeatureMusicPutt

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // setup app delegate
    self.del = [[UIApplication sharedApplication] delegate];
    
    // setup title
    [self setTitle:@"MusicPutt"];
    
    // setup tableview
    scrollView = _tableView;
    
    // init loaging activity indicator
    activityIndicator= [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    activityIndicator.opaque = YES;
    activityIndicator.backgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    activityIndicator.center = self.view.center;
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview: activityIndicator];
    [activityIndicator startAnimating];
    
    // init musicputt api
    _musicputt = [[MusicPuttApi alloc] init];
    
    // musicputt api
    [_musicputt queryListeningListAsynchronizationMode:true
                                               success:^(NSArray* results){
                                                   NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"MusicPutt request succeed");
                                                   
                                                   topMusic = results;
                                                   
                                                   [_tableView reloadData];
                                                   
                                                   // stop activity indicator
                                                   [activityIndicator stopAnimating];
                                               }
                                               failure:^(NSError* error){
                                                   NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"MusicPutt request failed");
                                                   
                                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Server unreachable!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil,nil];
                                                   [alert show];
                                                   
                                                   // stop activity indicator
                                                   [activityIndicator stopAnimating];
                                                   
                                               }];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self stopPlaying];
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
    return 1;
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
    return topMusic.count;
}

/**
 *  Return the cell at a specified location in the talbe view.
 *
 *  @param tableView :
 *  @param indexPath : The path to the cell.
 *
 *  @return
 */
- (UITableViewCellFeatureMusicPutt*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellFeatureMusicPutt * cell = [tableView dequeueReusableCellWithIdentifier:@"FeatureMusicPuttCell"];
    
    MPListening *track = [topMusic objectAtIndex:indexPath.row];
    
    cell.trackId = [track trackId];
    cell.collectionId = [track collectionId];
    [cell title].text = [track trackName];
    [cell artist].text = [track artistName];
    [[cell image] setImage:nil];
    [[cell image] sd_setImageWithURL:[NSURL URLWithString:[track artworkUrl100]]
                    placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[track trackId]]]];
    
    cell.parentNavCtrl = self.navigationController;
    
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

/**
 *  Create the header cell of the section in the table view.
 *
 *  @param tableView :
 *  @param section   : The section index.
 *  @return          : The header cell.
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 180.0f)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 100, 100)];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    imageView.image = [UIImage imageNamed:@"musicputt"];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 50.0;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.borderWidth = 3.0f;
    imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    imageView.layer.shouldRasterize = YES;
    imageView.clipsToBounds = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 0, 24)];
    label.text = @"musicputt";
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithHex:@"#750300" alpha:1.0f];
    [label sizeToFit];
    label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    UILabel *labelversion = [[UILabel alloc] initWithFrame:CGRectMake(0, 147, 0, 24)];
    labelversion.text = @"See what users are listening to on MusicPutt";
    labelversion.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    labelversion.backgroundColor = [UIColor clearColor];
    labelversion.textColor = [UIColor colorWithHex:@"#750300" alpha:1.0f];
    [labelversion sizeToFit];
    labelversion.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    [view setBackgroundColor:[UIColor whiteColor]];
    [view setOpaque:TRUE];
    [view addSubview:imageView];
    [view addSubview:label];
    [view addSubview:labelversion];
    return view;
}
/**
 *  Set the section header's height.
 *
 *  @param tableView : Table view for this section.
 *  @param section   : Section index.
 *
 *  @return          : Section hearder's height.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 180.0f;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == currentSongIndex && [audioPlayer isPlaying]) {
        NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Stop playing ", (long)currentSongIndex);
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentSongIndex inSection:0];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [audioPlayer stop];
        [self stopPlayingProgress:[NSNumber numberWithInteger:currentSongIndex]];
    }
    else{
        [self startPlayingAtIndex:indexPath.row];
    }
    return indexPath;
}


#pragma mark - AVAudioPlayerDelegate

/**
 *  Ensure that playing preview song is ended
 */
- (void) stopPlaying
{
    [audioPlayer stop];
    [self stopPlayingProgress:[NSNumber numberWithInteger:currentPlayingIndex]];
}

/**
 *  Start playing item a this index
 *
 *  @param index <#index description#>
 */
- (void) startPlayingAtIndex:(NSInteger) index
{
    if (topMusic.count>index) {
        currentSongIndex = index;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentSongIndex inSection:0];
        [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Start playing", (long)currentSongIndex);
        
        [self startDownloadProgress:currentSongIndex];
        
        NSURL *url = [NSURL URLWithString: [[topMusic objectAtIndex:index] previewUrl]];
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
            
            [self stopDownloadProgress: [NSNumber numberWithInteger:currentSongIndex]];
        }
    }
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Playing ended ", (long)currentSongIndex);
    [audioPlayer stop];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentSongIndex inSection:0];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self startPlayingAtIndex:currentSongIndex+1];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"Error occured");
}

-(void) startDownloadProgress:(NSInteger) index
{
    if (currentDownloadingIndex != -1) {
        // stop already downloding progress
        [self stopDownloadProgress:[NSNumber numberWithInteger:index]];
    }
    
    currentDownloadingIndex = index;
    
    //NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Start downloading progress ", (long)index);
    
    UITableViewCellFeatureMusicPutt *cell = (UITableViewCellFeatureMusicPutt*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    if (cell) {
        [cell startDownloadProgress];
    }
}

-(void) stopDownloadProgress:(NSNumber*) index
{
    //NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Stop downloading progress ", (long)[index integerValue]);
    
    UITableViewCellFeatureMusicPutt *cell = (UITableViewCellFeatureMusicPutt*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[index integerValue] inSection:0]];
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
    
    UITableViewCellFeatureMusicPutt *cell = (UITableViewCellFeatureMusicPutt*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentPlayingIndex inSection:0]];
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
    
    UITableViewCellFeatureMusicPutt *cell = (UITableViewCellFeatureMusicPutt*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[index integerValue] inSection:0]];
    if (cell) {
        [cell stopPlayingProgress];
    }
    currentPlayingIndex = -1;
}

/**
 *  Share button was pressed by the user.
 *
 *  @param sender sender of event.
 */
- (IBAction)sharePressed:(id)sender
{
    /*
    if(songs[0])
    {
        NSString* sharedString = [NSString stringWithFormat:@"I'm listening : %@ - %@ @musicputt!", [songs[0] artistName], [songs[0] collectionName]];
        NSURL* sharedUrl = [NSURL URLWithString:[songs[0] collectionViewUrl]];
        
        id path = [songs[0] getArtworkUrlCustomQuality:@"300x300-100"];
        NSURL *url = [NSURL URLWithString:path];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *sharedImage = [[UIImage alloc] initWithData:data];
        
        UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[sharedString, sharedUrl, sharedImage] applicationActivities:nil];
        controller.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact];
        [self presentViewController:controller animated:YES completion:nil];
    }
     */
}


/**
 *  Click on itunes button.
 *
 *  @param sender <#sender description#>
 */
- (IBAction)itunesButtonPressed:(id)sender
{
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[songs[0] collectionViewUrl]]];
}

/**
 *  Click on artist button.
 */
- (IBAction)artistButtonPressed:(id)sender
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"artistPressed");
    
    /*
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewControllerArtistStore *storeView = [sb instantiateViewControllerWithIdentifier:@"Store"];
    [storeView setStoreArtistId: [songs[0] artistId]];
    [self.navigationController pushViewController:storeView animated:YES];
    //[self.navigationController presentViewController:storeView animated:YES completion:nil];
    */
}

#pragma mark - AMWaveViewController

- (NSArray*)visibleCells
{
    return [self.tableView visibleCells];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
