//
//  ZCTrainTableViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/11/5.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCTrainTableViewController.h"
#import "ZCHeader.h"
#import "ZCWebViewController.h"

@interface ZCTrainTableViewController ()

@property (nonatomic, strong) RETableViewManager *manager;

@end

@implementation ZCTrainTableViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"彩票开奖";
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    self.manager.style.cellHeight = 36;
    
    // 添加section
    [self addSectionSearch];
    
}

// 添加section
- (void)addSectionSearch {
    
    UIImage *image = [UIImage imageNamed:@"train"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
    imageView.contentMode = UIViewContentModeCenter;
    
    // 添加头部视图
    RETableViewSection *headerSection = [RETableViewSection sectionWithHeaderView:imageView];
    [self.manager addSection:headerSection];
    headerSection.footerTitle = @"可以选择网络上主流的火车票查询网站进行比对,由于官方12306没有手机版网页，访问速度较慢，请耐心等待";
    
    ZCWebViewController *officialWeb = [[ZCWebViewController alloc] init];
    // 12306官方
    RETableViewItem *officialItem = [RETableViewItem itemWithTitle:@"12306官方" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        officialWeb.title = @"12306官方";
        officialWeb.webURL = @"https://kyfw.12306.cn";
        officialWeb.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:officialWeb animated:YES];
    }];
    [headerSection addItem:officialItem];
    
    ZCWebViewController *cTripWeb = [[ZCWebViewController alloc] init];
    // 携程
    RETableViewItem *ctripItem = [RETableViewItem itemWithTitle:@"携程" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        cTripWeb.title = @"携程";
        cTripWeb.webURL = @"http://touch.train.qunar.com";
        cTripWeb.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cTripWeb animated:YES];
    }];
    [headerSection addItem:ctripItem];
    
    ZCWebViewController *qunarWeb = [[ZCWebViewController alloc] init];
    // 去哪儿
    RETableViewItem *qunarItem = [RETableViewItem itemWithTitle:@"去哪儿" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        qunarWeb.title = @"去哪儿";
        qunarWeb.webURL = @"http://touch.train.qunar.com";
        qunarWeb.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:qunarWeb animated:YES];
    }];
    [headerSection addItem:qunarItem];
    
}

@end
