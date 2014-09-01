//
//  ITunesFeedsApi.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-08-30.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "ITunesFeedsApi.h"

#import "ITUnesAlbum.h"

@interface ITunesFeedsApi()
{
    id  delegate;
    
    NSMutableData*          webData;
    NSMutableArray*         albums;
    NSURLConnection*        connection;
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

/**
 *  Receive response from web json api.
 *
 *  @param connection <#connection description#>
 *  @param response   <#data description#>
 */
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength:0];
}

/**
 *  Receive data from web api
 *
 *  @param connection <#connection description#>
 *  @param data       <#data description#>
 */
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}

/**
 *  Connection error.
 *
 *  @param connection <#connection description#>
 *  @param error      <#error description#>
 */
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Error");
    
    if ( [delegate respondsToSelector:@selector(queryResult:type:results:)]){
        [delegate queryResult:StatusFailed type:QueryTopAlbums results: nil];
    }
}

/**
 *  Connection is finish loading
 *
 *  @param connection <#connection description#>
 */
- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary* allDataDictionary = [NSJSONSerialization JSONObjectWithData:webData options:0 error:nil];
    NSDictionary* feed = [allDataDictionary objectForKey:@"feed"];
    NSArray* entries = [feed objectForKey:@"entry"];
    
    // create new albums array
    albums = [[NSMutableArray alloc] init];
    
    for (NSDictionary *entry in entries)
    {
        // create new album
        ITunesAlbum* album = [[ITunesAlbum alloc] init];
        
        // load album title
        NSDictionary* title = [entry objectForKey:@"im:name"];
        NSString* strTitle = [title objectForKey:@"label"];
        [album setCollectionName:strTitle];
        
        // load artist name
        NSDictionary* artist = [entry objectForKey:@"im:artist"];
        NSString* strArtist = [artist objectForKey:@"label"];
        [album setArtistName:strArtist];
        
        // load album artwork
        NSArray* artworks = [entry objectForKey:@"im:image"];
        NSDictionary* artwork = [artworks objectAtIndex:2];
        NSString* strArtwork = [artwork objectForKey:@"label"];
        [album setArtworkUrl100:strArtwork];
        
        // load track count
        NSDictionary* count = [entry objectForKey:@"im:itemCount"];
        NSString* strItemCount = [count objectForKey:@"label"];
        [album setTrackCount:strItemCount];
        
        // load price
        NSDictionary* price = [entry objectForKey:@"im:price"];
        NSString* strPrice = [price objectForKey:@"label"];
        [album setCollectionPrice:strPrice];
        
        // load link
        NSDictionary* link = [entry objectForKey:@"link"];
        NSDictionary* attributes = [link objectForKey:@"attributes"];
        NSString* strLink = [attributes objectForKey:@"href"];
        [album setCollectionViewUrl:strLink];
        
        // load collection id
        NSDictionary* collectionId = [entry objectForKey:@"id"];
        NSDictionary* attributes2 = [collectionId objectForKey:@"attributes"];
        NSString* strCollectionId = [attributes2 objectForKey:@"im:id"];
        [album setCollectionId:strCollectionId];
        
        // load release date
        NSDictionary* releaseDate = [entry objectForKey:@"im:releaseDate"];
        NSDictionary* attributes3 = [releaseDate objectForKey:@"attributes"];
        NSString* strReleaseDate = [attributes3 objectForKey:@"label"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMMM dd, yyyy"];
        NSDate* date = [[NSDate alloc] init];
        date = [formatter dateFromString:strReleaseDate]; //TODO: ReleaseDate format doesn't work!
        [album setReleaseDate:date];
        
        [albums addObject:album];
    }
    
    if ( [delegate respondsToSelector:@selector(queryResult:type:results:)]){
        [delegate queryResult:StatusSucceed type:QueryTopAlbums results: albums];
    }
    
    
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
- (void) queryFeedType:(ITunesFeedsQueryType)type forCountry:(NSString*)country size:(NSInteger)size genre:(NSString*)genre asynchronizationMode:(BOOL)async
{
    if ([self validateParameters:type forCountry:country size:size genre:genre asynchronizationMode:async]) {
        
        NSString* queryType = @"topsongs";
        if (type == QueryTopAlbums) {
            queryType = @"topalbums";
        }
        NSString* strUrl = [NSString stringWithFormat:@"https://itunes.apple.com/%@/rss/%@/limit=%ld/explicit=true/json",country, queryType, size];
        NSURL* url = [NSURL URLWithString:strUrl];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        connection = [NSURLConnection connectionWithRequest:request delegate:self];
        if (connection) {
            webData = [[NSMutableData alloc]init];
        }
    }
    else{
        NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Error - Invalid parameters");
        
        if ( [delegate respondsToSelector:@selector(queryResult:type:results:)]){
            [delegate queryResult:StatusFailed type:type results: nil];
        }
    }
}


/**
 *  Validate parameters for querry
 *
 *  @param type    <#type description#>
 *  @param country <#country description#>
 *  @param size    <#size description#>
 *  @param genre   <#genre description#>
 *  @param async   <#async description#>
 *  @return true if all parameters are valid
 */
- (BOOL) validateParameters:(ITunesFeedsQueryType)type forCountry:(NSString*)country size:(NSInteger)size genre:(NSString*)genre asynchronizationMode:(BOOL)async
{
    return TRUE;
}

@end
