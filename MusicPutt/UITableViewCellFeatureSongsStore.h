//
//  UITableViewCellFeatureSongsStore.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-11-29.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewEqualizer.h"

@interface UITableViewCellFeatureSongsStore : UITableViewCell

@property (weak, nonatomic) UINavigationController* parentNavCtrl;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView* downloadProgress;

@property (weak, nonatomic) IBOutlet UIImageView* image;

@property (weak, nonatomic) IBOutlet UILabel* title;

@property (weak, nonatomic) IBOutlet UILabel* album;

@property (weak, nonatomic) IBOutlet UILabel* artist;

@property (weak, nonatomic) IBOutlet UIViewEqualizer* equalizer;

@property NSString* trackId;

/**
 *  Start downloading progress
 */
-(void) startDownloadProgress;

/**
 *  Stop downloading progress
 */
-(void) stopDownloadProgress;


/**
 *  Start playing progress
 */
-(void) startPlayingProgress;

/**
 *  Stop playing progress
 */
-(void) stopPlayingProgress;



@end
