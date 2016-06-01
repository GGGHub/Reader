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
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[LSYReadConfig shareInstance].theme];
    }
    return self;
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
    CTFrameDraw(_frameRef, ctx);
}

@end
