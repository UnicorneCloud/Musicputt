//
//  UITableViewCellMediaItem.m
//  MusicPutt
//
//  Created by Qiaomei Wang on 2014-07-25.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UITableViewCellMediaItem.h"
#import "AppDelegate.h"
#import "Playlist.h"
#import "PlaylistItem.h"

@interface UITableViewCellMediaItem()
{
   MPMediaItem* mediaItem;
}

@property AppDelegate* del;

@end

@implementation UITableViewCellMediaItem

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        // setup app delegate
        self.del = [[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    
    // setup app delegate
    self.del = [[UIApplication sharedApplication] delegate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  Set the information of the media item (name, track no. and duration).
 *
 *  @param albumSongItem : The media item to set.
 */
- (void)setAlbumSongItem: (MPMediaItem*)albumSongItem
{
    mediaItem = albumSongItem;
    self.songName.text = [albumSongItem valueForProperty:MPMediaItemPropertyTitle];
    self.trackNo.text  = [[albumSongItem valueForProperty:MPMediaItemPropertyAlbumTrackNumber] stringValue];
    
    NSNumber *durationtime = [albumSongItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
    self.songDuration.text = [NSString stringWithFormat: @"%02d:%02d",
                              [durationtime intValue]/60,
                              [durationtime intValue]%60];
}

- (MPMediaItem*)getMediaItem
{
    return mediaItem;
}

- (IBAction)addButtonClick:(id)sender
{
    // create new playlist item and add to current playlist
    PlaylistItem* item = [PlaylistItem MR_createEntity];
    item.songuid = [[NSNumber alloc] initWithUnsignedLongLong:mediaItem.persistentID];
    item.position = [[NSNumber alloc] initWithUnsignedLong: [[[[self.del mpdatamanager] currentMusicputtPlaylist] items] count] ];
    [[[self.del mpdatamanager] currentMusicputtPlaylist] addItemsObject:item];
}

@end
