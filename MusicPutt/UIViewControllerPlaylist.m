//
//  ViewControllerPlaylist.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-28.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerPlaylist.h"
#import "CurrentPlayingToolBar.h"
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
    toolbarTableView = _tableView;
    
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

- (IBAction)addPlaylistToSonglist:(id)sender
{
    MPMediaPlaylist* item =  playlists[0];
    for (int i=0 ; i<=item.items.count ; i++) {
        [[[self.del mpdatamanager] currentSonglist] addObject:item.items[i]];
    }
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
    MPMediaPlaylist* item =  playlists[indexPath.row];
    cell.playlisttitle.text = [item valueForProperty:MPMediaPlaylistPropertyName];
    cell.playlistnbtracks.text = [NSString stringWithFormat:@"%lu track(s)", (unsigned long)item.count];
    cell.uid = [item valueForProperty:MPMediaPlaylistPropertyPersistentID];
    
    if(item.count>0)
    {
        UIImage* image;
        MPMediaItem* song = item.items[0]; // 0 to keep firts item in playlist
        MPMediaItemArtwork *artwork = [song valueForProperty:MPMediaItemPropertyArtwork];
        if (artwork)
            image = [artwork imageWithSize:[cell.imageview frame].size];
        if (image.size.height>0 && image.size.width>0) // check if image present
            [cell.imageview setImage:image];
        else
            [cell.imageview setImage:[UIImage imageNamed:@"empty"]];
    }
    else
    {
        [cell.imageview setImage:[UIImage imageNamed:@"empty"]];
    }
    
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, [item valueForProperty:MPMediaPlaylistPropertyName]);
    return cell;
}


#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPMediaPlaylist* item = playlists[indexPath.row];
    [self.del mpdatamanager].currentPlaylist = item;
    return indexPath;
}


@end
