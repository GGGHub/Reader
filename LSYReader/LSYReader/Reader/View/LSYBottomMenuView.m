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
@property (nonatomic,strong) LSYReadProgressView *progressView;
@property (nonatomic,strong) LSYThemeView *themeView;
@property (nonatomic,strong) UIButton *minSpacing;
@property (nonatomic,strong) UIButton *mediuSpacing;
@property (nonatomic,strong) UIButton *maxSpacing;
@property (nonatomic,strong) UIButton *catalog;
@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) UIButton *lastChapter;
@property (nonatomic,strong) UIButton *nextChapter;
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
    [self addSubview:self.progressView];
    [self addSubview:self.lastChapter];
    [self addSubview:self.nextChapter];
    [self addObserver:self forKeyPath:@"readModel.chapter" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"readModel.page" options:NSKeyValueObservingOptionNew context:NULL];
}
-(UIButton *)catalog
{
    if (!_catalog) {
        _catalog = [LSYReadUtilites commonButtonSEL:@selector(showCatalog) target:self];
        [_catalog setImage:[UIImage imageNamed:@"reader_cover"] forState:UIControlStateNormal];
    }
    return _catalog;
}
-(LSYReadProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[LSYReadProgressView alloc] init];
        _progressView.hidden = YES;
        
    }
    return _progressView;
}
-(UISlider *)slider
{
    if (!_slider) {
        _slider = [[UISlider alloc] init];
        _slider.minimumValue = 0;
        _slider.maximumValue = 100;
        _slider.minimumTrackTintColor = RGB(227, 0, 0);
        _slider.maximumTrackTintColor = [UIColor whiteColor];
        [_slider setThumbImage:[self thumbImage] forState:UIControlStateNormal];
        [_slider setThumbImage:[self thumbImage] forState:UIControlStateHighlighted];
        [_slider addTarget:self action:@selector(changeMsg:) forControlEvents:UIControlEventValueChanged];
        [_slider addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        
    }
    return _slider;
}
-(UIButton *)nextChapter
{
    if (!_nextChapter) {
        _nextChapter = [LSYReadUtilites commonButtonSEL:@selector(jumpChapter:) target:self];
        [_nextChapter setTitle:@"下一章" forState:UIControlStateNormal];
    }
    return _nextChapter;
}
-(UIButton *)lastChapter
{
    if (!_lastChapter) {
        _lastChapter = [LSYReadUtilites commonButtonSEL:@selector(jumpChapter:) target:self];
        [_lastChapter setTitle:@"上一章" forState:UIControlStateNormal];
    }
    return _lastChapter;
}
-(void)jumpChapter:(UIButton *)sender
{
    if (sender == _nextChapter) {
        if ([self.delegate respondsToSelector:@selector(menuViewJumpChapter:page:)]) {
            [self.delegate menuViewJumpChapter:(_readModel.chapter == _readModel.chapterCount-1)?_readModel.chapter:_readModel.chapter+1 page:0];
        }
    }
    else{
        if ([self.delegate respondsToSelector:@selector(menuViewJumpChapter:page:)]) {
            [self.delegate menuViewJumpChapter:_readModel.chapter?_readModel.chapter-1:0 page:0];
        }
        
    }
}
#pragma mark showMsg

-(void)changeMsg:(UISlider *)sender
{
    NSUInteger page =ceil((_readModel.chapterModel.pageCount-1)*sender.value/100.00);
    if ([self.delegate respondsToSelector:@selector(menuViewJumpChapter:page:)]) {
        [self.delegate menuViewJumpChapter:_readModel.chapter page:page];
    }
    
    
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    
    if ([keyPath isEqualToString:@"readModel.chapter"] || [keyPath isEqualToString:@"readModel.page"]) {
        _slider.value = _readModel.page/((float)_readModel.chapterModel.pageCount)*100;
        [_progressView title:_readModel.chapterModel.title progress:[NSString stringWithFormat:@"%.1f%%",_slider.value]];
    }
    else{
        if (_slider.state == UIControlStateNormal) {
            _progressView.hidden = YES;
        }
        else if(_slider.state == UIControlStateHighlighted){
            _progressView.hidden = NO;
        }
    }
    
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
    _slider.frame = CGRectMake(50, 20, ViewSize(self).width-100, 30);
    _lastChapter.frame = CGRectMake(5, 20, 40, 30);
    _nextChapter.frame = CGRectMake(DistanceFromLeftGuiden(_slider)+5, 20, 40, 30);
    
    _catalog.frame = CGRectMake(10, DistanceFromTopGuiden(_slider), 30, 30);
    _progressView.frame = CGRectMake(60, -60, ViewSize(self).width-120, 50);
    
}
-(void)dealloc
{
    [_slider removeObserver:self forKeyPath:@"highlighted"];
    [self removeObserver:self forKeyPath:@"readModel.chapter"];
    [self removeObserver:self forKeyPath:@"readModel.page"];
}
@end

@implementation LSYThemeView

@end
@interface LSYReadProgressView ()
@property (nonatomic,strong) UILabel *label;
@end
@implementation LSYReadProgressView
- (instancetype)init
{
    self = [super init];
    if (self) {
         [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
        [self addSubview:self.label];
    }
    return self;
}
-(UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:[LSYReadConfig shareInstance].fontSize];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.numberOfLines = 0;
    }
    return _label;
}
-(void)title:(NSString *)title progress:(NSString *)progress
{
    _label.text = [NSString stringWithFormat:@"%@\n%@",title,progress];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _label.frame = self.bounds;
}
@end