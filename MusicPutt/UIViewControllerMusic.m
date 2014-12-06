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
#import "UIViewControllerAlbumPage.h"
#import "UIViewControllerLyricsPage.h"
#import "UIButton+Extensions.h"
#import "UIImageViewArtwork.h"


#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPMusicPlayerController.h>
#import <MediaPlayer/MPMediaItem.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>


@interface UIViewControllerMusic () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>
{
    NSTimer *timer;
}

/**
 *  App delegate
 */
@property AppDelegate* del;

/**
 *  Data manager of musicputt app
 */
@property MPDataManager *datamanager;

/**
 *  Page view controller for access artist, album and lyrics.
 */
@property (weak, nonatomic) IBOutlet UIPageViewController*  pageviewcontroller;

/**
 *  View that content page view controller for artist, album and lyrics.
 */
@property (weak, nonatomic) IBOutlet UIView*            pageview;

/**
 *  Artwork page.
 */
@property (strong, nonatomic) UIViewControllerArtworkPage* artworkpage;

/**
 *  Album details page.
 */
@property (strong, nonatomic) UIViewControllerAlbumPage* albumpage;

/**
 *  Artist information page. (Not display right now)
 */
@property (strong, nonatomic) UIViewControllerArtistPage* artistpage;

/**
 *  Lyrics page.
 */
@property (strong, nonatomic) UIViewControllerLyricsPage* lyricspage;

/**
 *  Artwork of the current playing song.
 */
@property (weak, nonatomic) IBOutlet UIImageView*       imageview;

/**
 *  Page control to display page.
 */
@property (weak, nonatomic) IBOutlet UIPageControl*     pagecontrol;

/**
 *  Song title of the current playing song.
 */
@property (weak, nonatomic) IBOutlet UILabel*           songtitle;

/**
 *  Artist and Album title of the current playing song.
 */
@property (weak, nonatomic) IBOutlet UILabel*           artistalbum;

/**
 *  View contain all controls to manage media player.
 */
@property (weak, nonatomic) IBOutlet UIView*            controlview;

/**
 *  Current playing time. Position in the current playing song.
 */
@property (weak, nonatomic) IBOutlet UILabel*           curtime;

/**
 *  Elapse time to reach end of the current playing song.
 */
@property (weak, nonatomic) IBOutlet UILabel*           endtime;

/**
 *  Progressbar to display current position in the current playing song.
 */
@property (weak, nonatomic) IBOutlet UIProgressView*    progresstime;

/**
 *  Button to display and manage shuffle mode of the media player.
 */
@property (weak, nonatomic) IBOutlet UIButton*          shuffle;

/**
 *  Button to display and manage the repeat mode of the media player.
 */
@property (weak, nonatomic) IBOutlet UIButton*          repeat;

/**
 *  Button to manage the rewind for the media player.
 */
@property (weak, nonatomic) IBOutlet UIButton*          rewind;

/**
 *  Play/Pause button for the media player.
 */
@property (weak, nonatomic) IBOutlet UIButton*          playpause;

/**
 *  Button to manage fastfoward for the media player.
 */
@property (weak, nonatomic) IBOutlet UIButton*          fastfoward;


/**
 *  Button to manage share functionality
 */
@property (weak, nonatomic) IBOutlet UIButton*          share;

/**
 *  Menu bar on top of the Artwork for display lyrics, artist, album, discover, share.
 */
@property (weak, nonatomic) IBOutlet UIView*            menubar;


@end

@implementation UIViewControllerMusic


