//
//  MusicViewController.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-24.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageViewArtwork.h"

@interface MusicViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageViewArtwork* imageviewartwork;

@property (weak, nonatomic) IBOutlet UIImageView*       imageview;

@property (weak, nonatomic) IBOutlet UIView*            currentsongview;
@property (weak, nonatomic) IBOutlet UILabel*           songtitle;
@property (weak, nonatomic) IBOutlet UILabel*           artistalbum;

@property (weak, nonatomic) IBOutlet UIView*            controlview;
@property (weak, nonatomic) IBOutlet UILabel*           curtime;
@property (weak, nonatomic) IBOutlet UILabel*           endtime;
@property (weak, nonatomic) IBOutlet UIProgressView*    progresstime;
@property (weak, nonatomic) IBOutlet UIButton*          shuffle;
@property (weak, nonatomic) IBOutlet UIButton*          repeat;

@property (weak, nonatomic) IBOutlet UIButton*          rewind;
@property (weak, nonatomic) IBOutlet UIButton*          playpause;
@property (weak, nonatomic) IBOutlet UIButton*          fastfoward;

- (IBAction)shufflePressed:(id)sender;
- (IBAction)repeatPressed:(id)sender;
- (IBAction)rewindPressed:(id)sender;
- (IBAction)playpausePressed:(id)sender;
- (IBAction)fastFoward:(id)sender;

@end
