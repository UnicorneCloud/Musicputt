//
//  ViewController.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-16.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "MusicViewController.h"

#import "MPCell.h"


@implementation MusicViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Init custom layout and attach to controller
    self.layout.itemCount = 18;
    
    // Init custom collectionview and attach to layout
    [self.collectionView registerClass:[MPCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.collectionView setCollectionViewLayout:self.layout];
    [self.collectionView reloadData];
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"endLoad");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


////////////////////////////////////////////
#pragma mark - UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    NSLog(@" %s - %@ %d\n", __PRETTY_FUNCTION__, @"return", 18);
    return 18;
}


- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    NSLog(@" %s - %@ %d\n", __PRETTY_FUNCTION__, @"return", 1);
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Return cell");
    
    MPCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}


////////////////////////////////////////////
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" %s - %@ %ld,%ld,%ld\n", __PRETTY_FUNCTION__, @"SelectItem Detected", indexPath.row, (long)indexPath.item, (long)indexPath.section);
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"DeselectItem Detected");
}




@end
