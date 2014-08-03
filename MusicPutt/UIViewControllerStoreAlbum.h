//
//  UIViewControllerStoreAlbum.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-07-24.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewControllerStoreAlbum : UIViewController

/**
 *  ArtistId
 */
@property (nonatomic, weak) NSString* storeArtistId;

/**
 *  Share button was pressed by the user.
 *
 *  @param sender sender of event.
 */
//- (IBAction)sharePressed:(id)sender;

/**
 *  Click on itunes button.
 *
 *  @param sender <#sender description#>
 */
//- (IBAction)itunesButtonPressed:(id)sender;


/**
 *  Ensure that playing preview song is ended
 */
- (void) stopPlaying;

@end
