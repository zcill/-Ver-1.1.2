//
//  ZCHistoryTableViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/11/5.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCHistoryTableViewController.h"
#import "ZCHeader.h"
#import <RETableViewManager/RETableViewOptionsController.h>

@interface ZCHistoryTableViewController ()

@property (nonatomic, strong) RETableViewManager *manager;
@property (nonatomic, strong) RETableViewSection *resultSection;
@property (nonatomic, strong) REPickerItem *monthItem;
@property (nonatomic, strong) REPickerItem *dayItem;

@end

@implementation ZCHistoryTableViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"历史上的今天";
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    self.manager.style.cellHeight = 36;
    
    // 添加section
    [self addSectionSearch];
    [self addSectionResult];
    [self addSectionButton];
    
    
}

// 添加第一个section
- (void)addSectionSearch {
    
    UIImage *image = [UIImage imageNamed:@"todayhistory"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
    imageView.contentMode = UIViewContentModeCenter;
    
    // 添加头部视图
    RETableViewSection *headerSection = [RETableViewSection sectionWithHeaderView:imageView];
    [self.manager addSection:headerSection];
    headerSection.footerTitle = @"历史上的指定日期发生的大事，包括重大事情、诞辰、逝世等，不断增加中";
    
    // 选择月份
    REPickerItem *monthItem = [REPickerItem itemWithTitle:@"选择月份" value:@[@"1"] placeholder:nil options:@[@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12"]]];
    [headerSection addItem:monthItem];
    self.monthItem = monthItem;
    
    // 选择日期
    NSMutableArray *dayArray = [NSMutableArray array];
    for (int i = 1; i <= 31; i++) {
        NSString *string = [NSString stringWithFormat:@"%d", i];
        [dayArray addObject:string];
    }
    REPickerItem *dayItem = [REPickerItem itemWithTitle:@"选择日期" value:@[@"1"] placeholder:nil options:@[dayArray]];
    [headerSection addItem:dayItem];
    self.dayItem = dayItem;
    
}

// 第二个组
- (void)addSectionResult {
    
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"查询结果:"];
    [self.manager addSection:section];
    self.resultSection = section;
    
}

// 第三个组
- (void)addSectionButton {
    
    RETableViewSection *section = [RETableViewSection section];
    [self.manager addSection:section];
    
    RETableViewItem *buttonItem = [RETableViewItem itemWithTitle:@"查询" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        
        if (self.monthItem.value) {
            
            NSString *monthValue = [self.monthItem.value lastObject];
            NSString *dayValue = [self.dayItem.value lastObject];
            
            [self getHistoryDataWithMonth:monthValue day:dayValue];
            [SVProgressHUD showWithStatus:@"查询中..."];
        }
        // item取消选择
        [item deselectRowAnimated:UITableViewRowAnimationAutomatic];
    }];
    
    buttonItem.textAlignment = NSTextAlignmentCenter;
    [section addItem:buttonItem];
    
}

- (void)getHistoryDataWithMonth:(NSString *)month day:(NSString *)day {
    
    [ZCSearchHttpRequest getHistoryWithMonth:month date:day succuss:^(id JSON) {
        
        NSDictionary *dic = JSON;
        
        NSArray *resultArr = dic[@"result"];
        
        NSString *msg = dic[@"msg"];
        
        // 清空
        [self.resultSection removeAllItems];
        
        // 是否成功
        if ([msg isEqualToString:@"ok"]) {
            
            for (NSDictionary *dict in resultArr) {
                
                // 时间
                NSString *time = [NSString stringWithFormat:@"时间: %@年%@月%@日", dict[@"year"], dict[@"month"], dict[@"day"]];
                [self.resultSection addItem:[RETableViewItem itemWithTitle:time]];
                
                // 事件标题
                NSString *title = [NSString stringWithFormat:@"事件: %@", dict[@"title"]];
                RETableViewItem *titleItem = [RETableViewItem itemWithTitle:title accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
                    [SVProgressHUD showInfoWithStatus:title];
                }];
                [self.resultSection addItem:titleItem];
                
            }
            
        } else {
            [self.resultSection addItem:[RETableViewItem itemWithTitle:@"查询失败，可能输入有误"]];
        }
        
        // 重新加载section
        [self.resultSection reloadSectionWithAnimation:UITableViewRowAnimationAutomatic];
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}


@end
