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
#import "LSYReadModel.h"
@class LSYReadViewController;
@protocol LSYReadViewControllerDelegate <NSObject>
-(void)readViewEditeding:(LSYReadViewController *)readView;
-(void)readViewEndEdit:(LSYReadViewController *)readView;
@end
@interface LSYReadViewController : UIViewController
@property (nonatomic,strong) NSString *content; //显示的内容
@property (nonatomic,strong) id epubFrameRef;  //epub显示内容
@property (nonatomic,strong) NSArray *imageArray;  //epub显示的图片
@property (nonatomic,assign) ReaderType type;   //文本类型
@property (nonatomic,strong) LSYRecordModel *recordModel;   //阅读进度
@property (nonatomic,strong) LSYReadView *readView;
@property (nonatomic,weak) id<LSYReadViewControllerDelegate>delegate;
@end
