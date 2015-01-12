//
//  UITableViewCellAlbumPageSong.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-07-19.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UITableViewCellAlbumPageSong.h"
#import <MediaPlayer/MediaPlayer.h>

@interface UITableViewCellAlbumPageSong ()
{
    MPMediaItem* _mediaitem;
}

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

@end

@implementation UITableViewCellAlbumPageSong

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
 *  @param artistAlbumItem : The media item to set.
 */
- (void)setMediaItem:(MPMediaItem *)mediaitem
{
    _songName.text = [mediaitem valueForProperty:MPMediaItemPropertyTitle];
    _trackNo.text  = [[mediaitem valueForProperty:MPMediaItemPropertyAlbumTrackNumber] stringValue];
    
    NSNumber *durationtime = [mediaitem valueForProperty:MPMediaItemPropertyPlaybackDuration];
    _songDuration.text = [NSString stringWithFormat: @"%02d:%02d",
                              [durationtime intValue]/60,
                              [durationtime intValue]%60];
    
    _mediaitem = mediaitem;
}

/**
 *  Get media item attach with this cell.
 *
 *  @return mediaItem attach with this cell.
 */
-(MPMediaItem*) getMediaItem
{
    return _mediaitem;
}

@end
