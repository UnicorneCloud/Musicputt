//
//  MusicViewController.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-24.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageViewArtwork.h"

@class UIViewControllerArtworkPage;
@class UIViewControllerArtistPage;
@class UIViewControllerLyricsPage;

/**
 *  Main screen to display current playing song.
 *  When this screen is display, the UICurrentPlayingToolBar is hidden. 
 *  When this screen is hidden, the UICurrentPlayingToolBar is display.
 *  
 *  From this screen, the user can access all details screen (lyrics, artist, album, discover, share)
 */
@interface UIViewControllerMusic : UIViewController


/**
 *  Page view controller for access artist, album and lyrics.
 */
@property (weak, nonatomic) IBOutlet UIPageViewController*  pageviewcontroller;

/**
 *  View that content page view controller for artist, album and lyrics.
 */
@property (weak, nonatomic) IBOutlet UIView*            pageview;

/**
 *  Artwork page.
 */
@property (strong, nonatomic) UIViewControllerArtworkPage* artworkpage;

/**
 *  Artist information page.
 */
@property (strong, nonatomic) UIViewControllerArtistPage* artistpage;

/**
 *  Lyrics page.
 */
@property (strong, nonatomic) UIViewControllerLyricsPage* lyricspage;

/**
 *  Artwork of the current playing song.
 */
@property (weak, nonatomic) IBOutlet UIImageView*       imageview;

/**
 *  Page control to display page.
 */
@property (weak, nonatomic) IBOutlet UIPageControl*     pagecontrol;

/**
 *  Song title of the current playing song.
 */
@property (weak, nonatomic) IBOutlet UILabel*           songtitle;

/**
 *  Artist and Album title of the current playing song.
 */
@property (weak, nonatomic) IBOutlet UILabel*           artistalbum;

/**
 *  View contain all controls to manage media player.
 */
@property (weak, nonatomic) IBOutlet UIView*            controlview;

/**
 *  Current playing time. Position in the current playing song.
 */
@property (weak, nonatomic) IBOutlet UILabel*           curtime;

/**
 *  Elapse time to reach end of the current playing song.
 */
@property (weak, nonatomic) IBOutlet UILabel*           endtime;

/**
 *  Progressbar to display current position in the current playing song.
 */
@property (weak, nonatomic) IBOutlet UIProgressView*    progresstime;

/**
 *  Button to display and manage shuffle mode of the media player.
 */
@property (weak, nonatomic) IBOutlet UIButton*          shuffle;

/**
 *  Button to display and manage the repeat mode of the media player.
 */
@property (weak, nonatomic) IBOutlet UIButton*          repeat;

/**
 *  Button to manage the rewind for the media player.
 */
@property (weak, nonatomic) IBOutlet UIButton*          rewind;

/**
 *  Play/Pause button for the media player.
 */
@property (weak, nonatomic) IBOutlet UIButton*          playpause;

/**
 *  Button to manage fastfoward for the media player.
 */
@property (weak, nonatomic) IBOutlet UIButton*          fastfoward;


/**
 *  Button to manage share functionality
 */
@property (weak, nonatomic) IBOutlet UIButton*          share;

/**
 *  Menu bar on top of the Artwork for display lyrics, artist, album, discover, share.
 */
@property (weak, nonatomic) IBOutlet UIView*            menubar;


/**
 *  Shuffle button pressed by the user.
 *
 *  @param sender sender of event.
 */
- (IBAction)shufflePressed:(id)sender;

/**
 *  Repeat button pressed by the user.
 *
 *  @param sender sender of event.
 */
- (IBAction)repeatPressed:(id)sender;

/**
 *  Rewind button pressed by the user.
 *
 *  @param sender send of event.
 */
- (IBAction)rewindPressed:(id)sender;

/**
 *  Play/Pause button pressed by the user.
 *
 *  @param sender sender of event.
 */
- (IBAction)playpausePressed:(id)sender;

/**
 *  Foward button pressed by the user.
 *
 *  @param sender sender of event.
 */
- (IBAction)fastFowardPressed:(id)sender;


/**
 *  Share button was pressed by the user.
 *
 *  @param sender sender of event.
 */
- (IBAction)sharePressed:(id)sender;

@end
