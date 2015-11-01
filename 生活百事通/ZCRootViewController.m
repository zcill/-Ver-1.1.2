//
//  ZCRootViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/10/21.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCRootViewController.h"
#import "ZCHeader.h"

@interface ZCRootViewController ()

@end

@implementation ZCRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNavigationBar];
    
    
}

- (void)initNavigationBar {
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor flatWhiteColor]];
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
}



@end
