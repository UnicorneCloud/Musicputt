//
//  MPDataManager.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-28.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "MPDataManager.h"
#import <MediaPlayer/MPMusicPlayerController.h>


@interface MPDataManager()
{
    BOOL mediaplayerinit;
}

@end

@implementation MPDataManager
{
    bool musicviewcontrollervisible;
}


/**
 *  Initialise all data for the current execution of the application.
 *
 *  @return True if the initialization succesed.
 */
-(bool) initialise
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    bool retval = false;
    
    // Init MusicPlayer
    retval = [self initialiseMediaPlayer];
    
    // init current playing toolbar
    _currentPlayingToolbar = [[UICurrentPlayingToolBar alloc] init];
    
    // the initial state of the musicviewcontroller is hidden.
    musicviewcontrollervisible = false;
    
    // init magic record
    [MagicalRecord setupCoreDataStack];
    
    
    return retval;
}

/**
 *  Prepare application to gone in background.
 */
- (void) prepareAppDidEnterBackground
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    // we lose link with media player
    // we have to recreate media player when application return from background
    mediaplayerinit = false;
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Completed");
}


/**
 *  Prepare application to becone active
 */
-(void) prepareAppDidBecomeActive
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    [self initialiseMediaPlayer];
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Conpleted");
}


/**
 *  Prepare application to terminate
 */
-(void) prepareAppWillTerminate
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    // terminate mediaplayer
    [[self musicplayer] stop];
    
    // terminate magicrecord
    [MagicalRecord cleanUp];
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Conpleted");
}



/**
 *  Indicate if the UIMusicViewController is displayed. When the UIMusicViewController
 *  is displayed, UICurrentPlayingToolBar is hidden.
 *
 *  @return True if UIMusicViewController displayed
 */
- (bool) isMusicViewControllerVisible
{
    return musicviewcontrollervisible;
}


/**
 *  Set the status of the visibility of the UIMusicViewController.
 *
 *  @param visible True to indicate the UIMusicViewController displayed.
 */
- (void) setMusicViewControllerVisible:(bool) visible
{
    musicviewcontrollervisible = visible;
}

#pragma mark - MediaPlayer

/**
 *  Initialization of the media player.
 *
 *  @return True if initialization succesed.
 */
-(bool) initialiseMediaPlayer
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    bool retval = false;
    _musicplayer = [MPMusicPlayerController iPodMusicPlayer];
    if (_musicplayer==NULL) {
        NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"[ERROR] - Error getting MPMusicPlayerController iPodMusicPlayer");
    }
    else{
        NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Completed.");
        retval = true;
    }
    mediaplayerinit = retval;
    return retval;
}

/**
 *  Return true if the mediaPlayer is initialized.
 *
 *  @return Return true if media player is initialized.
 */
-(bool) isMediaPlayerInitialized
{
    return mediaplayerinit;
}


@end
