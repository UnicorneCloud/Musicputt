//
//  UIViewControllerTabbar.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-30.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerTabbar.h"
#import "CurrentPlayingToolBar.h"
#import "AppDelegate.h"

#import <AVFoundation/AVFoundation.h>

@interface UIViewControllerTabbar ()
{
    BOOL isShowTabbar;
}

@property AppDelegate* del;

@end

@implementation UIViewControllerTabbar

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

- (void)viewWillDisappear:(BOOL)animated
{
    // setup currentPlayingToolBar
    currentPlayingToolBar = [[self.del mpdatamanager] currentPlayingToolbar];
    [currentPlayingToolBar hideAnimated:YES];

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
    if (!isShowTabbar) {
        [currentPlayingToolBar showFromNavigationBar:self.navigationController.navigationBar animated:YES];
        isShowTabbar = true;
    }
    
}

-(void) hideTabbar
{
    if (isShowTabbar) {
        [currentPlayingToolBar hideAnimated:YES];
        isShowTabbar = false;
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
