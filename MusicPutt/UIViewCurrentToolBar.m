//
//  UIViewCurrentToolBar.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-28.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewCurrentToolBar.h"
#import "AppDelegate.h"
#import "UIColor+CreateMethods.h"
#import "MusicViewController.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>


@interface UIViewCurrentToolBar()
{
    UIImageView *playView;
    UIImageView *pauseView;
}

@property AppDelegate* del;

@end

@implementation UIViewCurrentToolBar

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    // setup app delegate
    self.del = [[UIApplication sharedApplication] delegate];
    
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
    
    
    [_progress setBackgroundColor:[UIColor clearColor]];
    _progress.borderWidth = 1.0;
    _progress.lineWidth = 3.0;
    _progress.fillOnTouch = YES;
    _progress.tintColor = [UIColor colorWithHex:@"#8E8E93" alpha:1.0];
    
    playView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play-toolbar"]];
    pauseView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pause-toolbar"]];
    
    CGPoint point;
    point.x = 0;
    point.y = 0;
    CGSize size;
    size.height = 15;
    size.width = 15;
    CGRect rect;
    rect.origin = point;
    rect.size = size;
    playView.frame = rect;
    playView.opaque = FALSE;
    playView.alpha = .30;
    pauseView.frame = rect;
    pauseView.opaque = FALSE;
    pauseView.alpha = .30;
    _progress.centralView =  playView;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(updateCurrentTime)
                                   userInfo: nil
                                    repeats:YES];
    
    
    
    // Detect tapgesture
    _imageview.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureImageview = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewPressed)];
    [_imageview addGestureRecognizer:tapGestureImageview];
    
    _songTitle.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureSongtitle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(songtitlePressed)];
    [_songTitle addGestureRecognizer:tapGestureSongtitle];
    
    _artist.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureArtist = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(artistPressed)];
    [_artist addGestureRecognizer:tapGestureArtist];
    
    _album.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureAlbum = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(albumPressed)];
    [_album addGestureRecognizer:tapGestureAlbum];
    
    _progress.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureProgress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(progressPressed)];
    [_progress addGestureRecognizer:tapGestureProgress];
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Completed");
    
    //NSDictionary *mediaInfo = [[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo];
    //NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, [mediaInfo valueForKey:MPNowPlayingInfoPropertyElapsedPlaybackTime]);
    //NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, [mediaInfo valueForKey:MPMediaItemPropertyPlaybackDuration]);
    
}


-(void) displayMediaItem: (MPMediaItem*) aitem
{
    if (aitem!=NULL) {
        
        UIImage* image;
        MPMediaItemArtwork *artwork = [aitem valueForProperty:MPMediaItemPropertyArtwork];
        
        if (artwork) {
            image = [artwork imageWithSize:[_imageview frame].size];
            if(image.size.height==0 || image.size.width==0)
                image = [UIImage imageNamed:@"empty"];
                
        }
        
        [_imageview setImage:image];
        [_songTitle setText:[aitem valueForProperty:MPMediaItemPropertyTitle]];
        [_artist setText:[aitem valueForProperty:MPMediaItemPropertyArtist]];
        [_album setText:[aitem valueForProperty:MPMediaItemPropertyAlbumTitle]];
        
        [self updateCurrentTime];
    }
    else{
        [_imageview setImage:nil];
        [_songTitle setText:@""];
        [_artist setText:@""];
        [_album setText:@""];
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
            progressValue = currentTime / playbackDuration;
        }
    }
    
    [_progress setProgress:progressValue animated:false];
    
    // update icon play/pause
    
    //MPMusicPlayerController* player = [[self.del mpdatamanager] musicplayer];
    //if([player playbackState] == MPMoviePlaybackStatePlaying)
    if([[AVAudioSession sharedInstance] isOtherAudioPlaying])
        _progress.centralView =  pauseView;
    else
        _progress.centralView =  playView;
}


- (void)imageViewPressed
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MusicViewController *musicView = [sb instantiateViewControllerWithIdentifier:@"Song"]; // @"SettingsListViewController" is the string you have set in above picture
    [self.navigationController pushViewController:musicView animated:YES];
}


- (void)songtitlePressed
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MusicViewController *musicView = [sb instantiateViewControllerWithIdentifier:@"Song"]; // @"SettingsListViewController" is the string you have set in above picture
    [self.navigationController pushViewController:musicView animated:YES];
}



- (void)artistPressed
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MusicViewController *musicView = [sb instantiateViewControllerWithIdentifier:@"Song"]; // @"SettingsListViewController" is the string you have set in above picture
    [self.navigationController pushViewController:musicView animated:YES];
}



- (void)albumPressed
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MusicViewController *musicView = [sb instantiateViewControllerWithIdentifier:@"Song"]; // @"SettingsListViewController" is the string you have set in above picture
    [self.navigationController pushViewController:musicView animated:YES];
}



- (void)progressPressed
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    MPMusicPlayerController* player = [[self.del mpdatamanager] musicplayer];
    
    //if([player playbackState] == MPMoviePlaybackStatePlaying)
    if([[AVAudioSession sharedInstance] isOtherAudioPlaying])
        [player pause];
    else
        [player play];
    
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




@end
