//
//  UITableViewCellArtistStoreSong.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-07-29.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMusicTrack.h"

@interface UITableViewCellArtistStoreSong : UITableViewCell

/**
 *  Set the information of the media item (name, track no. and duration).
 *
 *  @param artistAlbumItem : The media item to set.
 */
- (void)setMediaItem: (MPMusicTrack*)mediaitem;


/**
 *  Get media item attach with this cell.
 *
 *  @return mediaItem attach with this cell.
 */
-(MPMusicTrack*) getMediaItem;



@end
