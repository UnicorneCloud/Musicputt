//
//  UITableViewCellPlaylist.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-29.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UITableViewCellPlaylist.h"
#import "AppDelegate.h"
#import "Playlist.h"
#import "PlaylistItem.h"
#import <MediaPlayer/MediaPlayer.h>

@interface UITableViewCellPlaylist()
{
    MPMediaPlaylist* itunesPlaylist;
    Playlist* musicputtPlaylist;
    
    int type;
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
        
        if (type == _ITUNES_PLAYLIST_) {
            [self.del mpdatamanager].currentPlaylist = itunesPlaylist;
            [self.del mpdatamanager].currentMusicputtPlaylist = nil;
        }
        else if (type == _MUSICPUTT_PLAYLIST_){
            [self.del mpdatamanager].currentPlaylist = nil;
            [self.del mpdatamanager].currentMusicputtPlaylist = musicputtPlaylist;
        }
        
    }
}

- (void) setMediaItem:(MPMediaPlaylist*) mediaItem
{
    type = _ITUNES_PLAYLIST_;
    itunesPlaylist = mediaItem;
    
    _playlisttitle.text = [itunesPlaylist valueForProperty:MPMediaPlaylistPropertyName];
    _playlistnbtracks.text = [NSString stringWithFormat:@"%lu track(s)", (unsigned long)itunesPlaylist.count];
    
    if(itunesPlaylist.count>0)
    {
        UIImage* image;
        MPMediaItem* song = itunesPlaylist.items[0]; // 0 to keep firts item in playlist
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
    return itunesPlaylist;
}

- (void) setPlaylistItem:(Playlist*) playlist
{
    type = _MUSICPUTT_PLAYLIST_;
    musicputtPlaylist = playlist;
    
    _playlisttitle.text = [musicputtPlaylist name];
    _playlistnbtracks.text = [NSString stringWithFormat:@"%lu track(s)", (unsigned long)[musicputtPlaylist items].count];
    
    if([musicputtPlaylist items].count>0)
    {
        UIImage* image;
        NSArray* songs;
        MPMediaQuery* everything;             // result of current query
        
        // search songs with his id
        everything = [MPMediaQuery songsQuery];
        MPMediaPropertyPredicate *predicate =[MPMediaPropertyPredicate predicateWithValue:[[[[musicputtPlaylist items] allObjects] objectAtIndex:0] songuid]
                                                                              forProperty:MPMediaItemPropertyPersistentID
                                                                           comparisonType:MPMediaPredicateComparisonEqualTo];
        [everything addFilterPredicate:predicate];
        songs = [everything items];
        
        // load image
        MPMediaItem* song = songs[0]; // 0 to keep firts item in playlist
        if (song) {
            MPMediaItemArtwork *artwork = [song valueForProperty:MPMediaItemPropertyArtwork];
            if (artwork)
                image = [artwork imageWithSize:[_imageview frame].size];
            if (image.size.height>0 && image.size.width>0) // check if image present
                [_imageview setImage:image];
            else
                [_imageview setImage:[UIImage imageNamed:@"empty"]];
        }
        else{
            [_imageview setImage:[UIImage imageNamed:@"empty"]];
        }
    }
    else
    {
        [_imageview setImage:[UIImage imageNamed:@"empty"]];
    }
    
}

- (Playlist*) getPlaylistItem
{
    return musicputtPlaylist;
}

- (NSInteger) getType
{
    return type;
}

@end
