//
//  UIViewControllerAlbumStore.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-09-13.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewControllerToolbar.h"

@class ITunesAlbum;

@interface UIViewControllerAlbumStore : UIViewControllerToolbar

@property (weak,nonatomic) NSString* collectionId;

@end
