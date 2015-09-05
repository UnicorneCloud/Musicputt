//
//  UITableViewCellFeatureSongsStore.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-11-29.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UITableViewCellFeatureSongsStore.h"

#import "UIViewControllerAlbumStore.h"
#import "ITunesSearchApi.h"
#import "UIViewEqualizer.h"

@interface UITableViewCellFeatureSongsStore() <ITunesSearchApiDelegate>
{
    NSString* collectionId;
    ITunesSearchApi* itunes;
    NSArray* resultArray;
}


@end

@implementation UITableViewCellFeatureSongsStore

- (void)awakeFromNib {
    // Initialization code
    
    // init download progress and playing
    [_downloadProgress setHidden:true];
    [_equalizer setHidden:true];
    
    // active gesture on image
    _image.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick)];
    [_image addGestureRecognizer:tapGestureImage];
    
    // Init iTunes search api
    itunes = [[ITunesSearchApi alloc] init];
    [itunes setDelegate:self];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  Start downloading progress
 */
-(void) startDownloadProgress
{
    [_downloadProgress setHidden:false];
    [_equalizer setHidden:true];
    [_downloadProgress startAnimating];
}


/**
 *  Stop downloading progress
 */
-(void) stopDownloadProgress
{
    [_downloadProgress startAnimating];
    [_downloadProgress setHidden:true];
}

/**
 *  Start playing progress
 */
-(void) startPlayingProgress
{
    [_downloadProgress setHidden:true];
    [_equalizer setHidden:false];
    [_equalizer startAnimation];
}

/**
 *  Stop playing progress
 */
-(void) stopPlayingProgress
{
    [_equalizer stopAnimation];
    [_equalizer setHidden:true];
}

/**
 *  Click on image
 */
- (void) imageClick
{
    [self displayStoreAlbum];
}

/**
 *  Display store album in new screen.
 */
-(void) displayStoreAlbum
{
    
    [itunes queryMusicTrackWithId:_trackId asynchronizationMode:false];
    
    if (collectionId != nil && [collectionId isEqualToString:@""]!=true ) {
        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewControllerAlbumStore *albumStore = [sb instantiateViewControllerWithIdentifier:@"AlbumStore"];
        [albumStore setCollectionId:collectionId];
        [_parentNavCtrl pushViewController:albumStore animated:YES];
    }
}

/**
 *  ITunesSearchApi receive result.
 *
 *  @param status  Status of the result.
 *  @param type    Type of query.
 *  @param results results of the query.
 */
-(void) queryResult:(ITunesSearchApiQueryStatus)status type:(ITunesSearchApiQueryType)type results:(NSArray*)results
{
    if (status==ITunesSearchApiStatusSucceed) {

        if ( type == QueryMusicTrackWithId ){
            resultArray = results;
            collectionId = [[resultArray objectAtIndex:0] collectionId];
        }
    }
}

@end
