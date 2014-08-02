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
 *  Click on itunes button.
 *
 *  @param sender <#sender description#>
 */
- (IBAction)itunesButtonPressed:(id)sender;

@end
