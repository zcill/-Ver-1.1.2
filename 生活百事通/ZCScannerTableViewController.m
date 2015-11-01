//
//  ZCScannerTableViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/11/1.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCScannerTableViewController.h"
#import "ZCHeader.h"
#import <RETableViewManager/RETableViewOptionsController.h>

#import "ScanViewController.h"
#import "HistoryViewController.h"
#import "InfoViewController.h"
#import "MakerViewController.h"

#import "JKAlert.h"
#import "DateManager.h"
#import "Scanner.h"

@interface ZCScannerTableViewController ()

@property (nonatomic, strong) RETableViewManager *manager;
@property (nonatomic, strong) RETableViewItem *historyItem;
@property (nonatomic, strong) RETableViewItem *scanItem;
@property (nonatomic, strong) RETableViewItem *makeItem;
@property (nonatomic, strong) RETableViewSection *resultSection;

@end

@implementation ZCScannerTableViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"二维码扫描";
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    self.manager.style.cellHeight = 36;
    
    // 添加section
    [self addSectionHeader];
    [self addSectionScan];
}

// 添加section
- (void)addSectionHeader {
    
    UIImage *image = [UIImage imageNamed:@"a0"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
    imageView.contentMode = UIViewContentModeCenter;
    
    // 添加头部视图
    RETableViewSection *headerSection = [RETableViewSection sectionWithHeaderView:imageView];
    [self.manager addSection:headerSection];
    headerSection.headerTitle = @"扫描二维码、条形码，可以查看扫描历史，还可以生成二维码";
    
}

- (void)addSectionScan {
    
    // 添加头部视图
    RETableViewSection *headerSection = [RETableViewSection section];
    [self.manager addSection:headerSection];
    
    // 扫描历史
    RETableViewItem *historyItem = [RETableViewItem itemWithTitle:@"扫描历史" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
        HistoryViewController *history = [[HistoryViewController alloc] init];
        history.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:history animated:YES];
        
    }];
    [headerSection addItem:historyItem];
    self.historyItem = historyItem;
    
    // 扫描
    RETableViewItem *scanItem = [RETableViewItem itemWithTitle:@"扫描二维码" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
        ScanViewController *scan = [[ScanViewController alloc] init];
        [scan finishingBlock:^(NSString *string) {
            NSLog(@"string:%@",string);
            InfoViewController *info = [[InfoViewController alloc]init];
            NSDictionary *item =  @{@"time":[DateManager nowTimeStampString],@"date":[DateManager stringConvert_YMD_FromDate:[NSDate date]],@"content":string?:@""};
            info.item = item;
            [Scanner insert:item];
            [self.navigationController pushViewController:info animated:YES];
            
        }];
        
        scan.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:scan animated:YES];
        
    }];
    [headerSection addItem:scanItem];
    self.scanItem = scanItem;
    
    // 生成二维码
    RETableViewItem *makeItem = [RETableViewItem itemWithTitle:@"生成二维码" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
        MakerViewController *maker = [[MakerViewController alloc] init];
        maker = [[MakerViewController alloc]init];
        maker.navigationItem.title=@"生成二维码";
        maker.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:maker animated:YES];
        
    }];
    [headerSection addItem:makeItem];
    self.makeItem = makeItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
