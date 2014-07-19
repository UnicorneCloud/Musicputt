//
//  UITableViewCellAlbumPageSong.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-07-19.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPMediaItem;

@interface UITableViewCellAlbumPageSong : UITableViewCell


/**
 *  Set the information of the media item (name, track no. and duration).
 *
 *  @param artistAlbumItem : The media item to set.
 */
- (void)setMediaItem: (MPMediaItem*)mediaitem;


/**
 *  Get media item attach with this cell.
 *
 *  @return mediaItem attach with this cell.
 */
-(MPMediaItem*) getMediaItem;

@end
