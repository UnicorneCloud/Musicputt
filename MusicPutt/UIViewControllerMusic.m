//
//  MusicViewController.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-24.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "AppDelegate.h"
#import "UIPageContentViewController.h"
#import "UIViewControllerMusic.h"
#import "UIViewControllerArtworkPage.h"
#import "UIViewControllerArtistPage.h"
#import "UIViewControllerLyricsPage.h"
#import "UIButton+Extensions.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPMusicPlayerController.h>
#import <MediaPlayer/MPMediaItem.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>


@interface UIViewControllerMusic () <UIPageViewControllerDataSource, UIScrollViewDelegate>
{
    NSTimer *timer;
}

@property AppDelegate* del;
@property MPDataManager *datamanager;

@end

@implementation UIViewControllerMusic

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    // setup app delegate
    self.del = [[UIApplication sharedApplication] delegate];
    
    // update current playing song display
    [self displayMediaItem:[[[self.del mpdatamanager] musicplayer] nowPlayingItem]];
    [self updateDisplay];
    
    // Create page view content
    _artistpage = [self.storyboard instantiateViewControllerWithIdentifier:@"MusicArtistPage"];
    _artistpage.pageIndex = 0;
    _artworkpage = [self.storyboard instantiateViewControllerWithIdentifier:@"MusicArtworkPage"];
    _artworkpage.pageIndex = 1;
    _artworkpage.view.backgroundColor = [UIColor clearColor];
    _lyricspage = [self.storyboard instantiateViewControllerWithIdentifier:@"MusicLyricsPage"];
    _lyricspage.pageIndex = 2;
    
    _pagecontrol.numberOfPages = 3;
    _pagecontrol.currentPage = 1;
    
    // Create page view controller
    _pageviewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewControllerMusic"];
    _pageviewcontroller.dataSource = self;
    
    UIPageContentViewController *startingViewController = [self viewControllerAtIndex:1];
    NSArray *viewControllers = @[startingViewController];
    [_pageviewcontroller setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
    // Change the size of page view controller
    _pageviewcontroller.view.frame = CGRectMake(0, 0, _pageview.frame.size.width, _pageview.frame.size.height);
    
    [self addChildViewController:_pageviewcontroller];
    
    _pageview.backgroundColor = [UIColor clearColor];
    [_pageview addSubview:_pageviewcontroller.view];
    [_pageviewcontroller didMoveToParentViewController:self];
    
    // create blur effect for _controlview
    UIToolbar *blurtoolbar = [[UIToolbar alloc] initWithFrame:self.view.frame];
    _controlview.backgroundColor = [UIColor clearColor];
    blurtoolbar.autoresizingMask = self.view.autoresizingMask;
    [_controlview insertSubview:blurtoolbar atIndex:0];
    
    // improve hittest for share button.
    [_share setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Completed");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    [[self.del mpdatamanager] setMusicViewControllerVisible:true];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter
     addObserver: self
     selector:    @selector (handle_NowPlayingItemChanged:)
     name:        MPMusicPlayerControllerNowPlayingItemDidChangeNotification
     object:      [[self.del mpdatamanager] musicplayer]];
    
    [notificationCenter
     addObserver: self
     selector:    @selector (handle_PlaybackStateChanged:)
     name:        MPMusicPlayerControllerPlaybackStateDidChangeNotification
     object:      [[self.del mpdatamanager] musicplayer]];
    
    [[[self.del mpdatamanager] musicplayer] beginGeneratingPlaybackNotifications];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(updateDisplay)
                                   userInfo: nil
                                    repeats:YES];
    
    // update current playing song display
    [self displayMediaItem:[[[self.del mpdatamanager] musicplayer] nowPlayingItem]];
    [self updateDisplay];
}



- (void) viewWillDisappear:(BOOL)animated
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    [timer invalidate];
    
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
    
    [[self.del mpdatamanager] setMusicViewControllerVisible:false];
}


