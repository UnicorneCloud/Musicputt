//
//  MPServiceStore.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-07-13.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "MPServiceStore.h"
#import "MPMusicTrack.h"
#import "MPAlbum.h"

#import <RestKit/RestKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MPServiceStore()
{
    NSArray*                searchResult;
    RKResponseDescriptor*   responsedescriptor;
    RKObjectManager*        objectManager;
    id                      delegate;
}

@end

@implementation MPServiceStore

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
    NSURL *baseURL = [NSURL URLWithString:@"https://itunes.apple.com/"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // define music track mapping
    RKObjectMapping *musicTrackMapping = [RKObjectMapping mappingForClass:[MPMusicTrack class]];
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
    
    // define album mapping
    RKObjectMapping *albumMapping = [RKObjectMapping mappingForClass:[MPAlbum class]];
    [albumMapping addAttributeMappingsFromArray:@[@"wrapperType",
                                                  @"collectionType",
                                                  @"artistId",
                                                  @"collectionId",
                                                  @"artistName",
                                                  @"collectionName",
                                                  @"collectionCensoredName",
                                                  @"artistViewUrl",
                                                  @"collectionViewUrl",
                                                  @"artworkUrl60",
                                                  @"artworkUrl100",
                                                  @"collectionPrice",
                                                  @"collectionExplicitness",
                                                  @"trackCount",
                                                  @"copyright",
                                                  @"country",
                                                  @"currency",
                                                  @"releaseDate",
                                                  @"primaryGenreName"
                                                  ]];
    
    // define album mapping
    RKObjectMapping *artistMapping = [RKObjectMapping mappingForClass:[MPArtist class]];
    [artistMapping addAttributeMappingsFromArray:@[@"wrapperType",
                                                  @"artistType",
                                                  @"artistName",
                                                  @"artistLinkUrl",
                                                  @"artistId",
                                                  @"amgArtistId",
                                                  @"primarygenrename",
                                                  @"primarygenreid",
                                                  @"radiostationurl"
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
    
    [dynamicMapping setObjectMappingForRepresentationBlock:^RKObjectMapping *(id representation) {
        if ([[representation valueForKey:@"wrapperType"] isEqualToString:@"track"]) {
            return musicTrackMapping;
        } else if ([[representation valueForKey:@"wrapperType"] isEqualToString:@"collection"]) {
            return albumMapping;
        } else if ([[representation valueForKey:@"wrapperType"] isEqualToString:@"artist"]) {
            return artistMapping;
        }
        return nil;
    }];
 
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/javascript"];
}



/**
 *  Execute query in iTunes Store and return results to the delagate.
 *
 *  @param searchTerm see itunes api doc: https://www.apple.com/itunes/affiliates/resources/documentation/itunes-store-web-service-search-api.html
 *  @param async true if you want asynchronization mode
 */
- (void) queryMusicTrackWithSearchTerm:(NSString*)searchTerm asynchronizationMode:(BOOL) async
{
    if (async) {
        [self executeSearchAsync:searchTerm addFilter:@"musicTrack" queryType:MPQueryMusicTrackWithSearchTerm];
    }
    else {
        [self executeSearch:searchTerm addFilter:@"musicTrack" queryType:MPQueryMusicTrackWithSearchTerm];
    }
    
}

/**
 *  Execute query in iTunes Store and return music track with this id to the delagate.
 *
 *  @param id       id of the music track to find
 *  @param async true if you want asynchronization mode
 */
- (void) queryMusicTrackWithId:(NSString*)itemId asynchronizationMode:(BOOL) async
{
    if (async) {
        [self executeSearchAsync:itemId addFilter:@"musicTrack" queryType:MPQueryMusicTrackWithId];
    }
    else {
        [self executeSearch:itemId addFilter:@"musicTrack" queryType:MPQueryMusicTrackWithId];
    }
}

/**
 *  Execute query in iTunes Store and return music track with this album id to the delagate.
 *
 *  @param itemId   id of the album to find
 *  @param async true if you want asynchronization mode
 */
- (void) queryMusicTrackWithAlbumId:(NSString*)itemId asynchronizationMode:(BOOL) async
{
    if (async) {
        [self executeSearchAsync:itemId addFilter:@"song" queryType:MPQueryMusicTrackWithAlbumId];
    }
    else {
        [self executeSearch:itemId addFilter:@"song" queryType:MPQueryMusicTrackWithAlbumId];
    }
}

/**
 *  Execute query in iTunes Store and return music track with this artist id to the delagate.
 *
 *  @param itemId   id of the artist to find
 *  @param async true if you want asynchronization mode
 */
- (void) queryMusicTrackWithArtistId:(NSString*)itemId asynchronizationMode:(BOOL) async
{
    if (async) {
        [self executeSearchAsync:itemId addFilter:@"song" queryType:MPQueryMusicTrackWithArtistId];
    }
    else {
        [self executeSearch:itemId addFilter:@"song" queryType:MPQueryMusicTrackWithArtistId];
    }
}

/**
 *  Execute query for return albums from iTunes Store and return results to the delagate.
 *
 *  @param searchTerm see itunes api doc
 */
- (void) queryAlbumWithSearchTerm:(NSString*)searchTerm asynchronizationMode:(BOOL) async
{
    if (async) {
        [self executeSearchAsync:searchTerm addFilter:@"album" queryType:MPQueryAlbumWithSearchTerm];
    }
    else {
        [self executeSearch:searchTerm addFilter:@"album" queryType:MPQueryAlbumWithSearchTerm];
    }
}

/**
 *  Execute query in iTunes Store and return music track with this id to the delagate.
 *
 *  @param itemId   id of the music track to find
 *  @param async true if you want asynchronization mode
 */
- (void) queryAlbumWithId:(NSString*)itemId asynchronizationMode:(BOOL) async
{
    if (async) {
        [self executeSearchAsync:itemId addFilter:@"album" queryType:MPQueryAlbumWithId];
    }
    else {
        [self executeSearch:itemId addFilter:@"album" queryType:MPQueryAlbumWithId];
    }
}


/**
 *  Execute query in iTunes Store and return all album for an artist with this id to the delagate.
 *
 *  @param itemId   id of the music track to find
 *  @param async true if you want asynchronization mode
 */
- (void) queryAlbumWithArtistId:(NSString*)itemId asynchronizationMode:(BOOL) async
{
    if (async) {
        [self executeSearchAsync:itemId addFilter:@"album" queryType:MPQueryAlbumWithArtistId];
    }
    else {
        [self executeSearch:itemId addFilter:@"album" queryType:MPQueryAlbumWithArtistId];
    }
}

/**
 *  Make request to the iTunes Store with searchTerm and filterTerm in Asych mode.
 *
 *  @warning Call configureConnection before this function.
 *
 *  @param searchTerm see itunes api doc: https://www.apple.com/itunes/affiliates/resources/documentation/itunes-store-web-service-search-api.html
 *  @param filterTerm see itunes api doc: https://www.apple.com/itunes/affiliates/resources/documentation/itunes-store-web-service-search-api.html
 */
-(void) executeSearchAsync:(NSString*)searchTerm addFilter:(NSString*)filterTerm queryType:(MPServiceStoreQueryType)type;
{
    //Let's get this on a background thread.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSURLRequest *request;
                       if (type == MPQueryMusicTrackWithId ||
                           type == MPQueryMusicTrackWithAlbumId ||
                           type == MPQueryMusicTrackWithArtistId ||
                           type == MPQueryArtistWithId ||
                           type == MPQueryAlbumWithId ||
                           type == MPQueryAlbumWithArtistId) {
                           request = [NSURLRequest requestWithURL:[self createURLForCallWithId:searchTerm andFilter:filterTerm]];
                       }
                       else{
                           request = [NSURLRequest requestWithURL:[self createURLForCallWithSearchTerm:searchTerm andFilter:filterTerm]];
                       }
                       
                       RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[self->responsedescriptor]];
                       operation.HTTPRequestOperation.acceptableContentTypes = [NSSet setWithObject:@"text/javascript"];
                       [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
                           
                           //About to update the UI, so jump back to the main/UI thread
                           dispatch_async(dispatch_get_main_queue(), ^{
                               NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Request completed.");
                               if ( [delegate respondsToSelector:@selector(queryResult:type:results:)]){
                                   [delegate queryResult:MPServiceStoreStatusSucceed type:type results:[result array]];
                               }
                           });
                           
                       } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                           
                           //About to update the UI, so jump back to the main/UI thread
                           dispatch_async(dispatch_get_main_queue(), ^{
                               NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Request failed.");
                               if ( [delegate respondsToSelector:@selector(queryResult:type:results:)] ){
                                   [delegate queryResult:MPServiceStoreStatusFailed type:type results:nil];
                               }
                           });
                       }];
                       [operation start];
                   });
}

