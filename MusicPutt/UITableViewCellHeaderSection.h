//
//  UITableViewCellHeaderSection.h
//  MusicPutt
//
//  Created by Qiaomei Wang on 2014-07-15.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCellHeaderSection : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* albumName;
@property (nonatomic, weak) IBOutlet UILabel* artistName;
@property (nonatomic, weak) IBOutlet UIImageView* imageHeader;

@end
