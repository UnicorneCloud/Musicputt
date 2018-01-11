//
//  UITableViewCellPlaylistSong.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-30.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UITableViewCellPlaylistSong.h"
#import "AppDelegate.h"
#import "PlaylistItem.h"
#import <MediaPlayer/MediaPlayer.h>

@interface UITableViewCellPlaylistSong ()
{
    MPMediaItem* _item;
    PlaylistItem* _playlistItem;
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
    self.del = (AppDelegate*)[[UIApplication sharedApplication]delegate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setMediaItem:(MPMediaItem*) mediaItem
{
    if (mediaItem) {
        _item = mediaItem;
        _title.text = [_item valueForProperty:MPMediaItemPropertyTitle];
        _artist.text = [_item valueForProperty:MPMediaItemPropertyArtist];
        _album.text = [_item valueForProperty:MPMediaItemPropertyAlbumTitle];
        
        UIImage* image;
        MPMediaItemArtwork *artwork = [_item valueForProperty:MPMediaItemPropertyArtwork];
        if (artwork)
            image = [artwork imageWithSize:[_imageview frame].size];
        if (image.size.height>0 && image.size.width>0) // check if image present
            [_imageview setImage:image];
        else
            [_imageview setImage:[UIImage imageNamed:@"empty"]];
    }
}


- (MPMediaItem*) getMediaItem
{
    return _item;
}

- (void) setPlaylistItem:(PlaylistItem*) playlistItem
{
    if (playlistItem) {
        
        _playlistItem = playlistItem;
        
        MPMediaItem *song;
        MPMediaPropertyPredicate *predicate;
        MPMediaQuery *songQuery;
        
        predicate = [MPMediaPropertyPredicate predicateWithValue: _playlistItem.songuid forProperty:MPMediaItemPropertyPersistentID];
        songQuery = [[MPMediaQuery alloc] init];
        [songQuery addFilterPredicate: predicate];
        if (songQuery.items.count > 0)
        {
            //song exists
            song = [songQuery.items objectAtIndex:0];
            [self setMediaItem:song];
        }
    }
}

- (PlaylistItem*) getPlaylistItem
{
    return _playlistItem;
}

@end
