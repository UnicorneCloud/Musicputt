//
//  ITunesFeedsApi.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-08-30.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "ITunesFeedsApi.h"

#import <RestKit/RestKit.h>

@interface ITunesFeedsApi()
{
    id  delegate;
    RKObjectManager*        objectManager;
}

@end


@implementation ITunesFeedsApi

/**
 *  Set delegate to recieve result of query.
 *
 *  @param anObject delegate object with ITunesFeedsApiDelegate protocol.
 */
- (void) setDelegate:(id) anObject
{
    delegate = anObject;
}


- (void) configureConnection
{
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"https://itunes.apple.com/"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // define music track mapping
    /*
    RKObjectMapping *musicTrackMapping = [RKObjectMapping mappingForClass:[ITunesMusicTrack class]];
    [musicTrackMapping addAttributeMappingsFromArray:@[@"wrapperType",
                                                       @"kind",
                                                       @"artistId",
                                                       @"collectionId",
                                                       @"trackId",
                                                       @"artistName",
                                                       @"collectionName",
                                                       @"trackName",
                                                       @"artistViewUrl",
                                                       @"collectionViewUrl",
                                                       @"trackViewUrl",
                                                       @"previewUrl",
                                                       @"artworkUrl60",
                                                       @"artworkUrl100",
                                                       @"collectionPrice",
                                                       @"trackPrice",
                                                       @"releaseDate",
                                                       @"collectionExplicitness",
                                                       @"trackExplicitness",
                                                       @"discCount",
                                                       @"discNumber",
                                                       @"trackCount",
                                                       @"trackNumber",
                                                       @"trackTimeMillis",
                                                       @"country",
                                                       @"currency",
                                                       @"primaryGenreName"
                                                       ]];
     */
    

}


/**
 *  Query iTunes feeds. When to result are ready, results are sends to ITunesFeedsApiDelegate queryResult.
 *  See: http://www.apple.com/itunes/affiliates/resources/blog/introduction---rss-feed-generator.html for more details
 *
 *  @param type    ITunesFeedsQueryType are QueryTopSongs or QueryTopAlbums.
 *  @param country Enter the country code. (United State:us, Canada:ca, etc...)
 *  @param size    Enter the size of result. (Must be: 10, 25,50 or 100)
 *  @param genre   Enter the genre: (nil for all) See: http://www.apple.com/itunes/affiliates/resources/documentation/genre-mapping.html for more details.
 *  @param async   <#async description#>
 */
- (void) queryFeedType:(ITunesFeedsQueryType)type forCountry:(NSString*) country size:(NSInteger) size genre:(NSString*) genre asynchronizationMode:(BOOL) async
{
    
}

@end
