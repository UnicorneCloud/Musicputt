//
//  UITableViewCellFeature.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-07-02.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UITableViewCellFeature.h"

#import "AppDelegate.h"
#import "UIViewControllerMusic.h"
#import "UIViewControllerAlbumStore.h"
#import "UIViewControllerGender.h"
#import <MediaPlayer/MediaPlayer.h>


#define MUSICPUTT_PLAY_PREFERED         @"Play my favorites"
#define MUSICPUTT_PLAY_LASTEST          @"Play lastest playlist"
#define MUSICPUTT_CREATE_NEW_PLAYLIST   @"Create new playlist"

#define DISCOVER_SEE_WHATS_NEW          @"See what's hot"
#define DISCOVER_PLAY_WHATS_NEW         @"Play what's hot"
#define DISCOVER_SELECT_PREFERED_GENDER @"Select your preferred gender"

@interface UITableViewCellFeature() <UIActionSheetDelegate>
{
    MPMediaQuery* everything;                   // result of current query
}

@property AppDelegate* del;

@end

@implementation UITableViewCellFeature

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    
    // setup app delegate
    self.del = [[UIApplication sharedApplication] delegate];
    
    // active tap gesture on title label
    _title.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureTitle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuPoppu)];
    [_title addGestureRecognizer:tapGestureTitle];
    
    // active tap gesture on desc label
    _desc.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureDesc = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuPoppu)];
    [_desc addGestureRecognizer:tapGestureDesc];
    
    // active tap gesture on image1 label
    _image1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureImage1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickImage1)];
    [_image1 addGestureRecognizer:tapGestureImage1];
    
    // active tap gesture on image2 label
    _image2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureImage2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickImage2)];
    [_image2 addGestureRecognizer:tapGestureImage2];
    
    // active tap gesture on image3 label
    _image3.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureImage3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickImage3)];
    [_image3 addGestureRecognizer:tapGestureImage3];
    
    // active tap gesture on image4 label
    _image4.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureImage4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickImage4)];
    [_image4 addGestureRecognizer:tapGestureImage4];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)menuPoppu
{
    if (_type == TypeMusicPutt) {
        // Musicputt row
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:MUSICPUTT_PLAY_PREFERED, MUSICPUTT_PLAY_LASTEST, MUSICPUTT_CREATE_NEW_PLAYLIST, nil];
        [actionSheet showInView:_parentView];
    }
    else if (_type == TypeDiscover){
        // Discover row
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:DISCOVER_SEE_WHATS_NEW, DISCOVER_PLAY_WHATS_NEW, DISCOVER_SELECT_PREFERED_GENDER, nil];
        [actionSheet showInView:_parentView];
    }
}

- (void)onClickImage1
{
    if (_type == TypeMusicPutt) {
        // click on album in musicputt (local device album)
        [self playAlbum:_albumUid1];
        NSLog(@"You have click album: %@", _albumUid1);
    }
    else if (_type == TypeDiscover){
        // click on album in TopRate
        [self displayStoreAlbum:_collectionId1];
        NSLog(@"You have click album: %@", _collectionId1);
    }
}

- (void)onClickImage2
{
    if (_type == TypeMusicPutt) {
        // click on album in musicputt (local device album)
        [self playAlbum:_albumUid2];
        NSLog(@"You have click album: %@", _albumUid2);
    }
    else if (_type == TypeDiscover){
        // click on album in TopRate
        [self displayStoreAlbum:_collectionId2];
        NSLog(@"You have click album: %@", _collectionId2);
    }
}

- (void)onClickImage3
{
    if (_type == TypeMusicPutt) {
        // click on album in musicputt (local device album)
        [self playAlbum:_albumUid3];
        NSLog(@"You have click album: %@", _albumUid3);
    }
    else if (_type == TypeDiscover){
        // click on album in TopRate
        [self displayStoreAlbum:_collectionId3];
        NSLog(@"You have click album: %@", _collectionId3);
    }
}

- (void)onClickImage4
{
    if (_type == TypeMusicPutt) {
        // click on album in musicputt (local device album)
        [self playAlbum:_albumUid4];
        NSLog(@"You have click album: %@", _albumUid4);
    }
    else if (_type == TypeDiscover){
        // click on album in TopRate
        [self displayStoreAlbum:_collectionId4];
        NSLog(@"You have click album: %@", _collectionId4);
    }
}

-(void) playAlbum:(NSNumber*)albumUid
{
    if (albumUid != nil) {
        // query album media on device
        everything = [MPMediaQuery albumsQuery];
        MPMediaPropertyPredicate *albumPredicate =  [MPMediaPropertyPredicate predicateWithValue:albumUid
                                                                                     forProperty:MPMediaItemPropertyAlbumPersistentID
                                                                                  comparisonType:MPMediaPredicateComparisonEqualTo];
        [everything addFilterPredicate:albumPredicate];
        
        BOOL shuffleWasOn = NO;
        if ([[self.del mpdatamanager] musicplayer].shuffleMode != MPMusicShuffleModeOff &&
            [[self.del mpdatamanager] musicplayer].shuffleMode != MPMusicShuffleModeDefault)
        {
            [[self.del mpdatamanager] musicplayer].shuffleMode = MPMusicShuffleModeOff;
            shuffleWasOn = YES;
        }
        [[[self.del mpdatamanager] musicplayer] setQueueWithItemCollection:[MPMediaItemCollection collectionWithItems:[everything.collections[0] items]]];
        [[[self.del mpdatamanager] musicplayer] setNowPlayingItem:[[everything.collections[0] items ]objectAtIndex:0]];
        if (shuffleWasOn)
            [[self.del mpdatamanager] musicplayer].shuffleMode = MPMusicShuffleModeSongs;
        
        [[[self.del mpdatamanager] musicplayer] play];
        
        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewControllerMusic *musicView = [sb instantiateViewControllerWithIdentifier:@"Song"];
        [_parentNavCtrl pushViewController:musicView animated:YES];
    }
}

-(void) displayStoreAlbum:(NSString*) collectionId
{
    if (collectionId != nil && [collectionId isEqualToString:@""]!=true ) {
        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewControllerAlbumStore *albumStore = [sb instantiateViewControllerWithIdentifier:@"AlbumStore"];
        [albumStore setCollectionId:collectionId];
        [_parentNavCtrl pushViewController:albumStore animated:YES];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"You have pressed the %@ button", [actionSheet buttonTitleAtIndex:buttonIndex]);
    
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewControllerGender *gender = [sb instantiateViewControllerWithIdentifier:@"PreferredGender"];
    [_parentNavCtrl pushViewController:gender animated:YES];
}


@end
