//
//  MPAlbumLayout.h
//  TestDisplayMusic
//
//  Created by Eric Pinet on 2014-06-06.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>



static const int LayoutsPerRow = 9;

typedef enum LayoutType_e
{
    LayoutTypeA,
    LayoutTypeB,
    LayoutTypeC,
    LayoutTypeD,
    LayoutTypeE,
    LayoutTypeF,
    LayoutTypeG,
    LayoutTypeH,
    LayoutTypeI,
} LayoutType;

@interface MPLayout : UICollectionViewLayout

//! this is the number of items in the collection view.
@property int           itemCount;


-(void) createNewCell;

@end
