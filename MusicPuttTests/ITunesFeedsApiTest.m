//
//  ITunesFeedsApiTest.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-08-31.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ITunesFeedsApi.h"

@interface ITunesFeedsApiTest : XCTestCase <ITunesFeedsApiDelegate>
{
    ITunesFeedsApi *iTunes;
    NSArray* resultArray;
    BOOL testResult;
}

@end

@implementation ITunesFeedsApiTest

- (void)setUp
{
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    iTunes = [[ITunesFeedsApi alloc] init];
    resultArray = [[NSArray alloc]init];
    testResult = false;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testQueryTop10Album
{
    [iTunes queryFeedType:QueryTopAlbums forCountry:@"us" size:10 genre:nil asynchronizationMode:FALSE];
    
    NSDate *SecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:1.0];
    [[NSRunLoop currentRunLoop] runUntilDate:SecondsFromNow];
    
    //NSLog(resultArray);
    
    testResult = true;
    XCTAssert(testResult);
}


-(void) queryResult:(ITunesFeedsApiQueryStatus)status type:(ITunesFeedsQueryType)type results:(NSArray*)results
{
    resultArray = results;
}



@end
