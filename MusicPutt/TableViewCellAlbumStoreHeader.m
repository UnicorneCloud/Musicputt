//
//  TableViewCellAlbumStoreHeader.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-09-13.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "TableViewCellAlbumStoreHeader.h"

#import "ITunesAlbum.h"

@interface TableViewCellAlbumStoreHeader()
{
    ITunesAlbum* _mediaitem;
}

@property (weak, nonatomic) IBOutlet UIImageView* imageview;

@property (weak, nonatomic) IBOutlet UILabel* artistname;

@property (weak, nonatomic) IBOutlet UILabel* albumname;

@property (weak, nonatomic) IBOutlet UILabel* albumlink;

@property (weak, nonatomic) IBOutlet UILabel* trackandduration;

@property (weak, nonatomic) IBOutlet UILabel* year;

@property (weak, nonatomic) IBOutlet UILabel* price;

@property (weak, nonatomic) IBOutlet UILabel* genre;

@end

@implementation TableViewCellAlbumStoreHeader

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
- (void)setMediaItem:(ITunesAlbum *)mediaitem
{
    /*
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
     */
}

/**
 *  Get media item attach with this cell.
 *
 *  @return mediaItem attach with this cell.
 */
-(ITunesAlbum*) getMediaItem
{
    return _mediaitem;
}

@end
