//
//  UIMusicViewLoadingController.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-16.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  UIViewController for display application loading.
 */
@interface UIMusicViewLoadingController : UIViewController


/**
 *  Prepare application to start.
 */
-(void) loadApp;

/**
 *  Called when application is loaded and ready to open.
 */
-(void) loadAppCompleted;


@end
