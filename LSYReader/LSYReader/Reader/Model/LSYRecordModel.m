//
//  LSYRecordModel.m
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYRecordModel.h"

@implementation LSYRecordModel
-(id)copyWithZone:(NSZone *)zone
{
    LSYRecordModel *recordModel = [[LSYRecordModel allocWithZone:zone]init];
    recordModel.chapterModel = [self.chapterModel copy];
    recordModel.page = self.page;
    recordModel.chapter = self.chapter;
    return recordModel;
}
@end
