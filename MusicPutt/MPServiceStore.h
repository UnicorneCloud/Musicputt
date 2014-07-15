//
//  MPServiceStore.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-07-13.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  Enum of queryResult type.
 */
typedef enum {
    MPQueryMusicTrackWithSearchTerm,
    MPQueryMusicTrackWithId,
    MPQueryAlbumWithSearchTerm,
    MPQueryAlbumWithId,
    MPQueryArtistWithSearchTerm,
    MPQueryArtistWithId,
    MPQueryAll
} MPServiceStoreQueryType;

typedef enum {
    MPServiceStoreStatusSucceed,
    MPServiceStoreStatusFailed
} MPServiceStoreQueryStatus;

/**
 *  Protocol for the delegate of the MPServiceStore.
 */
@protocol MPServiceStoreDelegate <NSObject>

@optional

/**
 *  Implement this methode for recieve result after query.
 *
 *  @param status  Status of the querys
 *  @param type    Type of query sender
 *  @param results resultset of the query
 */
-(void) queryResult:(MPServiceStoreQueryStatus)status type:(MPServiceStoreQueryType)type results:(NSArray*)results;

@end


/**
 *  Service for access to iTunes Store.
 *
 *  This class is a wrapper on the iTunes Store Search API. Looking at: https://www.apple.com/itunes/affiliates/resources/documentation/itunes-store-web-service-search-api.html
 *  for details of the API.
 */
@interface MPServiceStore : NSObject


/**
 *  Configuration of the connection with the iTunes Store API.
 */
- (void) configureConnection;


/**
 *  Execute query in iTunes Store and return results to the delagate.
 *
 *  @param searchTerm see itunes api doc: https://www.apple.com/itunes/affiliates/resources/documentation/itunes-store-web-service-search-api.html
 *  @param anObject   Delagate to receive the result. Must respect MPServiceStoreDelegate.
 */
- (void) queryMusicTrackWithSearchTerm:(NSString*)searchTerm setDelegate:(id) anObject;


/**
 *  Execute query in iTunes Store and return music track with this id to the delagate.
 *
 *  @param itemId   id of the music track to find
 *  @param anObject Delegate who recieve the result. Must respect MPServiceStoreDelegate.
 */
- (void) queryMusicTrackWithId:(NSString*)itemId setDelegate:(id) anObject;


/**
 *  Execute asynchrone query in itunes store.
 *
 *  @param type       Indicate type of the query. See: MPServiceStoreQueryType
 *  @param searchTerm searchTerm or itemId for query with item
 *  @param anObject   the object delegate that receive result
 */
- (void) executeQuery:(MPServiceStoreQueryType) type searchTerm:(NSString*)searchTerm setDelegate:(id) anObject;


@end
