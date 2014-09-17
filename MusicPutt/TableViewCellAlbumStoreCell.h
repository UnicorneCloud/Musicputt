//
//  TableViewCellAlbumStoreCell.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-09-13.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>


@class UAProgressView;
@class ITunesMusicTrack;

@interface TableViewCellAlbumStoreCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UAProgressView* downloadProgress;

/**
 *  Set the information of the media item (name, track no. and duration).
 *
 *  @param mediaitem : The media item to set.
 */
- (void)setMediaItem: (ITunesMusicTrack*)mediaitem;


/**
 *  Get media item attach with this cell.
 *
 *  @return mediaItem attach with this cell.
 */
-(ITunesMusicTrack*) getMediaItem;



-(void) startDownloadProgress;


-(void) stopDownloadProgress;


@end
