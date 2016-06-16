//
//  LSYReadModel.h
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSYMarkModel.h"
#import "LSYNoteModel.h"
#import "LSYChapterModel.h"
#import "LSYRecordModel.h"
@interface LSYReadModel : NSObject<NSCoding>
@property (nonatomic,strong) NSURL *resource;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,strong) NSMutableArray <LSYMarkModel *>*marks;
@property (nonatomic,strong) NSMutableArray <LSYNoteModel *>*notes;
@property (nonatomic,strong) NSMutableArray <LSYChapterModel *>*chapters;
@property (nonatomic,strong) LSYRecordModel *record;
-(instancetype)initWithContent:(NSString *)content;
-(instancetype)initWithePub:(NSString *)ePubPath;
+(void)updateLocalModel:(LSYReadModel *)readModel url:(NSURL *)url;
+(id)getLocalModelWithURL:(NSURL *)url;
@end
