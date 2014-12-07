//
//  MPDataManager.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-28.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "MPDataManager.h"

#import "LastPlaying.h"
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
    
    // save magical record
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
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
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
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

/**
 *  Set the last playing album
 *
 *  @param albumUid uid of the album
 */
- (void) setLastPlayingAlbum:(NSNumber*) albumUid
{
    NSLog(@" %s - %@ %@\n", __PRETTY_FUNCTION__, @"setLastPlayingAlbum", albumUid);
    
    LastPlaying *lastplaying = [LastPlaying MR_findFirst];
    if (lastplaying==nil) {
        lastplaying = [LastPlaying MR_createEntity];
    }
    lastplaying.albumuid = albumUid;
    //[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

/**
 *  Return last playing album
 *
 *  @return uid of the last playing album, nil if nothing
 */
- (NSNumber*) getLastPlayingAlbum
{
    LastPlaying *lastplaying = [LastPlaying MR_findFirst];
    if (lastplaying) {
        return lastplaying.albumuid;
    }
    return nil;
}


/**
 *  Set the last playing playlist
 *
 *  @param playlistUid uid of the playlist
 */
- (void) setLastPlayingPlaylist:(NSNumber*) playlistUid
{
    NSLog(@" %s - %@ %@\n", __PRETTY_FUNCTION__, @"setLastPlayingPlaylist", playlistUid);
    
    LastPlaying *lastplaying = [LastPlaying MR_findFirst];
    if (lastplaying==nil) {
        lastplaying = [LastPlaying MR_createEntity];
    }
    lastplaying.playlistuid = playlistUid;
    //[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

/**
 *  Return the last playing playlist
 *
 *  @return uid of the last playing playlist, nil if nothing.
 */
- (NSNumber*) getLastPLayingPlaylist
{
    LastPlaying *lastplaying = [LastPlaying MR_findFirst];
    if (lastplaying) {
        return lastplaying.playlistuid;
    }
    return nil;
}


/**
 *  Start playing an album.
 *
 *  @param albumUid album uid for starting playing.
 *
 *  @return true if album is starting to playing.
 */
- (bool) startPlayingAlbum:(NSNumber*) albumUid
{
    MPMediaQuery* everything;                   // result of current query
    BOOL retval = FALSE;
    
    if (albumUid!=nil) {
        // query album media on device
        everything = [MPMediaQuery albumsQuery];
        MPMediaPropertyPredicate *albumPredicate =  [MPMediaPropertyPredicate predicateWithValue:albumUid
                                                                                     forProperty:MPMediaItemPropertyAlbumPersistentID
                                                                                  comparisonType:MPMediaPredicateComparisonEqualTo];
        [everything addFilterPredicate:albumPredicate];
        
        if( everything.collections[0]!=nil && [everything.collections[0] items].count>0 )
        {
            [[self musicplayer] stop];
            
            BOOL shuffleWasOn = NO;
            if ([self musicplayer].shuffleMode != MPMusicShuffleModeOff &&
                [self musicplayer].shuffleMode != MPMusicShuffleModeDefault)
            {
                [self musicplayer].shuffleMode = MPMusicShuffleModeOff;
                shuffleWasOn = YES;
            }
            [[self musicplayer] setQueueWithItemCollection:[MPMediaItemCollection collectionWithItems:[everything.collections[0] items]]];
            [[self musicplayer] setNowPlayingItem:[[everything.collections[0] items ]objectAtIndex:0]];
            if (shuffleWasOn)
                [self musicplayer].shuffleMode = MPMusicShuffleModeSongs;
            
            [[self musicplayer] play];
            
            retval = TRUE;
        }
    }
    return retval;
}

/**
 *  Start playing a playlist.
 *
 *  @param playlistUid playlist uid for starting playing.
 *
 *  @return true if plylist is starting to playing.
 */
- (bool) startPlayingPlaylist:(NSNumber*) playlistUid
{
    MPMediaQuery* everything;                   // result of current query
    BOOL retval = FALSE;
    
    if (playlistUid!=nil) {
        // query album media on device
        everything = [MPMediaQuery playlistsQuery];
        MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:playlistUid
                                                                               forProperty:MPMediaPlaylistPropertyPersistentID
                                                                            comparisonType:MPMediaPredicateComparisonEqualTo];
        [everything addFilterPredicate:predicate];
        
        if( everything.collections[0]!=nil && [everything.collections[0] items].count>0 )
        {
            [[self musicplayer] stop];
            
            BOOL shuffleWasOn = NO;
            if ([self musicplayer].shuffleMode != MPMusicShuffleModeOff &&
                [self musicplayer].shuffleMode != MPMusicShuffleModeDefault)
            {
                [self musicplayer].shuffleMode = MPMusicShuffleModeOff;
                shuffleWasOn = YES;
            }
            [[self musicplayer] setQueueWithItemCollection:[MPMediaItemCollection collectionWithItems:[everything.collections[0] items]]];
            [[self musicplayer] setNowPlayingItem:[[everything.collections[0] items ]objectAtIndex:0]];
            if (shuffleWasOn)
                [self musicplayer].shuffleMode = MPMusicShuffleModeSongs;
            
            [[self musicplayer] play];
            
            retval = TRUE;
        }
    }
    return retval;
}


@end
