//
//  MusicViewController.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-24.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "MusicViewController.h"
#import "AppDelegate.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPMusicPlayerController.h>
#import <MediaPlayer/MPMediaItem.h>

@interface MusicViewController ()
{
}

@property AppDelegate* del;
@property MPDataManager *datamanager;

@end

@implementation MusicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    // setup app delegate
    self.del = [[UIApplication sharedApplication] delegate];
    
    // update current playing song display
    [self displayMediaItem:[[[self.del mpdatamanager] musicplayer] nowPlayingItem]];
    [self updateCurrentTime];
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Completed");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    [[self.del mpdatamanager] setMusicViewControllerVisible:true];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter
     addObserver: self
     selector:    @selector (handle_NowPlayingItemChanged:)
     name:        MPMusicPlayerControllerNowPlayingItemDidChangeNotification
     object:      [[self.del mpdatamanager] musicplayer]];
    
    [notificationCenter
     addObserver: self
     selector:    @selector (handle_PlaybackStateChanged:)
     name:        MPMusicPlayerControllerPlaybackStateDidChangeNotification
     object:      [[self.del mpdatamanager] musicplayer]];
    
    [[[self.del mpdatamanager] musicplayer] beginGeneratingPlaybackNotifications];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(updateCurrentTime)
                                   userInfo: nil
                                    repeats:YES];
    
    // update current playing song display
    [self displayMediaItem:[[[self.del mpdatamanager] musicplayer] nowPlayingItem]];
    [self updateCurrentTime];
}

- (void) viewWillDisappear:(BOOL)animated
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    // desabled notification if view is not visible.
    [[NSNotificationCenter defaultCenter]
     removeObserver: self
     name:           MPMusicPlayerControllerNowPlayingItemDidChangeNotification
     object:         [[_del mpdatamanager] musicplayer]];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver: self
     name:           MPMusicPlayerControllerPlaybackStateDidChangeNotification
     object:         [[_del mpdatamanager] musicplayer]];
    
    [[[_del mpdatamanager] musicplayer] endGeneratingPlaybackNotifications];
    
    [[self.del mpdatamanager] setMusicViewControllerVisible:false];
}


-(void) displayMediaItem: (MPMediaItem*) aitem
{
    if (aitem!=NULL) {
        
        // setup title
        [self setTitle:[aitem valueForProperty:MPMediaItemPropertyTitle]];
        
        UIImage* image;
        MPMediaItemArtwork *artwork = [aitem valueForProperty:MPMediaItemPropertyArtwork];
        
        if (artwork) {
            image = [artwork imageWithSize:[_imageview frame].size];
            if(image.size.height==0 || image.size.width==0)
                image = [UIImage imageNamed:@"empty"];
            
        }
        
        [_imageview setImage:image];
        [_songtitle setText:[aitem valueForProperty:MPMediaItemPropertyTitle]];
        
        NSString *artistalbum = [NSString stringWithFormat:@"%@ - %@", [aitem valueForProperty:MPMediaItemPropertyArtist]
                                                                     , [aitem valueForProperty:MPMediaItemPropertyAlbumTitle]];
        [_artistalbum setText:artistalbum];
        
        //[self updateCurrentTime];
    }
    else{
        [_imageview setImage:nil];
        [_songtitle setText:@""];
        [_artistalbum setText:@""];
    }
    
}

-(void) updateCurrentTime
{
    // update current time with progress round
    NSTimeInterval currentTime = [[[self.del mpdatamanager] musicplayer] currentPlaybackTime];
    NSTimeInterval playbackDuration;
    double progressValue = 0;
    
    if ([[[self.del mpdatamanager] musicplayer] nowPlayingItem]!=NULL) {
        NSNumber* duration = [[[[self.del mpdatamanager] musicplayer] nowPlayingItem] valueForKey:MPMediaItemPropertyPlaybackDuration];
        playbackDuration = [duration doubleValue];
        
        if (playbackDuration>0 && currentTime>0) {
            
            // calcul progressvalue
            progressValue = currentTime / playbackDuration;
            
            // set current time
            long minutes = currentTime / 60;
            long seconds = (int)currentTime % 60;
            
            NSString *strCurrentTime = [NSString stringWithFormat:@"%ld:%02ld", minutes, seconds];
            [_curtime setText:strCurrentTime];
            
            // set endtime
            double timerest = [duration integerValue] - currentTime;
            minutes = timerest / 60;
            seconds = (int)timerest % 60;
            
            NSString *enddingTime = [NSString stringWithFormat:@"-%ld:%02ld", minutes, seconds];
            [_endtime setText:enddingTime];
        }
    }
    [_progresstime setProgress:progressValue animated:false];
    
    // update icon play/pause
    //MPMusicPlayerController* player = [[self.del mpdatamanager] musicplayer];
    //if([player playbackState] == MPMoviePlaybackStatePlaying)
    if([[AVAudioSession sharedInstance] isOtherAudioPlaying])
        [_playpause setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    else
        [_playpause setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
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
    MPMusicPlayerController* player = [[self.del mpdatamanager] musicplayer];
    NSTimeInterval currentTime = [[[self.del mpdatamanager] musicplayer] currentPlaybackTime];
    if (currentTime<=2.0) {
        [player skipToPreviousItem];
    }
    else{
        [player skipToBeginning];
    }
    
}


- (IBAction)playpausePressed:(id)sender
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    MPMusicPlayerController* player = [[self.del mpdatamanager] musicplayer];
    //if([player playbackState] == MPMoviePlaybackStatePlaying)
    if([[AVAudioSession sharedInstance] isOtherAudioPlaying])
    {
        [player pause];
        [_playpause setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
    else
    {
        [player play];
        [_playpause setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
}


- (IBAction)fastFoward:(id)sender
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    MPMusicPlayerController* player = [[self.del mpdatamanager] musicplayer];
    [player skipToNextItem];
}



#pragma  mark - MPMusicPlayerNSNotificationCenter

-(void) handle_PlaybackStateChanged:(id) notification
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    [self displayMediaItem:[[[self.del mpdatamanager] musicplayer] nowPlayingItem]];
    
}

-(void) handle_NowPlayingItemChanged:(id) notification
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    [self displayMediaItem:[[[self.del mpdatamanager] musicplayer] nowPlayingItem]];
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
