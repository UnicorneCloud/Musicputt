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
}

@property (weak, nonatomic) IBOutlet UITableView* tableView;

@property AppDelegate* del;

@property ITunesFeedsApi* itunesTopAlbums;

@property ITunesFeedsApi* itunesTopSongs;

@end

@implementation UIViewControllerFeatureStore

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


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                           ^{
                               // image 1
                               UIImage *sharedImage = nil;
                               ITunesAlbum* album = nil;
                               if (results.count>0) {
                                   album = [results objectAtIndex:0];
                                   id path = [album artworkUrl100];
                                   NSURL *url = [NSURL URLWithString:path];
                                   NSData *data = [NSData dataWithContentsOfURL:url];
                                   sharedImage = [[UIImage alloc] initWithData:data];
                               }
                               
                               
                               // image 2
                               UIImage *sharedImage2 = nil;
                               ITunesAlbum* album2 = nil;
                               if (results.count>1) {
                                   album2 = [results objectAtIndex:1];
                                   id path2 = [album2 artworkUrl100];
                                   NSURL *url2 = [NSURL URLWithString:path2];
                                   NSData *data2 = [NSData dataWithContentsOfURL:url2];
                                   sharedImage2 = [[UIImage alloc] initWithData:data2];
                               }
                               
                               // image 3
                               UIImage *sharedImage3 = nil;
                               ITunesAlbum* album3 = nil;
                               if (results.count>2) {
                                   album3 = [results objectAtIndex:2];
                                   id path3 = [album3 artworkUrl100];
                                   NSURL *url3 = [NSURL URLWithString:path3];
                                   NSData *data3 = [NSData dataWithContentsOfURL:url3];
                                   sharedImage3 = [[UIImage alloc] initWithData:data3];
                               }
                               
                               // image 4
                               UIImage *sharedImage4 = nil;
                               ITunesAlbum* album4 = nil;
                               if (results.count>3) {
                                   album4 = [results objectAtIndex:3];
                                   id path4 = [album4 artworkUrl100];
                                   NSURL *url4 = [NSURL URLWithString:path4];
                                   NSData *data4 = [NSData dataWithContentsOfURL:url4];
                                   sharedImage4 = [[UIImage alloc] initWithData:data4];
                               }
                               
                               // image 5
                               UIImage *sharedImage5 = nil;
                               ITunesAlbum* album5 = nil;
                               if (results.count>4) {
                                   album5 = [results objectAtIndex:4];
                                   id path5 = [album5 artworkUrl100];
                                   NSURL *url5 = [NSURL URLWithString:path5];
                                   NSData *data5 = [NSData dataWithContentsOfURL:url5];
                                   sharedImage5 = [[UIImage alloc] initWithData:data5];
                               }
                               
                               // image 6
                               UIImage *sharedImage6 = nil;
                               ITunesAlbum* album6 = nil;
                               if (results.count>5) {
                                   album6 = [results objectAtIndex:5];
                                   id path6 = [album6 artworkUrl100];
                                   NSURL *url6 = [NSURL URLWithString:path6];
                                   NSData *data6 = [NSData dataWithContentsOfURL:url6];
                                   sharedImage6 = [[UIImage alloc] initWithData:data6];
                               }
                               
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   
                                   if(album!=nil && sharedImage!=nil){
                                       [[cell image1] setImage:sharedImage];
                                       cell.collectionId1 = [album collectionId];
                                       [cell title1].text = [album collectionName];
                                       [cell artist1].text = [album artistName];
                                    }
                                   else{
                                       [[cell image1] setImage:nil];
                                       cell.collectionId1 = nil;
                                       [cell title1].text = @"";
                                       [cell artist1].text = @"";
                                   }
                                   
                                   if(album2!=nil && sharedImage2!=nil){
                                       [[cell image2] setImage:sharedImage2];
                                       cell.collectionId2 = [album2 collectionId];
                                       [cell title2].text = [album2 collectionName];
                                       [cell artist2].text = [album2 artistName];
                                   }
                                   else{
                                       [[cell image2] setImage:nil];
                                       cell.collectionId2 = nil;
                                       [cell title2].text = @"";
                                       [cell artist2].text = @"";
                                   }
                                   
                                   if(album3!=nil && sharedImage3!=nil){
                                       [[cell image3] setImage:sharedImage3];
                                       cell.collectionId3 = [album3 collectionId];
                                       [cell title3].text = [album3 collectionName];
                                       [cell artist3].text = [album3 artistName];
                                   }
                                   else{
                                       [[cell image3] setImage:nil];
                                       cell.collectionId3 = nil;
                                       [cell title3].text = @"";
                                       [cell artist3].text = @"";
                                   }
                                   
                                   if(album4!=nil && sharedImage4!=nil){
                                       [[cell image4] setImage:sharedImage4];
                                       cell.collectionId4 = [album4 collectionId];
                                       [cell title4].text = [album4 collectionName];
                                       [cell artist4].text = [album4 artistName];
                                   }
                                   else{
                                       [[cell image4] setImage:nil];
                                       cell.collectionId4 = nil;
                                       [cell title4].text = @"";
                                       [cell artist4].text = @"";
                                   }
                                   
                                   if(album5!=nil && sharedImage5!=nil){
                                       [[cell image5] setImage:sharedImage5];
                                       cell.collectionId5 = [album5 collectionId];
                                       [cell title5].text = [album5 collectionName];
                                       [cell artist5].text = [album5 artistName];
                                   }
                                   else{
                                       [[cell image5] setImage:nil];
                                       cell.collectionId5 = nil;
                                       [cell title5].text = @"";
                                       [cell artist5].text = @"";
                                   }
                                   
                                   if(album6!=nil && sharedImage6!=nil){
                                       [[cell image6] setImage:sharedImage6];
                                       cell.collectionId6 = [album6 collectionId];
                                       [cell title6].text = [album6 collectionName];
                                       [cell artist6].text = [album6 artistName];
                                   }
                                   else{
                                       [[cell image6] setImage:nil];
                                       cell.collectionId6 = nil;
                                       [cell title6].text = @"";
                                       [cell artist6].text = @"";
                                   }
                                   
                                   [cell stopLoading];
                               });
                               
                           });
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


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0f;
}

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
        
        ITunesMusicTrack* track = [topRatesSongs objectAtIndex:indexPath.row];
        cell.trackId = [track trackId];
        [cell title].text = [track trackName];
        [cell artist].text = [track artistName];
        [[cell image] setImage:nil];
        cell.parentNavCtrl = self.navigationController;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                       ^{
                           // image 1
                           ITunesMusicTrack* track = [topRatesSongs objectAtIndex:indexPath.row];
                           id path = [track artworkUrl100];
                           NSURL *url = [NSURL URLWithString:path];
                           NSData *data = [NSData dataWithContentsOfURL:url];
                           UIImage *sharedImage = [[UIImage alloc] initWithData:data];
                           
                           dispatch_async(dispatch_get_main_queue(), ^{
                               
                               [[cell image] setImage:sharedImage];
                           });
                           
                       });
       return cell;
    }
    return nil;
}


