//
//  MPDataManager.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-28.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "MPDataManager.h"

#import "LastPlaying.h"
#import "Playlist.h"
#import "PlaylistItem.h"
#import "ITunesSearchApi.h"
#import "MusicPuttApi.h"
#import "MPListening.h"

#import <MediaPlayer/MPMusicPlayerController.h>
#import <CoreMotion/CoreMotion.h>

#define _QUALITY_MUSICPUTT_SERVER_ @"300x300-100"

#define IS_IOS7 [[UIDevice currentDevice].systemVersion hasPrefix:@"7"]

@interface MPDataManager() <ITunesSearchApiDelegate>
{
    BOOL mediaplayerinit;
    CMMotionManager *motionmanager;
    
    BOOL playlistEditing;
    bool currentPlayingToolbarMustBeHidden; // if true, CurrentPlayingToolBar must be hidden.
    
    MPMediaItem* _lastPlayingMediaItem;
}

@end

@implementation MPDataManager

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
    
    // the initial state of the currentPlayingToolbarMustBeHidden is not hidden.
    currentPlayingToolbarMustBeHidden = false;
    
    // init current editing playlist toolbar
    _currentEditingPlaylistToolbar = [[BFNavigationBarDrawer alloc] init];
    
    // the initial state of playlist editing mode is FALSE:
    playlistEditing = false;
    
    // the initial state of forceDisplayMediaItem is FLASE;
    _forceDisplayMediaItem = false;
    
    // init magic record
    [MagicalRecord setupCoreDataStack];
    
    // init last playing media item
    _lastPlayingMediaItem = nil;
    
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
 *  Prepare application to gone in foreground.
 */
- (void) prepareAppWillEnterForeground
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    _forceDisplayMediaItem = true;
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Completed");
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
 *  Indicate if UICurrentPlayingToolBar must be hidden.
 *
 *  @return True if UICurrentPlayingToolBar must be hidden.
 */
- (bool) currentPlayingToolbarMustBeHidden
{
    return currentPlayingToolbarMustBeHidden;
}


/**
 *  Set if UICurrentPlayingToolBar must be hidden.
 *
 *  @param hidden True to hidden UICurrentPlayingToolBar.
 */
- (void) setCurrentPlayingToolbarMustBeHidden:(bool) hidden
{
    currentPlayingToolbarMustBeHidden = hidden;
}

/**
 *  Indicate if playlist is in editing mode. If true, we have to display toolbar editing.
 *
 *  @return True if a playlist is in editing mode.
 */
- (bool) isPlaylistEditing
{
    return playlistEditing;
}

/**
 *  Set  state of playlist editing mode.
 *
 *  @param active True to indicate that a playlist is in editing mode.
 */
