//
//  LSYMenuView.h
//  LSYReader
//
//  Created by Labanotation on 16/6/1.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSYMenuView;
@class LSYBottomMenuView;
@class LSYTopMenuView;
@protocol LSYMenuViewDelegate <NSObject>
@optional
-(void)menuViewDidHidden:(LSYMenuView *)menu;
-(void)menuViewDidAppear:(LSYMenuView *)menu;
-(void)menuViewInvokeCatalog:(LSYBottomMenuView *)bottomMenu;
@end
@interface LSYMenuView : UIView
@property (nonatomic,weak) id<LSYMenuViewDelegate> delegate;
-(void)showAnimation:(BOOL)animation;
-(void)hiddenAnimation:(BOOL)animation;
@end
