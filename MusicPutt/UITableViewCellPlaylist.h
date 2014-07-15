//
//  UITableViewCellPlaylist.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-29.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPMediaPlaylist;


/**
 *  Cell for a playlist item.
 */
@interface UITableViewCellPlaylist : UITableViewCell


/**
 *  Album Artwork of the playlist.
 */
@property (weak,nonatomic) IBOutlet UIImageView* imageview;

/**
 *  Title of the playlist.
 */
@property (weak,nonatomic) IBOutlet UILabel* playlisttitle;

/**
 *  Nb songs presents in the playlist.
 */
@property (weak,nonatomic) IBOutlet UILabel* playlistnbtracks;


/**
 *  Set the media item playlist attach with this cell.
 *
 *  @param mediaItem the playlist attach with this cell.
 */
- (void) setMediaItem:(MPMediaPlaylist*) mediaItem;

/**
 *  Get the media item playlist attach with this cell.
 *
 *  @return the media item.
 */
- (MPMediaPlaylist*) getMediaItem;


@end
