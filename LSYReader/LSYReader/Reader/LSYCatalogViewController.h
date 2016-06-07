//
//  LSYCatalogViewController.h
//  LSYReader
//
//  Created by okwei on 16/6/2.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYViewPagerVC.h"
@class LSYCatalogViewController;
@protocol LSYCatalogViewControllerDelegate <NSObject>
@optional
-(void)catalog:(LSYCatalogViewController *)catalog didSelectChapter:(NSUInteger)chapter page:(NSUInteger)page;
@end
@interface LSYCatalogViewController : LSYViewPagerVC
@property (nonatomic,strong) LSYReadModel *readModel;
@property (nonatomic,weak) id<LSYCatalogViewControllerDelegate>catalogDelegate;
@end
