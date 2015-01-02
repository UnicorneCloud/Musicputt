//
//  UIViewControllerPlaylistSong.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-28.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerPlaylistSong.h"
#import "AppDelegate.h"
#import "Playlist.h"
#import "UITableViewCellPlaylistSong.h"
#import <BFNavigationBarDrawer.h>
#import <MediaPlayer/MediaPlayer.h>

@interface UIViewControllerPlaylistSong () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>
{
    BOOL                    isMusicputtPlaylist;
    MPMediaQuery*           everything;             // result of current query
    NSArray*                songs;
    BFNavigationBarDrawer*  toolbar;
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
    scrollView = self.tableView;
    
    // init toolbar
    toolbar = nil;
    
    // load playlist
    if ([[self.del mpdatamanager] currentPlaylist] != nil) {
        // itunes playlist
        [self setTitle:[[[self.del mpdatamanager] currentPlaylist] valueForProperty:MPMediaPlaylistPropertyName]];
        songs = [[[self.del mpdatamanager] currentPlaylist] items];
        isMusicputtPlaylist = FALSE;
    }
    else if ([[self.del mpdatamanager] currentMusicputtPlaylist] != nil){
        
        // hide current playing song toolbar
        [[self.del mpdatamanager] setCurrentPlayingToolbarMustBeHidden:true];
        
        // musicputt playlist (it's permit to edit)
        [self setTitle:[[[self.del mpdatamanager] currentMusicputtPlaylist] name]];
        songs = [[[[self.del mpdatamanager] currentMusicputtPlaylist] items] allObjects];
        isMusicputtPlaylist = TRUE;
        
        // display tool bar
        toolbar = [[BFNavigationBarDrawer alloc] init];
        toolbar.scrollView = self.tableView;
        
        // Add some buttons
        //UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
        //UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:0];
        UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
        UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:0];
        UIBarButtonItem *button3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trash)];
        
        toolbar.items = @[button1, button2, button3/*, button4, button5*/];
        
        [toolbar showFromNavigationBar:self.navigationController.navigationBar animated:YES];
    }
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Completed");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated
{
    if (toolbar) {
        [toolbar hideAnimated:YES];
    }
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Completed");
}

- (void) add
{
     NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Completed");
}

- (void) edit
{
     NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Completed");
}

- (void) trash
{
     NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Completed");
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return songs.count;
}


- (UITableViewCellPlaylistSong*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellPlaylistSong* cell = [tableView dequeueReusableCellWithIdentifier:@"CellPlaylistSong"];
    [cell setMediaItem: songs[indexPath.row]];
    return cell;
}

#pragma mark - AMWaveViewController

- (NSArray*)visibleCells
{
    return [self.tableView visibleCells];
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    UITableViewCellPlaylistSong* cell = (UITableViewCellPlaylistSong*)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
    
    NSMutableArray* list = [[NSMutableArray alloc] init];
    NSInteger step = 0;
    NSInteger maxstep = songs.count;
    NSInteger pos = indexPath.row;
    
    while (step<maxstep) {
        [list addObject: [songs objectAtIndex:pos]];
        step++;
        pos++;
        if(pos == songs.count)
            pos=0;
    }
    
    [[[self.del mpdatamanager] musicplayer] stop];
    
    BOOL shuffleWasOn = NO;
    if ([[self.del mpdatamanager] musicplayer].shuffleMode != MPMusicShuffleModeOff &&
        [[self.del mpdatamanager] musicplayer].shuffleMode != MPMusicShuffleModeDefault)
    {
        [[self.del mpdatamanager] musicplayer].shuffleMode = MPMusicShuffleModeOff;
        shuffleWasOn = YES;
    }
    [[[self.del mpdatamanager] musicplayer] setQueueWithItemCollection:[MPMediaItemCollection collectionWithItems:list]];
    [[[self.del mpdatamanager] musicplayer] setNowPlayingItem:[cell getMediaItem]];
    if (shuffleWasOn)
        [[self.del mpdatamanager] musicplayer].shuffleMode = MPMusicShuffleModeSongs;
    
    [[[self.del mpdatamanager] musicplayer] play];
    
    // save last playing playlist
    [[self.del mpdatamanager] setLastPlayingPlaylist:[[[self.del mpdatamanager] currentPlaylist] valueForProperty:MPMediaPlaylistPropertyPersistentID]];
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Completed");
    
    return indexPath;
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
