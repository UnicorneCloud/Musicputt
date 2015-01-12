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

- (id)init
{
    self = [self initWithFrame:CGRectMake(0, 0, 320, 60)];
    return self;
}

- (void)setupConstraintsWithNavigationBar:(UINavigationBar *)bar {
	NSLayoutConstraint *constraint;
	constraint = [NSLayoutConstraint constraintWithItem:self
											  attribute:NSLayoutAttributeLeft
											  relatedBy:NSLayoutRelationEqual
												 toItem:bar
											  attribute:NSLayoutAttributeLeft
											 multiplier:1
											   constant:0];
	[self.superview addConstraint:constraint];
	
	constraint = [NSLayoutConstraint constraintWithItem:self
											  attribute:NSLayoutAttributeRight
											  relatedBy:NSLayoutRelationEqual
												 toItem:bar
											  attribute:NSLayoutAttributeRight
											 multiplier:1
											   constant:0];
	[self.superview addConstraint:constraint];
	
	constraint = [NSLayoutConstraint constraintWithItem:self
											  attribute:NSLayoutAttributeHeight
											  relatedBy:NSLayoutRelationEqual
												 toItem:nil
											  attribute:NSLayoutAttributeNotAnAttribute
											 multiplier:1
											   constant:60];
	[self addConstraint:constraint];
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
    [super showFromNavigationBar:bar animated:animated];
    [view startNotificationCapture];
}

/**
 *  Hide tabbar
 *
 *  @param animated animate during hide.
 */
- (void)hideAnimated:(BOOL)animated
{
    [super hideAnimated:animated];
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
