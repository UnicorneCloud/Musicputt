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
@property (strong, nonatomic) NSMutableArray* currentSonglist;


/**
 * Current selected artist collection for the artist navigation bar.
 */
@property (strong, nonatomic) MPMediaItemCollection* currentArtistCollection;


/**
 *  Current selected artist for the artist navigation bar.
 */
@property (strong, nonatomic) MPMediaItem* currentArtist;



/**
 *  Initialise all data for the current execution of the application.
 *
 *  @return True if the initialization succesed.
 */
- (bool) initialise;


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
