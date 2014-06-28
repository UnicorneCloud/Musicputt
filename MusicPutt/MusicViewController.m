//
//  MusicViewController.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-24.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "MusicViewController.h"
#import "AppDelegate.h"


@interface MusicViewController ()
{
    BOOL hideCurrentSong;
}

@property AppDelegate* del;

@end

@implementation MusicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        hideCurrentSong = TRUE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup app delegate
    self.del = [[UIApplication sharedApplication] delegate];
    
    hideCurrentSong = TRUE;
    [self hideCurrentSong:hideCurrentSong];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) hideCurrentSong:(BOOL)hiddend
{
    [_currentSongView setHidden:hiddend];
}



#pragma mark - Button action

- (IBAction)shufflePressed:(id)sender
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
}

- (IBAction)repeatPressed:(id)sender
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
}


- (IBAction)rewindPressed:(id)sender
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
}


- (IBAction)playpausePressed:(id)sender
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    hideCurrentSong = !hideCurrentSong;
    [self hideCurrentSong:hideCurrentSong];
    
}


- (IBAction)fastFoward:(id)sender
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
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
