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
    CurrentPlayingToolBar*  currentPlayingToolBar;
    MPMediaQuery*           everything;             // result of current query
    NSArray*                m_playlists;
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
    
    // setup app delegate
    self.del = [[UIApplication sharedApplication] delegate];
    
    [self setTitle:@"Playlist"];
    
    currentPlayingToolBar = [[CurrentPlayingToolBar alloc] init];
    currentPlayingToolBar.scrollView = self.tableView;
    //[currentPlayingToolBar showFromNavigationBar:self.navigationController.navigationBar animated:YES];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter
     addObserver: self
     selector:    @selector (handle_NowPlayingItemChanged:)
     name:        MPMusicPlayerControllerNowPlayingItemDidChangeNotification
     object:      [[_del mpdatamanager] musicplayer]];
    
    [notificationCenter
     addObserver: self
     selector:    @selector (handle_PlaybackStateChanged:)
     name:        MPMusicPlayerControllerPlaybackStateDidChangeNotification
     object:      [[_del mpdatamanager] musicplayer]];
    
    [[[_del mpdatamanager] musicplayer] beginGeneratingPlaybackNotifications];
    
    everything = [MPMediaQuery playlistsQuery];
    m_playlists = [everything collections];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma  mark - MPMusicPlayerNSNotificationCenter

-(void) handle_PlaybackStateChanged:(id) notification
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    MPMediaItem* item = [[[_del mpdatamanager] musicplayer] nowPlayingItem];
    if (item!=NULL) {
        [currentPlayingToolBar showFromNavigationBar:self.navigationController.navigationBar animated:YES];
    }
    else{
        [currentPlayingToolBar hideAnimated:YES];
    }
}

-(void) handle_NowPlayingItemChanged:(id) notification
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    MPMediaItem* item = [[[_del mpdatamanager] musicplayer] nowPlayingItem];
    if (item!=NULL) {
        [currentPlayingToolBar showFromNavigationBar:self.navigationController.navigationBar animated:YES];
    }
    else{
        [currentPlayingToolBar hideAnimated:YES];
    }
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_playlists count];
}


- (UITableViewCellPlaylist*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellPlaylist* cell = [tableView dequeueReusableCellWithIdentifier:@"CellPlaylist"];
    MPMediaPlaylist* item =  m_playlists[indexPath.row];
    cell.playlisttitle.text = [item valueForProperty:MPMediaPlaylistPropertyName];
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, [item valueForProperty:MPMediaPlaylistPropertyName]);
    //cell.textLabel.text = @"text";
    //[cell setBackgroundColor:[UIColor clearColor]];
	//[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //[cell.imageView setImage:[UIImage imageNamed:dict[@"icon"]]];
    return cell;
}





#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPMediaPlaylist* item =  m_playlists[indexPath.row];
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, [item valueForProperty:MPMediaPlaylistPropertyName]);
    [self.del mpdatamanager].currentPlaylist = item;
    
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
