//
//  MusicViewController.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-24.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewArtwork.h"
#import "UIViewCurrentTrackDetails.h"

@interface MusicViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIViewArtwork* artwork;
@property (weak, nonatomic) IBOutlet UIViewCurrentTrackDetails* currentTrack;

@end
