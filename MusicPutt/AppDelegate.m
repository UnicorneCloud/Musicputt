//
//  AppDelegate.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-16.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "AppDelegate.h"
#import "MPDataManager.h"
#import "REFrostedViewController.h"

@interface AppDelegate()
{
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    _mpdatamanager = [[MPDataManager alloc]init];
    if (_mpdatamanager!=NULL) {
        if (![_mpdatamanager initialise]) {
            NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"[ERROR] - Unable to initialise MPDataManager");
        }
    }
    else{
        NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"[ERROR] - Unable to initialise MPDataManager");
    }
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Completed");
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Completed");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Completed");
    
    if (_mpdatamanager!=NULL) {
        [_mpdatamanager prepareAppDidEnterBackground];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if (_mpdatamanager!=NULL) {
        [_mpdatamanager prepareAppWillEnterForeground];
    }
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Completed");
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (_mpdatamanager!=NULL) {
        [_mpdatamanager prepareAppDidBecomeActive];
    }

    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Completed");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    if (_mpdatamanager!=NULL) {
        [_mpdatamanager prepareAppWillTerminate];
    }
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Completed");
}

/**
 *  Return appVersion from project settings
 *
 *  @return <#return value description#>
 */
- (NSString *) appVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

/**
 *  Return build from projects settings
 *
 *  @return <#return value description#>
 */
- (NSString *) build
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
}


/**
 *  Return the version and build from the project settings
 *
 *  @return <#return value description#>
 */
- (NSString *) versionBuild
{
    NSString * version = [self appVersion];
    NSString * build = [self build];
    
    NSString * versionBuild = [NSString stringWithFormat: @"v%@", version];
    
    if (![version isEqualToString: build]) {
        versionBuild = [NSString stringWithFormat: @"%@(%@)", versionBuild, build];
    }
    
    return versionBuild;
}

@end
