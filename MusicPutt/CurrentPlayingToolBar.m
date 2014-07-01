//
//  CurrentPlayingToolBar.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-28.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "CurrentPlayingToolBar.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIViewCurrentToolBar.h"

@interface CurrentPlayingToolBar()
{
    UIViewCurrentToolBar *view;
    UINavigationController* navController;
}

@property AppDelegate* del;

@end

@implementation CurrentPlayingToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // setup app delegate
        self.del = [[UIApplication sharedApplication] delegate];
        
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [barItems addObject:flexSpace];
        
        UINib *nib = [UINib nibWithNibName:@"UIViewCurrentPlayingToolBar" bundle:nil];
        view = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
        [view setBackgroundColor:[UIColor clearColor]];
        UIBarButtonItem *customViewContainer = [[UIBarButtonItem alloc] initWithCustomView:view];
        
        [barItems addObject:customViewContainer];
        
        UIBarButtonItem *flexSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [barItems addObject:flexSpace2];
        
        [self setItems:barItems animated:YES];
    }
    return self;
}

-(void)dealloc {
}

- (void) setNavigationController:(UINavigationController*) controller;
{
    self->navController = controller;
    [view setNavigationController:navController];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
