//
//  LSYMenuView.m
//  LSYReader
//
//  Created by Labanotation on 16/6/1.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYMenuView.h"
#import "LSYTopMenuView.h"
#import "LSYBottomMenuView.h"
#define AnimationDelay 0.5f
@interface LSYMenuView ()
@property (nonatomic,strong) LSYTopMenuView *topView;
@property (nonatomic,strong) LSYBottomMenuView *bottomView;
@end
@implementation LSYMenuView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
-(void)setup
{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.topView];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSelf)]];
}
-(LSYTopMenuView *)topView
{
    if (!_topView) {
        _topView = [[LSYTopMenuView alloc] init];
    }
    return _topView;
}
-(void)hiddenSelf
{
    [self hiddenAnimation:YES];
}
-(void)showAnimation:(BOOL)animation
{
    self.hidden = NO;
    [UIView animateWithDuration:animation?AnimationDelay:0 animations:^{
        _topView.frame = CGRectMake(0, 0, ViewSize(self).width, 64);
    } completion:^(BOOL finished) {
        
    }];
    if ([self.delegate respondsToSelector:@selector(menuViewDidAppear:)]) {
        [self.delegate menuViewDidAppear:self];
    }
}
-(void)hiddenAnimation:(BOOL)animation
{
    [UIView animateWithDuration:animation?AnimationDelay:0 animations:^{
        _topView.frame = CGRectMake(0, -64, ViewSize(self).width, 64);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    if ([self.delegate respondsToSelector:@selector(menuViewDidHidden:)]) {
        [self.delegate menuViewDidHidden:self];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _topView.frame = CGRectMake(0, -64, ViewSize(self).width,64);
}
@end
