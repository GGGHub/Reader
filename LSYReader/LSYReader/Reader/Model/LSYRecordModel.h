//
//  LSYRecordModel.h
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSYChapterModel.h"
@interface LSYRecordModel : NSObject <NSCopying,NSCoding>
@property (nonatomic,strong) LSYChapterModel *chapterModel;  //阅读的章节
@property (nonatomic) NSUInteger page;  //阅读的页数
@property (nonatomic) NSUInteger chapter;    //阅读的章节数
@property (nonatomic) NSUInteger chapterCount;  //总章节数
@end
