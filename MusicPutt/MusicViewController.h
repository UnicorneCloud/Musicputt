//
//  ViewController.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-16.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPLayout.h"
#import "MediaDataSource.h"

@class MediaDataSourceManager;

@interface MusicViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, MediaDataSource>

@property (nonatomic, weak) IBOutlet UICollectionView*      collectionView;
@property (nonatomic, weak) IBOutlet MPLayout*              layout;
@property MediaDataSourceManager* mediaManager;


@end
