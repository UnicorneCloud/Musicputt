//
//  REFrostedViewControllerMain.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-08-03.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "REFrostedViewControllerMain.h"

#import "AppDelegate.h"

@interface REFrostedViewControllerMain ()
{
    
}

/**
 *  App delegate
 */
@property AppDelegate* del;

@end

@implementation REFrostedViewControllerMain

- (void)awakeFromNib
{
    // setup app delegate
    self.del = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //self.liveBlur = TRUE;
    
    [self.del setMainMenu:self];
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainContentController"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController"];
    
    
}

@end
