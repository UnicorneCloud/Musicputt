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
#import <MediaPlayer/MPMusicPlayerController.h>

@interface UIViewControllerPlaylist () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>
{
    CurrentPlayingToolBar *currentPlayingToolBar;
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

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellPlaylist"];
    
    //cell.textLabel.text = @"text";
    //[cell setBackgroundColor:[UIColor clearColor]];
	//[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //[cell.imageView setImage:[UIImage imageNamed:dict[@"icon"]]];
    return cell;
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
