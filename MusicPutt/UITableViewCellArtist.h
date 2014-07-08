//
//  UITableViewCellArtist.h
//  MusicPutt
//
//  Created by Qiaomei Wang on 2014-07-02.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCellArtist : UITableViewCell

@property (weak,nonatomic) IBOutlet UIImageView* imageview;
@property (weak,nonatomic) IBOutlet UILabel* artistName;
@property (weak,nonatomic) IBOutlet UILabel* nbAlbums;
@property (weak,nonatomic) IBOutlet UILabel* nbTracks;

- (void)setArtistItem:(NSArray*)artistCollection withDictionnary:(NSMutableDictionary*)dictionary;
@end
