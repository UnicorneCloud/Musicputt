//
//  MPServiceStoreTest.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-07-13.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MPServiceStore.h"

@interface MPServiceStoreTest : XCTestCase <MPServiceStoreDelegate>
{
    MPServiceStore *iTunes;
    
    NSArray* resultArray;
    BOOL queryMusicTrackWithSearchTerm;
    BOOL queryMusicTrackWithSearchTId;
    BOOL queryAlbumWithSearchTerm;
    BOOL queryAlbumWithId;
    BOOL queryAlbumWithArtistId;
    
    BOOL testResult;
}

@end

@implementation MPServiceStoreTest

- (void) setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    iTunes = [[MPServiceStore alloc] init];
    [iTunes setDelegate:self];
    resultArray = [[NSArray alloc]init];
    testResult = false;
    
    queryMusicTrackWithSearchTerm = false;
    queryMusicTrackWithSearchTId = false;
    queryAlbumWithSearchTerm = false;
    queryAlbumWithId = false;
    queryAlbumWithArtistId = false;
}

- (void) tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void) testQueryMusicTrackWithSearchTerm
{
    [iTunes queryMusicTrackWithSearchTerm:@"london+grammar+strong" asynchronizationMode:false];
    if(resultArray.count>0 && queryMusicTrackWithSearchTerm){
        testResult = true;
    }
    XCTAssert(testResult);
}


- (void) testQueryMusicTrackWithId
{
    [iTunes queryMusicTrackWithId:@"695806055" asynchronizationMode:false];
    if (resultArray.count==1 && queryMusicTrackWithSearchTId) {
        testResult = true;
    }
    XCTAssert(testResult);
    
}

- (void) testqueryAlbumWithSearchTerm
{
    [iTunes queryAlbumWithSearchTerm:@"london+grammar" asynchronizationMode:false];
    if (resultArray.count>0 && queryAlbumWithSearchTerm) {
        testResult = true;
    }
    XCTAssert(testResult);
}


- (void) testQueryAlbumWithId
{
    [iTunes queryAlbumWithId:@"695805771" asynchronizationMode:false];
    if (resultArray.count==1 && queryAlbumWithId) {
        testResult = true;
    }
    XCTAssert(testResult);
    
}

-(void) testQueryAlbumWithArtistId
{
    [iTunes queryAlbumWithArtistId:@"604064576" asynchronizationMode:false];
    if (resultArray.count>0 && queryAlbumWithArtistId) {
        testResult = true;
    }
    XCTAssert(testResult);
    
}

- (void) testQueryMusicTrackWithSearchTermAsync
{
    [iTunes queryMusicTrackWithSearchTerm:@"london+grammar+strong" asynchronizationMode:true];
    
    NSDate *SecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:1.0];
    [[NSRunLoop currentRunLoop] runUntilDate:SecondsFromNow];
    
    if(resultArray.count>0 && queryMusicTrackWithSearchTerm){
        testResult = true;
    }
    XCTAssert(testResult);
}


- (void) testQueryMusicTrackWithIdAsync
{
    [iTunes queryMusicTrackWithId:@"695806055" asynchronizationMode:true];
    
    NSDate *SecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:1.0];
    [[NSRunLoop currentRunLoop] runUntilDate:SecondsFromNow];
    
    if (resultArray.count==1 && queryMusicTrackWithSearchTId) {
        testResult = true;
    }
    XCTAssert(testResult);
    
}

- (void) testqueryAlbumWithSearchTermAsync
{
    [iTunes queryAlbumWithSearchTerm:@"london+grammar" asynchronizationMode:true];
    
    NSDate *SecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:1.0];
    [[NSRunLoop currentRunLoop] runUntilDate:SecondsFromNow];
    
    if (resultArray.count>0 && queryAlbumWithSearchTerm) {
        testResult = true;
    }
    XCTAssert(testResult);
}


- (void) testQueryAlbumWithIdAsync
{
    [iTunes queryAlbumWithId:@"695805771" asynchronizationMode:true];
    
    NSDate *SecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:1.0];
    [[NSRunLoop currentRunLoop] runUntilDate:SecondsFromNow];
    
    if (resultArray.count==1 && queryAlbumWithId) {
        testResult = true;
    }
    XCTAssert(testResult);
    
}

-(void) testQueryAlbumWithArtistIdAsync
{
    [iTunes queryAlbumWithArtistId:@"604064576" asynchronizationMode:true];
    
    NSDate *SecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:1.0];
    [[NSRunLoop currentRunLoop] runUntilDate:SecondsFromNow];
    
    if (resultArray.count>0 && queryAlbumWithArtistId) {
        testResult = true;
    }
    XCTAssert(testResult);
    
}

-(void) queryResult:(MPServiceStoreQueryStatus)status type:(MPServiceStoreQueryType)type results:(NSArray*)results
{
    if (status==MPServiceStoreStatusSucceed) {
        if (type == MPQueryMusicTrackWithSearchTerm){
            queryMusicTrackWithSearchTerm = true;
        }
        else if ( type == MPQueryMusicTrackWithId ){
            queryMusicTrackWithSearchTId = true;
        }
        else if (type == MPQueryAlbumWithSearchTerm){
            queryAlbumWithSearchTerm = true;
        }
        else if (type == MPQueryAlbumWithId){
            queryAlbumWithId = true;
        }
        else if (type == MPQueryAlbumWithArtistId){
            queryAlbumWithArtistId = true;
        }
            
        resultArray = results;
    }
}



@end
