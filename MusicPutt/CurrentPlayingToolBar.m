//
//  CurrentPlayingToolBar.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-28.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "CurrentPlayingToolBar.h"
#import "AppDelegate.h"
#import <MediaPlayer/MPMusicPlayerController.h>

@interface CurrentPlayingToolBar()
{
    UIImageView* _artwork;
    UILabel* _titleView;
}

@property AppDelegate* del;

@end

@implementation CurrentPlayingToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // setup app delegate
        self.del = [[UIApplication sharedApplication] delegate];
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        
        [notificationCenter
         addObserver: self
         selector:    @selector (handle_NowPlayingItemChanged:)
         name:        MPMusicPlayerControllerNowPlayingItemDidChangeNotification
         object:      [[_del mpdatamanager] musicplayer]];
        
        [notificationCenter
         addObserver: self
         selector:    @selector (handle_PlaybackStateChanged:)
         name:        MPMusicPlayerControllerPlaybackStateDidChangeNotification
         object:      [[_del mpdatamanager] musicplayer]];
        
        [[[_del mpdatamanager] musicplayer] beginGeneratingPlaybackNotifications];
        
        
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
        
        _artwork = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 50,50) ];
        [_artwork setBackgroundColor:[UIColor blackColor]];
        UIBarButtonItem *customViewContainer = [[UIBarButtonItem alloc] initWithCustomView:_artwork];
        [barItems addObject:customViewContainer];
        
        _titleView = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 250,50) ];
        [_titleView setBackgroundColor:[UIColor clearColor]];
        [_titleView setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        [_titleView setBackgroundColor:[UIColor clearColor]];
        [_titleView setTextColor:[UIColor blackColor]];
        [_titleView setText:@""];
        [_titleView setTextAlignment:NSTextAlignmentLeft];
        UIBarButtonItem *titleViewContainer = [[UIBarButtonItem alloc] initWithCustomView:_titleView];
        [barItems addObject:titleViewContainer];

        UIBarButtonItem *flexSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [barItems addObject:flexSpace2];
        
        [self setItems:barItems animated:YES];
    }
    return self;
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter]
     removeObserver: self
     name:           MPMusicPlayerControllerNowPlayingItemDidChangeNotification
     object:         [[_del mpdatamanager] musicplayer]];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver: self
     name:           MPMusicPlayerControllerPlaybackStateDidChangeNotification
     object:         [[_del mpdatamanager] musicplayer]];
    
    [[[_del mpdatamanager] musicplayer] endGeneratingPlaybackNotifications];
}



-(void) displayMediaItem: (MPMediaItem*) aitem
{
    if (aitem!=NULL) {
        NSString* temp = [aitem valueForProperty:MPMediaItemPropertyTitle];
        UIImage* image;
        
        MPMediaItemArtwork *artwork = [aitem valueForProperty:MPMediaItemPropertyArtwork];
        
        if (artwork) {
            image = [artwork imageWithSize:[_artwork frame].size];
        }
        
        [_artwork setImage:image];
        [_titleView setText:temp];
    }
    else{
        [_titleView setText:@""];
        [_artwork setImage:nil];
    }
    
}


#pragma  mark - MPMusicPlayerNSNotificationCenter

-(void) handle_PlaybackStateChanged:(id) notification
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    [self displayMediaItem:[[[_del mpdatamanager] musicplayer] nowPlayingItem]];
    
}

-(void) handle_NowPlayingItemChanged:(id) notification
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    [self displayMediaItem:[[[_del mpdatamanager] musicplayer] nowPlayingItem]];
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
