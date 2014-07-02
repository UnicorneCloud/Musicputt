//
//  UIViewControllerTabbar.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-30.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMWaveViewController.h"
#import "CurrentPlayingToolBar.h"

@interface UIViewControllerToolbar : AMWaveViewController
{
    CurrentPlayingToolBar*  currentPlayingToolBar;
    UITableView*            toolbarTableView;
}
@end
