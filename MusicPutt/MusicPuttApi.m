//
//  MusicPuttApi.m
//  MusicPutt
//
//  Created by Eric Pinet on 2015-01-31.
//  Copyright (c) 2015 Eric Pinet. All rights reserved.
//

#import "MusicPuttApi.h"

#import "Restkit.h"
#import "MPListening.h"




#define _MUSICPUTT_BASE_URL_ @"http://musicputt.atwebpages.com/"
#define _MUSICPUTT_RELATIVE_URL_ @"http://musicputt.atwebpages.com/listeningList.php"

//#define _MUSICPUTT_BASE_URL_ @"http://192.168.5.10:8080/"
//#define _MUSICPUTT_RELATIVE_URL_ @"http://192.168.5.10:8080/listeningList.php"




@interface MusicPuttApi()
{
    NSArray*                searchResult;
    RKResponseDescriptor*   responsedescriptor;
    RKObjectManager*        objectManager;
    id                      delegate;
}

@end




@implementation MusicPuttApi

/**
 *  Constructor
 *
 *  @return return instance of this object
 */
- (id) init
{
    self = [super init];
    [self configureConnection];
    return self;
}

/**
 *  Set delegate to recieve result of query.
 *
 *  @param anObject delegate object with MPServiceStoreDelegate protocol.
 */
- (void) setDelegate:(id) anObject
{
    delegate = anObject;
}

/**
 *  Configuration of the connection with the iTunes Store API.
 */
- (void) configureConnection
{
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:_MUSICPUTT_BASE_URL_];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // define music track mapping
    RKObjectMapping *musicTrackMapping = [RKObjectMapping mappingForClass:[MPListening class]];
    [musicTrackMapping addAttributeMappingsFromArray:@[@"trackId",
                                                       @"artistId",
                                                       @"collectionId",
                                                       @"trackName",
                                                       @"artistName",
                                                       @"collectionName",
                                                       @"previewUrl",
                                                       @"artworkUrl100"                                                       
                                                       ]];
    
    RKDynamicMapping* dynamicMapping = [RKDynamicMapping new];
    
    // Connect a response descriptor for our dynamic mapping
    responsedescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:dynamicMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:@"results"
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responsedescriptor];
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"application/json"];
    
    [dynamicMapping setObjectMappingForRepresentationBlock:^RKObjectMapping *(id representation) {
        
            // TODO adding mapping if needed
            return musicTrackMapping;
        
    }];
}

/**
 *  Execute query to retrieve last playing songs by others users in musicputt and return results to the delagate.
 */
- (void) queryListening;
{
    //Let's get this on a background thread.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSURLRequest *request = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:_MUSICPUTT_RELATIVE_URL_]];
                       
                       RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[self->responsedescriptor]];
                       operation.HTTPRequestOperation.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
                       [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
                           
                           //About to update the UI, so jump back to the main/UI thread
                           dispatch_async(dispatch_get_main_queue(), ^{
                               NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Request completed.");
                               if ( [delegate respondsToSelector:@selector(queryResultMusicPutt:type:results:)]){
                                   [delegate queryResultMusicPutt:MusicPuttApiStatusSucceed type:QueryMusicPuttListening results:[result array]];
                               }
                           });
                           
                       } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                           
                           //About to update the UI, so jump back to the main/UI thread
                           dispatch_async(dispatch_get_main_queue(), ^{
                               NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Request failed.");
                               if ( [delegate respondsToSelector:@selector(queryResultMusicPutt:type:results:)] ){
                                   [delegate queryResultMusicPutt:MusicPuttApiStatusFailed type:QueryMusicPuttListening results:nil];
                               }
                           });
                       }];
                       [operation start];
                   });
}

/**
 *  Post a MPListening to musicputt server
 *
 *  @param listening Object repressenting a listening in the application
 */
- (void) postListening:(MPListening*) listening
{
    // TEST ADDING MORE LOG
    // RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    RKObjectMapping *musicTrackMapping = [RKObjectMapping mappingForClass:[MPListening class]];
    [musicTrackMapping addAttributeMappingsFromArray:@[@"trackId",
                                                       @"artistId",
                                                       @"collectionId",
                                                       @"trackName",
                                                       @"artistName",
                                                       @"collectionName",
                                                       @"previewUrl",
                                                       @"artworkUrl100"
                                                       ]];
    
    RKDynamicMapping* dynamicMapping = [RKDynamicMapping new];
    [dynamicMapping setObjectMappingForRepresentationBlock:^RKObjectMapping *(id representation) {
        
        // TODO adding mapping if needed
        return musicTrackMapping;
        
    }];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:dynamicMapping objectClass:[MPListening class] rootKeyPath:@"mplistening" method:RKRequestMethodAny];
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:_MUSICPUTT_BASE_URL_]];
    [manager addRequestDescriptor:requestDescriptor];
    
    // POST to create
    [manager postObject:listening path:@"/listeningList.php" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        // TODO
        NSLog(@"successful post");
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // TODO
        NSLog(@"failed post %@", error);
        NSLog(@"%@",operation.description);
        NSLog(@"%@",operation.HTTPRequestOperation.description);
    }];

    

}

@end
