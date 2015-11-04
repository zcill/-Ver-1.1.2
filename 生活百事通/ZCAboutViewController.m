//
//  ZCAboutViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/11/1.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCAboutViewController.h"

@interface ZCAboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *githubLabel;
@property (weak, nonatomic) IBOutlet UILabel *callMeLabel;

@end

@implementation ZCAboutViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

- (void)openGithub {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    
    [self.githubLabel addGestureRecognizer:tap];
    
}

- (void)tap:(UITapGestureRecognizer *)tap {
    
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
