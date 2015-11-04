//
//  ZCAreaCodeTableViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/11/4.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCAreaCodeTableViewController.h"
#import "ZCHeader.h"
#import <RETableViewManager/RETableViewOptionsController.h>

@interface ZCAreaCodeTableViewController ()

@property (nonatomic, strong) RETableViewManager *manager;
@property (nonatomic, strong) NSArray *currencyArray;
@property (nonatomic, strong) RETableViewSection *resultSection;
@property (nonatomic, strong) RETextItem *cityItem;
@property (nonatomic, strong) REPickerItem *pickerItem;

@property (nonatomic, copy) NSString *result;

@end

@implementation ZCAreaCodeTableViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"区号查询";
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    self.manager.style.cellHeight = 36;
    
    // 添加section
    [self addSectionSearch];
    [self addSectionResult];
    [self addSectionButton];
    
    
}

// 添加第一个section
- (void)addSectionSearch {
    
    UIImage *image = [UIImage imageNamed:@"areacode"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
    imageView.contentMode = UIViewContentModeCenter;
    
    // 添加头部视图
    RETableViewSection *headerSection = [RETableViewSection sectionWithHeaderView:imageView];
    [self.manager addSection:headerSection];
    headerSection.footerTitle = @"区号查询系统，可根据区号查城市，也可以根据城市查区号";
    
    // 输入区号或者城市
    RETextItem *cityItem = [RETextItem itemWithTitle:@"查询框" value:nil placeholder:@"根据选择哪种查询去输入"];
    [headerSection addItem:cityItem];
    self.cityItem = cityItem;
    
    // 选择种类
    REPickerItem *pickerItem = [REPickerItem itemWithTitle:@"查询类型类型:" value:@[@"根据区号查城市"] placeholder:nil options:@[@[@"根据区号查城市", @"根据城市查区号"]]];
    [headerSection addItem:pickerItem];
    self.pickerItem = pickerItem;
    
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
        
        if (self.cityItem.value) {
            
            NSString *value = [self.pickerItem.value lastObject];
            
            if ([value isEqualToString:@"根据区号查城市"]) {
                [self getCityDataWithAreacode:self.cityItem.value];
                [SVProgressHUD showWithStatus:@"查询中..."];
            } else {
                [self getAreaCodeWithCity:self.cityItem.value];
                [SVProgressHUD showWithStatus:@"查询中..."];
            }
            
            // 清除所有items
            [self.resultSection removeAllItems];
            
            // 重新加载section
            [self.resultSection reloadSectionWithAnimation:UITableViewRowAnimationAutomatic];
        }
        // item取消选择
        [item deselectRowAnimated:UITableViewRowAnimationAutomatic];
    }];
    
    buttonItem.textAlignment = NSTextAlignmentCenter;
    [section addItem:buttonItem];
    
}

// 根据区号查城市
- (void)getCityDataWithAreacode:(NSString *)areacode {
    
    [ZCSearchHttpRequest getCityDataWithAreacode:areacode succuss:^(id JSON) {
        
        NSLog(@"%@", JSON);
        NSDictionary *dic = JSON;
        NSString *msg = dic[@"msg"];
        
        // 判断result是否为@""字符串，是就返回msg错误信息
        if (![dic[@"result"] isKindOfClass:[NSArray class]]) {
            
            if ([dic[@"result"] isEqualToString:@""]) {
                [SVProgressHUD showErrorWithStatus:msg];
                return ;
            }
        }
        
        NSArray *resultArr = dic[@"result"];
        
        // 清除所有items
        [self.resultSection removeAllItems];
        
        // 是否成功
        if ([msg isEqualToString:@"ok"]) {
            
            for (NSDictionary *dict in resultArr) {
                
                // 城市列表
                NSString *status = [NSString stringWithFormat:@"%@%@%@", dict[@"province"], dict[@"city"], dict[@"town"]];
                RETableViewItem *statusItem = [RETableViewItem itemWithTitle:status];
                [self.resultSection addItem:statusItem];
                
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
        // 重新加载section
        [self.resultSection reloadSectionWithAnimation:UITableViewRowAnimationAutomatic];
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        
    }];
    
}

// 根据城市查区号
- (void)getAreaCodeWithCity:(NSString *)city {
    
    [ZCSearchHttpRequest getAreacodeWithCity:city succuss:^(id JSON) {
        
        NSLog(@"%@", JSON);
        NSDictionary *dic = JSON;
        NSString *msg = dic[@"msg"];
        
        // 判断result是否为@""字符串，是就返回msg错误信息
        if (![dic[@"result"] isKindOfClass:[NSArray class]]) {
            
            if ([dic[@"result"] isEqualToString:@""]) {
                [SVProgressHUD showErrorWithStatus:msg];
                return ;
            }
        }
        
        NSArray *resultArr = dic[@"result"];
        
        // 清除所有items
        [self.resultSection removeAllItems];
        
        // 是否成功
        if ([msg isEqualToString:@"ok"]) {
            
            for (NSDictionary *dict in resultArr) {
                
                // 查询的城市
                NSString *status = [NSString stringWithFormat:@"查询城市: %@%@%@ %@", dict[@"province"], dict[@"city"], dict[@"town"], dict[@"areacode"]];
                RETableViewItem *statusItem = [RETableViewItem itemWithTitle:status accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
                    [SVProgressHUD showInfoWithStatus:status];
                }];
                [self.resultSection addItem:statusItem];
                
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
        // 重新加载section
        [self.resultSection reloadSectionWithAnimation:UITableViewRowAnimationAutomatic];
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        
    }];
    
}

@end
