//
//  LSYReadView.m
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYReadView.h"
#import "LSYReadConfig.h"
#import "LSYNoteModel.h"
#import "LSYReadViewController.h"
#import "LSYMagnifierView.h"
@interface LSYReadView ()
@property (nonatomic,strong) LSYMagnifierView *magnifierView;
@end
@implementation LSYReadView
{
    NSRange _selectRange;
    NSRange _calRange;
    NSArray *_pathArray;
    
    UIPanGestureRecognizer *_pan;
    //滑动手势有效区间
    CGRect _leftRect;
    CGRect _rightRect;
    
    CGRect _menuRect;
    //是否进入选择状态
    BOOL _selectState;
    BOOL _direction; //滑动方向  (0---左侧滑动 1 ---右侧滑动)
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
        [self addGestureRecognizer:({
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
            pan.enabled = NO;
            _pan = pan;
            pan;
        })];
        
        
    }
    return self;
}
#pragma mark - Magnifier View
-(void)showMagnifier
{
    if (!_magnifierView) {
        self.magnifierView = [[LSYMagnifierView alloc] init];
        self.magnifierView.readView = self;
        [self addSubview:self.magnifierView];
    }
}
-(void)hiddenMagnifier
{
    if (_magnifierView) {
        [self.magnifierView removeFromSuperview];
        self.magnifierView = nil;
    }
}
#pragma -mark Gesture Recognizer
-(void)longPress:(UILongPressGestureRecognizer *)longPress
{
    CGPoint point = [longPress locationInView:self];
    [self hiddenMenu];
    if (longPress.state == UIGestureRecognizerStateBegan || longPress.state == UIGestureRecognizerStateChanged) {
        CGRect rect = [LSYReadParser parserRectWithPoint:point range:&_selectRange frameRef:_frameRef];
        [self showMagnifier];
        self.magnifierView.touchPoint = point;
        if (!CGRectEqualToRect(rect, CGRectZero)) {
            _pathArray = @[NSStringFromCGRect(rect)];
            [self setNeedsDisplay];
           
        }
    }
    if (longPress.state == UIGestureRecognizerStateEnded) {
        [self hiddenMagnifier];
        if (!CGRectEqualToRect(_menuRect, CGRectZero)) {
            [self showMenu];
        }
    }
}
-(void)pan:(UIPanGestureRecognizer *)pan
{
   
    CGPoint point = [pan locationInView:self];
    [self hiddenMenu];
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
        [self showMagnifier];
        self.magnifierView.touchPoint = point;
        if (CGRectContainsPoint(_rightRect, point)||CGRectContainsPoint(_leftRect, point)) {
            if (CGRectContainsPoint(_leftRect, point)) {
                _direction = NO;   //从左侧滑动
            }
            else{
                _direction=  YES;    //从右侧滑动
            }
            _selectState = YES;
        }
        if (_selectState) {
//            NSArray *path = [LSYReadParser parserRectsWithPoint:point range:&_selectRange frameRef:_frameRef paths:_pathArray];
            NSArray *path = [LSYReadParser parserRectsWithPoint:point range:&_selectRange frameRef:_frameRef paths:_pathArray direction:_direction];
            _pathArray = path;
            [self setNeedsDisplay];
        }
       
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        [self hiddenMagnifier];
        _selectState = NO;
        if (!CGRectEqualToRect(_menuRect, CGRectZero)) {
            [self showMenu];
        }
    }
    
}

