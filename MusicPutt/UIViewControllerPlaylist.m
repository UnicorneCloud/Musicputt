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
    
    // load musicputt playlist
    musicputtPlaylists = [Playlist MR_findAll];
    
    // load query playlist
    everything = [MPMediaQuery playlistsQuery];
    itunesPlaylists = [everything collections];
    
    // add playlist button
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"add"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(addPlaylist)];
    [self.navigationItem setLeftBarButtonItem:menuItem];
    
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UITextField * alertTextField = [alertView textFieldAtIndex:0];
    NSLog(@"alerttextfiled - %@",alertTextField.text);
    
    // do whatever you want to do with this UITextField.
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
        [cell setMediaItem: musicputtPlaylists[indexPath.row]];
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
