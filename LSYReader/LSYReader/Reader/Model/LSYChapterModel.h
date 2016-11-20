//
//  LSYChapterModel.h
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
typedef  NS_ENUM(NSInteger,ReaderType){
    ReaderTxt,
    ReaderEpub
};

/**
 epubs images信息
 
 */
@interface LSYImageData : NSObject
@property (nonatomic,strong) NSString *url; //图片链接
@property (nonatomic,assign) CGRect imageRect;  //图片位置
@property (nonatomic,assign) NSInteger position;

@end

@interface LSYChapterModel : NSObject<NSCopying,NSCoding>
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *title;
@property (nonatomic) NSUInteger pageCount;



-(NSString *)stringOfPage:(NSUInteger)index;
-(void)updateFont;

@property (nonatomic,copy) NSString *chapterpath;
@property (nonatomic,copy) NSString *html;

@property (nonatomic,copy) NSArray *epubContent;
@property (nonatomic,copy) NSArray *epubString;
@property (nonatomic,copy) NSArray *epubframeRef;
@property (nonatomic,copy) NSString *epubImagePath;
@property (nonatomic,copy) NSArray <LSYImageData *> *imageArray;
@property (nonatomic,assign) ReaderType type;
+(id)chapterWithEpub:(NSString *)chapterpath title:(NSString *)title imagePath:(NSString *)path;
-(void)parserEpubToDictionary;
-(void)paginateEpubWithBounds:(CGRect)bounds;
@end

