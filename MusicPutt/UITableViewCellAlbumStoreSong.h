//
//  UITableViewCellAlbumStoreSong.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-07-29.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITunesMusicTrack.h"


/**
 *  Cell for the store album module
 */
@interface UITableViewCellAlbumStoreSong : UITableViewCell

/**
 *  Set the information of the media item (name, track no. and duration).
 *
 *  @param mediaitem : The media item to set.
 */
- (void)setMediaItem: (ITunesMusicTrack*)mediaitem;


/**
 *  Get media item attach with this cell.
 *
 *  @return mediaItem attach with this cell.
 */
-(ITunesMusicTrack*) getMediaItem;



@end