//
//  UITableViewCellPlaylist.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-29.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCellPlaylist : UITableViewCell

@property (weak,nonatomic) IBOutlet UIImageView* imageview;
@property (weak,nonatomic) IBOutlet UILabel* playlisttitle;
@property (weak,nonatomic) IBOutlet UILabel* playlistartist;

@end
