//
//  UIViewControllerStoreSongs.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-08-02.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerStoreSongs.h"

#import "AppDelegate.h"
#import "MPServiceStore.h"
#import "UITableViewCellSongStore.h"
#import <AVFoundation/AVFoundation.h>



@interface UIViewControllerStoreSongs () <MPServiceStoreDelegate, UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate>
{
    NSArray* result;
    AVAudioPlayer* audioPlayer;
    MPMusicTrack* currentPlaying;
}

/**
 *  App delegate
 */
@property AppDelegate* del;

/**
 *  Table view of songs
 */
@property (weak, nonatomic) IBOutlet UITableView* tableView;


@end



@implementation UIViewControllerStoreSongs

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
    
    // query store for top song of artist
    MPServiceStore *store = [[MPServiceStore alloc]init];
    [store setDelegate:self];
    [store queryMusicTrackWithArtistId:_storeArtistId asynchronizationMode:true];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  Ensure that playing preview song is ended
 */
- (void) stopPlaying
{
    [audioPlayer stop];
}

/**
 *  Share button was pressed by the user.
 *
 *  @param sender sender of event.
 */
- (IBAction)sharePressed:(id)sender
{
    NSString* sharedString = [NSString stringWithFormat:@"I'm listening : %@ - %@ @musicputt!", [currentPlaying trackName], [currentPlaying collectionName]];
    NSURL* sharedUrl = [NSURL URLWithString:[currentPlaying trackViewUrl]];
    
    id path = [currentPlaying artworkUrl100];
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


#pragma mark MPServiceStoreDelegate
/**
 *  Implement this methode for recieve result after query.
 *
 *  @param status  Status of the querys
 *  @param type    Type of query sender
 *  @param results resultset of the query
 */
-(void) queryResult:(MPServiceStoreQueryStatus)status type:(MPServiceStoreQueryType)type results:(NSArray*)results
{
    if (status!=MPServiceStoreStatusSucceed || [results count]==0)
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
        if (type == MPQueryMusicTrackWithArtistId)
        {
            result = results;
            if (result.count>0)
            {
                currentPlaying = [result objectAtIndex:1];
            }
            [_tableView reloadData];
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
    if (result!=nil && result.count>0) {
        return result.count-1;
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
- (UITableViewCellSongStore*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellSongStore* cell = [tableView dequeueReusableCellWithIdentifier:@"SongStore"];
    [cell setMediaItem:[result objectAtIndex:indexPath.row+1]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentPlaying = [result objectAtIndex:indexPath.row+1];
    NSURL *url = [NSURL URLWithString: [[result objectAtIndex:indexPath.row+1] previewUrl]];
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
        [audioPlayer play];
    }];
    [task resume];
    
    return indexPath;
}


#pragma mark - AVAudioPlayerDelegate

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [audioPlayer stop];
    NSLog(@"Finished Playing");
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"Error occured");
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