-(void) displayMediaItem: (MPMediaItem*) aitem
{
    if (aitem!=NULL) {
        
        // setup title
        [self setTitle:[aitem valueForProperty:MPMediaItemPropertyTitle]];
        
        UIImage* image;
        MPMediaItemArtwork *artwork = [aitem valueForProperty:MPMediaItemPropertyArtwork];
        
        if (artwork) {
            image = [artwork imageWithSize:[_imageview frame].size];
            if(image.size.height==0 || image.size.width==0)
                image = [UIImage imageNamed:@"empty"];
            
        }
        
        [_imageview setImage:image];
        [_songtitle setText:[aitem valueForProperty:MPMediaItemPropertyTitle]];
        
        NSString *artistalbum = [NSString stringWithFormat:@"%@ - %@", [aitem valueForProperty:MPMediaItemPropertyArtist]
                                                                     , [aitem valueForProperty:MPMediaItemPropertyAlbumTitle]];
        [_artistalbum setText:artistalbum];
    }
    else{
        [_imageview setImage:nil];
        [_songtitle setText:@""];
        [_artistalbum setText:@""];
    }
    
}

-(void) updateDisplay
{
    // update current time with progress round
    NSTimeInterval currentTime = [[[self.del mpdatamanager] musicplayer] currentPlaybackTime];
    NSTimeInterval playbackDuration;
    double progressValue = 0;
    
    if ([[[self.del mpdatamanager] musicplayer] nowPlayingItem]!=NULL) {
        NSNumber* duration = [[[[self.del mpdatamanager] musicplayer] nowPlayingItem] valueForKey:MPMediaItemPropertyPlaybackDuration];
        playbackDuration = [duration doubleValue];
        
        if (playbackDuration>0 && currentTime>0) {
            
            // calcul progressvalue
            progressValue = currentTime / playbackDuration;
            
            // set current time
            long minutes = currentTime / 60;
            long seconds = (int)currentTime % 60;
            
            NSString *strCurrentTime = [NSString stringWithFormat:@"%ld:%02ld", minutes, seconds];
            [_curtime setText:strCurrentTime];
            
            // set endtime
            double timerest = [duration integerValue] - currentTime;
            minutes = timerest / 60;
            seconds = (int)timerest % 60;
            
            NSString *enddingTime = [NSString stringWithFormat:@"-%ld:%02ld", minutes, seconds];
            [_endtime setText:enddingTime];
        }
    }
    [_progresstime setProgress:progressValue animated:false];
    
    // update icon play/pause
    //MPMusicPlayerController* player = [[self.del mpdatamanager] musicplayer];
    //if([player playbackState] == MPMoviePlaybackStatePlaying)
    if([[AVAudioSession sharedInstance] isOtherAudioPlaying])
        [_playpause setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    else
        [_playpause setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];

    
    // update repeat button
    if ([[[self.del mpdatamanager] musicplayer] repeatMode] == MPMusicRepeatModeDefault ||
        [[[self.del mpdatamanager] musicplayer] repeatMode] == MPMusicRepeatModeAll ||
        [[[self.del mpdatamanager] musicplayer] repeatMode] == MPMusicRepeatModeOne ) {
        _repeat.opaque = false;
        _repeat.alpha = 1.0;
    }
    else{
        _repeat.opaque = false;
        _repeat.alpha = 0.5;
    }
    
    // update shuffle button
    if ([[[self.del mpdatamanager] musicplayer] shuffleMode] == MPMusicShuffleModeDefault ||
        [[[self.del mpdatamanager] musicplayer] shuffleMode] == MPMusicShuffleModeSongs ||
        [[[self.del mpdatamanager] musicplayer] shuffleMode] == MPMusicShuffleModeAlbums ) {
        _shuffle.opaque = false;
        _shuffle.alpha = 1.0;
    }
    else{
        _shuffle.opaque = false;
        _shuffle.alpha = 0.5;
    }
}


#pragma mark - Button action

- (IBAction)shufflePressed:(id)sender
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    MPMusicPlayerController* player = [[self.del mpdatamanager] musicplayer];
    if ([[[self.del mpdatamanager] musicplayer] shuffleMode] == MPMusicShuffleModeDefault ||
        [[[self.del mpdatamanager] musicplayer] shuffleMode] == MPMusicShuffleModeSongs ||
        [[[self.del mpdatamanager] musicplayer] shuffleMode] == MPMusicShuffleModeAlbums ) {
        player.shuffleMode = MPMusicShuffleModeOff;
        _shuffle.opaque = false;
        _shuffle.alpha = 0.5;
    }
    else{
        player.shuffleMode = MPMusicShuffleModeSongs;
        _shuffle.opaque = false;
        _shuffle.alpha = 1.0;
    }
    
}

