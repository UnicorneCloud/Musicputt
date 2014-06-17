//
//  MPAlbumLayout.m
//  TestDisplayMusic
//
//  Created by Eric Pinet on 2014-06-06.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "MPLayout.h"

@interface MPLayout ()

@property UIView* layoutView;

@end

@implementation MPLayout

-(id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if( self )
    {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    self.layoutView = [[[NSBundle mainBundle] loadNibNamed:@"MPLayout" owner:self options:nil] objectAtIndex:0];
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"initialized");
}


-(CGSize)collectionViewContentSize
{
    if( self.itemCount == 0 ){
        
        NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"return CGSizeZero");
        return CGSizeZero;
    }
    
    float w = [self rowWidth];
    float h = [self rowHeight];
    int   x = [self itemCount];
    float c = LayoutsPerRow;
    
    float height = (h/c * ( x + (c/2) - ( x % (int)(c/2) ) ) );
    CGSize contentSize = { w, height };
    
    //NSLog(@" %s - %@ %fx%f\n", __PRETTY_FUNCTION__, @"return", contentSize.height, contentSize.width);
    return contentSize;
}

-(CGRect)frameForLayoutType:(LayoutType)type
{
    UIView* cell = [self.layoutView.subviews objectAtIndex:type];
    
    //NSLog(@" %s - %@ %fx%f\n", __PRETTY_FUNCTION__, @"return", cell.frame.size.height, cell.frame.size.width);
    return cell.frame;
}

-(float)rowWidth
{
    //NSLog(@" %s - %@ %f\n", __PRETTY_FUNCTION__, @"return", self.layoutView.frame.size.width);
    return self.layoutView.frame.size.width;
}

-(float)rowHeight
{
    //NSLog(@" %s - %@ %f\n", __PRETTY_FUNCTION__, @"return ", self.layoutView.frame.size.height);
    return self.layoutView.frame.size.height;
}

-(LayoutType)layoutTypeForIndexPath:(NSIndexPath*)indexPath
{
    return indexPath.row % LayoutsPerRow;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    for( int i=0, size = self.itemCount; i< size; i++ )
    {
        UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if( CGRectIntersectsRect( attributes.frame, rect) )
            [array addObject:attributes];
    }
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"return");
    return [NSArray arrayWithArray:array];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = [self frameForLayoutType:[self layoutTypeForIndexPath:indexPath]];
    
    int row = (int)indexPath.row /LayoutsPerRow;
    frame.origin.y += row * [self rowHeight];
    
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = frame;
    
    
    //NSLog(@" %s - %@ %fx%f\n", __PRETTY_FUNCTION__, @"return", attributes.frame.size.height, attributes.frame.size.width);
    return attributes;
}

-(UICollectionViewScrollDirection)scrollDirection
{
    return UICollectionViewScrollDirectionVertical;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.alpha = 0.0;
    
    CGSize size = [self collectionView].frame.size;
    attributes.center = CGPointMake(size.width / 2.0, size.height / 2.0);
    
    NSLog(@" %s - %@ %fx%f\n", __PRETTY_FUNCTION__, @"return", attributes.frame.size.height, attributes.frame.size.width);
    return attributes;
}

-(void) createNewCell
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"return");
    return;
}

@end
