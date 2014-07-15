//
//  UITableViewCellArtistAlbum.h
//  MusicPutt
//
//  Created by Qiaomei Wang on 2014-07-09.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface UITableViewCellArtistAlbum : UITableViewCell
@property (weak,nonatomic) IBOutlet UILabel* trackNo;
@property (weak,nonatomic) IBOutlet UILabel* songName;
@property (weak,nonatomic) IBOutlet UILabel* songDuration;

- (void)setArtistAlbumItem: (MPMediaItem*)artistAlbumItem;
@end
