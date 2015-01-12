//
//  MMViewController.m
//  MediaManager
//
//  Created by Eric Pinet on 2014-06-19.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "MMViewController.h"
#import "MediaDataSourceManager.h"

@interface MMViewController ()

@end

@implementation MMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Init media manager
    self.mediaManager = [[MediaDataSourceManager alloc] init];
    [self.mediaManager setDataSource:self];
    [self.mediaManager loadMediaByGroup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


////////////////////////////////////////////
#pragma mark - MediaDataSource
- (void) mediaWillLoad
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Delegate works!!!");
}

@end
