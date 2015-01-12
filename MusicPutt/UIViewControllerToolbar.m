//
//  UIViewControllerTabbar.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-30.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerToolbar.h"
#import "UICurrentPlayingToolBar.h"
#import "AppDelegate.h"

#import <AVFoundation/AVFoundation.h>

@interface UIViewControllerToolbar ()
{
    BOOL isShowCurrentPlayingToolbar;
    BOOL isShowCurrentEditingPlaylistToolbar;
}

@property AppDelegate* del;

@end

@implementation UIViewControllerToolbar


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
    
    // by default current playlist toolbar is hide.
    isShowCurrentPlayingToolbar = false;
    
    // by default current editing playlist is hide.
    isShowCurrentEditingPlaylistToolbar = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    // setup Notification for NowPlayingItem
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
    
    // setup current editing playlist toolbar
    currentEditingPlaylistToolbar = [[self.del mpdatamanager] currentEditingPlaylistToolbar];
    [self hideCurrentEditingPlaylistToolbar];
    currentEditingPlaylistToolbar.scrollView = self->scrollView;

    if ([[self.del mpdatamanager] isPlaylistEditing]) {
        [currentEditingPlaylistToolbar showFromNavigationBar:self.navigationController.navigationBar animated:YES];
        isShowCurrentEditingPlaylistToolbar = true;
    }
    else{
        isShowCurrentEditingPlaylistToolbar = false;
    }
    
    // setup currentPlayingToolBar
    currentPlayingToolBar = [[self.del mpdatamanager] currentPlayingToolbar];
    [self hideCurrentPlayingToolbar];
    [currentPlayingToolBar setNavigationController:self.navigationController];
    currentPlayingToolBar.scrollView = self->scrollView;
    
    // show current playing toolbar only if current editing playlist toolbar aren't shown
    if (isShowCurrentEditingPlaylistToolbar==false) {
        
        MPMusicPlayerController* player = [[self.del mpdatamanager] musicplayer];
        //if([player playbackState] == MPMoviePlaybackStatePlaying)
        if([[AVAudioSession sharedInstance] isOtherAudioPlaying])
        {
            [currentPlayingToolBar showFromNavigationBar:self.navigationController.navigationBar animated:YES];
            isShowCurrentPlayingToolbar = true;
        }
        else
        {
            if ([player nowPlayingItem] == nil)
            {
                isShowCurrentPlayingToolbar = false;
            }
            else
            {
                [currentPlayingToolBar showFromNavigationBar:self.navigationController.navigationBar animated:YES];
                isShowCurrentPlayingToolbar = true;
            }
        }
    }
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Complete");
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // hide current playing toolbar
    if ([[self.del mpdatamanager] isPlaylistEditing]==false) {
        currentEditingPlaylistToolbar = [[self.del mpdatamanager] currentEditingPlaylistToolbar];
        [self hideCurrentEditingPlaylistToolbar];
    }
    
    // hide current playing toolbar
    if ([[self.del mpdatamanager] currentPlayingToolbarMustBeHidden]) {
        currentPlayingToolBar = [[self.del mpdatamanager] currentPlayingToolbar];
        [self hideCurrentPlayingToolbar];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    // desabled notification if view is not visible.
    [[NSNotificationCenter defaultCenter]
     removeObserver: self
     name:           MPMusicPlayerControllerNowPlayingItemDidChangeNotification
     object:         [[_del mpdatamanager] musicplayer]];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver: self
     name:           MPMusicPlayerControllerPlaybackStateDidChangeNotification
     object:         [[_del mpdatamanager] musicplayer]];
    
    [[[_del mpdatamanager] musicplayer] endGeneratingPlaybackNotifications];

    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Completed");
}

-(void) showCurrentPlayingToolbar
{
    if ([[self.del mpdatamanager] currentPlayingToolbarMustBeHidden] == false && [[AVAudioSession sharedInstance] isOtherAudioPlaying]){
        if (![currentPlayingToolBar isVisible]) {
            [currentPlayingToolBar showFromNavigationBar:self.navigationController.navigationBar animated:YES];
        }
    }
}

-(void) hideCurrentPlayingToolbar
{
    if ([currentPlayingToolBar isVisible]) {
        [currentPlayingToolBar hideAnimated:YES];
    }
}

-(void) showCurrentEditingPlaylistToolbar
{
    if ([[self.del mpdatamanager] isPlaylistEditing] == TRUE) {
        if([currentEditingPlaylistToolbar isVisible] == FALSE){
            [currentEditingPlaylistToolbar showFromNavigationBar:self.navigationController.navigationBar animated:YES];
        }
    }
}

-(void) hideCurrentEditingPlaylistToolbar
{
    if ([currentEditingPlaylistToolbar isVisible]) {
        [currentEditingPlaylistToolbar hideAnimated:YES];
    }
}


-(void) setupNavigationBar
{
    // setup currentPlayingToolBar
    currentPlayingToolBar = [[self.del mpdatamanager] currentPlayingToolbar];
    [self hideCurrentPlayingToolbar];
    [currentPlayingToolBar setNavigationController:self.navigationController];
    currentPlayingToolBar.scrollView = self->scrollView;
}


#pragma  mark - MPMusicPlayerNSNotificationCenter

-(void) handle_PlaybackStateChanged:(id) notification
{
    //NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    MPMusicPlayerController* player = [[self.del mpdatamanager] musicplayer];
    //if([player playbackState] == MPMoviePlaybackStatePlaying)
    if([[AVAudioSession sharedInstance] isOtherAudioPlaying])
        [self showCurrentPlayingToolbar];
    else
    {
        if ([player nowPlayingItem] == nil)
            [self hideCurrentPlayingToolbar];
    }
}

-(void) handle_NowPlayingItemChanged:(id) notification
{
    //NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    MPMusicPlayerController* player = [[self.del mpdatamanager] musicplayer];
    //if([player playbackState] == MPMoviePlaybackStatePlaying)
    if([[AVAudioSession sharedInstance] isOtherAudioPlaying])
    {
        [self showCurrentPlayingToolbar];
    }
    else
    {
        if ([player nowPlayingItem] == nil)
            [self hideCurrentPlayingToolbar];
    }
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
