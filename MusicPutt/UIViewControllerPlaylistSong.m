//
//  UIViewControllerPlaylistSong.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-28.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerPlaylistSong.h"
#import "AppDelegate.h"
#import "UITableViewCellPlaylistSong.h"
#import <MediaPlayer/MediaPlayer.h>

@interface UIViewControllerPlaylistSong () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>
{
    //CurrentPlayingToolBar*  currentPlayingToolBar;
    MPMediaQuery*           everything;             // result of current query
    NSArray*                m_songs;
}

@property (weak, nonatomic) IBOutlet UITableView*            tableView;
@property AppDelegate* del;

@end

@implementation UIViewControllerPlaylistSong

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
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    // setup app delegate
    self.del = [[UIApplication sharedApplication] delegate];
    
    // setup table view
    toolbarTableView = self.tableView;
    
    // setup title
    [self setTitle:[[[self.del mpdatamanager] currentPlaylist] valueForProperty:MPMediaPlaylistPropertyName]];
    
    // query playlist songs
    everything = [MPMediaQuery playlistsQuery];
    MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:[[[self.del mpdatamanager] currentPlaylist] valueForProperty:MPMediaPlaylistPropertyPersistentID]
                                                                    forProperty:MPMediaPlaylistPropertyPersistentID
                                                                    comparisonType:MPMediaPredicateComparisonEqualTo];
   [everything addFilterPredicate:predicate];
    m_songs = [everything items];
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Completed");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_songs.count;
}


- (UITableViewCellPlaylistSong*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellPlaylistSong* cell = [tableView dequeueReusableCellWithIdentifier:@"CellPlaylistSong"];
    MPMediaItem* item =  m_songs[indexPath.row];
    cell.title.text = [item valueForProperty:MPMediaItemPropertyTitle];
    cell.artist.text = [item valueForProperty:MPMediaItemPropertyArtist];
    cell.album.text = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
    
    UIImage* image;
    MPMediaItemArtwork *artwork = [item valueForProperty:MPMediaItemPropertyArtwork];
    if (artwork)
        image = [artwork imageWithSize:[cell.imageview frame].size];
    if (image.size.height>0 && image.size.width>0) // check if image present
        [cell.imageview setImage:image];
    else
        [cell.imageview setImage:[UIImage imageNamed:@"empty"]];
    
    return cell;
}

#pragma mark - AMWaveViewController

- (NSArray*)visibleCells
{
    return [self.tableView visibleCells];
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
