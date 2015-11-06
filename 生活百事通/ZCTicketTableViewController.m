//
//  ZCTicketTableViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/11/6.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCTicketTableViewController.h"
#import "ZCHeader.h"
#import "ZCWebViewController.h"

@import WebKit;

@interface ZCTicketTableViewController ()

@property (nonatomic, strong) RETableViewManager *manager;

@end

@implementation ZCTicketTableViewController

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
    
    UIImage *image = [UIImage imageNamed:@"ticket"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
    imageView.contentMode = UIViewContentModeCenter;
    
    // 添加头部视图
    RETableViewSection *headerSection = [RETableViewSection sectionWithHeaderView:imageView];
    [self.manager addSection:headerSection];
    headerSection.footerTitle = @"可以选择网络上主流的彩票网站进行比对";
    
    ZCWebViewController *netEaseTicket = [[ZCWebViewController alloc] init];
    // 网易彩票
    RETableViewItem *netEaseItem = [RETableViewItem itemWithTitle:@"网易彩票" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        netEaseTicket.title = @"网易彩票";
        netEaseTicket.webURL = @"http://caipiao.163.com/t/";
        netEaseTicket.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:netEaseTicket animated:YES];
    }];
    [headerSection addItem:netEaseItem];
    
}

@end
