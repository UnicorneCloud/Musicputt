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
    
    // init download progress
    [_downloadProgress setHidden:true];
    
    // active gesture on image
    _image.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick)];
    [_image addGestureRecognizer:tapGestureImage];
    
    /*
    // active gesture on title
    _title.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureTitle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick)];
    [_title addGestureRecognizer:tapGestureTitle];
    
    // active gesture on artist name
    _artist.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureArtist = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(artistClick)];
    [_artist addGestureRecognizer:tapGestureArtist];
    */
    
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

- (void) imageClick
{
    [self displayStoreAlbum];
}

/*
- (void) titleClick
{
    [self displayStoreAlbum];
}

- (void) artistClick
{
    [self displayStoreAlbum];
}
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
