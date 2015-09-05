//
//  MusicPuttApi.m
//  MusicPutt
//
//  Created by Eric Pinet on 2015-01-31.
//  Copyright (c) 2015 Eric Pinet. All rights reserved.
//

#import "MusicPuttApi.h"

#import <RestKit.h>
#import "MPListening.h"


/**
 *  Activate this define to execute the musicputt with local
 *  test environnement.
 */
//#define _TEST_ENVIRONNEMENT_

#ifdef _TEST_ENVIRONNEMENT_

    #define _MUSICPUTT_BASE_URL_ @"http://192.168.5.10:8080/"
    #define _MUSICPUTT_RELATIVE_URL_ @"http://192.168.5.10:8080/listeningList.php"

#else

    #define _MUSICPUTT_BASE_URL_ @"http://musicputt.atwebpages.com/"
    #define _MUSICPUTT_RELATIVE_URL_ @"http://musicputt.atwebpages.com/listeningList.php"

#endif


@interface MusicPuttApi()
{
    id                      delegate;
    
    NSMutableData*          webData;
    NSMutableArray*         tracks;
    NSURLConnection*        connection;
}
@end


@implementation MusicPuttApi

/**
 *  Execute query to retrieve last playing songs by others users in musicputt and execute success block or failure
 *
 *  @param async   True for async response.
 *  @param success success block
 *  @param failure failure block
 */
- (void) queryListeningListAsynchronizationMode:(BOOL)async
                                        success:(void (^)(NSArray* results))success
                                        failure:(void (^)(NSError *error))failure
{
    NSURL* url = [NSURL URLWithString:_MUSICPUTT_RELATIVE_URL_];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin request");
    
    [NSURLConnection
     sendAsynchronousRequest:request
     queue:[[NSOperationQueue alloc] init]
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error)
     {
         
         if ([data length] >0 && error == nil)
         {
             webData = (NSMutableData*)data;
             
             // unpack response
             NSDictionary* allDataDictionary = [NSJSONSerialization JSONObjectWithData:webData options:0 error:nil];
             NSArray* entries = [allDataDictionary objectForKey:@"results"];
             
             // create new albums array
             tracks = [[NSMutableArray alloc] init];
             
             for (NSDictionary *entry in entries)
             {
                 MPListening* track = [[MPListening alloc]init];
                 
                 // load track id
                 NSString* strTrackId = [entry objectForKey:@"trackId"];
                 [track setTrackId:strTrackId];
                 
                 // load artist id
                 NSString* strArtistId = [entry objectForKey:@"artistId"];
                 [track setArtistId:strArtistId];
                 
                 // load collection id
                 NSString* strCollectionId = [entry objectForKey:@"collectionId"];
                 [track setCollectionId:strCollectionId];
                 
                 // load track name
                 NSString* strTrackName = [entry objectForKey:@"trackName"];
                 [track setTrackName:strTrackName];
                 
                 // load artist name
                 NSString* strArtistName = [entry objectForKey:@"artistName"];
                 [track setArtistName:strArtistName];
                 
                 // load collection name
                 NSString* strCollectionName = [entry objectForKey:@"collectionName"];
                 [track setCollectionName:strCollectionName];
                 
                 // load previewUrl
                 NSString* strPreviewUrl = [entry objectForKey:@"previewUrl"];
                 [track setPreviewUrl:strPreviewUrl];
                 
                 // load artworkUrl100
                 NSString* strArtworkUrl100 = [entry objectForKey:@"artworkUrl100"];
                 [track setArtworkUrl100:strArtworkUrl100];
                 
                 [tracks addObject:track];
             }
             
             //About to update the UI, so jump back to the main/UI thread
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (success) {
                     success(tracks);
                 }
             });
             
         }
         // error no data read from response
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Nothing was downloaded.");
             if (failure) {
                 NSError* error = [NSError errorWithDomain:@"com.ericpinet.musictputtapi"
                                                      code:1
                                                  userInfo:[NSDictionary dictionaryWithObject:@"My error message"
                                                                                       forKey:NSLocalizedDescriptionKey]];
                 //About to update the UI, so jump back to the main/UI thread
                 dispatch_async(dispatch_get_main_queue(), ^{
                     failure(error);
                 });
             }
             
         }
         // error no connexion failed
         else if (error != nil){
             NSLog(@"Error = %@", error);
             if (failure) {
                 //About to update the UI, so jump back to the main/UI thread
                 dispatch_async(dispatch_get_main_queue(), ^{
                     failure(error);
                 });
             }
         }
         
     }];
}


/**
 *  Post a MPListening to musicputt server
 *
 *  @param listening Object repressenting a listening in the application
 */
- (void) postListening:(MPListening*) listening
{    
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
        NSLog(@"successful post");
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"failed post %@", error);
        NSLog(@"%@",operation.description);
        NSLog(@"%@",operation.HTTPRequestOperation.description);
    }];
}

@end
