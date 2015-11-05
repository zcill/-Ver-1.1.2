//
//  ZCOilTableViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/11/5.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCOilTableViewController.h"
#import "ZCHeader.h"
#import <RETableViewManager/RETableViewOptionsController.h>

@interface ZCOilTableViewController ()

@property (nonatomic, strong) RETableViewManager *manager;
@property (nonatomic, strong) RETableViewSection *ZipcodeSection;
@property (nonatomic, strong) RETableViewSection *resultSection;

@end

@implementation ZCOilTableViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"油价查询";
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    self.manager.style.cellHeight = 36;
    
    // 添加section
    [self addSectionSearch];
    [self addSectionResult];
    [self addSectionButton];
    
    
}

// 添加第一个section
- (void)addSectionSearch {
    
    UIImage *image = [UIImage imageNamed:@"oil"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
    imageView.contentMode = UIViewContentModeCenter;
    
    // 添加头部视图
    RETableViewSection *ZipcodeSection = [RETableViewSection sectionWithHeaderView:imageView];
    ZipcodeSection.footerTitle = @"各省油价查询系统，可以查询指定省份的各类汽油的价格";
    
    [self.manager addSection:ZipcodeSection];
    self.ZipcodeSection = ZipcodeSection;
    
    RETextItem *ZipcodeItem = [RETextItem itemWithTitle:@"地区" value:nil placeholder:@"请输入查询省份(例.江苏)"];
    [ZipcodeSection addItem:ZipcodeItem];
    
}

- (void)addSectionResult {
    
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"查询结果:"];
    [self.manager addSection:section];
    self.resultSection = section;
    
}

- (void)addSectionButton {
    
    RETableViewSection *section = [RETableViewSection section];
    [self.manager addSection:section];
    
    __typeof (self) __weak weakSelf = self;
    RETableViewItem *buttonItem = [RETableViewItem itemWithTitle:@"查询" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        
        // 读取item数据
        RETextItem *ZipcodeItem = weakSelf.ZipcodeSection.items[0];
        
        if (ZipcodeItem.value) {
            // 查询数据
            [weakSelf getOilPriceWithProvince:ZipcodeItem.value];
            [SVProgressHUD showWithStatus:@"查询中..."];
        }
        
        // item取消选择
        [item deselectRowAnimated:UITableViewRowAnimationAutomatic];
    }];
    buttonItem.textAlignment = NSTextAlignmentCenter;
    [section addItem:buttonItem];
    
}

/*
 {
     "msg" : "ok",
     "result" : {
         "oil0" : "5.33",
         "oil90" : "5.33",
         "oil93" : "5.70",
         "oil97" : "6.13",
         "province" : "安徽",
         "updatetime" : "2015-11-05 06:00:02"
     },
     "status" : "0"
 }
 */

// 查询数据
- (void)getOilPriceWithProvince:(NSString *)province {
    
    __typeof (self) __weak weakSelf = self;
    [ZCSearchHttpRequest getOilPriceWithProvince:province succuss:^(id JSON) {
        
        NSLog(@"%@", JSON);
        NSDictionary *dic = JSON;
        
        NSDictionary *resultDict = dic[@"result"];
        
        // 清除所有items
        [weakSelf.resultSection removeAllItems];
        
        // 是否成功
        if (![resultDict[@"updatetime"] isEqualToString:@"1970-01-01 08:00:00"]) {
            
            // 查询地区
            NSString *area = [NSString stringWithFormat:@"查询地区: %@", resultDict[@"province"]];
            RETableViewItem *areaItem = [RETableViewItem itemWithTitle:area];
            [weakSelf.resultSection addItem:areaItem];
            
            // 油价
            NSString *oil0 = [NSString stringWithFormat:@"0号油: %@元/升", resultDict[@"oil0"]];
            RETableViewItem *oil0Item = [RETableViewItem itemWithTitle:oil0];
            [weakSelf.resultSection addItem:oil0Item];
            
            NSString *oil90 = [NSString stringWithFormat:@"90号油: %@元/升", resultDict[@"oil90"]];
            RETableViewItem *oil90Item = [RETableViewItem itemWithTitle:oil90];
            [weakSelf.resultSection addItem:oil90Item];
            
            NSString *oil93 = [NSString stringWithFormat:@"93号油: %@元/升", resultDict[@"oil93"]];
            RETableViewItem *oil93Item = [RETableViewItem itemWithTitle:oil93];
            [weakSelf.resultSection addItem:oil93Item];
            
            NSString *oil97 = [NSString stringWithFormat:@"97号油: %@元/升", resultDict[@"oil97"]];
            RETableViewItem *oil97Item = [RETableViewItem itemWithTitle:oil97];
            [weakSelf.resultSection addItem:oil97Item];
            
            NSString *updateTime = [NSString stringWithFormat:@"更新时间: %@", resultDict[@"updatetime"]];
            RETableViewItem *updateTimeItem = [RETableViewItem itemWithTitle:updateTime];
            [weakSelf.resultSection addItem:updateTimeItem];
            
            
        } else {
            [weakSelf.resultSection addItem:[RETableViewItem itemWithTitle:@"没有信息，请输入省份或直辖市"]];
        }
        
        // 重新加载section
        [weakSelf.resultSection reloadSectionWithAnimation:UITableViewRowAnimationAutomatic];
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"ZCZipcodeTableViewController dealloc");
}

@end