#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == currentSongIndex && [audioPlayer isPlaying]) {
        NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Stop playing ", (long)currentSongIndex);
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentSongIndex inSection:SECTION_SONG];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [audioPlayer stop];
    }
    else{
        [self startPlayingAtIndex:indexPath.row];
    }
    return indexPath;
}


#pragma mark - ITunesFeedsApiDelegate

-(void) queryResult:(ITunesFeedsApiQueryStatus)status type:(ITunesFeedsQueryType)type results:(NSArray*)results
{
    if (status == StatusSucceed) {
        
        if (type == QueryTopAlbums)
        {
            // top albums receieved
            
            // load images from itunes store
            UITableViewCellFeatureAlbumStore* cell = (UITableViewCellFeatureAlbumStore*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
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
        [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        
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
                
                //[self stopDownloadProgress:currentDownloadingIndex];
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
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentSongIndex inSection:SECTION_SONG];
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
    
    UITableViewCellFeatureSongsStore *cell = (UITableViewCellFeatureSongsStore*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:SECTION_SONG]];
    if (cell) {
        [cell startDownloadProgress];
    }
}

-(void) stopDownloadProgress:(NSNumber*) index
{
    //NSLog(@" %s - %@ %ld\n", __PRETTY_FUNCTION__, @"Stop downloading progress ", (long)[index integerValue]);
    
    UITableViewCellFeatureSongsStore *cell = (UITableViewCellFeatureSongsStore*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[index integerValue] inSection:SECTION_SONG]];
    if (cell) {
        [cell stopDownloadProgress];
    }
    currentDownloadingIndex = -1;
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
