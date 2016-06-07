//
//  LSYChapterVC.h
//  LSYReader
//
//  Created by okwei on 16/6/2.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSYReadModel.h"
@protocol LSYCatalogViewControllerDelegate;
@interface LSYChapterVC : UIViewController
@property (nonatomic,strong) LSYReadModel *readModel;
@property (nonatomic,weak) id<LSYCatalogViewControllerDelegate>delegate;

@end
