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
 *  Prepare application to gone in foreground.
 */
- (void) prepareAppWillEnterForeground;

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
 *  Indicate if UICurrentPlayingToolBar must be hidden.
 *
 *  @return True if UICurrentPlayingToolBar must be hidden.
 */
- (bool) currentPlayingToolbarMustBeHidden;

/**
 *  Set if UICurrentPlayingToolBar must be hidden.
 *
 *  @param hidden True to hidden UICurrentPlayingToolBar.
 */
- (void) setCurrentPlayingToolbarMustBeHidden:(bool) hidden;

/**
 *  Set the last playing album
 *
 *  @param albumUid uid of the album
 */
- (void) setLastPlayingAlbum:(NSNumber*) albumUid;

/**
 *  Return last playing album
 *
 *  @return uid of the last playing album
 */
- (NSNumber*) getLastPlayingAlbum;

/**
 *  Set the last playing playlist
 *
 *  @param playlistUid uid of the playlist
 */
- (void) setLastPlayingPlaylist:(NSNumber*) playlistUid;

/**
 *  Return the last playing playlist
 *
 *  @return uid of the last playing playlist
 */
- (NSNumber*) getLastPLayingPlaylist;

/**
 *  Start playing an album.
 *
 *  @param albumUid album uid for starting playing.
 *
 *  @return true if album is starting to playing.
 */
- (bool) startPlayingAlbum:(NSNumber*) albumUid;

/**
 *  Start playing a playlist.
 *
 *  @param playlistUid playlist uid for starting playing.
 *
 *  @return true if playlist is starting to playing.
 */
- (bool) startPlayingPlaylist:(NSNumber*) playlistUid;

/**
 *  Start playing best rating song on the device.
 * 
 *  @return true if start playing is possible.
 */
- (BOOL) startPlayingBestRating;


@end
