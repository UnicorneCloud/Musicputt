//
//  TableViewCellAlbumStoreCell.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-09-13.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "TableViewCellAlbumStoreCell.h"

#import "ITunesMusicTrack.h"
#import "UAProgressView.h"
#import "UIColor+CreateMethods.h"

@interface TableViewCellAlbumStoreCell ()
{
    ITunesMusicTrack* _mediaitem;
    NSTimer *timerDownload;
    float currentProgress;
}

/**
 *  Song's album name
 */
@property (weak, nonatomic) IBOutlet UILabel* songNumber;

/**
 *  Song's name.
 */
@property (weak, nonatomic) IBOutlet UILabel* songName;

/**
 *  Song's duration.
 */
@property (weak, nonatomic) IBOutlet UILabel* songDuration;


@end

@implementation TableViewCellAlbumStoreCell

- (void)awakeFromNib {
    // Initialization code
    
    // init download progress
    currentProgress = 0;
    [_downloadProgress setHidden:true];
    _downloadProgress.borderWidth = 1.0;
    _downloadProgress.lineWidth = 3.0;
    _downloadProgress.animationDuration = 0.1;
    _downloadProgress.tintColor = [UIColor colorWithHex:@"#8E8E93" alpha:1.0];

    // hide song durration
    //[_songDuration setHidden:true];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  Set the information of the media item (name, track no. and duration).
 *
 *  @param artistAlbumItem : The media item to set.
 */
- (void)setMediaItem:(ITunesMusicTrack *)mediaitem
{
    // song number
    _songNumber.text = [mediaitem trackNumber];
    
    // song name
    _songName.text = [mediaitem trackName];
    
    // song duration
    NSNumber *durationtime = [NSNumber numberWithInteger:[[mediaitem trackTimeMillis] integerValue]/1000];
    _songDuration.text = [NSString stringWithFormat: @"%02d:%02d",
                          [durationtime intValue]/60,
                          [durationtime intValue]%60];
    
    // media item link with song
    _mediaitem = mediaitem;
}

/**
 *  Get media item attach with this cell.
 *
 *  @return mediaItem attach with this cell.
 */
-(ITunesMusicTrack*) getMediaItem
{
    return _mediaitem;
}

-(void) startDownloadProgress
{
    [_songDuration setHidden:true];
    [_downloadProgress setHidden:false];
    
    currentProgress = 0;
    
    timerDownload = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                      target:self
                                                    selector:@selector(stepDownload)
                                                    userInfo: nil
                                                     repeats:YES];
    
}

-(void) stopDownloadProgress
{
    [timerDownload invalidate];
    
    [_downloadProgress setHidden:true];
    [_songDuration setHidden:false];
}


-(void) stepDownload
{
    if (currentProgress<1) {
        currentProgress = currentProgress + 0.05;
    }
    else{
        currentProgress = 0;
    }
    [_downloadProgress setProgress:currentProgress animated:true];
}


@end
