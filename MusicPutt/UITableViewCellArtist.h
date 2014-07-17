//
//  UITableViewCellArtist.h
//  MusicPutt
//
//  Created by Qiaomei Wang on 2014-07-02.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface UITableViewCellArtist : UITableViewCell

/**
 *  Artist's picture.
 */
@property (weak,nonatomic) IBOutlet UIImageView* imageview;
/**
 *  Artist's name.
 */
@property (weak,nonatomic) IBOutlet UILabel* artistName;
/**
 *  The number of albums of the artist.
 */
@property (weak,nonatomic) IBOutlet UILabel* nbAlbums;
/**
 *  The number of tracks of this artist in the library.
 */
@property (weak,nonatomic) IBOutlet UILabel* nbTracks;

/**
 *  This function fills the table cell of artist with the displayed information.
 *
 *  @param artistCollection : Artist collection.
 *  @param dictionary       : Dictionnary which contains artist's name - > number of albums.
 */
- (void)setArtistItem:(MPMediaItemCollection*)artistCollection withDictionnary:(NSMutableDictionary*)dictionary;
@end
