//
//  LSYTopMenuView.m
//  LSYReader
//
//  Created by Labanotation on 16/6/1.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYTopMenuView.h"
@interface LSYTopMenuView ()
@property (nonatomic,strong) UIButton *back;
@property (nonatomic,strong) UIButton *more;
@end
@implementation LSYTopMenuView
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
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [self addSubview:self.back];
    [self addSubview:self.more];
}
-(UIButton *)back
{
    if (!_back) {
        _back = [LSYReadUtilites commonButtonSEL:@selector(backView) target:self];
        [_back setImage:[UIImage imageNamed:@"bg_back_white"] forState:UIControlStateNormal];
    }
    return _back;
}
-(UIButton *)more
{
    if (!_more) {
        _more = [LSYReadUtilites commonButtonSEL:@selector(moreOption) target:self];
        [_more setImage:[UIImage imageNamed:@"reader_more"] forState:UIControlStateNormal];
    }
    return _more;
}
-(void)moreOption
{
    [LSYReadUtilites showAlert:@"more click!"];
}
-(void)backView
{
    [[LSYReadUtilites getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _back.frame = CGRectMake(0, 24, 40, 40);
    _more.frame = CGRectMake(ViewSize(self).width-50, 24, 40, 40);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
