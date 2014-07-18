//
//  UIViewControllerLyricsPage.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-07-17.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerLyricsPage.h"

@interface UIViewControllerLyricsPage ()

@end

@implementation UIViewControllerLyricsPage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Create blur effect
    UIToolbar *blurtoolbar = [[UIToolbar alloc] initWithFrame:self.view.frame];
    self.view.backgroundColor = [UIColor clearColor];
    blurtoolbar.autoresizingMask = self.view.autoresizingMask;
    [self.view insertSubview:blurtoolbar atIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
