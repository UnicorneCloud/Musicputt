//
//  TableViewCellAlbumStoreCell.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-09-13.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "TableViewCellAlbumStoreCell.h"

#import "ITunesMusicTrack.h"

@interface TableViewCellAlbumStoreCell ()
{
    ITunesMusicTrack* _mediaitem;
}

/**
 *  Song's album name
 */
@property (weak, nonatomic) IBOutlet UILabel* songNumber;

/**
 *  Song's name.
 */
@property (weak, nonatomic) IBOutlet UILabel* songName;

/**
 *  Song's duration.
 */
@property (weak, nonatomic) IBOutlet UILabel* songDuration;


@end

@implementation TableViewCellAlbumStoreCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
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
    _songNumber.text = [mediaitem trackNumber];
    
    _songName.text = [mediaitem trackName];
    
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

@end
