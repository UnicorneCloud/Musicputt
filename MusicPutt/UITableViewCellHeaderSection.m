//
//  UITableViewCellHeaderSection.m
//  MusicPutt
//
//  Created by Qiaomei Wang on 2014-07-15.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UITableViewCellHeaderSection.h"

@implementation UITableViewCellHeaderSection

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
