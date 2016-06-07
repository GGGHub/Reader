//
//  LSYReadParser.m
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYReadParser.h"
#import "LSYReadConfig.h"
@implementation LSYReadParser
+(CTFrameRef)parserContent:(NSString *)content config:(LSYReadConfig *)parser bouds:(CGRect)bounds
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSDictionary *attribute = [self parserAttribute:parser];
    [attributedString setAttributes:attribute range:NSMakeRange(0, content.length)];
    CTFramesetterRef setterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
    CGPathRef pathRef = CGPathCreateWithRect(bounds, NULL);
    CTFrameRef frameRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(0, 0), pathRef, NULL);
    CFRelease(setterRef);
    CFRelease(pathRef);
    return frameRef;
    
}
+(NSDictionary *)parserAttribute:(LSYReadConfig *)config
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = config.fontColor;
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:config.fontSize];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = config.lineSpace;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    dict[NSParagraphStyleAttributeName] = paragraphStyle;
    return [dict copy];
}
+(CFIndex)parserIndexWithPoint:(CGPoint)point frameRef:(CTFrameRef)frameRef
{
    CFIndex index = -1;
    CGPathRef pathRef = CTFrameGetPath(frameRef);
    CGRect bounds = CGPathGetBoundingBox(pathRef);
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frameRef);
    if (!lines) {
        return index;
    }
    NSInteger lineCount = [lines count];
    CGPoint *origins = malloc(lineCount * sizeof(CGPoint)); //给每行的起始点开辟内存
    if (lineCount) {
        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
        for (int i = 0; i<lineCount; i++) {
            CGPoint baselineOrigin = origins[i];
            CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
            CGFloat ascent,descent,linegap; //声明字体的上行高度和下行高度和行距
            CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, &linegap);
            CGRect lineFrame = CGRectMake(baselineOrigin.x, CGRectGetHeight(bounds)-baselineOrigin.y-ascent, lineWidth, ascent+descent+linegap+[LSYReadConfig shareInstance].lineSpace);    //没有转换坐标系左下角为坐标原点 字体高度为上行高度加下行高度
            if (CGRectContainsPoint(lineFrame,point)){
                index = CTLineGetStringIndexForPosition(line, point);
                break;
            }
        }
    }
    free(origins);
    return index;
    
}
+(CGRect)parserRectWithPoint:(CGPoint)point range:(NSRange *)selectRange frameRef:(CTFrameRef)frameRef
{
    CFIndex index = -1;
    CGPathRef pathRef = CTFrameGetPath(frameRef);
    CGRect bounds = CGPathGetBoundingBox(pathRef);
    CGRect rect = CGRectZero;
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frameRef);
    if (!lines) {
        return rect;
    }
    NSInteger lineCount = [lines count];
    CGPoint *origins = malloc(lineCount * sizeof(CGPoint)); //给每行的起始点开辟内存
    if (lineCount) {
        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
        for (int i = 0; i<lineCount; i++) {
            CGPoint baselineOrigin = origins[i];
            CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
            CGFloat ascent,descent,linegap; //声明字体的上行高度和下行高度和行距
            CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, &linegap);
            CGRect lineFrame = CGRectMake(baselineOrigin.x, CGRectGetHeight(bounds)-baselineOrigin.y-ascent, lineWidth, ascent+descent+linegap+[LSYReadConfig shareInstance].lineSpace);    //没有转换坐标系左下角为坐标原点 字体高度为上行高度加下行高度
            if (CGRectContainsPoint(lineFrame,point)){
                CFRange stringRange = CTLineGetStringRange(line);
                index = CTLineGetStringIndexForPosition(line, point);
                CGFloat xStart = CTLineGetOffsetForStringIndex(line, index, NULL);
                CGFloat xEnd;
                //默认选中两个单位
                if (index > stringRange.location+stringRange.length-2) {
                    xEnd = xStart;
                    xStart = CTLineGetOffsetForStringIndex(line,index-2,NULL);
                    (*selectRange).location = index-2;
                }
                else{
                    xEnd = CTLineGetOffsetForStringIndex(line,index+2,NULL);
                    (*selectRange).location = index;
                }
                
                (*selectRange).length = 2;
                rect = CGRectMake(origins[i].x+xStart,baselineOrigin.y-descent,fabs(xStart-xEnd), ascent+descent);
                
                break;
            }
        }
    }
    free(origins);
    return rect;
}
+(NSArray *)parserRectsWithPoint:(CGPoint)point range:(NSRange *)selectRange frameRef:(CTFrameRef)frameRef paths:(NSArray *)paths calRange:(NSRange *)range
{
    CFIndex index = -1;
    CGPathRef pathRef = CTFrameGetPath(frameRef);
    CGRect bounds = CGPathGetBoundingBox(pathRef);
//    CGRect rect = CGRectZero;
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frameRef);

    NSMutableArray *muArr = [NSMutableArray array];
    
    NSInteger lineCount = [lines count];
    CGPoint *origins = malloc(lineCount * sizeof(CGPoint)); //给每行的起始点开辟内存
    index = [self parserIndexWithPoint:point frameRef:frameRef];
    if (index == -1) {
        return paths;
    }
    if (lineCount) {
        
        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
        for (int i = 0; i<lineCount; i++){
            CGPoint baselineOrigin = origins[i];
            CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
            CGFloat ascent,descent,linegap; //声明字体的上行高度和下行高度和行距
            CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, &linegap);
            CFRange stringRange = CTLineGetStringRange(line);
            CGFloat xStart;
            CGFloat xEnd;
            if (index<(*selectRange).location) {
                if (!(stringRange.location>index)&&(stringRange.location+stringRange.length>index)) {
                    xStart = CTLineGetOffsetForStringIndex(line, index, NULL);
                    NSUInteger xEndIndex = ((*selectRange).location+(*selectRange).length-1)>(stringRange.location+stringRange.length-1)?(stringRange.location+stringRange.length-1):((*selectRange).location+(*selectRange).length-1);
                    xEnd = CTLineGetOffsetForStringIndex(line,xEndIndex,NULL);
                    CGRect rect = CGRectMake(origins[i].x+xStart, baselineOrigin.y-descent, fabs(xStart-xEnd), ascent+descent);
                    NSUInteger location = index;
                    NSUInteger length = xEndIndex-index-1;
                    (*range).location = location;
                    (*range).length = length;
                    [muArr addObject:NSStringFromCGRect(rect)];
                    
                }
                
                if (stringRange.location>index && (stringRange.location+stringRange.length)<(*selectRange).location) {
                    xStart = CTLineGetOffsetForStringIndex(line, stringRange.location, NULL);
                    xEnd = CTLineGetOffsetForStringIndex(line, stringRange.location+stringRange.length, NULL);
                    CGRect rect = CGRectMake(origins[i].x+xStart, baselineOrigin.y-descent, fabs(xStart-xEnd), ascent+descent);
                    [muArr addObject:NSStringFromCGRect(rect)];
                }
                if (stringRange.location>index&&!(stringRange.location+stringRange.length<(*selectRange).location)&&!(stringRange.location>(*selectRange).location)) {
                    xStart = CTLineGetOffsetForStringIndex(line, stringRange.location, NULL);
                     NSUInteger xEndIndex = ((*selectRange).location+(*selectRange).length-1)>(stringRange.location+stringRange.length-1)?(stringRange.location+stringRange.length-1):((*selectRange).location+(*selectRange).length-1);
                    xEnd = CTLineGetOffsetForStringIndex(line, xEndIndex, NULL);
                    CGRect rect = CGRectMake(origins[i].x+xStart, baselineOrigin.y-descent, fabs(xStart-xEnd), ascent+descent);
                    NSUInteger location = index;
                    NSUInteger length = xEndIndex-stringRange.location-1;
                    (*range).location = location;
                    (*range).length = length;
                    [muArr addObject:NSStringFromCGRect(rect)];
                }
            }
            else if (index == (*selectRange).location){
                
            }
            else{

                if (!(stringRange.location>(*selectRange).location)&&(stringRange.location+stringRange.length>(*selectRange).location)) {
                    xStart = CTLineGetOffsetForStringIndex(line, (*selectRange).location, NULL);
                    xEnd = CTLineGetOffsetForStringIndex(line,index,NULL);
                    CGRect rect = CGRectMake(origins[i].x+xStart, baselineOrigin.y-descent, fabs(xStart-xEnd), ascent+descent);
                    NSUInteger location = (*selectRange).location;
                    NSUInteger length = index-(*selectRange).location-1;
                    (*range).location = location;
                    (*range).length = length;
                    [muArr addObject:NSStringFromCGRect(rect)];
                    
                }
                
                if (stringRange.location>(*selectRange).location && (stringRange.location+stringRange.length)<index) {
                    xStart = CTLineGetOffsetForStringIndex(line, stringRange.location, NULL);
                    xEnd = CTLineGetOffsetForStringIndex(line, stringRange.location+stringRange.length, NULL);
                    CGRect rect = CGRectMake(origins[i].x+xStart, baselineOrigin.y-descent, fabs(xStart-xEnd), ascent+descent);
                    [muArr addObject:NSStringFromCGRect(rect)];
                }
                if (stringRange.location>(*selectRange).location&&!(stringRange.location+stringRange.length<index)&&!(stringRange.location>index)) {
                    xStart = CTLineGetOffsetForStringIndex(line, stringRange.location, NULL);
                    xEnd = CTLineGetOffsetForStringIndex(line, index, NULL);
                    CGRect rect = CGRectMake(origins[i].x+xStart, baselineOrigin.y-descent, fabs(xStart-xEnd), ascent+descent);
                    NSUInteger location = (*selectRange).location;
                    NSUInteger length = index-(*selectRange).location-1;
                    (*range).location = location;
                    (*range).length = length;
                    [muArr addObject:NSStringFromCGRect(rect)];
                }
            }
            
        }
    }
    free(origins);
    return [muArr copy];
}
+(NSArray *)parserRectsWithPoint:(CGPoint)point range:(NSRange *)selectRange frameRef:(CTFrameRef)frameRef paths:(NSArray *)paths
{
    CFIndex index = -1;
    CGPathRef pathRef = CTFrameGetPath(frameRef);
    CGRect bounds = CGPathGetBoundingBox(pathRef);
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frameRef);
    NSMutableArray *muArr = [NSMutableArray array];
    NSInteger lineCount = [lines count];
    CGPoint *origins = malloc(lineCount * sizeof(CGPoint)); //给每行的起始点开辟内存
    index = [self parserIndexWithPoint:point frameRef:frameRef];
    if (index == -1) {
        return paths;
    }
    if (!(index>(*selectRange).location)) {
        (*selectRange).length = (*selectRange).location-index+(*selectRange).length;
        (*selectRange).location = index;
    }
    else{
        (*selectRange).length = index-(*selectRange).location;
    }
    NSLog(@"selectRange - %@",NSStringFromRange((*selectRange)));
    if (lineCount) {
        
        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
        for (int i = 0; i<lineCount; i++){
            CGPoint baselineOrigin = origins[i];
            CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
            CGFloat ascent,descent,linegap; //声明字体的上行高度和下行高度和行距
            CTLineGetTypographicBounds(line, &ascent, &descent, &linegap);
            CFRange stringRange = CTLineGetStringRange(line);
            CGFloat xStart;
            CGFloat xEnd;
            NSRange drawRange = [self selectRange:NSMakeRange((*selectRange).location, (*selectRange).length) lineRange:NSMakeRange(stringRange.location, stringRange.length)];
            
            if (drawRange.length) {        
                xStart = CTLineGetOffsetForStringIndex(line, drawRange.location, NULL);
                xEnd = CTLineGetOffsetForStringIndex(line, drawRange.location+drawRange.length, NULL);
                CGRect rect = CGRectMake(xStart, baselineOrigin.y-descent, fabs(xStart-xEnd), ascent+descent);
//                 NSLog(@"drawRangeRange - %@",NSStringFromRange(drawRange));
//                NSLog(@"RECT === %.2f line === %d",xStart,i);
                if (rect.size.width ==0 || rect.size.height == 0) {
                    continue;
                }
                [muArr addObject:NSStringFromCGRect(rect)];
            }
            
    }
        
}
    return muArr;
}
+(NSRange)selectRange:(NSRange)selectRange lineRange:(NSRange)lineRange
{
    NSRange range = NSMakeRange(NSNotFound, 0);
    if (lineRange.location>selectRange.location) {
        NSRange tmp = lineRange;
        lineRange = selectRange;
        selectRange = lineRange;
    }
    if (selectRange.location<lineRange.location+lineRange.length) {
        range.location = selectRange.location;
        NSUInteger end = MIN(selectRange.location+selectRange.length, lineRange.location+lineRange.length);
        range.length = end-range.location;
    }
    return range;
}
@end
