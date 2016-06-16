//
//  LSYChapterModel.h
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface LSYChapterModel : NSObject<NSCopying,NSCoding>
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *title;
@property (nonatomic) NSUInteger pageCount;
-(NSString *)stringOfPage:(NSUInteger)index;
-(void)updateFont;
+(id)chapterWithEpub:(NSString *)chapterpath title:(NSString *)title;
@end
