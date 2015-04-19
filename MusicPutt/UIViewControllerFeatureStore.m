//
//  UIViewControllerFeatureStore.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-10-19.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerFeatureStore.h"

#import <AVFoundation/AVAudioSession.h>
#import <AVFoundation/AVAudioPlayer.h>

#import "AppDelegate.h"
#import "ITunesFeedsApi.h"
#import "ITunesAlbum.h"
#import "ITunesMusicTrack.h"
#import "PreferredGender.h"
#import "UITableViewCellFeatureAlbumStore.h"
#import "UITableViewCellFeatureHeaderStore.h"
#import "UITableViewCellFeatureSongsStore.h"

#import <SDWebImage/UIImageView+WebCache.h>

#define SECTION_ALBUM 0
#define SECTION_SONG 1

#define NB_TOP_ALBUM 100
#define NB_TOP_SONG  50

@interface UIViewControllerFeatureStore () <UITableViewDataSource, UITableViewDelegate, ITunesFeedsApiDelegate, AVAudioPlayerDelegate>
{
    NSArray *topRates;
    NSArray *topRatesSongs;
    NSInteger currentTopRateStep;
    
    AVAudioPlayer* audioPlayer;
    NSInteger currentSongIndex;
    NSInteger currentDownloadingIndex;
    NSInteger currentPlayingIndex;
}

@property (weak, nonatomic) IBOutlet UITableView* tableView;

@property AppDelegate* del;

@property ITunesFeedsApi* itunesTopAlbums;

@property ITunesFeedsApi* itunesTopSongs;

@end

@implementation UIViewControllerFeatureStore


/**
 *  viewDidLoad
 *  Initialisation and iTunes request
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // setup app delegate
    self.del = [[UIApplication sharedApplication] delegate];
    
    // setup title
    [self setTitle:@"Store"];
    
    // setup tableview
    scrollView = _tableView;
    
    // top rate albums
    _itunesTopAlbums = [[ITunesFeedsApi alloc] init];
    [_itunesTopAlbums setDelegate:self];
    NSString *country = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    if ([country compare:@"CN"]==0) { // if country = CN (Chenese) store are not available
        country = @"US";
    }
    
    
    [_itunesTopAlbums queryFeedType:QueryTopAlbums forCountry:country size:NB_TOP_ALBUM genre:0 asynchronizationMode:true];
    
    // top rate songs
    _itunesTopSongs = [[ITunesFeedsApi alloc] init];
    [_itunesTopSongs setDelegate:self];
    [_itunesTopSongs queryFeedType:QueryTopSongs forCountry:country size:NB_TOP_SONG genre:0 asynchronizationMode:true];
    
    
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

/**
 *  viewWillAppear start timer to flip feature image.
 *
 *  @param animated <#animated description#>
 */
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

/**
 *  Stop timer of flip image.
 *
 *  @param animated <#animated description#>
 */
- (void) viewWillDisappear:(BOOL)animated
{
    [self stopPlaying];
}

/**
 *  didReceiveMemoryWarning
 */
- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  handleLeftSwipeFrom
 *
 *  @param sender <#sender description#>
 */
