//
//  UITableViewCellAlbumStoreSong.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-07-29.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UITableViewCellAlbumStoreSong.h"
#import "UIViewEqualizer.h"

@interface UITableViewCellAlbumStoreSong ()
{
    ITunesMusicTrack* _mediaitem;
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

@implementation UITableViewCellAlbumStoreSong

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // init download progress
        [_downloadProgress setHidden:true];
        
        // init playing progress
        [_equalizer setHidden:true];

    }
    return self;
}

- (void)awakeFromNib
{
    // init download progress
    [_downloadProgress setHidden:true];
    
    // init playing progress
    [_equalizer setHidden:true];
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
- (void)setMediaItem:(ITunesMusicTrack *)mediaitem
{
    _songName.text = [mediaitem trackName];
    _trackNo.text  = [mediaitem trackNumber];
    
    NSNumber *durationtime = [NSNumber numberWithInteger:[[mediaitem trackTimeMillis] integerValue]/1000];
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
-(ITunesMusicTrack*) getMediaItem
{
    return _mediaitem;
}

/**
 *  Start downloading progress
 */
-(void) startDownloadProgress
{
    [_songDuration setHidden:true];
    [_equalizer setHidden:true];
    
    [_downloadProgress setHidden:false];
    [_downloadProgress startAnimating];
}

/**
 *  Stop downloading progress
 */
-(void) stopDownloadProgress
{
    
    [_downloadProgress startAnimating];
    [_downloadProgress setHidden:true];
    
    [_songDuration setHidden:false];
}

/**
 *  Start playing progress
 */
-(void) startPlayingProgress
{
    [_downloadProgress setHidden:true];
    [_songDuration setHidden:true];
    
    [_equalizer setHidden:false];
    [_equalizer startAnimation];
}

/**
 *  Stop playing progress
 */
-(void) stopPlayingProgress
{
    [_equalizer stopAnimation];
    [_equalizer setHidden:true];
    
    [_songDuration setHidden:false];
}

@end
