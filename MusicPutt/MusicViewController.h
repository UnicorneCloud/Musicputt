//
//  ViewController.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-16.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPLayout.h"

@interface MusicViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView*      collectionView;
@property (nonatomic, weak) IBOutlet MPLayout*              layout;

@end
