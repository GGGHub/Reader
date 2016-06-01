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
@end
