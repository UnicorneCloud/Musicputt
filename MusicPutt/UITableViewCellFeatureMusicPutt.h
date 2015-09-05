//
//  UITableViewCellFeatureMusicPutt.h
//  MusicPutt
//
//  Created by Eric Pinet on 2015-09-04.
//  Copyright (c) 2015 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>


@class UIViewEqualizer;



@interface UITableViewCellFeatureMusicPutt : UITableViewCell

@property (weak, nonatomic) UINavigationController* parentNavCtrl;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView* downloadProgress;

@property (weak, nonatomic) IBOutlet UIImageView* image;

@property (weak, nonatomic) IBOutlet UILabel* title;

@property (weak, nonatomic) IBOutlet UILabel* artist;

@property (weak, nonatomic) IBOutlet UIViewEqualizer* equalizer;

@property NSString* trackId;

@property NSString* collectionId;

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
