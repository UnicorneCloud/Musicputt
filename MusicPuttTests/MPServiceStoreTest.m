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
    BOOL testResult;
}

@end

@implementation MPServiceStoreTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    iTunes = [[MPServiceStore alloc] init];
    [iTunes configureConnection];
    resultArray = [[NSArray alloc]init];
    testResult = false;
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testQueryMusicTrackWithSearchTerm
{
    [iTunes queryMusicTrackWithSearchTerm:@"london+grammar+strong" setDelegate:self];
    
    NSDate *fiveSecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:5.0];
    [[NSRunLoop currentRunLoop] runUntilDate:fiveSecondsFromNow];
    
    if(resultArray.count>0 && queryMusicTrackWithSearchTerm){
        testResult = true;
    }
    XCTAssert(testResult);
}


- (void)testQueryMusicTrackWithId
{
    [iTunes queryMusicTrackWithId:@"695806055" setDelegate:self];
    
    NSDate *fiveSecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:5.0];
    [[NSRunLoop currentRunLoop] runUntilDate:fiveSecondsFromNow];
    
    if (resultArray.count==1 && queryMusicTrackWithSearchTId) {
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
        resultArray = results;
    }
}



@end
