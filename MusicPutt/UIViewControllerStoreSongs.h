//
//  UIViewControllerStoreSongs.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-08-02.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewControllerStoreSongs : UIViewController

/**
 *  ArtistId
 */
@property (nonatomic, weak) NSString* storeArtistId;

/**
 *  Ensure that playing preview song is ended
 */
- (void) stopPlaying;


@end
