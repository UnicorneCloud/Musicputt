//
//  UITableViewCellSongStore.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-08-02.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPMusicTrack;

@interface UITableViewCellSongStore : UITableViewCell

/**
 *  Set the information of the media item (name, track no. and duration).
 *
 *  @param mediaitem : The media item to set.
 */
- (void)setMediaItem: (MPMusicTrack*)mediaitem;


/**
 *  Get media item attach with this cell.
 *
 *  @return mediaItem attach with this cell.
 */
-(MPMusicTrack*) getMediaItem;


@end
