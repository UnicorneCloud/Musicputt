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
    [iTunes setDelegate:self];
    resultArray = [[NSArray alloc]init];
    testResult = false;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testQueryTop10AlbumUS
{
    [iTunes queryFeedType:QueryTopAlbums forCountry:@"us" size:10 genre:0 asynchronizationMode:FALSE];
    
    NSDate *SecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:1.0];
    [[NSRunLoop currentRunLoop] runUntilDate:SecondsFromNow];
    
    if (resultArray.count==10) {
        testResult = true;
    }
    
    XCTAssert(testResult);
}

- (void)testQueryTop10AlbumCA
{
    [iTunes queryFeedType:QueryTopAlbums forCountry:@"ca" size:10 genre:0 asynchronizationMode:FALSE];
    
    NSDate *SecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:1.0];
    [[NSRunLoop currentRunLoop] runUntilDate:SecondsFromNow];
    
    if (resultArray.count==10) {
        testResult = true;
    }
    
    XCTAssert(testResult);
}

- (void)testQueryTop25AlbumCA
{
    [iTunes queryFeedType:QueryTopAlbums forCountry:@"ca" size:25 genre:0 asynchronizationMode:FALSE];
    
    NSDate *SecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:1.0];
    [[NSRunLoop currentRunLoop] runUntilDate:SecondsFromNow];
    
    if (resultArray.count==25) {
        testResult = true;
    }
    
    XCTAssert(testResult);
}

- (void)testQueryTop50AlbumCA
{
    [iTunes queryFeedType:QueryTopAlbums forCountry:@"ca" size:50 genre:0 asynchronizationMode:FALSE];
    
    NSDate *SecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:1.0];
    [[NSRunLoop currentRunLoop] runUntilDate:SecondsFromNow];
    
    if (resultArray.count==50) {
        testResult = true;
    }
    
    XCTAssert(testResult);
}

- (void)testQueryTop100AlbumCA
{
    [iTunes queryFeedType:QueryTopAlbums forCountry:@"ca" size:100 genre:0 asynchronizationMode:FALSE];
    
    NSDate *SecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:1.0];
    [[NSRunLoop currentRunLoop] runUntilDate:SecondsFromNow];
    
    if (resultArray.count==100) {
        testResult = true;
    }
    
    XCTAssert(testResult);
}

- (void)testQueryTop10AlbumCAGenreChinese
{
    [iTunes queryFeedType:QueryTopAlbums forCountry:@"ca" size:10 genre:GENRE_CHINESE asynchronizationMode:FALSE];
    
    NSDate *SecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:1.0];
    [[NSRunLoop currentRunLoop] runUntilDate:SecondsFromNow];
    
    if (resultArray.count==10) {
        testResult = true;
    }
    
    XCTAssert(testResult);
}

- (void)testQueryTop10SongsUS
{
    [iTunes queryFeedType:QueryTopSongs forCountry:@"us" size:10 genre:0 asynchronizationMode:FALSE];
    
    NSDate *SecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:1.0];
    [[NSRunLoop currentRunLoop] runUntilDate:SecondsFromNow];
    
    if (resultArray.count==10) {
        testResult = true;
    }
    
    XCTAssert(testResult);
}

-(void) queryResult:(ITunesFeedsApiQueryStatus)status type:(ITunesFeedsQueryType)type results:(NSArray*)results
{
    resultArray = results;
}



@end
