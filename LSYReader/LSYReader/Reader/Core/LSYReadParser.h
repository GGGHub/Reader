//
//  LSYReadParser.h
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSYReadConfig.h"
@interface LSYReadParser : NSObject
+(CTFrameRef)parserContent:(NSString *)content config:(LSYReadConfig *)parser bouds:(CGRect)bounds;
+(NSDictionary *)parserAttribute:(LSYReadConfig *)config;
//根据触碰点获取当前文字的索引
+(CFIndex)parserIndexWithPoint:(CGPoint)point frameRef:(CTFrameRef)frameRef;
/**
 *  根据触碰点获取默认选中区域
 *  @range 选中范围
 *  @return 选中区域
 */
+(CGRect)parserRectWithPoint:(CGPoint)point range:(NSRange *)selectRange frameRef:(CTFrameRef)frameRef;
/**
 *  根据触碰点获取默认选中区域
 *  @range 选中范围
 *  @return 选中区域的集合
 */
+(NSArray *)parserRectsWithPoint:(CGPoint)point range:(NSRange *)selectRange frameRef:(CTFrameRef)frameRef paths:(NSArray *)paths;
/**
 *  根据触碰点获取默认选中区域
 *  @range 选中范围
 *  @return 选中区域的集合
 *  @direction 滑动方向 (0 -- 从左侧滑动 1-- 从右侧滑动)
 */
+(NSArray *)parserRectsWithPoint:(CGPoint)point range:(NSRange *)selectRange frameRef:(CTFrameRef)frameRef paths:(NSArray *)paths direction:(BOOL) direction;
@end
