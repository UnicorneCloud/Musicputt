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
#import "DLAVAlertView.h"
#import "ITunesFeedsApi.h"
#import "PreferredGender.h"
#import <MediaPlayer/MediaPlayer.h>


#define MUSICPUTT_PLAY_PREFERED         @"Play my favorites"
#define MUSICPUTT_PLAY_LASTEST          @"Play lastest playlist"
#define MUSICPUTT_CREATE_NEW_PLAYLIST   @"Create new playlist"

#define DISCOVER_SEE_WHATS_NEW          @"See what's hot"
#define DISCOVER_PLAY_WHATS_NEW         @"Play what's hot"
#define DISCOVER_SELECT_PREFERED_GENDER @"Select your preferred gender"

@interface UITableViewCellFeature() <UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate>
{
    MPMediaQuery* everything;                   // result of current query
    UITableView *tableview;
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
    
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 400.0, 270.0)];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.editing = true;
    tableview.allowsMultipleSelectionDuringEditing = YES;
    tableview.allowsSelectionDuringEditing = YES;
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
    
    // DISCOVER_SELECT_PREFERED_GENDER
    //
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:DISCOVER_SELECT_PREFERED_GENDER]) {
        DLAVAlertView *alertView = [[DLAVAlertView alloc] initWithTitle:@"Select your preferred gender!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        alertView.contentView = tableview;
        
        [alertView showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
            NSLog(@"Tapped button '%@' at index: %ld", [alertView buttonTitleAtIndex:buttonIndex], (long)buttonIndex);
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }];
    }
    
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 41;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (indexPath.row==0)
        cell.textLabel.text = GENRE_ALTERNATIVE_TXT;
    else if (indexPath.row == 1)
        cell.textLabel.text = GENRE_ANIME_TXT;
    else if (indexPath.row == 2)
        cell.textLabel.text = GENRE_BLUES_TXT;
    else if (indexPath.row == 3)
        cell.textLabel.text = GENRE_BRAZILIAN_TXT;
    else if (indexPath.row == 4)
        cell.textLabel.text = GENRE_CHILDRENSMUSIC_TXT;
    else if (indexPath.row == 5)
        cell.textLabel.text = GENRE_CHINESE_TXT;
    else if (indexPath.row == 6)
        cell.textLabel.text = GENRE_CHRISTIANGOSPEL_TXT;
    else if (indexPath.row == 7)
        cell.textLabel.text = GENRE_CLASSICAL_TXT;
    else if (indexPath.row == 8)
        cell.textLabel.text = GENRE_COMEDY_TXT;
    else if (indexPath.row == 9)
        cell.textLabel.text = GENRE_COUNTRY_TXT;
    else if (indexPath.row == 10)
        cell.textLabel.text = GENRE_DANCE_TXT;
    else if (indexPath.row == 11)
        cell.textLabel.text = GENRE_DISNEY_TXT;
    else if (indexPath.row == 12)
        cell.textLabel.text = GENRE_EASYLISTENING_TXT;
    else if (indexPath.row == 13)
        cell.textLabel.text = GENRE_ELECTRONIC_TXT;
    else if (indexPath.row == 14)
        cell.textLabel.text = GENRE_ENKA_TXT;
    else if (indexPath.row == 15)
        cell.textLabel.text = GENRE_FITNESSWORKOUT_TXT;
    else if (indexPath.row == 16)
        cell.textLabel.text = GENRE_FRENCHPOP_TXT;
    else if (indexPath.row == 17)
        cell.textLabel.text = GENRE_GERMANFOLK_TXT;
    else if (indexPath.row == 18)
        cell.textLabel.text = GENRE_GERMANPOP_TXT;
    else if (indexPath.row == 19)
        cell.textLabel.text = GENRE_HIPHOPRAP_TXT;
    else if (indexPath.row == 20)
        cell.textLabel.text = GENRE_HOLIDAY_TXT;
    else if (indexPath.row == 21)
        cell.textLabel.text = GENRE_INDIAN_TXT;
    else if (indexPath.row == 22)
        cell.textLabel.text = GENRE_INSTRUMENTAL_TXT;
    else if (indexPath.row == 23)
        cell.textLabel.text = GENRE_JPOP_TXT;
    else if (indexPath.row == 24)
        cell.textLabel.text = GENRE_JAZZ_TXT;
    else if (indexPath.row == 25)
        cell.textLabel.text = GENRE_KPOP_TXT;
    else if (indexPath.row == 26)
        cell.textLabel.text = GENRE_KARAOKE_TXT;
    else if (indexPath.row == 27)
        cell.textLabel.text = GENRE_KAYOKYOKU_TXT;
    else if (indexPath.row == 28)
        cell.textLabel.text = GENRE_KOREAN_TXT;
    else if (indexPath.row == 29)
        cell.textLabel.text = GENRE_LATINO_TXT;
    else if (indexPath.row == 30)
        cell.textLabel.text = GENRE_NEWAGE_TXT;
    else if (indexPath.row == 31)
        cell.textLabel.text = GENRE_OPERA_TXT;
    else if (indexPath.row == 32)
        cell.textLabel.text = GENRE_POP_TXT;
    else if (indexPath.row == 33)
        cell.textLabel.text = GENRE_RBSOUL_TXT;
    else if (indexPath.row == 34)
        cell.textLabel.text = GENRE_REGGAE_TXT;
    else if (indexPath.row == 35)
        cell.textLabel.text = GENRE_ROCK_TXT;
    else if (indexPath.row == 36)
        cell.textLabel.text = GENRE_SINGERSONGWRITER_TXT;
    else if (indexPath.row == 37)
        cell.textLabel.text = GENRE_SOUNDTRACK_TXT;
    else if (indexPath.row == 38)
        cell.textLabel.text = GENRE_SPOKENWORD_TXT;
    else if (indexPath.row == 39)
        cell.textLabel.text = GENRE_VOCAL_TXT;
    else if (indexPath.row == 40)
        cell.textLabel.text = GENRE_WORLD_TXT;
    
    // find gender
    PreferredGender* preferredGender = [PreferredGender MR_findFirstByAttribute:@"genderid" withValue:[NSNumber numberWithInteger:[self convertRowId2GenderId:indexPath.row]]];
    if (preferredGender!=nil) {
        // if preferred gender is found select the cell
        [cell setSelected:TRUE];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        [cell setSelected:FALSE];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType == UITableViewCellAccessoryCheckmark){
        [cell setSelected:FALSE];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    */
    
    // witch gender we have to delete
    NSInteger genderid = 0;
    genderid = [self convertRowId2GenderId:indexPath.row];
    
    // find gender
    PreferredGender* preferredGender = [PreferredGender MR_findFirstByAttribute:@"genderid" withValue:[NSNumber numberWithInteger:genderid]];
    if (preferredGender!=nil) {
        [preferredGender MR_deleteEntity];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType == UITableViewCellAccessoryCheckmark){
        NSLog(@"Checkmark did select");
        [cell setSelected:TRUE];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }*/
    
    // find gender to add
    NSInteger genderid = 0;
    genderid = [self convertRowId2GenderId:indexPath.row];
    
    // add to preferred gender
    PreferredGender* preferredGender = [PreferredGender MR_createEntity];
    preferredGender.genderid = [NSNumber numberWithInteger:genderid];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

- (NSInteger) convertRowId2GenderId: (NSInteger) rowId
{
    NSInteger genderid = 0;
    
    if (rowId==0)
        genderid = GENRE_ALTERNATIVE;
    else if (rowId == 1)
        genderid = GENRE_ANIME;
    else if (rowId == 2)
        genderid = GENRE_BLUES;
    else if (rowId == 3)
        genderid = GENRE_BRAZILIAN;
    else if (rowId == 4)
        genderid = GENRE_CHILDRENSMUSIC;
    else if (rowId == 5)
        genderid = GENRE_CHINESE;
    else if (rowId == 6)
        genderid = GENRE_CHRISTIANGOSPEL;
    else if (rowId == 7)
        genderid = GENRE_CLASSICAL;
    else if (rowId == 8)
        genderid = GENRE_COMEDY;
    else if (rowId == 9)
        genderid = GENRE_COUNTRY;
    else if (rowId == 10)
        genderid = GENRE_DANCE;
    else if (rowId == 11)
        genderid = GENRE_DISNEY;
    else if (rowId == 12)
        genderid = GENRE_EASYLISTENING;
    else if (rowId == 13)
        genderid = GENRE_ELECTRONIC;
    else if (rowId == 14)
        genderid = GENRE_ENKA;
    else if (rowId == 15)
        genderid = GENRE_FITNESSWORKOUT;
    else if (rowId == 16)
        genderid = GENRE_FRENCHPOP;
    else if (rowId == 17)
        genderid = GENRE_GERMANFOLK;
    else if (rowId == 18)
        genderid = GENRE_GERMANPOP;
    else if (rowId == 19)
        genderid = GENRE_HIPHOPRAP;
    else if (rowId == 20)
        genderid = GENRE_HOLIDAY;
    else if (rowId == 21)
        genderid = GENRE_INDIAN;
    else if (rowId == 22)
        genderid = GENRE_INSTRUMENTAL;
    else if (rowId == 23)
        genderid = GENRE_JPOP;
    else if (rowId == 24)
        genderid = GENRE_JAZZ;
    else if (rowId == 25)
        genderid = GENRE_KPOP;
    else if (rowId == 26)
        genderid = GENRE_KARAOKE;
    else if (rowId == 27)
        genderid = GENRE_KAYOKYOKU;
    else if (rowId == 28)
        genderid = GENRE_KOREAN;
    else if (rowId == 29)
        genderid = GENRE_LATINO;
    else if (rowId == 30)
        genderid = GENRE_NEWAGE;
    else if (rowId == 31)
        genderid = GENRE_OPERA;
    else if (rowId == 32)
        genderid = GENRE_POP;
    else if (rowId == 33)
        genderid = GENRE_RBSOUL;
    else if (rowId == 34)
        genderid = GENRE_REGGAE;
    else if (rowId == 35)
        genderid = GENRE_ROCK;
    else if (rowId == 36)
        genderid = GENRE_SINGERSONGWRITER;
    else if (rowId == 37)
        genderid = GENRE_SOUNDTRACK;
    else if (rowId == 38)
        genderid = GENRE_SPOKENWORD;
    else if (rowId == 39)
        genderid = GENRE_VOCAL;
    else if (rowId == 40)
        genderid = GENRE_WORLD;
    
    return genderid;
}



@end