/**
 *  Make request to the iTunes Store with searchTerm and filterTerm in Asych mode.
 *
 *  @warning Call configureConnection before this function.
 *
 *  @param searchTerm see itunes api doc: https://www.apple.com/itunes/affiliates/resources/documentation/itunes-store-web-service-search-api.html
 *  @param filterTerm see itunes api doc: https://www.apple.com/itunes/affiliates/resources/documentation/itunes-store-web-service-search-api.html
 */
-(void) executeSearch:(NSString*)searchTerm addFilter:(NSString*)filterTerm queryType:(MPServiceStoreQueryType)type;
{
    NSURLRequest *request;
    if (type == MPQueryMusicTrackWithId ||
        type == MPQueryMusicTrackWithAlbumId ||
        type == MPQueryMusicTrackWithArtistId ||
        type == MPQueryArtistWithId ||
        type == MPQueryAlbumWithId ||
        type == MPQueryAlbumWithArtistId) {
        request = [NSURLRequest requestWithURL:[self createURLForCallWithId:searchTerm andFilter:filterTerm]];
    }
    else{
        request = [NSURLRequest requestWithURL:[self createURLForCallWithSearchTerm:searchTerm andFilter:filterTerm]];
    }
    
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[self->responsedescriptor]];
    
    operation.HTTPRequestOperation.acceptableContentTypes = [NSSet setWithObject:@"text/javascript"];

    [operation start];
    [operation waitUntilFinished];
    
    if (!operation.error) {
        if ( [delegate respondsToSelector:@selector(queryResult:type:results:)]){
            [delegate queryResult:MPServiceStoreStatusSucceed type:type results: [[operation mappingResult] array]];
        }
    }
}



