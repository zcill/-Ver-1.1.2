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
    
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
