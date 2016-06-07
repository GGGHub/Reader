//
//  LSYReadUtilites.m
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYReadUtilites.h"
#import "LSYChapterModel.h"
@implementation LSYReadUtilites
+(void)separateChapter:(NSMutableArray **)chapters content:(NSString *)content
{
    [*chapters removeAllObjects];
    NSString *parten = @"第[0-9一二三四五六七八九十百千]*[章回]";
    NSError* error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray* match = [reg matchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, [content length])];
    
    if (match.count != 0)
    {
        __block NSRange lastRange = NSMakeRange(0, 0);
        [match enumerateObjectsUsingBlock:^(NSTextCheckingResult *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSRange range = [obj range];
            NSInteger local = range.location;
            if (idx > 0 ) {
                LSYChapterModel *model = [[LSYChapterModel alloc] init];
                model.title = [content substringWithRange:lastRange];
                NSUInteger len = local-lastRange.location;
                model.content = [content substringWithRange:NSMakeRange(lastRange.location, len)];
                [*chapters addObject:model];
                
            }
            if (idx == match.count-1) {
                LSYChapterModel *model = [[LSYChapterModel alloc] init];
                model.title = [content substringWithRange:range];
                model.content = [content substringWithRange:NSMakeRange(local, content.length-local)];
                [*chapters addObject:model];
            }
            lastRange = range;
        }];
    }
    else{
         LSYChapterModel *model = [[LSYChapterModel alloc] init];
        model.content = content;
        [*chapters addObject:model];
    }
    
}
+(NSString *)encodeWithURL:(NSURL *)url
{
    if (!url) {
        return @"";
    }
    NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    if (!content) {
        content = [NSString stringWithContentsOfURL:url encoding:0x80000632 error:nil];
    }
    if (!content) {
        content = [NSString stringWithContentsOfURL:url encoding:0x80000631 error:nil];
    }
    if (!content) {
        return @"";
    }
    return content;
    
}
+(UIButton *)commonButtonSEL:(SEL)sel target:(id)target
{
    UIButton *button = [[UIButton alloc] init];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+(UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
+(void)showAlertTitle:(NSString *)title content:(NSString *)string
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
#pragma clang diagnostic pop
    
}
@end
