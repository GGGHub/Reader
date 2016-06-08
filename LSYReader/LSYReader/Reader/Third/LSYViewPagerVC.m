//
//  LSYViewPagerVC.m
//  LSYViewPagerVC
//  github:https://github.com/GGGHub/ViewPager
//  Created by okwei on 15/10/9.
//  Copyright © 2015年 okwei. All rights reserved.
//

#import "LSYViewPagerVC.h"

@interface LSYViewPagerVC ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
{
    NSInteger numberOfViewController;   //VC的总数量
    NSArray *arrayOfViewController;     //存放VC的数组
    NSArray *arrayOfViewControllerButton;    //存放VC Button的数组
    UIView *headerView;     //头部视图
    CGRect oldRect;   //用来保存title布局的Rect
    LSYViewPagerTitleButton *oldButton;
    NSInteger pendingVCIndex;   //将要显示的View Controller 索引
    
}
@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (nonatomic,strong) UIScrollView *titleBackground;
@end

@implementation LSYViewPagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.view addSubview:self.titleBackground];
}
-(UIPageViewController *)pageViewController
{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;

    }
    return _pageViewController;
}
-(UIScrollView *)titleBackground
{
    if (!_titleBackground) {
        _titleBackground = [[UIScrollView alloc] init];
        _titleBackground.showsHorizontalScrollIndicator = NO;
        _titleBackground.showsVerticalScrollIndicator = NO;
    }
    return _titleBackground;
}
-(void)setDataSource:(id<LSYViewPagerVCDataSource>)dataSource
{
    _dataSource = dataSource;
    [self reload];
    
}
-(void)setForbidGesture:(BOOL)forbidGesture
{
    _forbidGesture = forbidGesture;
    for (UIScrollView *view in self.pageViewController.view.subviews) {
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            
            view.scrollEnabled = !forbidGesture;
        }
    }
    
}
-(void)reload
{
    if ([self.dataSource respondsToSelector:@selector(numberOfViewControllersInViewPager:)]) {
        oldRect = CGRectZero;
        if (![self.dataSource numberOfViewControllersInViewPager:self]) {
             @throw [NSException exceptionWithName:@"viewControllerException" reason:@"设置要返回的控制器数量" userInfo:nil];
        }
        numberOfViewController = [self.dataSource numberOfViewControllersInViewPager:self];
        NSMutableArray *mutableArrayOfVC = [NSMutableArray array];
        NSMutableArray *mutableArrayOfBtn = [NSMutableArray array];
        for (int i = 0; i<numberOfViewController; i++) {
            if ([self.dataSource respondsToSelector:@selector(viewPager:indexOfViewControllers:)]) {
                if (![[self.dataSource viewPager:self indexOfViewControllers:i] isKindOfClass:[UIViewController class]]) {
                    @throw [NSException exceptionWithName:@"viewControllerException" reason:[NSString stringWithFormat:@"第%d个分类下的控制器必须是UIViewController类型或者其子类",i+1] userInfo:nil];
                }
                else
                {
                    [mutableArrayOfVC addObject:[self.dataSource viewPager:self indexOfViewControllers:i]];
                }
                
            }
            else{
                @throw [NSException exceptionWithName:@"viewControllerException" reason:@"设置要显示的控制器" userInfo:nil];
            }
            if ([self.dataSource respondsToSelector:@selector(viewPager:titleWithIndexOfViewControllers:)]) {
                NSString *buttonTitle = [self.dataSource viewPager:self titleWithIndexOfViewControllers:i];
                if (arrayOfViewControllerButton.count > i) {
                    [[arrayOfViewControllerButton objectAtIndex:i] removeFromSuperview];
                }
                UIButton *button;
                if ([self.dataSource respondsToSelector:@selector(viewPager:titleButtonStyle:)]) {
                    if (![[self.dataSource viewPager:self titleButtonStyle:i] isKindOfClass:[UIButton class]]) {
                         @throw [NSException exceptionWithName:@"titleException" reason:[NSString stringWithFormat:@"第%d的标题类型必须为UIButton或者其子类",i+1] userInfo:nil];
                    }
                    button = [self.dataSource viewPager:self titleButtonStyle:i];
                }
                else
                {
                    button = [[LSYViewPagerTitleButton alloc] init];
                }
                [button addTarget:self action:@selector(p_titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
                
                button.frame = CGRectMake(oldRect.origin.x+oldRect.size.width, 0, [self p_fontText:buttonTitle withFontHeight:20], [self.dataSource respondsToSelector:@selector(heightForTitleOfViewPager:)]?[self.dataSource heightForTitleOfViewPager:self]:0);
                oldRect = button.frame;
                [button setTitle:buttonTitle forState:UIControlStateNormal];
                [mutableArrayOfBtn addObject:button];
                [_titleBackground addSubview:button];
                if (i == 0) {
                    oldButton = [mutableArrayOfBtn objectAtIndex:0];
                    oldButton.selected = YES;
                }
                
            }
            else
            {
                @throw [NSException exceptionWithName:@"titleException" reason:@"每个控制器必须设置一个标题" userInfo:nil];
            }
            
            
        }
        if (mutableArrayOfBtn.count && ((UIButton *)mutableArrayOfBtn.lastObject).frame.origin.x + ((UIButton *)mutableArrayOfBtn.lastObject).frame.size.width<self.view.frame.size.width) //当所有按钮尺寸小于屏幕宽度的时候要重新布局
        {
            oldRect = CGRectZero;
            CGFloat padding = self.view.frame.size.width-(((UIButton *)mutableArrayOfBtn.lastObject).frame.origin.x + ((UIButton *)mutableArrayOfBtn.lastObject).frame.size.width);
            for (LSYViewPagerTitleButton *button in mutableArrayOfBtn) {
                button.frame = CGRectMake(oldRect.origin.x+oldRect.size.width, 0,button.frame.size.width+padding/mutableArrayOfBtn.count, [self.dataSource respondsToSelector:@selector(heightForTitleOfViewPager:)]?[self.dataSource heightForTitleOfViewPager:self]:0);
                oldRect = button.frame;
            }
        }
        arrayOfViewControllerButton = [mutableArrayOfBtn copy];
        arrayOfViewController = [mutableArrayOfVC copy];
    }
    if ([self.dataSource respondsToSelector:@selector(headerViewForInViewPager:)]) {
        [headerView removeFromSuperview];
        headerView = [self.dataSource headerViewForInViewPager:self];
        [self.view addSubview:headerView];
    }
    if (arrayOfViewController.count) {
        [_pageViewController setViewControllers:@[arrayOfViewController.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
}
-(void)p_titleButtonClick:(LSYViewPagerTitleButton *)sender
{
    oldButton.selected = NO;
    sender.selected = YES;
    oldButton = sender;
    NSInteger index = [arrayOfViewControllerButton indexOfObject:sender];
    [_pageViewController setViewControllers:@[arrayOfViewController[index]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
}
-(void)p_titleButtonConvert:(LSYViewPagerTitleButton *)sender
{
    oldButton.selected = NO;
    sender.selected = YES;
    oldButton = sender;
}
#pragma mark -UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        if (pendingVCIndex != [arrayOfViewController indexOfObject:previousViewControllers[0]]) {
            [self p_titleSelectIndex:pendingVCIndex];
            if ([self.delegate respondsToSelector:@selector(viewPagerViewController:didFinishScrollWithCurrentViewController:)]) {
                [self.delegate viewPagerViewController:self didFinishScrollWithCurrentViewController:[arrayOfViewController objectAtIndex:pendingVCIndex]];
            }
        }
        
    }
}
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    pendingVCIndex = [arrayOfViewController indexOfObject:pendingViewControllers[0]];
    if ([self.delegate respondsToSelector:@selector(viewPagerViewController:willScrollerWithCurrentViewController:)]) {
        [self.delegate viewPagerViewController:self willScrollerWithCurrentViewController:pageViewController.viewControllers[0]];
    }
}
#pragma mark -UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [arrayOfViewController indexOfObject:viewController];
    if (index == 0) {
        return nil;
    }
    else{
        
        return arrayOfViewController[--index];
        
    }
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [arrayOfViewController indexOfObject:viewController];
    if (index == arrayOfViewController.count-1) {
        return nil;
    }
    else{
        
        return arrayOfViewController[++index];
    }
}
-(void)p_titleSelectIndex:(NSInteger)index
{
    [self p_titleButtonConvert:arrayOfViewControllerButton[index]];
}
-(void)viewDidLayoutSubviews
{
    headerView.frame = CGRectMake(0, self.topLayoutGuide.length, self.view.frame.size.width,[self.dataSource respondsToSelector:@selector(heightForHeaderOfViewPager:)]?[self.dataSource heightForHeaderOfViewPager:self]:0);
    _titleBackground.frame = CGRectMake(0, (headerView.frame.size.height)?headerView.frame.origin.y+headerView.frame.size.height:self.topLayoutGuide.length, self.view.frame.size.width,[self.dataSource respondsToSelector:@selector(heightForTitleOfViewPager:)]?[self.dataSource heightForTitleOfViewPager:self]:0);
    if (arrayOfViewControllerButton.count) {
        
        _titleBackground.contentSize = CGSizeMake(((UIButton *)arrayOfViewControllerButton.lastObject).frame.size.width+((UIButton *)arrayOfViewControllerButton.lastObject).frame.origin.x, _titleBackground.frame.size.height);
    }
    _pageViewController.view.frame = CGRectMake(0, _titleBackground.frame.origin.y+_titleBackground.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-(_titleBackground.frame.origin.y+_titleBackground.frame.size.height));
}
#pragma maek 计算字体宽度
-(CGFloat)p_fontText:(NSString *)text withFontHeight:(CGFloat)height
{
    CGFloat padding = 20;
    NSDictionary *fontAttribute = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
    CGSize fontSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:fontAttribute context:nil].size;
    return fontSize.width+padding;
}

@end

#pragma -mark View Controller Title Button

@implementation LSYViewPagerTitleButton
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}
-(void)drawRect:(CGRect)rect
{
    if (self.selected) {
        CGFloat lineWidth = 2.5;
        CGColorRef color = self.titleLabel.textColor.CGColor;
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(ctx, color);
        CGContextSetLineWidth(ctx, lineWidth);
        CGContextMoveToPoint(ctx, 0, self.frame.size.height-lineWidth);
        CGContextAddLineToPoint(ctx, self.frame.size.width, self.frame.size.height-lineWidth);
        CGContextStrokePath(ctx);
    }
}
@end
