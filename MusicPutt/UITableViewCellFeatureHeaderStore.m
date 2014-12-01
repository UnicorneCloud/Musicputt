//
//  UITableViewCellFeatureHeaderStore.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-11-29.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UITableViewCellFeatureHeaderStore.h"

@interface UITableViewCellFeatureHeaderStore()

@end

@implementation UITableViewCellFeatureHeaderStore

- (void)awakeFromNib {
    // Initialization code
    
    // create blur effect
    UIToolbar *blurtoolbar = [[UIToolbar alloc] initWithFrame:self.contentView.frame];
    self.contentView.backgroundColor = [UIColor clearColor];
    blurtoolbar.autoresizingMask = self.contentView.autoresizingMask;
    [self.contentView insertSubview:blurtoolbar atIndex:0];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
