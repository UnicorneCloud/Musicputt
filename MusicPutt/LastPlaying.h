//
//  LastPlaying.h
//  MusicPutt
//
//  Created by Eric Pinet on 2015-01-20.
//  Copyright (c) 2015 Eric Pinet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LastPlaying : NSManagedObject

@property (nonatomic, retain) NSNumber * albumuid;
@property (nonatomic, retain) NSNumber * playlistuid;
@property (nonatomic, retain) NSNumber * islastmusicputt;
@property (nonatomic, retain) NSString * playlistmusicputt;

@end
