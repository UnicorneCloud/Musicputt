//
//  IPodLibraryManager.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-17.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MPMediaQuery.h>
#import <MediaPlayer/MPMediaItemCollection.h>
#import "MediaDataSource.h"






@interface MediaDataSourceManager : NSObject

@property (weak) NSObject <MediaDataSource>* dataSource;

-(void) StartLoad;

@end



//! Notification names
extern NSString *MediaDataSourceWillChangeValueNotification;


//! Parameters GroupBy Options
NSString *const MediaDataSourceLoadMediaGroupByAlbum  = @"LoadMediaGroupByAlbum";            // Load media group by album
NSString *const MediaDataSourceLoadMediaGroupByArtist = @"LoadMediaGroupByArtist";           // Load media group by artist
NSString *const MediaDataSourceLoadMediaGroupByPlaylist = @"LoadMediaGroupByPlaylist";       // Load media group by album




