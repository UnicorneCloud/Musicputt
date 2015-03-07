//
//  MusicPuttApi.h
//  MusicPutt
//
//  Created by Eric Pinet on 2015-01-31.
//  Copyright (c) 2015 Eric Pinet. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MPListening;

@interface MusicPuttApi : NSObject


/**
 *  Execute query to retrieve last playing songs by others users in musicputt and execute success block or failure
 * [_musicputt queryListeningListAsynchronizationMode:true
 *                                            success:^(NSArray* results){
 *                                                                          NSLog(@"success");
 *                                                                       }
 *                                            failure:^(NSError* error){
 *                                                                          NSLog(@"error");
 *                                                                      }];
 *
 *  @param async   True for async response.
 *  @param success success block
 *  @param failure failure block
 */
- (void) queryListeningListAsynchronizationMode:(BOOL)async
                                        success:(void (^)(NSArray* results))success
                                        failure:(void (^)(NSError *error))failure;

/**
 *  Post a MPListening to musicputt server
 *
 *  @param listening Object repressenting a listening in the application
 */
- (void) postListening:(MPListening*) listening;

@end
