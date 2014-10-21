//
//  UITableViewCellFeatureAlbumStore.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-10-19.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCellFeatureAlbumStore : UITableViewCell

@property (weak, nonatomic) UINavigationController* parentNavCtrl;

@property (weak, nonatomic) IBOutlet UIView*        viewAlbums;

@property (weak, nonatomic) IBOutlet UILabel*       more;

@property (weak, nonatomic) IBOutlet UIImageView*   image1;
@property (weak, nonatomic) IBOutlet UILabel*       title1;
@property (weak, nonatomic) IBOutlet UILabel*       artist1;
@property (weak, nonatomic) NSString*               collectionId1;

@property (weak, nonatomic) IBOutlet UIImageView*   image2;
@property (weak, nonatomic) IBOutlet UILabel*       title2;
@property (weak, nonatomic) IBOutlet UILabel*       artist2;
@property (weak, nonatomic) NSString*               collectionId2;

@property (weak, nonatomic) IBOutlet UIImageView*   image3;
@property (weak, nonatomic) IBOutlet UILabel*       title3;
@property (weak, nonatomic) IBOutlet UILabel*       artist3;
@property (weak, nonatomic) NSString*               collectionId3;

@property (weak, nonatomic) IBOutlet UIImageView*   image4;
@property (weak, nonatomic) IBOutlet UILabel*       title4;
@property (weak, nonatomic) IBOutlet UILabel*       artist4;
@property (weak, nonatomic) NSString*               collectionId4;

@property (weak, nonatomic) IBOutlet UIImageView*   image5;
@property (weak, nonatomic) IBOutlet UILabel*       title5;
@property (weak, nonatomic) IBOutlet UILabel*       artist5;
@property (weak, nonatomic) NSString*               collectionId5;

@property (weak, nonatomic) IBOutlet UIImageView*   image6;
@property (weak, nonatomic) IBOutlet UILabel*       title6;
@property (weak, nonatomic) IBOutlet UILabel*       artist6;
@property (weak, nonatomic) NSString*               collectionId6;


/**
 *  Start loading cell
 */
- (void) startLoading;


/**
 *  Stop loading cell
 */
- (void) stopLoading;



@end
