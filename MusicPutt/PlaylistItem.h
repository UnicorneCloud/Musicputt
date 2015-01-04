//
//  PlaylistItem.h
//  MusicPutt
//
//  Created by Eric Pinet on 2015-01-03.
//  Copyright (c) 2015 Eric Pinet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Playlist;

@interface PlaylistItem : NSManagedObject

@property (nonatomic, retain) NSNumber * songuid;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) Playlist *playlist;

@end
