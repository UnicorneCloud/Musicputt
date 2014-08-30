//
//  ITunesFeedsApi.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-08-30.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Enum of queryResult type.
 */
typedef enum {
    QueryTopSongs,
    QueryTopAlbums
} ITunesFeedsQueryType;

/**
 *  Enum of query status.
 */
typedef enum {
    StatusSucceed,
    StatusFailed
} ITunesFeedsApiQueryStatus;


/**
 *  Protocol for the delegate of the MPServiceStore.
 */
@protocol ITunesFeedsApiDelegate <NSObject>

@optional

/**
 *  Implement this methode for recieve result after query.
 *
 *  @param status  Status of the querys
 *  @param type    Type of query sender
 *  @param results resultset of the query
 */
-(void) queryResult:(ITunesFeedsApiQueryStatus)status type:(ITunesFeedsQueryType)type results:(NSArray*)results;

@end


/**
 *  ITunesFeedsApi class permit to request at iTunes the top songs and top album.
 */
@interface ITunesFeedsApi : NSObject


/**
 *  Set delegate to recieve result of query.
 *
 *  @param anObject delegate object with ITunesFeedsApiDelegate protocol.
 */
- (void) setDelegate:(id) anObject;


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
- (void) queryFeedType:(ITunesFeedsQueryType)type forCountry:(NSString*) country size:(NSInteger) size genre:(NSString*) genre asynchronizationMode:(BOOL) async;

@end
