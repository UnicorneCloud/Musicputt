//
//  LastPlaying.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-12-07.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LastPlaying : NSManagedObject

@property (nonatomic, retain) NSNumber * albumuid;
@property (nonatomic, retain) NSNumber * playlistuid;

@end
