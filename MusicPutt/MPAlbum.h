//
//  MPAlbum.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-07-25.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  MusicTrack receive from the iTunes Search API.
 */
@interface MPAlbum : NSObject

/**
 *  The name of the object returned by the search request.
 *
 *  track, collection, artist
 *  For example: track.
 */
@property (nonatomic, copy) NSString *wrapperType;


/**
 *  collection type must be Album
 */
@property (nonatomic, copy) NSString *collectiontype;


/**
 *  unique artist id
 */
@property (nonatomic, copy) NSString *artistid;


/**
 *  unique collection id (album)
 */
@property (nonatomic, copy) NSString *collectionid;


/**
 *  Astist's name
 */
@property (nonatomic, copy) NSString *artistname;


/**
 *  Collection's name
 */
@property (nonatomic, copy) NSString *collectionname;


/**
 *  Collection's censored name
 */
@property (nonatomic, copy) NSString *collectioncensoredname;


/**
 *  Artist view url
 */
@property (nonatomic, copy) NSString *artistviewurl;


/**
 *  Collection view url
 */
@property (nonatomic, copy) NSString *collectionviewurl;


/**
 *  Album artwork 60 px.
 */
@property (nonatomic, copy) NSString *artworkurl60;


/**
 *  Album artwork 100 px.
 */
@property (nonatomic, copy) NSString *artworkurl100;


/**
 *  Collection price
 */
@property (nonatomic, copy) NSString *collectionprice;


/**
 *  The Recording Industry Association of America (RIAA) parental advisory for the content returned by the search request.
 *
 *  For more information, see http://itunes.apple.com/WebObjects/MZStore.woa/wa/parentalAdvisory.
 */
@property (nonatomic, copy) NSString *collectionexplicitness;

/**
 *  Nb track on album
 */
@property (nonatomic, copy) NSString *trackcount;

/**
 *  Copyright
 */
@property (nonatomic, copy) NSString *copyright;

/**
 *  Store country
 */
@property (nonatomic, copy) NSString *country;

/**
 *  Currency price
 */
@property (nonatomic, copy) NSString *currency;

/**
 *  Release date
 */
@property (nonatomic, copy) NSString *releasedate;


/**
 *  Primary genre for this album collection
 */
@property (nonatomic, copy) NSString *primarygenrename;

@end
