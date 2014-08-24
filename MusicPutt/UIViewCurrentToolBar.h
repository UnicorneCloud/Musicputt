//
//  UIViewCurrentToolBar.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-28.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAProgressView+Extensions.h"


/**
 *  Detail view for the UICurrentPlayingToolBar. 
 *  @see UICurrentPlayingToolBar.h
 */
@interface UIViewCurrentToolBar : UIView


/**
 *  Image of the album Artwork.
 */
@property (weak,nonatomic) IBOutlet UIImageView* imageview;

/**
 *  Title of the current playing song.
 */
@property (weak,nonatomic) IBOutlet UILabel* songTitle;

/**
 *  Artist name of the current playing song.
 */
@property (weak,nonatomic) IBOutlet UILabel* artist;

/**
 *  Album title of the current playing song.
 */
@property (weak,nonatomic) IBOutlet UILabel* album;

/**
 *  Progress of the current playing song and Play/Pause button.
 */
@property (weak,nonatomic) IBOutlet UAProgressView* progress;

/**
 *  Navigation controller attach with the toolbar.
 */
@property (strong,nonatomic) UINavigationController* navigationController;


/**
 *  Active notification capture from the media player.
 */
- (void) startNotificationCapture;


/**
 *  Stop notification capture from the media player.
 */
- (void) stopNotificationCapture;


/**
 *  Check the current playing item and update display.
 */
-(void) updateCurrentPlayingItem;


/**
 *  Image of the album Artwork pressed by the user.
 */
- (void)imageViewPressed;

/**
 *  Song title of the current playing song is pressed by the user.
 */
- (void)songtitlePressed;

/**
 *  Artist name of the current playing song is pressed by the user.
 */
- (void)artistPressed;

/**
 *  Album title of the current playing song is pressed by the user.
 */
- (void)albumPressed;

/**
 *  Progress Play/Pause button pressed by the user.
 */
- (void)progressPressed;

@end
