//
//  UIViewControllerFeatureStore.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-10-19.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerFeatureStore.h"

#import "AppDelegate.h"
#import "ITunesFeedsApi.h"
#import "ITunesAlbum.h"
#import "PreferredGender.h"
#import "UITableViewCellFeatureAlbumStore.h"

@interface UIViewControllerFeatureStore () <UITableViewDataSource, UITableViewDelegate, ITunesFeedsApiDelegate>
{
    BOOL TopRateReadyToFlip;
    NSArray *topRates;
    NSInteger currentTopRateStep;
}

@property (weak, nonatomic) IBOutlet UITableView* tableView;

@property AppDelegate* del;

@property ITunesFeedsApi* itunes;

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
    toolbarTableView = _tableView;
    
    // init members
    TopRateReadyToFlip = false;
    
    // init itunes feeds api
    _itunes = [[ITunesFeedsApi alloc] init];
    [_itunes setDelegate:self];
    
    // itunes search api
    NSString *country = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    if ([country compare:@"CN"]==0) { // if country = CN (Chenese) store are not available
        country = @"US";
    }
    [_itunes queryFeedType:QueryTopAlbums forCountry:country size:100 genre:0 asynchronizationMode:true];    
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
}


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)handleLeftSwipeFrom:(id)sender
{
    if (topRates.count >= currentTopRateStep+12) {
        
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
    UITableViewCellFeatureAlbumStore* cell = (UITableViewCellFeatureAlbumStore*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (cell) {
        NSMutableArray* results = [[NSMutableArray alloc] init];
        
        
        if (topRates.count>=index && topRates.count>=index+6) {
            for (int i=1; i<=6; i++) {
                [results addObject: [topRates objectAtIndex:index+i]];
            }
        }
        
        NSLog(@" %s - %@%ld/%ld\n", __PRETTY_FUNCTION__, @"Display:", index, index+6);
        
        // hide more button
        if (topRates.count<index+12) {
            [cell.more setHidden:TRUE];
        }
        else{
            [cell.more setHidden:FALSE];
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                       ^{
                           // image 1
                           ITunesAlbum* album = [results objectAtIndex:0];
                           id path = [album artworkUrl100];
                           NSURL *url = [NSURL URLWithString:path];
                           NSData *data = [NSData dataWithContentsOfURL:url];
                           UIImage *sharedImage = [[UIImage alloc] initWithData:data];
                           
                           // image 2
                           ITunesAlbum* album2 = [results objectAtIndex:1];
                           id path2 = [album2 artworkUrl100];
                           NSURL *url2 = [NSURL URLWithString:path2];
                           NSData *data2 = [NSData dataWithContentsOfURL:url2];
                           UIImage *sharedImage2 = [[UIImage alloc] initWithData:data2];
                           
                           // image 3
                           ITunesAlbum* album3 = [results objectAtIndex:2];
                           id path3 = [album3 artworkUrl100];
                           NSURL *url3 = [NSURL URLWithString:path3];
                           NSData *data3 = [NSData dataWithContentsOfURL:url3];
                           UIImage *sharedImage3 = [[UIImage alloc] initWithData:data3];
                           
                           // image 4
                           ITunesAlbum* album4 = [results objectAtIndex:3];
                           id path4 = [album4 artworkUrl100];
                           NSURL *url4 = [NSURL URLWithString:path4];
                           NSData *data4 = [NSData dataWithContentsOfURL:url4];
                           UIImage *sharedImage4 = [[UIImage alloc] initWithData:data4];
                           
                           // image 5
                           ITunesAlbum* album5 = [results objectAtIndex:4];
                           id path5 = [album5 artworkUrl100];
                           NSURL *url5 = [NSURL URLWithString:path5];
                           NSData *data5 = [NSData dataWithContentsOfURL:url5];
                           UIImage *sharedImage5 = [[UIImage alloc] initWithData:data5];
                           
                           // image 6
                           ITunesAlbum* album6 = [results objectAtIndex:5];
                           id path6 = [album6 artworkUrl100];
                           NSURL *url6 = [NSURL URLWithString:path6];
                           NSData *data6 = [NSData dataWithContentsOfURL:url6];
                           UIImage *sharedImage6 = [[UIImage alloc] initWithData:data6];
                           
                           
                           dispatch_async(dispatch_get_main_queue(), ^{
                               
                               [[cell image1] setImage:sharedImage];
                               cell.collectionId1 = [album collectionId];
                               [cell title1].text = [album collectionName];
                               [cell artist1].text = [album artistName];
                               
                               [[cell image2] setImage:sharedImage2];
                               cell.collectionId2 = [album2 collectionId];
                               [cell title2].text = [album2 collectionName];
                               [cell artist2].text = [album2 artistName];
                               
                               [[cell image3] setImage:sharedImage3];
                               cell.collectionId3 = [album3 collectionId];
                               [cell title3].text = [album3 collectionName];
                               [cell artist3].text = [album3 artistName];
                               
                               [[cell image4] setImage:sharedImage4];
                               cell.collectionId4 = [album4 collectionId];
                               [cell title4].text = [album4 collectionName];
                               [cell artist4].text = [album4 artistName];
                               
                               [[cell image5] setImage:sharedImage5];
                               cell.collectionId5 = [album5 collectionId];
                               [cell title5].text = [album5 collectionName];
                               [cell artist5].text = [album5 artistName];
                               
                               [[cell image6] setImage:sharedImage6];
                               cell.collectionId6 = [album6 collectionId];
                               [cell title6].text = [album6 collectionName];
                               [cell artist6].text = [album6 artistName];
                               
                               TopRateReadyToFlip = true;
                               
                               [cell stopLoading];
                           });
                           
                       });
    }
}

/**
 *  Timer reatch and flip image are needed.
 */
-(void) nextFlip
{
    if (TopRateReadyToFlip) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           //[self nextTopRate];
                       });
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
                if ([[[arrayToFilter objectAtIndex:i] primaryGenreName] isEqualToString:[_itunes getGenderName:[[[preferredGenders objectAtIndex:y] genderid] integerValue]]]) {
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCellFeatureAlbumStore*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellFeatureAlbumStore* cell = [tableView dequeueReusableCellWithIdentifier:@"FeatureStoreAlbumCell"];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell startLoading];
    
    cell.parentNavCtrl = self.navigationController;
    
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[cell contentView] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[cell contentView] addGestureRecognizer:recognizer];
    
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
        UITableViewCellFeatureAlbumStore* cell = (UITableViewCellFeatureAlbumStore*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (cell && results.count>=6) {
            
            NSLog(@" %s - %@:%ld\n", __PRETTY_FUNCTION__, @"queryResult", (unsigned long)results.count);
            
            // filter results
            topRates = [self filterTopRatesWithPreferred:results];
            
            NSLog(@" %s - %@%ld\n", __PRETTY_FUNCTION__, @"Results:", topRates.count);
            
            currentTopRateStep = 0;
            
            [self displayTopAlbumWithStartIndex:currentTopRateStep];
            
            
            NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"queryResult - end");
        }
    }
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
