//
//  UIViewControllerAlbumStore.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-09-13.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerAlbumStore.h"

#import "AppDelegate.h"
#import "TableViewCellAlbumStoreCell.h"
#import "TableViewCellAlbumStoreHeader.h"
#import "ITunesSearchApi.h"
#import <AVFoundation/AVAudioSession.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface UIViewControllerAlbumStore () <UITableViewDelegate, UITableViewDataSource, ITunesSearchApiDelegate, AVAudioPlayerDelegate>
{
    NSArray* songs;
    AVAudioPlayer* audioPlayer;
    NSInteger currentSongIndex;
}
@property AppDelegate* del;

/**
 * Table of songs
 */
@property (weak, nonatomic) IBOutlet UITableView* songstable;


@end

@implementation UIViewControllerAlbumStore

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // setup app delegate
    self.del = [[UIApplication sharedApplication] delegate];
    
    // setup title
    [self setTitle:@"Feature"];
    
    // setup tableview
    toolbarTableView = _songstable;
    
    // prepare itunes service for query
    ITunesSearchApi *itunes = [[ITunesSearchApi alloc] init];
    [itunes setDelegate:self];
    
    // query songs
    [itunes queryMusicTrackWithAlbumId:_collectionId asynchronizationMode:true];
    
    // Initialize AVAudioPLayer
    [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryError];
    if (setCategoryError)
        NSLog(@"Error setting category! %@", setCategoryError);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AMWaveViewController

- (NSArray*)visibleCells
{
    return [self.songstable visibleCells];
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
    if (songs.count>0) {
        return 1;
    }
    else{
        return 0;
    }
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
    return songs.count - 1;
}

/**
 *  Return the cell at a specified location in the talbe view.
 *
 *  @param tableView :
 *  @param indexPath : The path to the cell.
 *
 *  @return
 */
- (TableViewCellAlbumStoreCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCellAlbumStoreCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumStoreCell"];
    [cell setMediaItem:songs[indexPath.row+1]];
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
    TableViewCellAlbumStoreHeader * headerCell = [tableView dequeueReusableCellWithIdentifier:@"AlbumStoreHeaderCell"];
    headerCell.backgroundColor = [UIColor whiteColor];
    [headerCell setMediaItem:songs[0]];
    return headerCell;
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
    return 110.0f;
}

/**
 *  Implement this methode for recieve result after query.
 *
 *  @param status  Status of the querys
 *  @param type    Type of query sender
 *  @param results resultset of the query
 */
-(void) queryResult:(ITunesSearchApiQueryStatus)status type:(ITunesSearchApiQueryType)type results:(NSArray*)results
{
    if(status == ITunesSearchApiStatusSucceed)
    {
        if(type == QueryMusicTrackWithAlbumId)
        {
            // query music track completed
            songs = results;
        }
        
        [_songstable reloadData];
    }
    
    
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row+1 == currentSongIndex && [audioPlayer isPlaying]) {
        NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Stop playing ", (long)currentSongIndex);
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentSongIndex-1 inSection:0];
        [self.songstable deselectRowAtIndexPath:indexPath animated:YES];
        
        [audioPlayer stop];
    }
    else{
        [self startPlayingAtIndex:indexPath.row+1];
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
}

/**
 *  Start playing item a this index
 *
 *  @param index <#index description#>
 */
- (void) startPlayingAtIndex:(NSInteger) index
{
    if (songs.count>index) {
        currentSongIndex = index;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentSongIndex-1 inSection:0];
        [_songstable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Start playing ", (long)currentSongIndex);
        
        NSURL *url = [NSURL URLWithString: [[songs objectAtIndex:index] previewUrl]];
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
            audioPlayer.delegate = self;
            [audioPlayer prepareToPlay];
            [audioPlayer play];
        }];
        [task resume];
    }
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
