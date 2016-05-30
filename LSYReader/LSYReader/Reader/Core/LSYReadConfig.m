//
//  LSYReadConfig.m
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYReadConfig.h"

@implementation LSYReadConfig
+(instancetype)shareInstance
{
    static LSYReadConfig *readConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        readConfig = [[self alloc] init];
    });
    return readConfig;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _lineSpace = 10.0f;
        _fontSize = 14.0f;
        _fontColor = [UIColor whiteColor];
    }
    return self;
}
@end
