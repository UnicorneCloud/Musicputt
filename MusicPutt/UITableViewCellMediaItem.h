//
//  UITableViewCellMediaItem.h
//  MusicPutt
//
//  Created by Qiaomei Wang on 2014-07-25.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface UITableViewCellMediaItem : UITableViewCell

/**
 *  Song's track number.
 */
@property (weak,nonatomic) IBOutlet UILabel* trackNo;

/**
 *  Song's name.
 */
@property (weak,nonatomic) IBOutlet UILabel* songName;

/**
 *  Song's duration.
 */
@property (weak,nonatomic) IBOutlet UILabel* songDuration;

/**
 *  Button add
 */
@property (weak, nonatomic) IBOutlet UIButton* add;

/**
 *  Set the artist album item information for the cell.
 *
 *  @param albumSongItem : the media item of the cell.
 */
- (void)setAlbumSongItem: (MPMediaItem*)albumSongItem;
/**
 *  return the media item.
 *
 *  @return : the media item.
 */
- (MPMediaItem*)getMediaItem;
@end
