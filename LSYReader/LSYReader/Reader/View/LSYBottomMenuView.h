//
//  LSYBottomMenuView.h
//  LSYReader
//
//  Created by Labanotation on 16/6/1.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSYRecordModel.h"
@protocol LSYMenuViewDelegate;

@interface LSYBottomMenuView : UIView
@property (nonatomic,weak) id<LSYMenuViewDelegate>delegate;
@property (nonatomic,strong) LSYRecordModel *readModel;
@end

@interface LSYThemeView : UIView

@end

@interface LSYReadProgressView : UIView
-(void)title:(NSString *)title progress:(NSString *)progress;
@end
