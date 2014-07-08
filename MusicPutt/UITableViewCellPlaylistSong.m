//
//  UITableViewCellPlaylistSong.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-30.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UITableViewCellPlaylistSong.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>

@interface UITableViewCellPlaylistSong ()
{
    MPMediaItem* item;
}
@property (weak,nonatomic) AppDelegate* del;

@end

@implementation UITableViewCellPlaylistSong

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
    
    // setup app delegate
    self.del = [[UIApplication sharedApplication] delegate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setMediaItem:(MPMediaItem*) mediaItem
{
    item = mediaItem;
    _title.text = [item valueForProperty:MPMediaItemPropertyTitle];
    _artist.text = [item valueForProperty:MPMediaItemPropertyArtist];
    _album.text = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
    
    UIImage* image;
    MPMediaItemArtwork *artwork = [item valueForProperty:MPMediaItemPropertyArtwork];
    if (artwork)
        image = [artwork imageWithSize:[_imageview frame].size];
    if (image.size.height>0 && image.size.width>0) // check if image present
        [_imageview setImage:image];
    else
        [_imageview setImage:[UIImage imageNamed:@"empty"]];
}


- (MPMediaItem*) getMediaItem
{
    return item;
}

@end
