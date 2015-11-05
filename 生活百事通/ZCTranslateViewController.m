//
//  ZCTranslateViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/11/5.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCTranslateViewController.h"
#import "ZCHeader.h"
#import "ZCWebViewController.h"
@import WebKit;

@interface ZCTranslateViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) RETableViewManager *manager;

@end

@implementation ZCTranslateViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"翻译";
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    self.manager.style.cellHeight = 36;
    
    // 添加section
    [self addSectionSearch];
    
}

// 添加section
- (void)addSectionSearch {
    
    UIImage *image = [UIImage imageNamed:@"translate"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
    imageView.contentMode = UIViewContentModeCenter;
    
    // 添加头部视图
    RETableViewSection *headerSection = [RETableViewSection sectionWithHeaderView:imageView];
    [self.manager addSection:headerSection];
    headerSection.footerTitle = @"可以选择网络上主流的翻译网站进行在线翻译";
    
    ZCWebViewController *youdaoWeb = [[ZCWebViewController alloc] init];
    
    // 有道词典
    RETableViewItem *youdaoItem = [RETableViewItem itemWithTitle:@"有道词典" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        youdaoWeb.title = @"有道词典";
        youdaoWeb.webURL = @"http://m.youdao.com";
        youdaoWeb.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:youdaoWeb animated:YES];
    }];
    [headerSection addItem:youdaoItem];
    
    ZCWebViewController *baiduWeb = [[ZCWebViewController alloc] init];
    // 百度翻译
    RETableViewItem *baiduItem = [RETableViewItem itemWithTitle:@"百度翻译" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        baiduWeb.title = @"百度翻译";
        baiduWeb.webURL = @"http://fanyi.baidu.com";
        baiduWeb.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:baiduWeb animated:YES];
    }];
    [headerSection addItem:baiduItem];
    
}

@end
