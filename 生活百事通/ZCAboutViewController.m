//
//  ZCAboutViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/11/1.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCAboutViewController.h"

@interface ZCAboutViewController ()


@end

@implementation ZCAboutViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

// 联系我们按钮
- (IBAction)callMe:(id)sender {
    
    
    
}

// 关注作者按钮
- (IBAction)gotoGithub:(id)sender {
    
    // 使用safari打开github
    NSURL *url = [NSURL URLWithString:@"https://github.com/zcill"];
    [[UIApplication sharedApplication] openURL:url];
    
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
