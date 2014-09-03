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
    BOOL isShowTabbar;
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
    
    isShowTabbar = false;
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
    
    // setup currentPlayingToolBar
    currentPlayingToolBar = [[self.del mpdatamanager] currentPlayingToolbar];
    [currentPlayingToolBar hideAnimated:NO];
    [currentPlayingToolBar setNavigationController:self.navigationController];
    currentPlayingToolBar.scrollView = self->toolbarTableView;
    
    
    MPMusicPlayerController* player = [[self.del mpdatamanager] musicplayer];
    //if([player playbackState] == MPMoviePlaybackStatePlaying)
    if([[AVAudioSession sharedInstance] isOtherAudioPlaying])
    {
        [currentPlayingToolBar showFromNavigationBar:self.navigationController.navigationBar animated:YES];
        isShowTabbar = true;
    }
    else
    {
        if ([player nowPlayingItem] == nil)
        {
            isShowTabbar = false;
        }
        else
        {
            [currentPlayingToolBar showFromNavigationBar:self.navigationController.navigationBar animated:YES];
            isShowTabbar = true;
        }
        
    }
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Complete");
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // setup currentPlayingToolBar
    if ([[self.del mpdatamanager] isMusicViewControllerVisible]) {
        currentPlayingToolBar = [[self.del mpdatamanager] currentPlayingToolbar];
        [self hideTabbar];
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


#pragma  mark - MPMusicPlayerNSNotificationCenter

-(void) handle_PlaybackStateChanged:(id) notification
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    MPMusicPlayerController* player = [[self.del mpdatamanager] musicplayer];
    //if([player playbackState] == MPMoviePlaybackStatePlaying)
    if([[AVAudioSession sharedInstance] isOtherAudioPlaying])
        [self showTabbar];
    else
    {
        if ([player nowPlayingItem] == nil)
            [self hideTabbar];
    }
}

-(void) handle_NowPlayingItemChanged:(id) notification
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    MPMusicPlayerController* player = [[self.del mpdatamanager] musicplayer];
    //if([player playbackState] == MPMoviePlaybackStatePlaying)
    if([[AVAudioSession sharedInstance] isOtherAudioPlaying])
    {
        [self showTabbar];
    }
    else
    {
        if ([player nowPlayingItem] == nil)
            [self hideTabbar];
    }
}

-(void) showTabbar
{
    if (![currentPlayingToolBar isVisible]) {
        [currentPlayingToolBar showFromNavigationBar:self.navigationController.navigationBar animated:YES];
    }
}

-(void) hideTabbar
{
    if ([currentPlayingToolBar isVisible]) {
        [currentPlayingToolBar hideAnimated:YES];
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
