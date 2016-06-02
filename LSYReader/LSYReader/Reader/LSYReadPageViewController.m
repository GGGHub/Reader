//
//  LSYReadPageViewController.m
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYReadPageViewController.h"
#import "LSYReadViewController.h"
#import "LSYChapterModel.h"
#import "LSYMenuView.h"
@interface LSYReadPageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,LSYMenuViewDelegate>
@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (nonatomic,getter=isShowBar) BOOL showBar; //是否显示状态栏
@property (nonatomic,strong) LSYMenuView *menuView; //菜单栏
@end

@implementation LSYReadPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchData];
    [self addChildViewController:self.pageViewController];
    [_pageViewController setViewControllers:@[[self readViewWithChapter:_model.record.chapter page:_model.record.page]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showToolMenu)]];
    [self.view addSubview:self.menuView];
}
-(BOOL)prefersStatusBarHidden
{
    return !_showBar;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)showToolMenu
{
    
    [self.menuView showAnimation:YES];
    
}
-(void)fetchData
{
    if (!_model) {
        _model = [[LSYReadModel alloc] initWithContent:[LSYReadUtilites encodeWithURL:_resourceURL]];
    }
}
-(LSYMenuView *)menuView
{
    if (!_menuView) {
        _menuView = [[LSYMenuView alloc] init];
        _menuView.hidden = YES;
        _menuView.delegate = self;
    }
    return _menuView;
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
#pragma mark - Menu View Delegate
-(void)menuViewDidHidden:(LSYMenuView *)menu
{
     _showBar = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}
-(void)menuViewDidAppear:(LSYMenuView *)menu
{
    _showBar = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    
}
-(void)menuViewInvokeCatalog:(LSYBottomMenuView *)bottomMenu
{
    [LSYReadUtilites showAlert:@"open the catalog!"];
}
#pragma mark - Create Read View Controller

-(LSYReadViewController *)readViewWithChapter:(NSUInteger)chapter page:(NSUInteger)page{
    _model.record.chapterModel = _model.chapters[chapter];
    _model.record.chapter = chapter;
    _model.record.page = page;
    LSYReadViewController *readView = [[LSYReadViewController alloc] init];
    readView.recordModel = _model.record;
    readView.content = [_model.chapters[chapter] stringOfPage:page];
    return readView;
}
#pragma mark -PageViewController DataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    LSYReadViewController *readViewController = (LSYReadViewController *)viewController;
    NSUInteger page = readViewController.recordModel.page;
    NSUInteger chapter = readViewController.recordModel.chapter;
    if (chapter==0 &&page == 0) {
        return nil;
    }
    if (page==0) {
        chapter--;
        page = _model.chapters[chapter].pageCount-1;
    }
    else{
        page--;
    }
    return [self readViewWithChapter:chapter page:page];
    
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    LSYReadViewController *readViewController = (LSYReadViewController *)viewController;
    NSUInteger page = readViewController.recordModel.page;
    NSUInteger chapter = readViewController.recordModel.chapter;
    
    if (page == _model.chapters.lastObject.pageCount-1 && chapter == _model.chapters.count-1) {
        return nil;
    }
    if (page == _model.chapters[chapter].pageCount-1) {
        chapter++;
        page = 0;
    }
    else{
        page++;
    }
    return [self readViewWithChapter:chapter page:page];
}
#pragma mark -PageViewController Delegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{

}
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _pageViewController.view.frame = self.view.frame;
    _menuView.frame = self.view.frame;
}
@end
