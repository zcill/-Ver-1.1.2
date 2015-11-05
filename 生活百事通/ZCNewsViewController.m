//
//  ZCNewsViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/11/3.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCNewsViewController.h"
#import "ZCHeader.h"
#import "ZCWebViewController.h"

@import WebKit;

@interface ZCNewsViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) RETableViewManager *manager;

@end

@implementation ZCNewsViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新闻";
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    self.manager.style.cellHeight = 36;
    
    // 添加section
    [self addSectionSearch];
    
}

// 添加section
- (void)addSectionSearch {
    
    UIImage *image = [UIImage imageNamed:@"news"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
    imageView.contentMode = UIViewContentModeCenter;
    
    // 添加头部视图
    RETableViewSection *headerSection = [RETableViewSection sectionWithHeaderView:imageView];
    [self.manager addSection:headerSection];
    headerSection.footerTitle = @"可以选择网络上主流的新闻网站进行阅读";
    
    ZCWebViewController *netEaseNews = [[ZCWebViewController alloc] init];
    // 网易新闻
    RETableViewItem *youdaoItem = [RETableViewItem itemWithTitle:@"网易新闻" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        netEaseNews.title = @"网易新闻";
        netEaseNews.webURL = @"http://news.163.com";
        netEaseNews.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:netEaseNews animated:YES];
    }];
    [headerSection addItem:youdaoItem];
    
    ZCWebViewController *fengNews = [[ZCWebViewController alloc] init];
    // 凤凰新闻
    RETableViewItem *fengItem = [RETableViewItem itemWithTitle:@"凤凰新闻" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        fengNews.title = @"凤凰新闻";
        fengNews.webURL = @"http://inews.ifeng.com";
        fengNews.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fengNews animated:YES];
    }];
    [headerSection addItem:fengItem];
    
    ZCWebViewController *toutiaoNews = [[ZCWebViewController alloc] init];
    // 今日头条
    RETableViewItem *toutiaoItem = [RETableViewItem itemWithTitle:@"今日头条" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        toutiaoNews.title = @"今日头条";
        toutiaoNews.webURL = @"http://m.toutiao.com";
        toutiaoNews.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:toutiaoNews animated:YES];
    }];
    [headerSection addItem:toutiaoItem];
    
}

@end