- (IBAction)handleLeftSwipeFrom:(id)sender
{
    if (topRates.count >= currentTopRateStep+7) {
        
        UITableViewCellFeatureAlbumStore* cell = (UITableViewCellFeatureAlbumStore*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (cell) {
            
            CATransition *animation = [CATransition animation];
            [animation setDelegate:self];
            [animation setType:kCATransitionPush];
            [animation setSubtype:kCATransitionFromRight];
            [animation setDuration:0.50];
            [animation setTimingFunction:
             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [cell.viewAlbums.layer addAnimation:animation forKey:kCATransition];
            
            [cell startLoading];
        }
        currentTopRateStep = currentTopRateStep+6;
        [self displayTopAlbumWithStartIndex:currentTopRateStep];
    }
}

/**
 *  handleRightSwipeFrom
 *
 *  @param sender <#sender description#>
 */
- (IBAction)handleRightSwipeFrom:(id)sender
{
    if (currentTopRateStep-6 >= 0) {
        UITableViewCellFeatureAlbumStore* cell = (UITableViewCellFeatureAlbumStore*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (cell) {
            
            CATransition *animation = [CATransition animation];
            [animation setDelegate:self];
            [animation setType:kCATransitionPush];
            [animation setSubtype:kCATransitionFromLeft];
            [animation setDuration:0.50];
            [animation setTimingFunction:
             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [cell.viewAlbums.layer addAnimation:animation forKey:kCATransition];
            
            [cell startLoading];
        }
        currentTopRateStep = currentTopRateStep-6;
        [self displayTopAlbumWithStartIndex:currentTopRateStep];
    }
}

/**
 *  display the next 6 album from a starting index
 *
 *  @param index starting index
 */
- (void) displayTopAlbumWithStartIndex:(NSInteger) index
{
    if (topRates.count>0)
    {
        UITableViewCellFeatureAlbumStore* cell = (UITableViewCellFeatureAlbumStore*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (cell) {
            NSMutableArray* results = [[NSMutableArray alloc] init];
            
            if (topRates.count>=index) {
                for (int i=1; i<=6; i++) {
                    if (topRates.count>index+i) {
                        [results addObject: [topRates objectAtIndex:index+i]];
                    }
                }
            }
            
            NSLog(@" %s - %@%ld/%ld\n", __PRETTY_FUNCTION__, @"Display:", index, index+6);
            
            // hide more button
            if (topRates.count<index+7) {
                [cell.more setHidden:TRUE];
            }
            else{
                [cell.more setHidden:FALSE];
            }
            
            // album 1
            ITunesAlbum* album = nil;
            if (results.count>0) {
                album = [results objectAtIndex:0];
                cell.collectionId1 = [album collectionId];
                [cell title1].text = [album collectionName];
                [cell artist1].text = [album artistName];
                [cell.image1 sd_setImageWithURL:[NSURL URLWithString:[album artworkUrl100]]
                               placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[album collectionId]]]];
            }
            
            // album 2
            ITunesAlbum* album2 = nil;
            if (results.count>1) {
                album2 = [results objectAtIndex:1];
                cell.collectionId2 = [album2 collectionId];
                [cell title2].text = [album2 collectionName];
                [cell artist2].text = [album2 artistName];
                [cell.image2 sd_setImageWithURL:[NSURL URLWithString:[album2 artworkUrl100]]
                               placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[album2 collectionId]]]];
            }
            
            // album 3
            ITunesAlbum* album3 = nil;
            if (results.count>2) {
                album3 = [results objectAtIndex:2];
                cell.collectionId3 = [album3 collectionId];
                [cell title3].text = [album3 collectionName];
                [cell artist3].text = [album3 artistName];
                [cell.image3 sd_setImageWithURL:[NSURL URLWithString:[album3 artworkUrl100]]
                               placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[album3 collectionId]]]];
            }
            
            // album 4
            ITunesAlbum* album4 = nil;
            if (results.count>3) {
                album4 = [results objectAtIndex:3];
                cell.collectionId4 = [album4 collectionId];
                [cell title4].text = [album4 collectionName];
                [cell artist4].text = [album4 artistName];
                [cell.image4 sd_setImageWithURL:[NSURL URLWithString:[album4 artworkUrl100]]
                               placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[album4 collectionId]]]];
            }
            
            // album 5
            ITunesAlbum* album5 = nil;
            if (results.count>4) {
                album5 = [results objectAtIndex:4];
                cell.collectionId5 = [album5 collectionId];
                [cell title5].text = [album5 collectionName];
                [cell artist5].text = [album5 artistName];
                [cell.image5 sd_setImageWithURL:[NSURL URLWithString:[album5 artworkUrl100]]
                               placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[album5 collectionId]]]];
            }
            
            // album 6
            ITunesAlbum* album6 = nil;
            if (results.count>5) {
                album6 = [results objectAtIndex:5];
                cell.collectionId6 = [album6 collectionId];
                [cell title6].text = [album6 collectionName];
                [cell artist6].text = [album6 artistName];
                [cell.image6 sd_setImageWithURL:[NSURL URLWithString:[album6 artworkUrl100]]
                               placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[album6 collectionId]]]];
            }
            
            [cell stopLoading];
        }
    }
}

