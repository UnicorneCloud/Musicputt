//
//  UITableViewCellSongStore.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-08-02.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UITableViewCellSongStore.h"

#import "ITunesMusicTrack.h"

@interface UITableViewCellSongStore ()
{
    ITunesMusicTrack* _mediaitem;
}

/**
 *  Song's album name
 */
@property (weak, nonatomic) IBOutlet UILabel* albumName;

/**
 *  Song's name.
 */
@property (weak, nonatomic) IBOutlet UILabel* songName;

/**
 *  Song's duration.
 */
@property (weak, nonatomic) IBOutlet UILabel* songDuration;

/**
 *  Artwork of the songs.
 */
@property (weak, nonatomic) IBOutlet UIImageView* artWork;


@end

@implementation UITableViewCellSongStore

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
- (void)setMediaItem:(ITunesMusicTrack *)mediaitem
{
    _songName.text = [mediaitem trackName];
    _albumName.text  = [mediaitem collectionName];
    
    NSNumber *durationtime = [NSNumber numberWithInteger:[[mediaitem trackTimeMillis] integerValue]/1000];
    _songDuration.text = [NSString stringWithFormat: @"%02d:%02d",
                          [durationtime intValue]/60,
                          [durationtime intValue]%60];
    
    id path = [mediaitem artworkUrl60];
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    
    _artWork.image = img;
    
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
