//
//  IPodLibraryManagerDelegate.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-17.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "IPodLibraryManager.h"


@protocol MediaDataSource <NSObject>

@optional

- (void) mediaWillLoad;
//- (void) iPodShouldLoad: (NSString*) IPodLibraryManagerLoadMediaGroupBy;
//- (void) iPodDidLoad: (NSString*) IPodLibraryManagerLoadMediaGroupBy, (NSArray*) results;

@end // end MediaDataSource

