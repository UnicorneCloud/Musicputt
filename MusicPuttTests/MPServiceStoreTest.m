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
    NSArray* resultArray;
    BOOL queryMusicTrackWithSearchTermResult;
    BOOL queryMusicTrackWithSearchTId;
}

@end

@implementation MPServiceStoreTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testQueryMusicTrackWithSearchTerm
{
        
    [NSThread sleepForTimeInterval:2.0];
    
    if (!queryMusicTrackWithSearchTermResult) {
        XCTFail(@"Querry failed \"%s\"", __PRETTY_FUNCTION__);
    }
}


- (void)testQueryMusicTrackWithId
{
    resultArray = [[NSArray alloc]init];
    MPServiceStore *iTunes = [[MPServiceStore alloc] init];
    
    if(iTunes)
        [iTunes queryMusicTrackWithId:@"695806055" setDelegate:self];
    else
        XCTFail(@"Unable to initialise MPServiceStore \"%s\"", __PRETTY_FUNCTION__);
    
    [NSThread sleepForTimeInterval:2.0];
    
    if (!queryMusicTrackWithSearchTId) {
        XCTFail(@"Querry failed \"%s\"", __PRETTY_FUNCTION__);
    }
}


-(void) queryResult:(MPServiceStoreQueryStatus)status type:(MPServiceStoreQueryType)type results:(NSArray*)results
{
    if (status==MPServiceStoreStatusSucceed) {
        if (type == MPQueryMusicTrackWithSearchTerm)
            queryMusicTrackWithSearchTermResult = true;
        else if ( type == MPQueryMusicTrackWithId )
            queryMusicTrackWithSearchTId = true;
    }
    NSLog(@"\nTEST PASS\n");
}



@end
