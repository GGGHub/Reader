//
//  LSYBottomMenuView.m
//  LSYReader
//
//  Created by Labanotation on 16/6/1.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYBottomMenuView.h"
#import "LSYMenuView.h"
@interface LSYBottomMenuView ()
@property (nonatomic,strong) UIButton *bigFont;
@property (nonatomic,strong) UIButton *smallFont;
@property (nonatomic,strong) UILabel *fontLabel;
//@property (nonatomic,strong) LSYReadProgressView *progressView;
@property (nonatomic,strong) LSYThemeView *themeView;
@property (nonatomic,strong) UIButton *minSpacing;
@property (nonatomic,strong) UIButton *mediuSpacing;
@property (nonatomic,strong) UIButton *maxSpacing;
@property (nonatomic,strong) UIButton *catalog;
@property (nonatomic,strong) UISlider *slider;
@end
@implementation LSYBottomMenuView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
-(void)setup{
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [self addSubview:self.slider];
    [self addSubview:self.catalog];
}
-(UIButton *)catalog
{
    if (!_catalog) {
        _catalog = [LSYReadUtilites commonButtonSEL:@selector(showCatalog) target:self];
        [_catalog setImage:[UIImage imageNamed:@"reader_cover"] forState:UIControlStateNormal];
    }
    return _catalog;
}
-(UISlider *)slider
{
    if (!_slider) {
        _slider = [[UISlider alloc] init];
        _slider.minimumValue = 0;
        _slider.maximumValue = 1;
        _slider.minimumTrackTintColor = RGB(227, 0, 0);
        _slider.maximumTrackTintColor = [UIColor whiteColor];
        [_slider setThumbImage:[self thumbImage] forState:UIControlStateNormal];
        [_slider setThumbImage:[self thumbImage] forState:UIControlStateHighlighted];
    }
    return _slider;
}
-(UIImage *)thumbImage
{
    CGRect rect = CGRectMake(0, 0, 15,15);
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 5;
    [path addArcWithCenter:CGPointMake(rect.size.width/2, rect.size.height/2) radius:7.5 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    {
        [[UIColor whiteColor] setFill];
        [path fill];
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    return image;
}
-(void)showCatalog
{
    if ([self.delegate respondsToSelector:@selector(menuViewInvokeCatalog:)]) {
        [self.delegate menuViewInvokeCatalog:self];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _slider.frame = CGRectMake(40, 20, ViewSize(self).width-80, 30);
    _catalog.frame = CGRectMake(10, DistanceFromTopGuiden(_slider), 30, 30);
    
}
@end

@implementation LSYThemeView

@end
@implementation LSYReadProgressView

@end