- (IBAction)repeatPressed:(id)sender
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    MPMusicPlayerController* player = [[self.del mpdatamanager] musicplayer];
    if ([[[self.del mpdatamanager] musicplayer] repeatMode] == MPMusicRepeatModeDefault ||
        [[[self.del mpdatamanager] musicplayer] repeatMode] == MPMusicRepeatModeAll ||
        [[[self.del mpdatamanager] musicplayer] repeatMode] == MPMusicRepeatModeOne ) {
        player.repeatMode = MPMusicRepeatModeNone;
        _repeat.opaque = false;
        _repeat.alpha = 0.5;
    }
    else{
        player.repeatMode = MPMusicRepeatModeAll;
        _repeat.opaque = false;
        _repeat.alpha = 1.0;
    }
}


- (IBAction)rewindPressed:(id)sender
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    MPMusicPlayerController* player = [[self.del mpdatamanager] musicplayer];
    NSTimeInterval currentTime = [[[self.del mpdatamanager] musicplayer] currentPlaybackTime];
    if (currentTime<=2.0) {
        [player skipToPreviousItem];
    }
    else{
        [player skipToBeginning];
    }
    
}


- (IBAction)playpausePressed:(id)sender
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    MPMusicPlayerController* player = [[self.del mpdatamanager] musicplayer];
    //if([player playbackState] == MPMoviePlaybackStatePlaying)
    if([[AVAudioSession sharedInstance] isOtherAudioPlaying])
    {
        [player pause];
        [_playpause setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
    else
    {
        [player play];
        [_playpause setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
}


- (IBAction)fastFowardPressed:(id)sender
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    MPMusicPlayerController* player = [[self.del mpdatamanager] musicplayer];
    [player skipToNextItem];
}

- (void) imageViewPressed
{
    _menubar.hidden = !_menubar.isHidden;
}


/**
 *  Share button was pressed by the user.
 *
 *  @param sender sender of event.
 */
- (IBAction)sharePressed:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *fbPost = [SLComposeViewController
                                           composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        
        [fbPost setInitialText: [NSString stringWithFormat:@"I'm listening : %@ - %@ @musicputt!", _songtitle.text, _artistalbum.text]];
        [fbPost addImage:_imageview.image];
        [self presentViewController:fbPost animated:YES completion:nil];
        [fbPost setCompletionHandler:^(SLComposeViewControllerResult result) {
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                default:
                    break;
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    else{
        UIAlertView *message = [[UIAlertView alloc]
                                initWithTitle:@"Error"
                                message:@"Your facebook service account is not set up and reachable. Go to setting for setup your facebook account."
                                delegate:nil
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
        
        [message show];
    
    }

}



#pragma  mark - MPMusicPlayerNSNotificationCenter

-(void) handle_PlaybackStateChanged:(id) notification
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    [self displayMediaItem:[[[self.del mpdatamanager] musicplayer] nowPlayingItem]];
    
}

-(void) handle_NowPlayingItemChanged:(id) notification
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    [self displayMediaItem:[[[self.del mpdatamanager] musicplayer] nowPlayingItem]];
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((UIPageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((UIPageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == 1) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (UIPageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    // Create a new view controller and pass suitable data.
    UIPageContentViewController *pageContentViewController;
    if(index==0)
    {
        pageContentViewController = _artistpage;
    }
    else if(index ==1)
    {
        pageContentViewController = _artworkpage;
    }
    else if(index ==2)
    {
        pageContentViewController = _lyricspage;
    }
    return pageContentViewController;
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
