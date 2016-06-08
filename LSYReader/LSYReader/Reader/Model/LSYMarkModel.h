//
//  LSYMarkModel.h
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSYRecordModel.h"
@interface LSYMarkModel : NSObject<NSCoding>
@property (nonatomic,strong) NSDate *date;
@property (nonatomic,strong) LSYRecordModel *recordModel;
@end
