//
//  MMViewController.h
//  MediaManager
//
//  Created by Eric Pinet on 2014-06-19.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaDataSource.h"

@class MediaDataSourceManager;

@interface MMViewController : UIViewController <MediaDataSource>

@property MediaDataSourceManager* mediaManager;

@end
