//
//  UITableViewCellPlaylistSong.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-30.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPMediaItem;
@class PlaylistItem;

/**
 *  Cell for display song of a playlist
 */
@interface UITableViewCellPlaylistSong : UITableViewCell


/**
 *  Artwork of the playlist.
 */
@property (weak,nonatomic) IBOutlet UIImageView* imageview;

/**
 *  Title of the playlist song attac with this cell.
 */
@property (weak,nonatomic) IBOutlet UILabel* title;

/**
 *  Artist name of the song attach with this cell.
 */
@property (weak,nonatomic) IBOutlet UILabel* artist;

/**
 *  Album title of the song attach with this cell.
 */
@property (weak,nonatomic) IBOutlet UILabel* album;

/**
 *  Media item song attach with this cell.
 *
 *  @param mediaItem media item to attach with this cell.
 */
- (void) setMediaItem:(MPMediaItem*) mediaItem;

/**
 *  Get media item song of this current cell.
 *
 *  @return Media item attach with this cell.
 */
- (MPMediaItem*) getMediaItem;

/**
 *  Playlist item attach with this cell.
 *
 *  @param playlistItem playlist item to attach with this cell.
 */
- (void) setPlaylistItem:(PlaylistItem*) playlistItem;

/**
 *  Get playlist item song of this current cell.
 *
 *  @return playlist item attach with this cell.
 */
- (PlaylistItem*) getPlaylistItem;

@end
