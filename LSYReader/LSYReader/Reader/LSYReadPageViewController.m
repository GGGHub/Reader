//
//  LSYReadPageViewController.m
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYReadPageViewController.h"
#import "LSYReadViewController.h"
@interface LSYReadPageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (nonatomic,strong) UIPageViewController *pageViewController;

@end

@implementation LSYReadPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViewController:self.pageViewController];
    [_pageViewController setViewControllers:@[[self createReadViewController]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}
-(UIPageViewController *)pageViewController
{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        [self.view addSubview:_pageViewController.view];
    }
    return _pageViewController;
}
#pragma mark - Create Read View Controller
-(LSYReadViewController *)createReadViewController
{
    LSYReadViewController *readView = [[LSYReadViewController alloc] init];
    readView.content = [NSString stringWithContentsOfURL:_resourceURL encoding:NSUTF8StringEncoding error:nil];
    return readView;
}
#pragma mark -PageViewController DataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    return [self createReadViewController];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    return [self createReadViewController];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _pageViewController.view.frame = self.view.frame;
}
@end
