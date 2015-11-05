//
//  ZCWikiViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/11/3.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCWikiViewController.h"
#import "ZCHeader.h"
#import "ZCWebViewController.h"

@interface ZCWikiViewController ()

@property (nonatomic, strong) RETableViewManager *manager;

@end

@implementation ZCWikiViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"百科";
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    self.manager.style.cellHeight = 36;
    
    // 添加section
    [self addSectionSearch];
    
}

// 添加section
- (void)addSectionSearch {
    
    UIImage *image = [UIImage imageNamed:@"wiki"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
    imageView.contentMode = UIViewContentModeCenter;
    
    // 添加头部视图
    RETableViewSection *headerSection = [RETableViewSection sectionWithHeaderView:imageView];
    [self.manager addSection:headerSection];
    headerSection.footerTitle = @"可以选择网络上主流的百科网站进行阅览，不过由于中文维基百科被墙，我们使用的是维基百科的镜像网站，内容完全来自于维基百科";
    
    ZCWebViewController *baiduWeb = [[ZCWebViewController alloc] init];
    
    // 百度百科
    RETableViewItem *baiduItem = [RETableViewItem itemWithTitle:@"百度百科" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        baiduWeb.title = @"百度百科";
        baiduWeb.webURL = @"http://baike.baidu.com";
        baiduWeb.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:baiduWeb animated:YES];
    }];
    [headerSection addItem:baiduItem];
    
    ZCWebViewController *wikiWeb = [[ZCWebViewController alloc] init];
    // 维基百科
    RETableViewItem *wikiItem = [RETableViewItem itemWithTitle:@"维基百科" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        wikiWeb.title = @"维基百科";
        wikiWeb.webURL = @"http://wc.yooooo.us";
        wikiWeb.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wikiWeb animated:YES];
    }];
    [headerSection addItem:wikiItem];
    
}

@end
