//
//  ZCAboutViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/11/1.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCAboutViewController.h"

@import SafariServices;

@interface ZCAboutViewController ()<SFSafariViewControllerDelegate, UIAlertViewDelegate>


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
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"呼叫" message:@"+86 186 1265 4171" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
    
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            return;
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://18612654171"]];
            break;
        default:
            break;
    }
    
}

// 关注作者按钮
- (IBAction)gotoGithub:(id)sender {
    
    // 使用SFSafariViewController打开Github
    NSString *urlString = @"https://github.com/zcill";
    
    SFSafariViewController *sfViewControllr = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:urlString]];
    sfViewControllr.delegate = self;
    
    [self presentViewController:sfViewControllr animated:YES completion:^{
        
    }];
    
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