/**
 *  Filter a array of album top rates with preferred gender
 *
 *  @param arrayToFilter array to filtered
 *
 *  @return array filtered
 */
-(NSArray*) filterTopRatesWithPreferred:(NSArray*)arrayToFilter
{
    NSTimeInterval start  = [[NSDate date] timeIntervalSince1970];
    NSMutableArray* filteredArray = [[NSMutableArray alloc] init];
    BOOL keepThisItem =  false;
    
    // check if the user have preferred gender
    NSArray* preferredGenders = [PreferredGender MR_findAll];
    if ([preferredGenders count]>0) {
        
        // check items and keep if if it's in preferred gender
        for (int i=0; i<arrayToFilter.count; i++)
        {
            keepThisItem = false;
            
            // check if this item is in preferred gender
            for (int y=0; y<preferredGenders.count; y++)
            {
                if ([[[arrayToFilter objectAtIndex:i] primaryGenreName] isEqualToString:[_itunesTopAlbums getGenderName:[[[preferredGenders objectAtIndex:y] genderid] integerValue]]]) {
                    keepThisItem = true;
                    break;
                }
            }
            
            if (keepThisItem) {
                [filteredArray addObject:[arrayToFilter objectAtIndex:i]];
            }
        }
        
        NSTimeInterval finish = [[NSDate date] timeIntervalSince1970];
        NSLog(@" %s - %@ %f secondes\n", __PRETTY_FUNCTION__, @"Finish filtering preferred gender took", finish - start);
        return filteredArray;
    }
    else{
        // if the user do not have preferred gender
        // return array without filter
        return arrayToFilter;
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
    return 2;
}

/**
 *  <#Description#>
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == SECTION_ALBUM) {
        return 1;
    }
    else if (section == SECTION_SONG){
        return topRatesSongs.count;
    }
    return 0;
}

/**
 *  <#Description#>
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCellFeatureHeaderStore* cell = [tableView dequeueReusableCellWithIdentifier:@"FeatureHeaderStoreCell"];
    if (section == SECTION_ALBUM) {
        cell.title.text = @"Top Albums";
    }
    else if (section == SECTION_SONG){
        cell.title.text = @"Top Songs";
    }
    return cell;
}

/**
 *  <#Description#>
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0f;
}

/**
 *  <#Description#>
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.section == SECTION_ALBUM )
    {
        return 310.0f;
    }
    else if (indexPath.section == SECTION_SONG )
    {
        return 60.0f;
    }
    return 0.0f;
}

/**
 *  <#Description#>
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SECTION_ALBUM) {
        
        UITableViewCellFeatureAlbumStore* cell = [tableView dequeueReusableCellWithIdentifier:@"FeatureStoreAlbumCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([cell isLoading]) {
            [cell startLoading];
        }
        
        cell.parentNavCtrl = self.navigationController;
        
        UISwipeGestureRecognizer *recognizer;
        
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [[cell contentView] addGestureRecognizer:recognizer];
        
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [[cell contentView] addGestureRecognizer:recognizer];
        
        [self displayTopAlbumWithStartIndex:currentTopRateStep];
        
        return cell;
    }
    else if (indexPath.section == SECTION_SONG)
    {
        UITableViewCellFeatureSongsStore* cell = [tableView dequeueReusableCellWithIdentifier:@"FeatureSongCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ITunesMusicTrack* track = [topRatesSongs objectAtIndex:indexPath.row];
        cell.trackId = [track trackId];
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
    return nil;
}


#pragma mark - UITableViewDelegate

/**
 *  <#Description#>
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == currentSongIndex && [audioPlayer isPlaying]) {
        NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Stop playing ", (long)currentSongIndex);
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentSongIndex inSection:SECTION_SONG];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [audioPlayer stop];
        [self stopPlayingProgress:[NSNumber numberWithInteger:currentSongIndex]];
    }
    else{
        if (indexPath.section!=0) {
            [self startPlayingAtIndex:indexPath.row];
        }
    }
    return indexPath;
}


#pragma mark - ITunesFeedsApiDelegate

/**
 *  <#Description#>
 *
 *  @param status  <#status description#>
 *  @param type    <#type description#>
 *  @param results <#results description#>
 */
-(void) queryResult:(ITunesFeedsApiQueryStatus)status type:(ITunesFeedsQueryType)type results:(NSArray*)results
{
    if (status == StatusSucceed) {
        
        if (type == QueryTopAlbums)
        {
            // top albums receieved
            
            // load images from itunes store
            UITableViewCellFeatureAlbumStore* cell = (UITableViewCellFeatureAlbumStore*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:SECTION_ALBUM]];
            if (cell && results.count>=6)
            {
                
                NSLog(@" %s - %@:%ld\n", __PRETTY_FUNCTION__, @"queryResult", (unsigned long)results.count);
                
                // filter results
                topRates = [self filterTopRatesWithPreferred:results];
                
                NSLog(@" %s - %@%ld\n", __PRETTY_FUNCTION__, @"Results:", topRates.count);
                
                currentTopRateStep = 0;
                
                [self displayTopAlbumWithStartIndex:currentTopRateStep];
                
                
                NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"queryResult - end");
            }
        }
        else if (type == QueryTopSongs)
        {
            // top songs receieved
            topRatesSongs = results;
            [_tableView reloadData];
            [self displayTopAlbumWithStartIndex:currentTopRateStep];
        }
    }
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
    if (topRatesSongs.count>index) {
        currentSongIndex = index;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentSongIndex inSection:SECTION_SONG];
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:true];
        
        NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Start playing", (long)currentSongIndex);
        
        [self startDownloadProgress:currentSongIndex];
        
        NSURL *url = [NSURL URLWithString: [[topRatesSongs objectAtIndex:index] previewUrl]];
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                            message:@"There is no preview for this song!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:nil,nil];
            [alert show];
            
            [self stopDownloadProgress: [NSNumber numberWithInteger:currentSongIndex]];
        }
    }
}

