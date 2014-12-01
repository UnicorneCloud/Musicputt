//
//  ViewControllerPlaylist.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-28.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerPlaylist.h"
#import "UICurrentPlayingToolBar.h"
#import "AppDelegate.h"
#import "UITableViewCellPlaylist.h"
#import <MediaPlayer/MediaPlayer.h>

@interface UIViewControllerPlaylist () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>
{
    //CurrentPlayingToolBar*  currentPlayingToolBar;
    MPMediaQuery*           everything;             // result of current query
    NSArray*                playlists;
}

@property (weak, nonatomic) IBOutlet UITableView*            tableView;
@property AppDelegate* del;

@end

@implementation UIViewControllerPlaylist

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
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    // setup app delegate
    self.del = [[UIApplication sharedApplication] delegate];
    
    // setup title
    [self setTitle:@"Playlist"];
    
    // setup tableview
    scrollView = _tableView;
    
    // setup query playlist
    everything = [MPMediaQuery playlistsQuery];
    playlists = [everything collections];
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Completed");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
}

#pragma mark - AMWaveViewController

- (NSArray*)visibleCells
{
    return [self.tableView visibleCells];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [playlists count];
}


- (UITableViewCellPlaylist*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellPlaylist* cell = [tableView dequeueReusableCellWithIdentifier:@"CellPlaylist"];
    [cell setMediaItem: playlists[indexPath.row]];
    return cell;
}


#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //MPMediaPlaylist* item = playlists[indexPath.row];
    //[self.del mpdatamanager].currentPlaylist = item;
    return indexPath;
}


@end
