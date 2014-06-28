//
//  CurrentPlayingToolBar.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-28.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "CurrentPlayingToolBar.h"

@implementation CurrentPlayingToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        /*UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
         [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
         [titleLabel setBackgroundColor:[UIColor clearColor]];
         [titleLabel setTextColor:[UIColor blackColor]];
         [titleLabel setText:@"Title"];
         [titleLabel setTextAlignment:NSTextAlignmentCenter];
         
         
         
         NSMutableArray *items = [[drawer items] mutableCopy];
         UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
         [items addObject:title];
         [drawer items animated:YES];
         */
        
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [barItems addObject:flexSpace];
        
        /*
        UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
        [barItems addObject:btnCancel];
        
        UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
        [barItems addObject:btnDone];
        */
        
        UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 50,50) ];
        [customView setBackgroundColor:[UIColor blackColor]];
        UIBarButtonItem *progress = [[UIBarButtonItem alloc] initWithCustomView:customView];
        [barItems addObject:progress];

        UIBarButtonItem *flexSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [barItems addObject:flexSpace2];
        
        [self setItems:barItems animated:YES];
    }
    return self;
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
