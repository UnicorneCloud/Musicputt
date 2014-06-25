//
//  UIViewArtwork.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-24.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewArtwork.h"

@interface UIViewArtwork()
{
    float       borderWith;
    UIColor*    borderColor;
    BOOL        imageExist;
}
@end

@implementation UIViewArtwork


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGRect frame = self.bounds;
    
    borderWith = 2.0;
    borderColor = [UIColor whiteColor];
    imageExist = false;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //[[UIColor blueColor] set];
    //CGContextFillRect( context, frame );
    
    
    CGRect imageRect = CGRectMake(0, 0, frame.size.width, frame.size.height);
    CGContextTranslateCTM(context, 0, frame.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, imageRect, [[UIImage imageNamed:imageExist?@"artwork-empty":@"artwork-empty"] CGImage]);
    
    
    // Stroke Rect convenience that is equivalent to above
    [[UIColor whiteColor] set];
    CGContextStrokeRectWithWidth(context, frame, borderWith);
}


@end