/**
 *  Init with nib file. Not user right now.
 *
 *  @param nibNameOrNil   <#nibNameOrNil description#>
 *  @param nibBundleOrNil <#nibBundleOrNil description#>
 *
 *  @return <#return value description#>
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


/**
 *  viewDidLoad 
 *  Init delegate, update current playing song, create page view.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    // setup app delegate
    self.del = [[UIApplication sharedApplication] delegate];
    
    // update current playing song display
    [self displayMediaItem:[[[self.del mpdatamanager] musicplayer] nowPlayingItem]];
    [self updateDisplay];
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"updateDisplay completed.");
    
    // Create page view content
    //_artistpage = [self.storyboard instantiateViewControllerWithIdentifier:@"MusicArtistPage"];
    //_artistpage.pageIndex = 0;
    
    CGRect framealbum = _pageview.frame;
    framealbum.origin.x = 0;
    framealbum.origin.y = 0;
    
    CGRect framelyrics = _pageview.frame;
    framelyrics.origin.x = 0;
    framelyrics.origin.y = 0;
    
    _albumpage = [self.storyboard instantiateViewControllerWithIdentifier:@"MusicAlbumPage"];
    _albumpage.pageIndex = 0;
    _albumpage.view.frame = framealbum;
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"MusicAlbumPage completed.");
    
    _artworkpage = [self.storyboard instantiateViewControllerWithIdentifier:@"MusicArtworkPage"];
    _artworkpage.pageIndex = 1;
    _artworkpage.view.backgroundColor = [UIColor clearColor];
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"MusicArtworkPage completed.");
    
    _lyricspage = [self.storyboard instantiateViewControllerWithIdentifier:@"MusicLyricsPage"];
    _lyricspage.view.frame = framelyrics;
    _lyricspage.pageIndex = 2;
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"MusicLyricsPage completed.");
    
    _pagecontrol.numberOfPages = 3;
    _pagecontrol.currentPage = 1;
    
    // Create page view controller
    _pageviewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewControllerMusic"];
    _pageviewcontroller.dataSource = self;
    
    UIPageContentViewController *startingViewController = [self viewControllerAtIndex:1];
    NSArray *viewControllers = @[startingViewController];
    [_pageviewcontroller setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [_pageviewcontroller setDelegate:self];
    
    // Change the size of page view controller
    _pageviewcontroller.view.frame = CGRectMake(0, 0, _pageview.frame.size.width, _pageview.frame.size.height);
    
    [self addChildViewController:_pageviewcontroller];
    
    _pageview.backgroundColor = [UIColor clearColor];
    [_pageview addSubview:_pageviewcontroller.view];
    [_pageviewcontroller didMoveToParentViewController:self];
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"pageViewController completed.");
    
    // create blur effect for _controlview
    UIToolbar *blurtoolbar = [[UIToolbar alloc] initWithFrame:self.view.frame];
    _controlview.backgroundColor = [UIColor clearColor];
    blurtoolbar.autoresizingMask = self.view.autoresizingMask;
    [_controlview insertSubview:blurtoolbar atIndex:0];
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Blur effect completed.");
    
    // improve hittest for share button.
    [_share setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Completed");
}


/**
 *  <#Description#>
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/**
 *  Start notification from mediaplayer, start timer update current time.
 *
 *  @param animated <#animated description#>
 */
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


/**
 *  Stop notification, stop timer update current time.
 *
 *  @param animated <#animated description#>
 */
- (void) viewWillDisappear:(BOOL)animated
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    // stop timer update current time
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


/**
 *  Display current playing song
 *
 *  @param aitem <#aitem description#>
 */
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
        // setup title
        [self setTitle:@""];
        
        [_imageview setImage:[UIImage imageNamed:@"empty"]];
        [_songtitle setText:@""];
        [_artistalbum setText:@""];
    }
    
}

/**
 *  Update current playing time, update progress, update button control
 */
-(void) updateDisplay
{
    // update display only if mediaplayer if ready
    if ([[self.del mpdatamanager] isMediaPlayerInitialized])
    {
        // update current time with progress round
        NSTimeInterval currentTime = 0;
        NSTimeInterval playbackDuration;
        double progressValue = 0;
        
        if ([[[self.del mpdatamanager] musicplayer] nowPlayingItem]!=NULL)
        {
            NSNumber* duration = [[[[self.del mpdatamanager] musicplayer] nowPlayingItem] valueForKey:MPMediaItemPropertyPlaybackDuration];
            playbackDuration = [duration doubleValue];
            currentTime = [[[self.del mpdatamanager] musicplayer] currentPlaybackTime];
            
            if (playbackDuration>0 && currentTime>0)
            {
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
            [[[self.del mpdatamanager] musicplayer] repeatMode] == MPMusicRepeatModeOne )
        {
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
            [[[self.del mpdatamanager] musicplayer] shuffleMode] == MPMusicShuffleModeAlbums )
        {
            _shuffle.opaque = false;
            _shuffle.alpha = 1.0;
        }
        else{
            _shuffle.opaque = false;
            _shuffle.alpha = 0.5;
        }
    }
    else
    {
        NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"[Warning] - MediaPlayer isn't initialized.");
    }
}


#pragma mark - Button action

/**
 *  Shuffle pressed
 *
 *  @param sender <#sender description#>
 */
- (IBAction)shufflePressed:(id)sender
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    // do action only if mediaplayer if ready
    if ([[self.del mpdatamanager] isMediaPlayerInitialized])
    {
        MPMusicPlayerController* player = [[self.del mpdatamanager] musicplayer];
        if ([[[self.del mpdatamanager] musicplayer] shuffleMode] == MPMusicShuffleModeDefault ||
            [[[self.del mpdatamanager] musicplayer] shuffleMode] == MPMusicShuffleModeSongs ||
            [[[self.del mpdatamanager] musicplayer] shuffleMode] == MPMusicShuffleModeAlbums )
        {
            player.shuffleMode = MPMusicShuffleModeOff;
            _shuffle.opaque = false;
            _shuffle.alpha = 0.5;
        }
        else
        {
            player.shuffleMode = MPMusicShuffleModeSongs;
            _shuffle.opaque = false;
            _shuffle.alpha = 1.0;
        }
    }
    else
    {
        NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"[Warning] - MediaPlayer isn't initialized.");
    }
    
}


/**
 *  Repeat pressed.
 *
 *  @param sender <#sender description#>
 */
