//
//  ViewController.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-16.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "MusicViewController.h"
#import "MediaDataSourceManager.h"



#import "MPCell.h"

@interface MusicViewController ()
{
    
}
@end


@implementation MusicViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Init media manager
    self.mediaManager = [[MediaDataSourceManager alloc] init];
    [self.mediaManager setDataSource:self];
    [self.mediaManager loadMediaByGroup];
	
    // Init custom layout and attach to controller
    self.layout.itemCount = (int)[self.mediaManager getNbMedia];
    
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
    NSLog(@" %s - %@ %d\n", __PRETTY_FUNCTION__, @"return", (int)[self.mediaManager getNbMedia]);
    return (int)[self.mediaManager getNbMedia];
}


- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    NSLog(@" %s - %@ %d\n", __PRETTY_FUNCTION__, @"return", (int)[self.mediaManager getNbSection]);
    return (int)[self.mediaManager getNbSection];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Return cell");
    
    MPCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell setImage: [self.mediaManager getMediaImage:indexPath.item :cell.frame.size]];
    return cell;
}


////////////////////////////////////////////
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" %s - %@ %ld,%ld,%ld\n", __PRETTY_FUNCTION__, @"SelectItem Detected", indexPath.row, (long)indexPath.item, (long)indexPath.section);
    [self.mediaManager logMediaInformation:indexPath.item];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"DeselectItem Detected");
}


////////////////////////////////////////////
#pragma mark - IPodLibraryManagerDelegate
- (void) mediaWillLoad
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Delegate works!!!");
}








@end
