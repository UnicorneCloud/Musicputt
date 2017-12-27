//
//  UITableViewCellAlbum.m
//  MusicPutt
//
//  Created by Qiaomei Wang on 2014-07-24.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UITableViewCellAlbum.h"
#import "AppDelegate.h"

@interface UITableViewCellAlbum()
{
    NSNumber *fullLength;
    MPMediaItemCollection *album;
}


@property AppDelegate* del;

@end

@implementation UITableViewCellAlbum
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
    self.del = (AppDelegate*)[[UIApplication sharedApplication]delegate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected==true) {
        // setup app delegate
        //[self.del mpdatamanager].currentArtistCollection = album;
    }
}

/**
 *  Get the full album duration
 *
 *  @param albumsCollection : Collection of media item of the album.
 *
 *  @return                 : The duration of album.
 */
- (NSString*) getAlbumDuration:(MPMediaItemCollection*)albumsCollection
{
    fullLength = 0;
    [[albumsCollection items] enumerateObjectsUsingBlock:^(MPMediaItem *songItem, NSUInteger idx, BOOL *stop) {
        fullLength = @([fullLength floatValue] + [[songItem valueForProperty:MPMediaItemPropertyPlaybackDuration] floatValue]);
    }];
    
    int fullMinutes = trunc([fullLength floatValue]) / 60;
    
    NSString* length = [NSString stringWithFormat:@"%d mins",fullMinutes];
    
    return length;
}

/**
 *  Get the number of tracks in the album.
 *
 *  @param albumsCollection : Collection of media item of the album.
 *
 *  @return                 : The number of tracks in the album.
 */
- (NSString*) getAlbumTracksCount:(MPMediaItemCollection*)albumsCollection
{
    NSUInteger nbTracks = [albumsCollection items].count;
    NSString*  str;
    
    if (nbTracks > 1)
    {
        str = [NSString stringWithFormat: @"%lu tracks, ", (unsigned long)nbTracks];
    }
    else if(nbTracks > 0)
    {
        str = [NSString stringWithFormat: @"%lu track, ", (unsigned long)nbTracks];
    }
    else
    {
        str = @"";
    }
    return str;
}

/**
 *  Set the cell of album in the table view of albums.
 *
 *  @param albumsCollection Collection of media item of the album.
 */
- (void)setAlbumItem:(MPMediaItemCollection*)albumsCollection
{
    MPMediaItem* albumRepresentativeItem = [(MPMediaItemCollection*)albumsCollection representativeItem];
 
    if([albumsCollection count]>0)
    {
        UIImage* image;
        MPMediaItemArtwork *artwork = [albumRepresentativeItem valueForProperty:MPMediaItemPropertyArtwork];
        if (artwork)
            image = [artwork imageWithSize:[[self imageview] frame].size];
        if (image.size.height>0 && image.size.width>0) // check if image present
            [[self imageview] setImage:image];
        else
            [[self imageview] setImage:[UIImage imageNamed:@"empty"]];
    }
    else
    {
        [[self imageview] setImage:[UIImage imageNamed:@"empty"]];
    }
    self.albumName.text  = [albumRepresentativeItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    self.artistName.text = [albumRepresentativeItem valueForProperty:MPMediaItemPropertyArtist];
    self.nbTacksAndDuration.text = [[self getAlbumTracksCount:albumsCollection] stringByAppendingString:[self getAlbumDuration:albumsCollection]];
}
@end