- (void) setPlaylistEditing:(bool) active
{
    playlistEditing = active;
    
    if (playlistEditing == FALSE) {
        
        // save magical record
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
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
    
    if (IS_IOS7) {
        _musicplayer = [MPMusicPlayerController iPodMusicPlayer];
    }
    else{
        _musicplayer = [MPMusicPlayerController systemMusicPlayer];
    }
    
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
 *  Return true if last playlist is musicputt type.
 *
 *  @return true if musicputt type. false if itunes type.
 */
- (BOOL) isLastPlaylistMusicPutt
{
    LastPlaying *lastplaying = [LastPlaying MR_findFirst];
    if (lastplaying) {
        if (lastplaying.islastmusicputt) {
            return TRUE;
        }
    }
    return FALSE;
}

/**
 *  Set last playing playlist (musicputt type)
 *
 *  @param playlistName Name of the playlist
 */
- (void) setLastPlayingPlaylistMusicPutt:(NSString*) playlistName
{
    NSLog(@" %s - %@ %@\n", __PRETTY_FUNCTION__, @"setLastPlayingPlaylistMusicputt", playlistName);
    
    LastPlaying *lastplaying = [LastPlaying MR_findFirst];
    if (lastplaying==nil) {
        lastplaying = [LastPlaying MR_createEntity];
    }
    lastplaying.playlistmusicputt = playlistName;
    lastplaying.islastmusicputt = [NSNumber numberWithInt:1];
    //[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

/**
 *  Get last playing playlist (musicputt type)
 *
 *  @return Name of the lastest playlist play.
 */
- (NSString*) getLastPLayingPlaylistMusicPutt
{
    LastPlaying *lastplaying = [LastPlaying MR_findFirst];
    if (lastplaying) {
        return lastplaying.playlistmusicputt;
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
    lastplaying.islastmusicputt = [NSNumber numberWithInt:0];
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
        
        if( everything.collections.count>0 && [everything.collections[0] items].count>0 )
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
 *  Start playing a playlist musicputt.
 *
 *  @param playlistName playlist name for starting playing musicputt playlist.
 *
 *  @return true if playlist is starting to playing.
 */
- (bool) startPlayingPlaylistMusicPutt:(NSString*) playlistName
{
    BOOL retval = FALSE;
    Playlist *playlist = [Playlist MR_findFirstByAttribute:@"name" withValue:playlistName];
    
    if (playlistName){

        NSSortDescriptor *sortPosition = [[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES];
        NSArray* songs = [[playlist items] sortedArrayUsingDescriptors:[NSArray arrayWithObjects: sortPosition, nil]];
        
        NSMutableArray* list = [[NSMutableArray alloc] init];
        MPMediaItem *song;
        MPMediaPropertyPredicate *predicate;
        MPMediaQuery *songQuery;
        
        for (int i=0 ; i<songs.count ; i++) {
            predicate = [MPMediaPropertyPredicate predicateWithValue: ((PlaylistItem*)[songs objectAtIndex:i]).songuid forProperty:MPMediaItemPropertyPersistentID];
            songQuery = [[MPMediaQuery alloc] init];
            [songQuery addFilterPredicate: predicate];
            if (songQuery.items.count > 0)
            {
                //song exists
                song = [songQuery.items objectAtIndex:0];
                [list addObject: song];
            }
        }
        
        if (list.count>0) {
            [[self musicplayer] stop];
            
            BOOL shuffleWasOn = NO;
            if ([self musicplayer].shuffleMode != MPMusicShuffleModeOff &&
                [self musicplayer].shuffleMode != MPMusicShuffleModeDefault)
            {
                [self musicplayer].shuffleMode = MPMusicShuffleModeOff;
                shuffleWasOn = YES;
            }
            [[self musicplayer] setQueueWithItemCollection:[MPMediaItemCollection collectionWithItems:list]];
            [[self musicplayer] setNowPlayingItem:[list objectAtIndex:0]];
            if (shuffleWasOn)
                [self musicplayer].shuffleMode = MPMusicShuffleModeSongs;
            
            [[self musicplayer] play];
            
            retval = TRUE;
        }
    }
    return retval;
}

/**
 *  Start playing best rating song on the device.
 */
- (BOOL) startPlayingBestRating
{
    BOOL retval = FALSE;
    
    NSTimeInterval start  = [[NSDate date] timeIntervalSince1970];
    
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    NSArray *songsArray = [songsQuery items];
    
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:MPMediaItemPropertyRating
                                                             ascending:NO];
    NSArray *sortedSongsArray = [songsArray sortedArrayUsingDescriptors:@[sorter]];
    
    NSTimeInterval finish = [[NSDate date] timeIntervalSince1970];
    
    NSLog(@" %s - %@ %f secondes\n", __PRETTY_FUNCTION__, @"Finish ordering took", finish - start);
    
    if (sortedSongsArray.count>0) {
        
        [[self musicplayer] stop];
        
        BOOL shuffleWasOn = NO;
        if ([self musicplayer].shuffleMode != MPMusicShuffleModeOff &&
            [self musicplayer].shuffleMode != MPMusicShuffleModeDefault)
        {
            [self musicplayer].shuffleMode = MPMusicShuffleModeOff;
            shuffleWasOn = YES;
        }
        [[self musicplayer] setQueueWithItemCollection:[MPMediaItemCollection collectionWithItems:sortedSongsArray]];
        [[self musicplayer] setNowPlayingItem:[sortedSongsArray objectAtIndex:0]];
        if (shuffleWasOn)
            [self musicplayer].shuffleMode = MPMusicShuffleModeSongs;
        
        [[self musicplayer] play];
        
        retval = TRUE;
    }
    
    return retval;
}

/**
 *  Set the last media playing item. This action will send item in musicputt server database.
 *
 *  @param item Media item now playing.
 */
- (void) setLastPlayingItem:(MPMediaItem*)item
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    if (item != _lastPlayingMediaItem) {
        
        _lastPlayingMediaItem = item;
        
        // prepare itunes service for query
        ITunesSearchApi *itunes = [[ITunesSearchApi alloc] init];
        [itunes setDelegate:self];
        
        // query song with media item
        [itunes queryMusicTrackWithSearchTerm:[itunes buildSearchTermForMusicTrackFromMediaItem:item] asynchronizationMode:true];
    }
}

/**
 *  Shared CMotionManager.
 *
 *  @return singleton CMotionManager
 */
- (CMMotionManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        motionmanager = [[CMMotionManager alloc] init];
    });
    return motionmanager;
}

#pragma mark - ITunesSearchApiDelegate

/**
 *  Implement this methode for recieve result after query.
 *
 *  @param status  Status of the querys
 *  @param type    Type of query sender
 *  @param results resultset of the query
 */
-(void) queryResult:(ITunesSearchApiQueryStatus)status type:(ITunesSearchApiQueryType)type results:(NSArray*)results
{
    // check if request return result
    if (status==ITunesSearchApiStatusSucceed && [results count]>0 && type == QueryMusicTrackWithSearchTerm)
    {
        NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Set last playing songs return a ITunesStore result.");
        
        ITunesMusicTrack* result = results[0];
        
        if (result){
            
            // convert itunes store result into musicputt listening object to post the songs on the
            // musicputt server by json.
            MusicPuttApi* musicputtapi = [[MusicPuttApi alloc] init];
            MPListening* listening = [[MPListening alloc] init];
            
            [listening setTrackId:result.trackId];
            [listening setArtistId:result.artistId];
            [listening setCollectionId:result.collectionId];
            [listening setTrackName:result.trackName];
            [listening setArtistName:result.artistName];
            [listening setCollectionName:result.collectionName];
            [listening setPreviewUrl:result.previewUrl];
            [listening setArtworkUrl100:result.artworkUrl100];
            
            // check if listening is complete before send it to musicputt server
            if ( [[listening trackId] isEqualToString:@""] != true &&
                 [[listening artistId] isEqualToString:@""] != true &&
                 [[listening collectionId] isEqualToString:@""] != true &&
                 [[listening trackName] isEqualToString:@""] != true &&
                 [[listening artistName] isEqualToString:@""] != true &&
                 [[listening collectionName] isEqualToString:@""] != true &&
                 [[listening previewUrl] isEqualToString:@""] != true &&
                 [[listening artworkUrl100] isEqualToString:@""] != true)
            {
                NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Set last playing songs sending to musicputt server.");
                
                // improve artwork quality
                [listening setArtworkUrl100: [[listening artworkUrl100] stringByReplacingOccurrencesOfString:@"100x100-75" withString:_QUALITY_MUSICPUTT_SERVER_] ];
                
                // post the song to the server
                [musicputtapi postListening:listening];
                
                NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Set last playing songs send completed to musicputt server.");
                
            }// endif check valid listening (complete)
            
        }// endif valid result
        
    }// endif valid request
}


@end
