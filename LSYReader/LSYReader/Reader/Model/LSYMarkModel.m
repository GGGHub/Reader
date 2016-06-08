//
//  LSYMarkModel.m
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYMarkModel.h"

@implementation LSYMarkModel
/***
 
 @property (nonatomic,strong) NSDate *date;
 @property (nonatomic,strong) LSYRecordModel *recordModel;
 */
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.recordModel forKey:@"recordModel"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.recordModel = [aDecoder decodeObjectForKey:@"recordModel"];
    }
    return self;
}
@end
