//
//  AppDelegate.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-16.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPDataManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MPDataManager* mpdatamanager;

@end
