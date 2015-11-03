//
//  ZCWikiViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/11/3.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCWikiViewController.h"
#import <WebKit/WebKit.h>

@interface ZCWikiViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation ZCWikiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWKWebView];
}

- (void)initWKWebView {
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.allowsBackForwardNavigationGestures = YES;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"www.baidu.com"]]];
    
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
