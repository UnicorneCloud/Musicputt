//
//  DLAVAlertViewSelectGender.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-10-18.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "DLAVAlertViewSelectGender.h"


#import "UITableViewControllerGender.h"

@interface DLAVAlertViewSelectGender ()

@property (strong,nonatomic) UITableViewControllerGender* content;

@end

@implementation DLAVAlertViewSelectGender

#pragma mark - Initialization

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitle, ...
{
    self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil];
    
    _content = [[UITableViewControllerGender alloc] init];
    self.contentView = _content.view;
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
