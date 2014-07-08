//
//  MPDataManager.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-28.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CurrentPlayingToolBar.h"

@class MPMusicPlayerController;

@interface MPDataManager : NSObject

@property (strong, nonatomic) MPMusicPlayerController* musicplayer;
@property (strong, nonatomic) MPMediaPlaylist* currentPlaylist;
@property (strong, nonatomic) CurrentPlayingToolBar*  currentPlayingToolbar;
@property (strong, nonatomic) NSMutableArray* currentSonglist;
//@property (strong, nonatomic) MPMedia

- (bool) initialise;
- (bool) isMusicViewControllerVisible;
- (void) setMusicViewControllerVisible:(bool) visible;

@end
