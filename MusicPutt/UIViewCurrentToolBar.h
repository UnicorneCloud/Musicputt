//
//  UIViewCurrentToolBar.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-28.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAProgressView.h"

@interface UIViewCurrentToolBar : UIView

@property (weak,nonatomic) IBOutlet UIImageView* imageview;
@property (weak,nonatomic) IBOutlet UILabel* songTitle;
@property (weak,nonatomic) IBOutlet UILabel* artist;
@property (weak,nonatomic) IBOutlet UILabel* album;
@property (weak,nonatomic) IBOutlet UAProgressView* progress;
@property (strong,nonatomic) UINavigationController* navigationController;


- (void)imageViewPressed;
- (void)songtitlePressed;
- (void)artistPressed;
- (void)albumPressed;
- (void)progressPressed;

@end
