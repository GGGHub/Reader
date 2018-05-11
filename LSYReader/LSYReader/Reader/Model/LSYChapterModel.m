//
//  LSYChapterModel.m
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYChapterModel.h"
#import "LSYReadConfig.h"
#import "LSYReadParser.h"
#import "NSString+HTML.h"
//#include <vector>

@interface LSYChapterModel ()
@property (nonatomic,strong) NSMutableArray *pageArray;
@end

@implementation LSYChapterModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _pageArray = [NSMutableArray array];
    }
    return self;
}
//-(NSString *)chapterpath {
//    NSLog(@"----------------------%@",_chapterpath);
//    return [kDocuments stringByAppendingPathComponent:_chapterpath];
//}
//-(NSString *)epubImagePath {
//    return [kDocuments stringByAppendingPathComponent:_epubImagePath];
//}
+(id)chapterWithEpub:(NSString *)chapterpath title:(NSString *)title imagePath:(NSString *)path
{
    LSYChapterModel *model = [[LSYChapterModel alloc] init];

    model.title = title;
    model.epubImagePath = path;
    model.type = ReaderEpub;
    model.chapterpath = chapterpath;
    NSString * fullPath= [kDocuments stringByAppendingPathComponent:chapterpath];
    NSString* html = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:fullPath]] encoding:NSUTF8StringEncoding];
    model.html = html;
    model.content = [html stringByConvertingHTMLToPlainText];
    [model parserEpubToDictionary];
    [model paginateEpubWithBounds:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width-LeftSpacing-RightSpacing, [UIScreen mainScreen].bounds.size.height-TopSpacing-BottomSpacing)];
    return model;
}

-(void)parserEpubToDictionary
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *imageArray = [NSMutableArray array];
    NSScanner *scanner = [NSScanner scannerWithString:self.content];
    NSMutableString *newString = [[NSMutableString alloc] init];
    while (![scanner isAtEnd]) {
        if ([scanner scanString:@"<img>" intoString:NULL]) {
            NSString *img;
            [scanner scanUpToString:@"</img>" intoString:&img];
            NSString *imageString = [[kDocuments stringByAppendingPathComponent:self.epubImagePath] stringByAppendingPathComponent:img];
            UIImage *image = [UIImage imageWithContentsOfFile:imageString];
            
            CGFloat width = ScreenSize.width - LeftSpacing - RightSpacing;
            CGFloat height = ScreenSize.height - TopSpacing - BottomSpacing;
            CGFloat scale = image.size.width / width;
            CGFloat realHeight = image.size.height / scale;
            CGSize size = CGSizeMake(width, realHeight);

            if (size.height > (height - 20)) {
                size.height = height - 20;
            }
            [array addObject:@{@"type":@"img",@"content":imageString?imageString:@"",@"width":@(size.width),@"height":@(size.height)}];
            //存储图片信息
            LSYImageData *imageData = [[LSYImageData alloc] init];
            imageData.url = imageString?imageString:@"";
            if (imageArray.count) {
                imageData.position = newString.length + imageArray.count;
            } else {
                imageData.position = newString.length;
            }
//            imageData.imageRect = CGRectMake(0, 0, size.width, size.height);
            [imageArray addObject:imageData];
            
//            [newString appendString:@" "];
            [scanner scanString:@"</img>" intoString:NULL];
        }
        else{
            NSString *content;
            if ([scanner scanUpToString:@"<img>" intoString:&content]) {
                [array addObject:@{@"type":@"txt",@"content":content?content:@""}];
                [newString appendString:content?content:@""];
            }
        }
    }
    self.epubContent = [array copy];
    self.imageArray = [imageArray copy];
