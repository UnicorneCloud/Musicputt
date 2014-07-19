//
//  UITableViewCellArtistAlbum.h
//  MusicPutt
//
//  Created by Qiaomei Wang on 2014-07-09.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface UITableViewCellArtistAlbum : UITableViewCell
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
 *  Set the artist album item information for the cell.
 *
 *  @param artistAlbumItem : the media item of the cell.
 */
- (void)setArtistAlbumItem: (MPMediaItem*)artistAlbumItem;
/**
 *  return the media item.
 *
 *  @return : the media item.
 */
- (MPMediaItem*)getMediaItem;
@end