/**
 *  Build valid URL to search on itune store api.
 *
 *  @param searchTerm see itunes api doc: https://www.apple.com/itunes/affiliates/resources/documentation/itunes-store-web-service-search-api.html
 *  @param filterTerm see itunes api doc: https://www.apple.com/itunes/affiliates/resources/documentation/itunes-store-web-service-search-api.html
 *
 *  @return valid url request to call RKObjectRequestOperation initWithRequest.
 */
-(NSURL *)createURLForCallWithSearchTerm:(NSString *)searchTerm andFilter:(NSString *)filterTerm {
    
    NSString *urlAsString = [NSString stringWithFormat:@"https://itunes.apple.com/search?entity=%@&limit=25&term=%@",
                            filterTerm,
                            [searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlAsString];
    return url;
}

/**
 *  Build valid URL to search on itune store api with a unique id of item.
 *
 *  @param searchTerm see itunes api doc: https://www.apple.com/itunes/affiliates/resources/documentation/itunes-store-web-service-search-api.html
 *  @param filterTerm see itunes api doc: https://www.apple.com/itunes/affiliates/resources/documentation/itunes-store-web-service-search-api.html
 *
 *  @return valid url request to call RKObjectRequestOperation initWithRequest.
 */
-(NSURL *)createURLForCallWithId:(NSString *)itemId andFilter:(NSString *)filterTerm {
    
    NSString *urlAsString = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?entity=%@&id=%@",
                             filterTerm,
                             [itemId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlAsString];
    return url;
}


/**
 *  Build searchterm for find song in iTunes Store.
 *
 *  @param mediaitem MediaItem that you expect find in store.
 *
 *  @return searchTerm to find song.
 */
-(NSString*) buildSearchTermForMusicTrackFromMediaItem:(MPMediaItem*) mediaitem
{
    NSMutableString *retval = [[NSMutableString alloc] init];
    bool found = false;
    
    //artist name
    if ( ![[mediaitem valueForProperty:MPMediaItemPropertyAlbumArtist]  isEqual: @""] )
    {
        if (found) {
            [retval appendString:@"+"];
        }
        [retval appendString:[mediaitem valueForProperty:MPMediaItemPropertyAlbumArtist]];
        found = true;
    }
    
    // album name
    if ( ![[mediaitem valueForProperty:MPMediaItemPropertyAlbumTitle]  isEqual: @""] )
    {
        if (found) {
            [retval appendString:@"+"];
        }
        [retval appendString:[mediaitem valueForProperty:MPMediaItemPropertyAlbumTitle]];
        found = true;
    }
    
    // song name
    if ( ![[mediaitem valueForProperty:MPMediaItemPropertyTitle]  isEqual: @""] )
    {
        if (found) {
            [retval appendString:@"+"];
        }
        [retval appendString:[mediaitem valueForProperty:MPMediaItemPropertyTitle]];
        found = true;
    }
    
    [retval replaceOccurrencesOfString:@" " withString:@"+" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [retval length])];
    
    
    return retval;
}

@end