#pragma mark - Privite Method
#pragma mark  Draw Selected Path
-(void)drawSelectedPath:(NSArray *)array LeftDot:(CGRect *)leftDot RightDot:(CGRect *)rightDot{
    if (!array.count) {
        _pan.enabled = NO;
        if ([self.delegate respondsToSelector:@selector(readViewEndEdit:)]) {
            [self.delegate readViewEndEdit:nil];
        }
        return;
    }
    if ([self.delegate respondsToSelector:@selector(readViewEditeding:)]) {
        [self.delegate readViewEditeding:nil];
    }
    _pan.enabled = YES;
    CGMutablePathRef _path = CGPathCreateMutable();
    [[UIColor cyanColor]setFill];
    for (int i = 0; i < [array count]; i++) {
        CGRect rect = CGRectFromString([array objectAtIndex:i]);
        CGPathAddRect(_path, NULL, rect);
        if (i == 0) {
            *leftDot = rect;
            _menuRect = rect;
        }
        if (i == [array count]-1) {
            *rightDot = rect;
        }
       
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddPath(ctx, _path);
    CGContextFillPath(ctx);
    CGPathRelease(_path);
    
}
-(void)drawDotWithLeft:(CGRect)Left right:(CGRect)right
{
    if (CGRectEqualToRect(CGRectZero, Left) || (CGRectEqualToRect(CGRectZero, right))){
        return;
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGMutablePathRef _path = CGPathCreateMutable();
    [[UIColor orangeColor] setFill];
     CGPathAddRect(_path, NULL, CGRectMake(CGRectGetMinX(Left)-2, CGRectGetMinY(Left),2, CGRectGetHeight(Left)));
     CGPathAddRect(_path, NULL, CGRectMake(CGRectGetMaxX(right), CGRectGetMinY(right),2, CGRectGetHeight(right)));
    CGContextAddPath(ctx, _path);
    CGContextFillPath(ctx);
    CGPathRelease(_path);
    CGFloat dotSize = 15;
    _leftRect = CGRectMake(CGRectGetMinX(Left)-dotSize/2-10, ViewSize(self).height-(CGRectGetMaxY(Left)-dotSize/2-10)-(dotSize+20), dotSize+20, dotSize+20);
    _rightRect = CGRectMake(CGRectGetMaxX(right)-dotSize/2-10,ViewSize(self).height- (CGRectGetMinY(right)-dotSize/2-10)-(dotSize+20), dotSize+20, dotSize+20);
    CGContextDrawImage(ctx,CGRectMake(CGRectGetMinX(Left)-dotSize/2, CGRectGetMaxY(Left)-dotSize/2, dotSize, dotSize),[UIImage imageNamed:@"r_drag-dot"].CGImage);
    CGContextDrawImage(ctx,CGRectMake(CGRectGetMaxX(right)-dotSize/2, CGRectGetMinY(right)-dotSize/2, dotSize, dotSize),[UIImage imageNamed:@"r_drag-dot"].CGImage);
}
#pragma mark - Privite Method
#pragma mark Cancel Draw
-(void)cancelSelected
{
    if (_pathArray) {
        _pathArray = nil;
        [self hiddenMenu];
        [self setNeedsDisplay];
    }
    
}
#pragma mark Show Menu
-(void)showMenu
{
    if ([self becomeFirstResponder]) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        UIMenuItem *menuItemCopy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuCopy:)];
        UIMenuItem *menuItemNote = [[UIMenuItem alloc] initWithTitle:@"笔记" action:@selector(menuNote:)];
        UIMenuItem *menuItemShare = [[UIMenuItem alloc] initWithTitle:@"分享" action:@selector(menuShare:)];
        NSArray *menus = @[menuItemCopy,menuItemNote,menuItemShare];
        [menuController setMenuItems:menus];
        [menuController setTargetRect:CGRectMake(CGRectGetMidX(_menuRect), ViewSize(self).height-CGRectGetMidY(_menuRect), CGRectGetHeight(_menuRect), CGRectGetWidth(_menuRect)) inView:self];
        [menuController setMenuVisible:YES animated:YES];
        
    }
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark Hidden Menu
-(void)hiddenMenu
{
     [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}
#pragma mark Menu Function
-(void)menuCopy:(id)sender
{
    [self hiddenMenu];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    [pasteboard setString:[_content substringWithRange:_selectRange]];
    [LSYReadUtilites showAlertTitle:@"成功复制以下内容" content:pasteboard.string];
    
}
-(void)menuNote:(id)sender
{
    [self hiddenMenu];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"笔记" message:[_content substringWithRange:_selectRange]  preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       textField.placeholder = @"输入内容";
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LSYNoteModel *model = [[LSYNoteModel alloc] init];
        model.content = [_content substringWithRange:_selectRange];
        model.note = alertController.textFields.firstObject.text;
        model.date = [NSDate date];
        [[NSNotificationCenter defaultCenter] postNotificationName:LSYNoteNotification object:model];
    }];
    [alertController addAction:cancel];
    [alertController addAction:confirm];
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            [(UIViewController *)nextResponder presentViewController:alertController animated:YES completion:nil];
            break;
        }
    }
}

