//
//  UITableViewCellMediaItemHearder.h
//  MusicPutt
//
//  Created by Qiaomei Wang on 2014-07-25.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCellMediaItemHeader : UITableViewCell
/**
 *  Album's name.
 */
@property (nonatomic, weak) IBOutlet UILabel* albumName;
/**
 *  Artist's name.
 */
@property (nonatomic, weak) IBOutlet UILabel* artistName;
/**
 *  Album's information. There are tracks counte and the duration of the album at present.
 */
@property (nonatomic, weak) IBOutlet UILabel* infoAlbum;
/**
 *  The year of the birth of the album.
 */
@property (nonatomic, weak) IBOutlet UILabel* albumYear;
/**
 *  Album's cover.
 */
@property (nonatomic, weak) IBOutlet UIImageView* imageHeader;
@end
