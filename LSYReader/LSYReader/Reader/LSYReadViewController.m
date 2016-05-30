//
//  LSYReadViewController.m
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYReadViewController.h"
#import "LSYReadView.h"
#import "LSYReadParser.h"
#import "LSYReadConfig.h"
@interface LSYReadViewController ()
@property (nonatomic,strong) LSYReadView *readView;
@end

@implementation LSYReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.readView];
}
-(LSYReadView *)readView
{
    if (!_readView) {
        _readView = [[LSYReadView alloc] init];
        LSYReadConfig *config = [LSYReadConfig shareInstance];
        _readView.frame = self.view.frame;
        _readView.frameRef = [LSYReadParser parserContent:_content config:config bouds:self.view.bounds];
    }
    return _readView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
