//
//  MPDataManager.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-28.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UICurrentPlayingToolBar.h"
#import "UITabBarControllerMain.h"

@class MPMusicPlayerController;

/**
 * MPDataManager is the main application data manager. This class maintain all data for
 * the current execution.
 */
@interface MPDataManager : NSObject


/**
 *  Main music player controller.
 */
@property (strong, nonatomic) MPMusicPlayerController* musicplayer;

/**
 *  Toolbar displayed when music playing and the UIMusicViewController is not displayed.
 */
@property (strong, nonatomic) UICurrentPlayingToolBar*  currentPlayingToolbar;

/**
 *  Current selected playlist select in the playlist navigation bar.
 */
@property (strong, nonatomic) MPMediaPlaylist* currentPlaylist;

/**
 *  Current song list for the songlist navigation bar.
 */
//@property (strong, nonatomic) NSMutableArray* currentSonglist;

/**
 * Current selected artist collection for the artist navigation bar.
 */
@property (strong, nonatomic) MPMediaItemCollection* currentArtistCollection;

/**
 *  Current selected album collection for the album navigation bar.
 */
@property (strong, nonatomic) MPMediaItemCollection* currentAlbumCollection;

/**
 *  Current selected artist for the artist navigation bar.
 */
@property (strong, nonatomic) MPMediaItem* currentArtist;

/**
 *  Main tabbar controller
 */
@property (strong, nonatomic) UITabBarControllerMain* tabbar;

/**
 *  Current navigation controller. Use by the main tabbar and main menu to pop all view Controller when swith tabbar.
 */
@property (strong, nonatomic) UINavigationController* currentNavController;

/**
 *  Initialise all data for the current execution of the application.
 *
 *  @return True if the initialization succesed.
 */
- (bool) initialise;

/**
 *  Prepare application to gone in background.
 */
- (void) prepareAppDidEnterBackground;

/**
 *  Prepare application to become active
 */
-(void) prepareAppDidBecomeActive;

/**
 *  Prepare application to terminate
 */
-(void) prepareAppWillTerminate;

/**
 *  Return true if the mediaPlayer is initialized.
 *
 *  @return Return true if media player is initialized.
 */
-(bool) isMediaPlayerInitialized;

/**
 *  Indicate if the UIMusicViewController is displayed. When the UIMusicViewController
 *  is displayed, UICurrentPlayingToolBar is hidden.
 *
 *  @return True if UIMusicViewController displayed
 */
- (bool) isMusicViewControllerVisible;

/**
 *  Set the status of the visibility of the UIMusicViewController.
 *
 *  @param visible True to indicate the UIMusicViewController displayed.
 */
- (void) setMusicViewControllerVisible:(bool) visible;

@end
