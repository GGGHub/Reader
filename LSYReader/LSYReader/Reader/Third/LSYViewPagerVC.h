//
//  LSYViewPagerVC.h
//  LSYViewPagerVC
//  github:https://github.com/GGGHub/ViewPager
//  Created by okwei on 15/10/9.
//  Copyright © 2015年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSYViewPagerVC;
#pragma mark View Pager Delegate
@protocol  LSYViewPagerVCDelegate <NSObject>
@optional
/**
 控制器结束滑动时调用该方法，返回当前显示的视图控制器
 */
-(void)viewPagerViewController:(LSYViewPagerVC *)viewPager didFinishScrollWithCurrentViewController:(UIViewController *)viewController;
/**
 控制器将要开始滑动时调用该方法，返回当前将要滑动的视图控制器
 */
-(void)viewPagerViewController:(LSYViewPagerVC *)viewPager willScrollerWithCurrentViewController:(UIViewController *)ViewController;

@end

#pragma mark View Pager DataSource
@protocol LSYViewPagerVCDataSource <NSObject>

@required
/**
 设置返回需要滑动的控制器数量
 */
-(NSInteger)numberOfViewControllersInViewPager:(LSYViewPagerVC *)viewPager;
/**
 用来设置当前索引下返回的控制器
 */
-(UIViewController *)viewPager:(LSYViewPagerVC *)viewPager indexOfViewControllers:(NSInteger)index;
/**
 给每一个控制器设置一个标题
 */
-(NSString *)viewPager:(LSYViewPagerVC *)viewPager titleWithIndexOfViewControllers:(NSInteger)index;

@optional
/**
 设置控制器标题按钮的样式，如果不设置将使用默认的样式，选择为红色，不选中为黑色带有选中下划线
 */
-(UIButton *)viewPager:(LSYViewPagerVC *)viewPager titleButtonStyle:(NSInteger)index;
/**
 设置控制器上面标题的高度
 */
-(CGFloat)heightForTitleOfViewPager:(LSYViewPagerVC *)viewPager;
/**
 如果有需要还要在控制器标题顶上添加视图。用来设置控制器标题上面的头部视图
 */
-(UIView *)headerViewForInViewPager:(LSYViewPagerVC *)viewPager;
/**
 设置头部视图的高度
 */
-(CGFloat)heightForHeaderOfViewPager:(LSYViewPagerVC *)viewPager;
@end

@interface LSYViewPagerVC : UIViewController
@property (nonatomic,weak) id<LSYViewPagerVCDataSource>dataSource;
@property (nonatomic,weak) id<LSYViewPagerVCDelegate>delegate;
@property (nonatomic) BOOL forbidGesture;
/**
 用来刷新ViewPager
 */
-(void)reload;
@end


#pragma mark View Controller Title Button

@interface LSYViewPagerTitleButton : UIButton

@end