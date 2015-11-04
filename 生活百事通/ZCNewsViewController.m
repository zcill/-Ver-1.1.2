//
//  ZCNewsViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/11/3.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCNewsViewController.h"
#import "ZCHeader.h"

@import WebKit;

@interface ZCNewsViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation ZCNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initStartNewsPage];
    
}

- (void)initStartNewsPage {
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 49)];
    self.webView.allowsBackForwardNavigationGestures = YES;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://news.163.com"]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"didStartProvisionalNavigation");
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"didCommitNavigation");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"didFinishNavigation");
}

@end
