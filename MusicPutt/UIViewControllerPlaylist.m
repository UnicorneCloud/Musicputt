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
#import "UIViewControllerPlaylistSong.h"
#import "Playlist.h"


#import <MediaPlayer/MediaPlayer.h>

// Identification of tableview section
#define _SECTION_MUSICPUTT_PLAYLIST_    0
#define _SECTION_ITUNES_PLAYLIST_       1


@interface UIViewControllerPlaylist () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIAlertViewDelegate>
{
    //CurrentPlayingToolBar*  currentPlayingToolBar;
    MPMediaQuery*           everything;             // result of current query
    NSArray*                itunesPlaylists;
    NSArray*                musicputtPlaylists;
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
    
    // add playlist button
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"add"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(addPlaylist)];
    [self.navigationItem setLeftBarButtonItem:menuItem];
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Completed");
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // load musicputt playlist
    musicputtPlaylists = [Playlist MR_findAll];
    
    // load query playlist
    everything = [MPMediaQuery playlistsQuery];
    itunesPlaylists = [everything collections];
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
}

- (void) addPlaylist
{
    // enter new playlist name
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter playlist name:"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Ok",
                                                                nil] ;
    alertView.tag = 2;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField * alertTextField = [alertView textFieldAtIndex:0];
    
    // check if playlist name already exist
    NSArray* result = [Playlist MR_findByAttribute:@"name" withValue:alertTextField.text];
    if (result.count>0) {
        NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"This name is already use for a playlist!");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"This name is already use."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil,
                                                                    nil] ;
        [alertView show];
    }
    else{
        // create playlist
        Playlist* playlist = [Playlist MR_createEntity];
        playlist.name = alertTextField.text;
        
        // reload table data to show new playlist
        musicputtPlaylists = [Playlist MR_findAll];
        [self.tableView reloadData];
        
        // set current playlist
        [self.del mpdatamanager].currentPlaylist = nil;
        [self.del mpdatamanager].currentMusicputtPlaylist = playlist;
        
        // pop playlist songs
        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewControllerPlaylistSong *playlistSongs = [sb instantiateViewControllerWithIdentifier:@"PlaylistSongs"];
        [[self navigationController] pushViewController:playlistSongs animated:YES];
    }
}

#pragma mark - AMWaveViewController

- (NSArray*)visibleCells
{
    return [self.tableView visibleCells];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == _SECTION_MUSICPUTT_PLAYLIST_) {
        return [musicputtPlaylists count];
    }
    else if (section == _SECTION_ITUNES_PLAYLIST_){
        return [itunesPlaylists count];
    }
    return 0;
}


- (UITableViewCellPlaylist*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellPlaylist* cell = [tableView dequeueReusableCellWithIdentifier:@"CellPlaylist"];
    
    if (indexPath.section == _SECTION_MUSICPUTT_PLAYLIST_) {
        [cell setPlaylistItem: musicputtPlaylists[indexPath.row]];
    }
    else if (indexPath.section == _SECTION_ITUNES_PLAYLIST_){
        [cell setMediaItem: itunesPlaylists[indexPath.row]];
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}


@end
