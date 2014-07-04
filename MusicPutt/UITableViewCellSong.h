//
//  UITableViewCellSong.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-07-02.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCellSong : UITableViewCell

@property (weak,nonatomic) IBOutlet UIImageView* imageview;
@property (weak,nonatomic) IBOutlet UILabel* title;
@property (weak,nonatomic) IBOutlet UILabel* artist;
@property (weak,nonatomic) IBOutlet UILabel* album;

@end