- (IBAction)repeatPressed:(id)sender
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    // do action only if mediaplayer if ready
    if ([[self.del mpdatamanager] isMediaPlayerInitialized])
    {
        MPMusicPlayerController* player = [[self.del mpdatamanager] musicplayer];
        if ([[[self.del mpdatamanager] musicplayer] repeatMode] == MPMusicRepeatModeDefault ||
            [[[self.del mpdatamanager] musicplayer] repeatMode] == MPMusicRepeatModeAll ||
            [[[self.del mpdatamanager] musicplayer] repeatMode] == MPMusicRepeatModeOne )
        {
            player.repeatMode = MPMusicRepeatModeNone;
            _repeat.opaque = false;
            _repeat.alpha = 0.5;
        }
        else
        {
            player.repeatMode = MPMusicRepeatModeAll;
            _repeat.opaque = false;
            _repeat.alpha = 1.0;
        }
    }
    else
    {
        NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"[Warning] - MediaPlayer isn't initialized.");
    }
}

/**
 *  Rewind pressed
 *
 *  @param sender <#sender description#>
 */
- (IBAction)rewindPressed:(id)sender
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    // do action only if mediaplayer if ready
    if ([[self.del mpdatamanager] isMediaPlayerInitialized])
    {
        MPMusicPlayerController* player = [[self.del mpdatamanager] musicplayer];
        NSTimeInterval currentTime = [[[self.del mpdatamanager] musicplayer] currentPlaybackTime];
        if (currentTime<=2.0) {
            [player skipToPreviousItem];
        }
        else{
            [player skipToBeginning];
        }
    }
    else
    {
        NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"[Warning] - MediaPlayer isn't initialized.");
    }
    
}


/**
 *  Play/pause pressed
 *
 *  @param sender <#sender description#>
 */
- (IBAction)playpausePressed:(id)sender
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    // do action only if mediaplayer if ready
    if ([[self.del mpdatamanager] isMediaPlayerInitialized])
    {
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
    else
    {
        NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"[Warning] - MediaPlayer isn't initialized.");
    }
}

/**
 *  Fastfoward pressed
 *
 *  @param sender <#sender description#>
 */
- (IBAction)fastFowardPressed:(id)sender
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    // do action only if mediaplayer if ready
    if ([[self.del mpdatamanager] isMediaPlayerInitialized])
    {
        MPMusicPlayerController* player = [[self.del mpdatamanager] musicplayer];
        [player skipToNextItem];
    }
    else
    {
        NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"[Warning] - MediaPlayer isn't initialized.");
    }
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
    NSString* sharedString = [NSString stringWithFormat:@"I'm listening : %@ - %@ @musicputt!", _songtitle.text, _artistalbum.text];
    UIImage* sharedImage = _imageview.image;
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[sharedString, sharedImage] applicationActivities:nil];
    controller.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact];
    [self presentViewController:controller animated:YES completion:nil];
}



#pragma  mark - MPMusicPlayerNSNotificationCenter

/**
 *  Notification receive from mediaplayer.
 *
 *  @param notification <#notification description#>
 */
-(void) handle_PlaybackStateChanged:(id) notification
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    // do action only if mediaplayer if ready
    if ([[self.del mpdatamanager] isMediaPlayerInitialized])
    {
        [self displayMediaItem:[[[self.del mpdatamanager] musicplayer] nowPlayingItem]];
    }
    else
    {
        NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"[Warning] - MediaPlayer isn't initialized.");
    }
}


/**
 *  Notification receive from mediaplayer.
 *
 *  @param notification <#notification description#>
 */
-(void) handle_NowPlayingItemChanged:(id) notification
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    // do action only if mediaplayer if ready
    if ([[self.del mpdatamanager] isMediaPlayerInitialized])
    {
        [self displayMediaItem:[[[self.del mpdatamanager] musicplayer] nowPlayingItem]];
    }
    else
    {
        NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"[Warning] - MediaPlayer isn't initialized.");
    }
}


#pragma mark - Page View Controller Data Source

/**
 *  Return page before.
 *
 *  @param pageViewController <#pageViewController description#>
 *  @param viewController     <#viewController description#>
 *
 *  @return <#return value description#>
 */
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((UIPageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}


/**
 *  Return next page.
 *
 *  @param pageViewController <#pageViewController description#>
 *  @param viewController     <#viewController description#>
 *
 *  @return <#return value description#>
 */
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


/**
 *  Return page content view controller.
 *
 *  @param index <#index description#>
 *
 *  @return <#return value description#>
 */
- (UIPageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    // Create a new view controller and pass suitable data.
    UIPageContentViewController *pageContentViewController;
    //if(index==0)
    //{
    //    pageContentViewController = _artistpage;
    //}
    /*else */
    if(index ==0)
    {
        pageContentViewController = _albumpage;
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



#pragma mark - UIPageViewControllerDelegate

/**
 *  Page view changed.
 *
 *  @param pageViewController      <#pageViewController description#>
 *  @param finished                <#finished description#>
 *  @param previousViewControllers <#previousViewControllers description#>
 *  @param completed               <#completed description#>
 */
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    UIPageContentViewController* currentpage = pageViewController.viewControllers[0];
    [_pagecontrol setCurrentPage:[currentpage pageIndex]];
    
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
