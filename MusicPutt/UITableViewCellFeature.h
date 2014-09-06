//
//  UITableViewCellFeature.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-07-02.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCellFeature : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView*   image1;

@property (weak, nonatomic) IBOutlet UIImageView*   image2;

@property (weak, nonatomic) IBOutlet UIImageView*   image3;

@property (weak, nonatomic) IBOutlet UIImageView*   image4;

@property (weak, nonatomic) IBOutlet UILabel*   title;

@property (weak, nonatomic) IBOutlet UILabel*   desc;

@end
