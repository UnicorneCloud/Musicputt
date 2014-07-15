//
//  UITableViewCellArtist.m
//  MusicPutt
//
//  Created by Qiaomei Wang on 2014-07-02.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UITableViewCellArtist.h"
#import "AppDelegate.h"

@interface UITableViewCellArtist()
{
    MPMediaItemCollection* artist;
}

@property AppDelegate* del;

@end


@implementation UITableViewCellArtist

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

/**
 * Set the current artist value.
 *
 * @param
 * @param
 * @return
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected==true) {
        // setup app delegate
        self.del = [[UIApplication sharedApplication] delegate];
        [self.del mpdatamanager].currentArtistCollection = artist;
    }
}

/**
 * This function fill the table cell with the displayed information.
 *
 * @param
 * @param
 * @return
 */
- (void)setArtistItem:(MPMediaItemCollection*)artistCollection withDictionnary:(NSMutableDictionary*)dictionary
{
    MPMediaItem* artistRepresentativeItem = [(MPMediaItemCollection*)artistCollection representativeItem];
    artist = artistCollection;
    
    if([artistCollection count]>0)
    {
        UIImage* image;
        MPMediaItemArtwork *artwork = [artistRepresentativeItem valueForProperty:MPMediaItemPropertyArtwork];
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
    self.artistName.text = [artistRepresentativeItem valueForProperty:MPMediaItemPropertyArtist];
    
    NSUInteger nbAlbums = [[dictionary objectForKey:(self.artistName.text)] intValue];
    if(nbAlbums>1)
    {
        self.nbAlbums.text = [NSString stringWithFormat:@"%lu albums", (unsigned long)nbAlbums];
    }
    else
    {
        self.nbAlbums.text = [NSString stringWithFormat:@"%lu album", (unsigned long)nbAlbums];
    }
    
    NSUInteger nbTracks = [artistCollection count];
    if(nbTracks>1)
    {
        self.nbTracks.text = [NSString stringWithFormat:@"%lu tracks", (unsigned long)nbTracks];
    }
    else
    {
        self.nbTracks.text = [NSString stringWithFormat:@"%d track", nbTracks];
    }
    
    NSLog(@"Album number : %@\n", [dictionary objectForKey:(self.artistName.text)]);
}
@end
