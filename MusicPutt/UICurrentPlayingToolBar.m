//
//  CurrentPlayingToolBar.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-28.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UICurrentPlayingToolBar.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIViewCurrentToolBar.h"

@interface UICurrentPlayingToolBar()
{
    
    UINavigationController* navController;
}

@property AppDelegate* del;

@end

@implementation UICurrentPlayingToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // setup app delegate
        self.del = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        view = [[[NSBundle mainBundle] loadNibNamed:@"UIViewCurrentPlayingToolBar" owner:nil options:nil] objectAtIndex:0];
        [view setBackgroundColor:UIColor.clearColor];
        [self setContentView:view];
        [self layoutIfNeeded];
    }
    return self;
}

-(void)dealloc {
}

- (void) setNavigationController:(UINavigationController*) controller;
{
    self->navController = controller;
    [view setNavigationController:self->navController];
    [self setParentNavbar:(iNavigationBar*)controller.navigationBar];
}

- (id)init
{
    self = [self initWithFrame:CGRectMake(0, 0, 320, 60)];
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Triggered when touch is released
    [self hideAnimated:false];
    [view viewPressed];
}

/**
 *  Show navigation tabbar
 *
 *  @param bar      navigation bar parent of the toolbar.
 *  @param animated animation during show.
 */
- (void)showFromNavigationBar:(UINavigationBar *)bar animated:(BOOL)animated
{
    [view updateCurrentPlayingItem];
    [super show:animated];
    [view startNotificationCapture];
}

/**
 *  Hide tabbar
 *
 *  @param animated animate during hide.
 */
- (void)hideAnimated:(BOOL)animated
{
    [super hide:animated];
    [view stopNotificationCapture];
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
