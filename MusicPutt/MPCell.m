//
//  MPAlbumCell.m
//  TestDisplayMusic
//
//  Created by Eric Pinet on 2014-06-05.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "MPCell.h"

@interface MPCell ()
{
    UIImage* cellImage;
}
@end

@implementation MPCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setImage:(UIImage*) aimage
{
    cellImage = [[UIImage alloc] initWithCGImage:aimage.CGImage];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGRect frame = self.bounds;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //[[UIColor blueColor] set];
    //CGContextFillRect( context, frame );
    
    CGContextDrawImage( context, frame, cellImage.CGImage );
    
    // Stroke Rect convenience that is equivalent to above
    [[UIColor whiteColor] set];
    CGContextStrokeRect(context, frame);
    
    
}


@end
