//
//  ViewController.m
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "ViewController.h"
#import "LSYReadViewController.h"
#import "LSYReadPageViewController.h"
#import "LSYReadUtilites.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *begin;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self addObserver:self forKeyPath:@"begin.state" options:NSKeyValueObservingOptionNew context:NULL];
}
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
//{
//    NSLog(@"change");
//}
- (IBAction)begin:(id)sender {
    LSYReadPageViewController *pageView = [[LSYReadPageViewController alloc] init];
    pageView.resourceURL = [[NSBundle mainBundle] URLForResource:@"mdjyml"withExtension:@"txt"];
    [self presentViewController:pageView animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
