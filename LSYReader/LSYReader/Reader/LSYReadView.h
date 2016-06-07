//
//  LSYReadView.h
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSYReadView : UIView
@property (nonatomic,assign) CTFrameRef frameRef;
@property (nonatomic,strong) NSString *content;
-(void)cancelSelected;
@end
