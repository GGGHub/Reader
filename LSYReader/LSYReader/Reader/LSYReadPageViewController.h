//
//  LSYReadPageViewController.h
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSYReadPageViewController : UIViewController
@property (nonatomic,strong) NSURL *resourceURL;
+(void)loadURL:(NSURL *)url;
@end
