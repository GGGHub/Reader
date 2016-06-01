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
    [self prefersStatusBarHidden];
    [self.view addSubview:self.readView];
}

-(LSYReadView *)readView
{
    if (!_readView) {
        _readView = [[LSYReadView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
        LSYReadConfig *config = [LSYReadConfig shareInstance];
        _readView.frameRef = [LSYReadParser parserContent:_content config:config bouds:CGRectMake(LeftSpacing,TopSpacing, _readView.frame.size.width-LeftSpacing-RightSpacing, _readView.frame.size.height-TopSpacing-BottomSpacing)];
    }
    return _readView;
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
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
