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
#import "LSYReadModel.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *begin;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _activity.hidesWhenStopped = YES;
    
}

- (IBAction)begin:(id)sender {
    [_activity startAnimating];
   [_begin setTitle:@"" forState:UIControlStateNormal];
    LSYReadPageViewController *pageView = [[LSYReadPageViewController alloc] init];
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"mdjyml"withExtension:@"txt"];
    
    pageView.resourceURL = fileURL;    //文件位置
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        pageView.model = [LSYReadModel getLocalModelWithURL:fileURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_activity stopAnimating];
             [_begin setTitle:@"Beign Read" forState:UIControlStateNormal];
            
            [self presentViewController:pageView animated:YES completion:nil];
        });
    });
    
    
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
