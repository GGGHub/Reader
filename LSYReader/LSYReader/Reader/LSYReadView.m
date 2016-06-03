//
//  LSYReadView.m
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYReadView.h"
#import "LSYReadConfig.h"
@implementation LSYReadView
{
    NSRange _selectRange;
    NSArray *_pathArray;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self addGestureRecognizer:({
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            longPress;
        })];
        
    }
    return self;
}
#pragma -mark Gesture Recognizer
-(void)longPress:(UILongPressGestureRecognizer *)longPress
{
    CGPoint point = [longPress locationInView:self];
    if (longPress.state == UIGestureRecognizerStateBegan || longPress.state == UIGestureRecognizerStateChanged) {
        CGRect rect = [LSYReadParser parserRectWithPoint:point range:&_selectRange frameRef:_frameRef];
        
        if (!CGRectEqualToRect(rect, CGRectZero)) {
            _pathArray = @[NSStringFromCGRect(rect)];
            [self setNeedsDisplay];
        }
    }
}
#pragma mark - Privite Method
#pragma mark  Draw Selected Path
-(void)drawSelectedPath:(NSArray *)array{
    if (!array.count) {
        return;
    }
    CGMutablePathRef _path = CGPathCreateMutable();
    [[UIColor cyanColor]setFill];
    for (int i = 0; i < [array count]; i++) {
        CGRect rect = CGRectFromString([array objectAtIndex:i]);
        CGPathAddRect(_path, NULL, rect);
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddPath(ctx, _path);
    CGContextFillPath(ctx);
    CGPathRelease(_path);
}
#pragma mark - Privite Method
#pragma mark Cancel Draw
-(void)cancelSelected
{
    if (_pathArray) {
        _pathArray = nil;
        [self setNeedsDisplay];
    }
    
}
-(void)setFrameRef:(CTFrameRef)frameRef
{
    if (_frameRef != frameRef) {
        if (_frameRef) {
            CFRelease(_frameRef);
            _frameRef = nil;
        }
        _frameRef = frameRef;
    }
}
-(void)dealloc
{
    if (_frameRef) {
        CFRelease(_frameRef);
        _frameRef = nil;
    }
}
-(void)drawRect:(CGRect)rect
{
    if (!_frameRef) {
        return;
    }
    [self setBackgroundColor:[LSYReadConfig shareInstance].theme];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    [self drawSelectedPath:_pathArray];
    CTFrameDraw(_frameRef, ctx);
    
}

@end