//    self.content = [newString copy];
}
-(void)paginateEpubWithBounds:(CGRect)bounds
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    for (NSDictionary *dic in _epubContent) {
        if ([dic[@"type"] isEqualToString:@"txt"]) {
            //解析文本
            NSLog(@"--%.2f",[LSYReadConfig shareInstance].fontSize);
            NSDictionary *attr = [LSYReadParser parserAttribute:[LSYReadConfig shareInstance]];
            NSMutableAttributedString *subString = [[NSMutableAttributedString alloc] initWithString:dic[@"content"] attributes:attr];
            [attrString appendAttributedString:subString];
        }
        else if ([dic[@"type"] isEqualToString:@"img"]){
            //解析图片
            NSAttributedString *subString = [LSYReadParser parserEpubImageWithSize:dic config:[LSYReadConfig shareInstance]];
            [attrString appendAttributedString:subString];

        }
    }    
    CTFramesetterRef setterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
    CGPathRef pathRef = CGPathCreateWithRect(bounds, NULL);
    CTFrameRef frameRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(0, 0), pathRef, NULL);
    CFRange rang1 = CTFrameGetVisibleStringRange(frameRef);
    CFRange rang2 = CTFrameGetStringRange(frameRef);
    
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *stringArr = [NSMutableArray array];
    if (rang1.length+rang1.location == rang2.location+rang2.length) {
        CTFrameRef subFrameRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(rang1.location,0), pathRef, NULL);
        CFRange range = CTFrameGetVisibleStringRange(subFrameRef);
        rang1 = CFRangeMake(range.location+range.length, 0);
        [array addObject:(__bridge id)subFrameRef];
        [stringArr addObject:[[attrString string] substringWithRange:NSMakeRange(range.location, range.length)]];
        
        CFRelease(subFrameRef);
    }
    else{
        while (rang1.length+rang1.location<rang2.location+rang2.length) {
            CTFrameRef subFrameRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(rang1.location,0), pathRef, NULL);
            CFRange range = CTFrameGetVisibleStringRange(subFrameRef);
            rang1 = CFRangeMake(range.location+range.length, 0);
            [array addObject:(__bridge id)subFrameRef];
            [stringArr addObject:[[attrString string] substringWithRange:NSMakeRange(range.location, range.length)]];
            CFRelease(subFrameRef);
            
        }
    }
    
    CFRelease(setterRef);
    CFRelease(pathRef);
    _epubframeRef = [array copy];
    _epubString = [stringArr copy];
    _pageCount = _epubframeRef.count;
    _content = attrString.string;
}
-(void)setContent:(NSString *)content
{
    _content = content;
    if (_type == ReaderTxt) {
         [self paginateWithBounds:CGRectMake(LeftSpacing, TopSpacing, [UIScreen mainScreen].bounds.size.width-LeftSpacing-RightSpacing, [UIScreen mainScreen].bounds.size.height-TopSpacing-BottomSpacing)];
    }
    
}
-(void)updateFont
{
    if (_type==ReaderEpub) {
        [self paginateEpubWithBounds:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width-LeftSpacing-RightSpacing, [UIScreen mainScreen].bounds.size.height-TopSpacing-BottomSpacing)];
    }
    else{
        [self paginateWithBounds:CGRectMake(LeftSpacing, TopSpacing, [UIScreen mainScreen].bounds.size.width-LeftSpacing-RightSpacing, [UIScreen mainScreen].bounds.size.height-TopSpacing-BottomSpacing)];
    }
    
}
-(void)paginateWithBounds:(CGRect)bounds
{
    [_pageArray removeAllObjects];
    NSAttributedString *attrString;
    CTFramesetterRef frameSetter;
    CGPathRef path;
    NSMutableAttributedString *attrStr;
    attrStr = [[NSMutableAttributedString  alloc] initWithString:self.content];
    NSDictionary *attribute = [LSYReadParser parserAttribute:[LSYReadConfig shareInstance]];
    [attrStr setAttributes:attribute range:NSMakeRange(0, attrStr.length)];
    attrString = [attrStr copy];
    frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
    path = CGPathCreateWithRect(bounds, NULL);
    int currentOffset = 0;
    int currentInnerOffset = 0;
    BOOL hasMorePages = YES;
    // 防止死循环，如果在同一个位置获取CTFrame超过2次，则跳出循环
    int preventDeadLoopSign = currentOffset;
    int samePlaceRepeatCount = 0;
    
    while (hasMorePages) {
        if (preventDeadLoopSign == currentOffset) {
            
            ++samePlaceRepeatCount;
            
        } else {
            
            samePlaceRepeatCount = 0;
        }
        
        if (samePlaceRepeatCount > 1) {
            // 退出循环前检查一下最后一页是否已经加上
            if (_pageArray.count == 0) {
                [_pageArray addObject:@(currentOffset)];
            }
            else {
                
                NSUInteger lastOffset = [[_pageArray lastObject] integerValue];
                
                if (lastOffset != currentOffset) {
                    [_pageArray addObject:@(currentOffset)];
                }
            }
            break;
        }
        
        [_pageArray addObject:@(currentOffset)];
        
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(currentInnerOffset, 0), path, NULL);
        CFRange range = CTFrameGetVisibleStringRange(frame);
        if ((range.location + range.length) != attrString.length) {
            
            currentOffset += range.length;
            currentInnerOffset += range.length;
            
        } else {
            // 已经分完，提示跳出循环
            hasMorePages = NO;
        }
        if (frame) CFRelease(frame);
    }
    
    CGPathRelease(path);
    CFRelease(frameSetter);
    _pageCount = _pageArray.count;
}
-(NSString *)stringOfPage:(NSUInteger)index
{
    NSUInteger local = [_pageArray[index] integerValue];
    NSUInteger length;
    if (index<self.pageCount-1) {
        length=  [_pageArray[index+1] integerValue] - [_pageArray[index] integerValue];
    }
    else{
        length = _content.length - [_pageArray[index] integerValue];
    }
    return [_content substringWithRange:NSMakeRange(local, length)];
}
-(id)copyWithZone:(NSZone *)zone
{
    LSYChapterModel *model = [[LSYChapterModel allocWithZone:zone] init];
    model.content = self.content;
    model.title = self.title;
    model.pageCount = self.pageCount;
    model.pageArray = self.pageArray;
    model.epubImagePath = self.epubImagePath;
    model.type = self.type;
    model.epubString = self.epubString;
    return model;
    
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeInteger:self.pageCount forKey:@"pageCount"];
    [aCoder encodeObject:self.pageArray forKey:@"pageArray"];
    [aCoder encodeObject:self.epubImagePath forKey:@"epubImagePath"];
    [aCoder encodeObject:@(self.type) forKey:@"type"];
    [aCoder encodeObject:self.epubContent forKey:@"epubContent"];
    [aCoder encodeObject:self.chapterpath forKey:@"chapterpath"];
    [aCoder encodeObject:self.html forKey:@"html"];
    [aCoder encodeObject:self.epubString forKey:@"epubString"];
    /**
     @property (nonatomic,copy) NSArray *epubframeRef;
     @property (nonatomic,copy) NSString *epubImagePath;
     @property (nonatomic,copy) NSArray <LSYImageData *> *imageArray;
    
     */
//    [aCoder encodeObject:self.epubframeRef forKey:@"epubframeRef"];
//    [aCoder encodeObject:self.epubImagePath forKey:@"epubImagePath"];
    
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        _content = [aDecoder decodeObjectForKey:@"content"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.pageCount = [aDecoder decodeIntegerForKey:@"pageCount"];
        self.pageArray = [aDecoder decodeObjectForKey:@"pageArray"];
        self.type = [[aDecoder decodeObjectForKey:@"type"] integerValue];
        self.epubImagePath = [aDecoder decodeObjectForKey:@"epubImagePath"];
        self.epubContent = [aDecoder decodeObjectForKey:@"epubContent"];
        self.chapterpath = [aDecoder decodeObjectForKey:@"chapterpath"];
        self.html = [aDecoder decodeObjectForKey:@"html"];
        self.epubString = [aDecoder decodeObjectForKey:@"epubString"];
//        self.epubframeRef = [aDecoder decodeObjectForKey:@"epubframeRef"];
        
    }
    return self;
}
@end

@implementation LSYImageData

@end
