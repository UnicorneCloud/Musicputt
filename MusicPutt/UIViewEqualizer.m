//
//  UIViewEqualizer.m
//  MusicPutt
//
//  Created by Eric Pinet on 2015-03-08.
//  Copyright (c) 2015 Eric Pinet. All rights reserved.
//

#import "UIViewEqualizer.h"
#import "UIColor+CreateMethods.h"

#define _DEFAULT_NB_LINE_ 3
#define _DEFAULT_COLOR_ @"#750300"

@interface UIViewEqualizer()
{
    float _nbLine;
    float _firstLineCurrentValue;
    
    float _maxHeight;
    
    float _lineWidth;
    float _lineSpaceWidth;
    
    float _refreshRate;
    
    float _currentRatio;
    
    BOOL _directionUp;
    
    NSString* _color;
    
    NSTimer* timer;
}

@end

@implementation UIViewEqualizer

- (id) init
{
    [self initDefaultValue];
    return [super init];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    [self initDefaultValue];
    return [super initWithCoder:aDecoder];
}

- (id) initWithFrame:(CGRect)frame
{
    [self initDefaultValue];
    return [super initWithFrame:frame];
}

/**
 *  Initialize default value.
 */
- (void) initDefaultValue
{
    // init nb line by default
    _nbLine = _DEFAULT_NB_LINE_;
    
    // init current value at 0
    _firstLineCurrentValue = 0;
    
    // default color
    _color = _DEFAULT_COLOR_;
    
    // default direction up
    _directionUp = true;
    
    // default refresh rate
    _refreshRate = 0.02;
    
    // default current ratio
    _currentRatio = 0.25;
    
}

- (void)startAnimation
{
    //draw the first path
    [self setNeedsDisplay];
    
    //schedule redraws once per second
    timer = [NSTimer scheduledTimerWithTimeInterval:_refreshRate target:self selector:@selector(updateView:) userInfo:nil repeats:YES];
}

- (void)stopAnimation
{
    if (timer) {
        [timer invalidate];
    }
}

- (void)updateView:(NSTimer*)timer
{
    //tell the view to update
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    // Drawing code
    
    // max value is the frame height
    _maxHeight = self.frame.size.height;
    
    // init width line
    _lineSpaceWidth = (self.frame.size.width * 0.1) / (_nbLine-1);
    _lineWidth = ( ( self.frame.size.width - (self.frame.size.width * 0.1)) / _nbLine );
    
    // obtain the graphics context for the view
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set line width
    CGContextSetLineWidth(context, _lineWidth);
    
    // set color
    CGColorRef color = [[UIColor colorWithHex:_color alpha:1.0] CGColor];
    
    CGContextSetStrokeColorWithColor(context, color);
    
    // draw line 1
    CGContextMoveToPoint(context, _lineWidth/2, _maxHeight);
    CGContextAddLineToPoint(context, _lineWidth/2, _maxHeight-_firstLineCurrentValue);
    
    if (_directionUp) {
        _firstLineCurrentValue++;
        if ( _firstLineCurrentValue >= _maxHeight ) {
            _directionUp = false;
            
            _currentRatio = 0.0 + ((float)arc4random() / UINT32_MAX) * (0.8 - 0.2);
        }
    }
    else{
        _firstLineCurrentValue--;
        if ( _firstLineCurrentValue <= (_maxHeight/3) ) {
            _directionUp = true;
            
            _currentRatio = 0.0 + ((float)arc4random() / UINT32_MAX) * (0.8 - 0.2);
        }
    }
    
    // draw line 2
    CGContextMoveToPoint(context, (_lineWidth+_lineSpaceWidth)+_lineWidth/2, _maxHeight);
    CGContextAddLineToPoint(context, (_lineWidth+_lineSpaceWidth)+_lineWidth/2, _firstLineCurrentValue - (_firstLineCurrentValue*_currentRatio) );
    
    // draw line 3
    CGContextMoveToPoint(context, (_lineWidth*2+_lineSpaceWidth*2)+_lineWidth/2, _maxHeight);
    CGContextAddLineToPoint(context, (_lineWidth*2+_lineSpaceWidth*2)+_lineWidth/2, _firstLineCurrentValue + (_firstLineCurrentValue*_currentRatio) - (_maxHeight/3) );
    
    // strock path
    CGContextStrokePath(context);
    //CGColorRelease(color);
}


@end
