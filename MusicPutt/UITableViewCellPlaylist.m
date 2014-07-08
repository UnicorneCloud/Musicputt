//
//  UITableViewCellPlaylist.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-29.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UITableViewCellPlaylist.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>

@interface UITableViewCellPlaylist()
{
    MPMediaPlaylist* playlist;
}

@property AppDelegate* del;

@end

@implementation UITableViewCellPlaylist

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
    if (selected==true) {
        [self.del mpdatamanager].currentPlaylist = playlist;
    }
}



- (void) setMediaItem:(MPMediaPlaylist*) mediaItem
{
    playlist = mediaItem;
    
    _playlisttitle.text = [playlist valueForProperty:MPMediaPlaylistPropertyName];
    _playlistnbtracks.text = [NSString stringWithFormat:@"%lu track(s)", (unsigned long)playlist.count];
    
    if(playlist.count>0)
    {
        UIImage* image;
        MPMediaItem* song = playlist.items[0]; // 0 to keep firts item in playlist
        MPMediaItemArtwork *artwork = [song valueForProperty:MPMediaItemPropertyArtwork];
        if (artwork)
            image = [artwork imageWithSize:[_imageview frame].size];
        if (image.size.height>0 && image.size.width>0) // check if image present
            [_imageview setImage:image];
        else
            [_imageview setImage:[UIImage imageNamed:@"empty"]];
    }
    else
    {
        [_imageview setImage:[UIImage imageNamed:@"empty"]];
    }
}

- (MPMediaPlaylist*) getMediaItem
{
    return playlist;
}

@end
