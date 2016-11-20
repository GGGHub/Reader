//
//  LSYReadViewController.m
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYReadViewController.h"

#import "LSYReadParser.h"
#import "LSYReadConfig.h"


@interface LSYReadViewController ()<LSYReadViewControllerDelegate>

@end

@implementation LSYReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prefersStatusBarHidden];
    [self.view setBackgroundColor:[LSYReadConfig shareInstance].theme];
    [self.view addSubview:self.readView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme:) name:LSYThemeNotification object:nil];
}
-(void)changeTheme:(NSNotification *)no
{
    [LSYReadConfig shareInstance].theme = no.object;
    [self.view setBackgroundColor:[LSYReadConfig shareInstance].theme];
}
-(LSYReadView *)readView
{
    if (!_readView) {
        _readView = [[LSYReadView alloc] initWithFrame:CGRectMake(LeftSpacing,TopSpacing, self.view.frame.size.width-LeftSpacing-RightSpacing, self.view.frame.size.height-TopSpacing-BottomSpacing)];
        LSYReadConfig *config = [LSYReadConfig shareInstance];
        if (_type == ReaderEpub) {
            _readView.frameRef = (__bridge CTFrameRef)_epubFrameRef;
            _readView.imageArray = _imageArray;
        }
        else{
             _readView.frameRef = [LSYReadParser parserContent:_content config:config bouds:CGRectMake(0,0, _readView.frame.size.width, _readView.frame.size.height)];
        }
        _readView.content = _content;
        _readView.delegate = self;
    }
    return _readView;
}
-(void)readViewEditeding:(LSYReadViewController *)readView
{
    if ([self.delegate respondsToSelector:@selector(readViewEditeding:)]) {
        [self.delegate readViewEditeding:self];
    }
}
-(void)readViewEndEdit:(LSYReadViewController *)readView
{
    if ([self.delegate respondsToSelector:@selector(readViewEndEdit:)]) {
        [self.delegate readViewEndEdit:self];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
