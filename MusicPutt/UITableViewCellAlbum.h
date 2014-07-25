//
//  UITableViewCellAlbum.h
//  MusicPutt
//
//  Created by Qiaomei Wang on 2014-07-24.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface UITableViewCellAlbum : UITableViewCell
/**
 *  Album's picture.
 */
@property (weak,nonatomic) IBOutlet UIImageView* imageview;
/**
 *  Album's name.
 */
@property (weak,nonatomic) IBOutlet UILabel* albumName;
/**
 *  Album's artist.
 */
@property (weak,nonatomic) IBOutlet UILabel* artistName;
/**
 *  The number of songs in the album and its duration.
 */
@property (weak,nonatomic) IBOutlet UILabel* nbTacksAndDuration;

/**
 *  Set the cell of album in the table view of albums.
 *
 *  @param artistAlbumItem Collection of media item of the album.
 */
- (void)setAlbumItem: (MPMediaItem*)artistAlbumItem;
@end
