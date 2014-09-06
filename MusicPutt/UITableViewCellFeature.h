//
//  UITableViewCellFeature.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-07-02.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Enum of query status.
 */
typedef enum {
    TypeMusicPutt,
    TypeDiscover
} CellFeatureType;

@interface UITableViewCellFeature : UITableViewCell

@property CellFeatureType type;

@property (weak, nonatomic) UINavigationController* parentNavCtrl;

@property (weak,nonatomic) NSNumber*                albumUid1;

@property (weak,nonatomic) NSNumber*                albumUid2;

@property (weak,nonatomic) NSNumber*                albumUid3;

@property (weak,nonatomic) NSNumber*                albumUid4;

@property (weak, nonatomic) IBOutlet UIView*        parentView;

@property (weak, nonatomic) IBOutlet UIImageView*   image1;

@property (weak, nonatomic) IBOutlet UIImageView*   image2;

@property (weak, nonatomic) IBOutlet UIImageView*   image3;

@property (weak, nonatomic) IBOutlet UIImageView*   image4;

@property (weak, nonatomic) IBOutlet UILabel*   title;

@property (weak, nonatomic) IBOutlet UILabel*   desc;

@end
