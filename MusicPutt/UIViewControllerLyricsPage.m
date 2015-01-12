//
//  UIViewControllerLyricsPage.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-07-17.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerLyricsPage.h"

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface UIViewControllerLyricsPage ()
{
    MPMediaItem* currentplayingitem;
}

@property AppDelegate* del;

@property IBOutlet UILabel* lyrics;

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
    
    // setup app delegate
    self.del = [[UIApplication sharedApplication] delegate];
    
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

- (void) viewWillAppear:(BOOL)animated
{
    // set current playing media
    currentplayingitem = [[[self.del mpdatamanager] musicplayer] nowPlayingItem];
    
    /*
    NSString *title = [currentplayingitem valueForProperty:MPMediaItemPropertyTitle];
    NSString *lyrics = [currentplayingitem valueForProperty:MPMediaItemPropertyLyrics];
    */
    NSURL* songURL = [currentplayingitem valueForProperty:MPMediaItemPropertyAssetURL];
    AVAsset* songAsset = [AVURLAsset URLAssetWithURL:songURL options:nil];
    NSString* lyrics = [songAsset lyrics];
    
    if (lyrics!=nil) {
        _lyrics.text = lyrics;
    }
    else{
        _lyrics.text = @"No lyrics";
    }
    
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
