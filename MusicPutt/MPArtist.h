//
//  MPArtist.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-07-25.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  Artist receieved from iTunes Store
 */
@interface MPArtist : NSObject


@property (nonatomic, copy) NSString *wrapperType;

@property (nonatomic, copy) NSString *artistType;

@property (nonatomic, copy) NSString *artistName;

@property (nonatomic, copy) NSString *artistLinkUrl;

@property (nonatomic, copy) NSString *artistId;

@property (nonatomic, copy) NSString *amgArtistId;

@property (nonatomic, copy) NSString *primaryGenreName;

@property (nonatomic, copy) NSString *primaryGenreId;

@property (nonatomic, copy) NSString *radioStationUrl;

@end
