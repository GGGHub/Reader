//
//  LSYReadViewController.h
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSYRecordModel.h"
#import "LSYReadView.h"
@interface LSYReadViewController : UIViewController
@property (nonatomic,strong) NSString *content; //显示的内容
@property (nonatomic,strong) LSYRecordModel *recordModel;   //阅读进度

@end
