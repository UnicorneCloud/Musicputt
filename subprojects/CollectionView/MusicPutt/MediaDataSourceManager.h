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


-(BOOL) loadMediaByGroup;

-(NSUInteger) getNbSection;
-(NSUInteger) getNbMedia;

-(UIImage*) getMediaImage:(NSUInteger) media :(CGSize) size;

-(void) logMediaInformation:(NSInteger) media;

@end



/**
 *  Notification of datas source.
 */
extern NSString *MediaDataSourceWillChangeValueNotification;


/**
 *  Option for grouping media
 */
typedef NS_OPTIONS(NSInteger, MediaGroupByType) {
    /**
     *  Load media group by album
     */
    MediaDataSourceLoadMediaGroupByAlbumArtist      = 0,
    /**
     *  Load media group by artist
     */
    //
    MediaDataSourceLoadMediaGroupByArtist           = 1 << 0,
    /**
     *  Load media group by playlist
     */
    MediaDataSourceLoadMediaGroupByPlaylist         = 1 << 1
};






