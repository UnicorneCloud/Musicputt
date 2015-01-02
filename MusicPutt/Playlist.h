//
//  Playlist.h
//  MusicPutt
//
//  Created by Eric Pinet on 2015-01-01.
//  Copyright (c) 2015 Eric Pinet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PlaylistItem;

@interface Playlist : NSManagedObject

@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *items;
@end

@interface Playlist (CoreDataGeneratedAccessors)

- (void)addItemsObject:(PlaylistItem *)value;
- (void)removeItemsObject:(PlaylistItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
