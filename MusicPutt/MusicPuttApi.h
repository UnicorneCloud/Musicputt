//
//  MusicPuttApi.h
//  MusicPutt
//
//  Created by Eric Pinet on 2015-01-31.
//  Copyright (c) 2015 Eric Pinet. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  Enum of queryResult type.
 */
typedef enum {
    QueryMusicPuttListening,
    QueryAll
} MusicPuttApiQueryType;

typedef enum {
    MusicPuttApiStatusSucceed,
    MusicPuttApiStatusFailed
} MusicPuttApiQueryStatus;




/**
 *  Protocol for the delegate of the MusicPuttApi.
 */
@protocol MusicPuttApiDelegate <NSObject>

@optional

/**
 *  Implement this methode for recieve result after query.
 *
 *  @param status  Status of the querys
 *  @param type    Type of query sender
 *  @param results resultset of the query
 */
-(void) queryResultMusicPutt:(MusicPuttApiQueryStatus)status type:(MusicPuttApiQueryType)type results:(NSArray*)results;

@end



@class MPListening;

@interface MusicPuttApi : NSObject

/**
 *  Set delegate to recieve result of query.
 *
 *  @param anObject delegate object with ITunesSearchApiDelegate protocol.
 */
- (void) setDelegate:(id) anObject;

/**
 *  Execute query to retrieve last playing songs by others users in musicputt and return results to the delagate.
 */
- (void) queryListening;

/**
 *  Post a MPListening to musicputt server
 *
 *  @param listening Object repressenting a listening in the application
 */
- (void) postListening:(MPListening*) listening;

@end