-(void)menuShare:(id)sender
{
    [self hiddenMenu];
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

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGRect leftDot,rightDot = CGRectZero;
    _menuRect = CGRectZero;
    [self drawSelectedPath:_pathArray LeftDot:&leftDot RightDot:&rightDot];
    CTFrameDraw(_frameRef, ctx);
//    [self fillImagePosition];
    if (_imageArray.count) {
        for (LSYImageData * imageData in self.imageArray) {
            UIImage *image = [UIImage imageWithContentsOfFile:imageData.url];
            CFRange range = CTFrameGetVisibleStringRange(_frameRef);
            
            if (image&&(range.location<=imageData.position&&imageData.position<=(range.length + range.location))) {
                [self fillImagePosition:imageData];
                if (imageData.position==(range.length + range.location)) {
                    if ([self showImage]) {
                        CGContextDrawImage(ctx, imageData.imageRect, image.CGImage);
                    }
                    else{
                        
                    }
                }
                else{
                    CGContextDrawImage(ctx, imageData.imageRect, image.CGImage);
                }
            }
        }
    }
    [self drawDotWithLeft:leftDot right:rightDot];
}
-(BOOL)showImage
{
    NSArray *lines = (NSArray *)CTFrameGetLines(self.frameRef);
    NSUInteger lineCount = [lines count];
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(self.frameRef, CFRangeMake(0, 0), lineOrigins);
    
    CTLineRef line = (__bridge CTLineRef)lines[lineCount-1];
    
    NSArray * runObjArray = (NSArray *)CTLineGetGlyphRuns(line);
    CTRunRef run = (__bridge CTRunRef)runObjArray.lastObject;
    NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
    CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];
    if (delegate == nil) {
        return NO;
    }
    else{
        return YES;
    }
}
- (void)fillImagePosition:(LSYImageData *)imageData;
{
    if (self.imageArray.count == 0) {
        return;
    }
    NSArray *lines = (NSArray *)CTFrameGetLines(self.frameRef);
    NSUInteger lineCount = [lines count];
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(self.frameRef, CFRangeMake(0, 0), lineOrigins);
    for (int i = 0; i < lineCount; ++i) {
        if (imageData == nil) {
            break;
        }
        CTLineRef line = (__bridge CTLineRef)lines[i];
        NSArray * runObjArray = (NSArray *)CTLineGetGlyphRuns(line);
        for (id runObj in runObjArray) {
            CTRunRef run = (__bridge CTRunRef)runObj;
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (delegate == nil) {
                continue;
            }
            
            NSDictionary * metaDic = CTRunDelegateGetRefCon(delegate);
            if (![metaDic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            
            CGRect runBounds;
            CGFloat ascent;
            CGFloat descent;
            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            runBounds.size.height = ascent + descent;
            
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            runBounds.origin.x = lineOrigins[i].x + xOffset;
            runBounds.origin.y = lineOrigins[i].y;
            runBounds.origin.y -= descent;
            
            CGPathRef pathRef = CTFrameGetPath(self.frameRef);
            CGRect colRect = CGPathGetBoundingBox(pathRef);
            
            CGRect delegateBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
            imageData.imageRect = delegateBounds;
            break;
        }
    }
}
@end
