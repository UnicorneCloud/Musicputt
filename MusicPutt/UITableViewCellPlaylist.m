//
//  UITableViewCellPlaylist.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-29.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UITableViewCellPlaylist.h"

@implementation UITableViewCellPlaylist

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
