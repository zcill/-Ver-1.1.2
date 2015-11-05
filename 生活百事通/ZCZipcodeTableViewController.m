//
//  ZCZipcodeTableViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/11/5.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCZipcodeTableViewController.h"
#import "ZCHeader.h"
#import <RETableViewManager/RETableViewOptionsController.h>

@interface ZCZipcodeTableViewController ()

@property (nonatomic, strong) RETableViewManager *manager;
@property (nonatomic, strong) RETableViewSection *ZipcodeSection;
@property (nonatomic, strong) RETableViewSection *resultSection;

@end

@implementation ZCZipcodeTableViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"邮编查询";
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    self.manager.style.cellHeight = 36;
    
    // 添加section
    [self addSectionSearch];
    [self addSectionResult];
    [self addSectionButton];
    
    
}

// 添加第一个section
- (void)addSectionSearch {
    
    UIImage *image = [UIImage imageNamed:@"zipcode"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
    imageView.contentMode = UIViewContentModeCenter;
    
    // 添加头部视图
    RETableViewSection *ZipcodeSection = [RETableViewSection sectionWithHeaderView:imageView];
    ZipcodeSection.footerTitle = @"邮编查询系统，可以查询指定国内各地的邮政编码所对应的地址";
    
    [self.manager addSection:ZipcodeSection];
    self.ZipcodeSection = ZipcodeSection;
    
    RETextItem *ZipcodeItem = [RETextItem itemWithTitle:@"邮政编码" value:nil placeholder:@"请输入邮政编码"];
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
            [weakSelf getAddressWithZipcode:ZipcodeItem.value];
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
 "result" : [
 {
 "address" : "文一路80号浙江省省委党校图书馆(杂志)",
 "city" : "杭州市",
 "province" : "浙江省",
 "town" : "西湖区",
 "zipcode" : "310012"
 }
 */

// 查询数据
- (void)getAddressWithZipcode:(NSString *)zipcode {
    
    __typeof (self) __weak weakSelf = self;
    [ZCSearchHttpRequest getAddressWithZipcode:zipcode succuss:^(id JSON) {
        
        NSLog(@"%@", JSON);
        NSDictionary *dic = JSON;
        
        NSString *msg = dic[@"msg"];
        
        // 判断result是否为空
        if (![dic[@"result"] isKindOfClass:[NSArray class]]) {
            
            if ([dic[@"result"] isEqualToString:@""]) {
                [SVProgressHUD showErrorWithStatus:msg];
                return ;
            }
            
        }
        
        NSArray *resultArr = dic[@"result"];
        
        // 清除所有items
        [weakSelf.resultSection removeAllItems];
        
        // 是否成功
        if (resultArr != nil) {
            
            for (NSDictionary *dict in resultArr) {
                
                // 地址
                NSString *address = [NSString stringWithFormat:@"地址: %@%@%@ %@", dict[@"province"], dict[@"city"], dict[@"town"], dict[@"address"]];
                RETableViewItem *addressItem = [RETableViewItem itemWithTitle:address accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
                    [SVProgressHUD showInfoWithStatus:address];
                }];
                [weakSelf.resultSection addItem:addressItem];
                
            }
            
        } else {
            [weakSelf.resultSection addItem:[RETableViewItem itemWithTitle:@"查询失败，可能输入的IP地址有误"]];
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
