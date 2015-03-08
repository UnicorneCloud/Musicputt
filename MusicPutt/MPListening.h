//
//  MPListening.h
//  MusicPutt
//
//  Created by Eric Pinet on 2015-01-31.
//  Copyright (c) 2015 Eric Pinet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPListening : NSObject

/**
 *  Unique identifier of music track.
 */
@property (nonatomic, copy) NSString *trackId;

/**
 *  Unique identifier of artist.
 */
@property (nonatomic, copy) NSString *artistId;

/**
 *  Unique identifier of collection.
 */
@property (nonatomic, copy) NSString *collectionId;

/**
 *  The name of the track, song, video, TV episode, and so on returned by the search request.
 */
@property (nonatomic, copy) NSString *trackName;

/**
 *  The name of the artist returned by the search request.
 */
@property (nonatomic, copy) NSString *artistName;

/**
 *  The name of the album, TV season, audiobook, and so on returned by the search request.
 */
@property (nonatomic, copy) NSString *collectionName;

/**
 *  A URL referencing the 30-second preview file for the content associated with the returned media type.
 */
@property (nonatomic, copy) NSString *previewUrl;

/**
 *  A URL for the artwork associated with the returned media type, sized to 100x100 pixels or 60x60 pixels.
 */
@property (nonatomic, copy) NSString *artworkUrl100;

@end
