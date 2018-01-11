//
//  UIViewControllerToolbar.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-30.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICurrentPlayingToolBar.h"

#import <BFNavigationBarDrawer.h>
#import <iToolbar.h>


/**
 *  Base class for all UIViewController of this application.
 *
 *  This class provide :
 *
 *   - Toolbar mechanism
 *   - Wave effect on transition.
 *
 *  If you inherits from this class your UIViewController will be display a
 *  current playing toolbar automatic. See UICurrentPlayingToolBar.
 *
 *  @warning To active wave effect, add this to your UIViewController class
 *
 *          -(NSArray*)visibleCells
 *          {
 *              return [self.tableView visibleCells];
 *          }
 * 
 */
@interface UIViewControllerToolbar : UIViewController
{
    /**
     *  Toolbar to display current playing song.
     */
    UICurrentPlayingToolBar*    currentPlayingToolBar;
    
    /**
     * Toolbar to display edition action during playlist edition
     */
    iToolbar*      currentEditingPlaylistToolbar;
    
    /**
     *  TableView attach with the current playing song.
     */
    UIScrollView*                scrollView;
}

/**
 *  Show current playing toolbar
 */
-(void) showCurrentPlayingToolbar;

/**
 *  Hide current playing toolbar
 */
-(void) hideCurrentPlayingToolbar;

/**
 *  Show current editing playlist toolbar
 */
-(void) showCurrentEditingPlaylistToolbar;

/**
 *  Hide current editing playlist toolbar
 */
-(void) hideCurrentEditingPlaylistToolbar;

/**
 *  Setup navigation bar
 */
-(void) setupNavigationBar;


@end