/**
 *  <#Description#>
 *
 *  @param player <#player description#>
 *  @param flag   <#flag description#>
 */
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Playing ended ", (long)currentSongIndex);
    [audioPlayer stop];
    //[self stopPlayingProgress:[NSNumber numberWithInteger:currentSongIndex]];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentSongIndex inSection:SECTION_SONG];
    //[_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self startPlayingAtIndex:currentSongIndex+1];
}

/**
 *  <#Description#>
 *
 *  @param player <#player description#>
 *  @param error  <#error description#>
 */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"Error occured");
}

/**
 *  <#Description#>
 *
 *  @param index <#index description#>
 */
-(void) startDownloadProgress:(NSInteger) index
{
    if (currentDownloadingIndex != -1) {
        // stop already downloding progress
        [self stopDownloadProgress:[NSNumber numberWithInteger:index]];
    }
    
    currentDownloadingIndex = index;
    
    //NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Start downloading progress ", (long)index);
    
    UITableViewCellFeatureSongsStore *cell = (UITableViewCellFeatureSongsStore*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:SECTION_SONG]];
    if (cell) {
        [cell startDownloadProgress];
    }
}

/**
 *  <#Description#>
 *
 *  @param index <#index description#>
 */
-(void) stopDownloadProgress:(NSNumber*) index
{
    //NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Stop downloading progress ", (long)[index integerValue]);
    
    UITableViewCellFeatureSongsStore *cell = (UITableViewCellFeatureSongsStore*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[index integerValue] inSection:SECTION_SONG]];
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
    
    //NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Start downloading progress ", (long)index);
    
    UITableViewCellFeatureSongsStore *cell = (UITableViewCellFeatureSongsStore*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentPlayingIndex inSection:SECTION_SONG]];
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
    
    UITableViewCellFeatureSongsStore *cell = (UITableViewCellFeatureSongsStore*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[index integerValue] inSection:SECTION_SONG]];
    if (cell) {
        [cell stopPlayingProgress];
    }
    currentPlayingIndex = -1;
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
