//
//  UITableViewCellPlaylistSong.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-30.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCellPlaylistSong : UITableViewCell

@property (weak,nonatomic) IBOutlet UIImageView* imageview;
@property (weak,nonatomic) IBOutlet UILabel* title;
@property (weak,nonatomic) IBOutlet UILabel* artist;
@property (weak,nonatomic) IBOutlet UILabel* album;

@end
