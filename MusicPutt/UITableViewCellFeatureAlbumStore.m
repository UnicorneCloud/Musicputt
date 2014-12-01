//
//  UITableViewCellFeatureAlbumStore.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-10-19.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UITableViewCellFeatureAlbumStore.h"

#import "UIViewControllerAlbumStore.h"

@interface UITableViewCellFeatureAlbumStore()
{
    
}


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* loading;

@end

@implementation UITableViewCellFeatureAlbumStore

- (void)awakeFromNib {
    // Initialization code
    
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
    
    // active tap gesture on image5 label
    _image5.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureImage5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickImage5)];
    [_image5 addGestureRecognizer:tapGestureImage5];
    
    // active tap gesture on image6 label
    _image6.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureImage6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickImage6)];
    [_image6 addGestureRecognizer:tapGestureImage6];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)onClickImage1
{
    // click on album in TopRate
    [self displayStoreAlbum:_collectionId1];
    NSLog(@"You have click album: %@", _collectionId1);
}

- (void)onClickImage2
{
    // click on album in TopRate
    [self displayStoreAlbum:_collectionId2];
    NSLog(@"You have click album: %@", _collectionId2);
}

- (void)onClickImage3
{
    // click on album in TopRate
    [self displayStoreAlbum:_collectionId3];
    NSLog(@"You have click album: %@", _collectionId3);
}

- (void)onClickImage4
{
    // click on album in TopRate
    [self displayStoreAlbum:_collectionId4];
    NSLog(@"You have click album: %@", _collectionId4);
}

- (void)onClickImage5
{
    // click on album in TopRate
    [self displayStoreAlbum:_collectionId5];
    NSLog(@"You have click album: %@", _collectionId5);
}

- (void)onClickImage6
{
    // click on album in TopRate
    [self displayStoreAlbum:_collectionId6];
    NSLog(@"You have click album: %@", _collectionId6);
}



/**
 *  Start loading cell
 */
- (void) startLoading
{
    [_loading setHidden:FALSE];
    [_loading startAnimating];
    
    [self setVisibility:FALSE];
    
}


/**
 *  Stop loading cell
 */
- (void) stopLoading
{
    [_loading setHidden:TRUE];
    [_loading startAnimating];
    
    [self setVisibility:TRUE];
}

/**
 *  Check
 *
 *  @return true if the cell is in loading
 */
- (BOOL) isLoading
{
    // return false if loading is display
    return ![_loading isHidden];
}


- (void) setVisibility:(BOOL) visibility
{
    BOOL hidden = !visibility;
    
    // 1
    [_image1 setHidden:hidden];
    [_title1 setHidden:hidden];
    [_artist1 setHidden:hidden];
    
    // 2
    [_image2 setHidden:hidden];
    [_title2 setHidden:hidden];
    [_artist2 setHidden:hidden];
    
    // 3
    [_image3 setHidden:hidden];
    [_title3 setHidden:hidden];
    [_artist3 setHidden:hidden];
    
    // 4
    [_image4 setHidden:hidden];
    [_title4 setHidden:hidden];
    [_artist4 setHidden:hidden];
    
    // 5
    [_image5 setHidden:hidden];
    [_title5 setHidden:hidden];
    [_artist5 setHidden:hidden];
    
    // 6
    [_image6 setHidden:hidden];
    [_title6 setHidden:hidden];
    [_artist6 setHidden:hidden];
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



@end
