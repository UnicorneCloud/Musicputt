//
//  CurrentPlayingToolBar.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-28.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <iToolbar.h>

#import "UIViewCurrentToolBar.h"


/**
 *  Navigation Toolbar to displayed current playing song.
 *  This toolbar can display current playing song. 
 * @see UIViewCurrentToolBar.h
 */
@interface UICurrentPlayingToolBar : iToolbar
{
    UIViewCurrentToolBar *view;
}


/**
 *  Set the current NavigationController.
 *  You have to attach the navigation bar with the toolbar for properly display.
 *
 *  @param controller UINavigationController for attach with the toolbar.
 */
- (void) setNavigationController:(UINavigationController*) controller;


/**
 *  Show navigation tabbar
 *
 *  @param bar      navigation bar parent of the toolbar.
 *  @param animated animation during show.
 */
- (void)showFromNavigationBar:(UINavigationBar *)bar animated:(BOOL)animated;

/**
 *  Hide tabbar
 *
 *  @param animated animate during hide.
 */
- (void)hideAnimated:(BOOL)animated;

@end
