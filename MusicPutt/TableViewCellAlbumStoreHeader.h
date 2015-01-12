//
//  TableViewCellAlbumStoreHeader.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-09-13.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ITunesAlbum;

@interface TableViewCellAlbumStoreHeader : UITableViewCell

/**
 *  Set the information of the media item (name, track no. and duration).
 *
 *  @param mediaitem : The media item to set.
 */
- (void)setMediaItem: (ITunesAlbum*)mediaitem;

/**
 *  Get media item attach with this cell.
 *
 *  @return mediaItem attach with this cell.
 */
-(ITunesAlbum*) getMediaItem;

@end
