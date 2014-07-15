//
//  UIMusicViewLoadingController.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-16.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIMusicViewLoadingController.h"
#import "AppDelegate.h"

@interface UIMusicViewLoadingController ()
{
    
}
@property AppDelegate* del;
@end


@implementation UIMusicViewLoadingController


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"BeginLoad");
    
    // setup app delegate
    self.del = [[UIApplication sharedApplication] delegate];
    
    [self loadApp];
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"endLoad");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) loadApp
{
    [self performSelector:@selector(loadAppCompleted) withObject:nil afterDelay:0.0];
}


-(void) loadAppCompleted
{
    //[self performSegueWithIdentifier:@"loading_completed" sender:self];
    [self performSegueWithIdentifier:@"loading_completed" sender:self];
    
}

@end
