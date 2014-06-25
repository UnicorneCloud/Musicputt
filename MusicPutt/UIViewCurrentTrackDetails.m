//
//  UIViewCurrentTrackDetails.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-24.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewCurrentTrackDetails.h"

@implementation UIViewCurrentTrackDetails

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
    // Drawing code
    CGRect frame = self.bounds;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    // Stroke Rect convenience that is equivalent to above
    [[UIColor whiteColor] set];
    
    CGContextTranslateCTM(context, 0, frame.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 1.0);
    CGContextSetLineWidth(context, 2.0);
    CGContextSelectFont(context, "Helvetica", 10.0, kCGEncodingMacRoman);
    CGContextSetCharacterSpacing(context, 1.7);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextShowTextAtPoint(context, 100.0, 100.0, "SOME TEXT", 9);
    
    /*
    CGContextSetTextDrawingMode(context, kCGTextFill);
    //          CGContextSelectFont(ctx, [valueLabel.font.fontName UTF8String], valueLabel.font.pointSize, kCGEncodingMacRoman);
    CGAffineTransform transform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
    CGContextSetTextMatrix(context, transform);
    
    float minorTickAngleIncrement = self.arcLength / (float)numberOfMinorTicks;
    
    float textHeight = valueLabel.font.lineHeight;
    float textInset = textHeight + tickLength;
    
    float angle = startAngle;
    
    CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] CGColor]);    // Sets the current fill color in a graphics context, using a Quatz color
    CGContextSetStrokeColorWithColor(ctx, [[UIColor blackColor] CGColor]);  // Sets the current stroke color in a context, using a Quartz color
    NSString *string = [[NSString alloc] initWithFormat:@"%1.0f", self.minNumber];
    
    float textWidth = textHeight * [string length] / 2;
    //          CGContextShowTextAtPoint(ctx, centerX + cos(angle) * (radius - textInset) - textWidth / 2.0, centerY + sin(angle) * (radius - textInset) + textHeight / 4.0, [string UTF8String], [string length]);
    CGFloat x = centerX + cos(angle) * (radius - textInset) - textWidth / 2.0;
    CGFloat y = centerY + sin(angle) * (radius - textInset) + textHeight / 4.0;
    [string drawAtPoint:CGPointMake(x, y)
         withAttributes:@{NSFontAttributeName:[UIFont fontWithName:self.textLabel.font.fontName
                                                              size:self.textLabel.font.pointSize]
                          }];
    [string release];
     */
    
}


@end
