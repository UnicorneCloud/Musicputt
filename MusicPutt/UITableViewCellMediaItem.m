//
//  UITableViewCellMediaItem.m
//  MusicPutt
//
//  Created by Qiaomei Wang on 2014-07-25.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UITableViewCellMediaItem.h"

@interface UITableViewCellMediaItem()
{
   MPMediaItem* mediaItem;
}
@end

@implementation UITableViewCellMediaItem

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
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

@end
