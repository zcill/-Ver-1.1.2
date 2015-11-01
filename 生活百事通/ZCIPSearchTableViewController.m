//
//  ZCIPSearchTableViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/10/29.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCIPSearchTableViewController.h"
#import "ZCHeader.h"

@interface ZCIPSearchTableViewController ()

@property (nonatomic, strong) RETableViewManager *manager;
@property (nonatomic, strong) RETableViewSection *IPSection;
@property (nonatomic, strong) RETableViewSection *resultSection;

@end

@implementation ZCIPSearchTableViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"IP地址查询验证";
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    self.manager.style.cellHeight = 36;
    
    // 添加section
    [self addSectionSearch];
    [self addSectionResult];
    [self addSectionButton];
    
    
}

// 添加第一个section
- (void)addSectionSearch {
    
    UIImage *image = [UIImage imageNamed:@"a5"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
    imageView.contentMode = UIViewContentModeCenter;
    
    // 添加头部视图
    RETableViewSection *IPSection = [RETableViewSection sectionWithHeaderView:imageView];
    IPSection.footerTitle = @"IP查询系统，可以查询指定IP的所在国家或城市，以及类型";
    
    [self.manager addSection:IPSection];
    self.IPSection = IPSection;
    
    RETextItem *IPNumberItem = [RETextItem itemWithTitle:@"IP地址" value:nil placeholder:@"请输入IP地址"];
    [IPSection addItem:IPNumberItem];
    
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
        RETextItem *IPNumberItem = weakSelf.IPSection.items[0];
        
        if (IPNumberItem.value) {
            // 查询数据
            [weakSelf getIPNumberData:IPNumberItem.value];
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
 "error":"0",
 "msg":"",
 "data":{
    "area":"浙江省杭州市",
    "type":"移动"
    }
 }
 */

// 查询数据
- (void)getIPNumberData:(NSString *)IPNumber {
    
    __typeof (self) __weak weakSelf = self;
    [ZCSearchHttpRequest getIPDataWithIPNumber:IPNumber succuss:^(id JSON) {
        
        NSLog(@"%@", JSON);
        NSDictionary *dic = JSON;
        
        NSDictionary *dataDict = dic[@"data"];
        
        // 清除所有items
        [weakSelf.resultSection removeAllItems];
        
        // 是否成功
        if (dataDict[@"type"] != nil) {
            
            // 地区
            NSString *company = [NSString stringWithFormat:@"地区:\t%@", dataDict[@"area"]];
            [weakSelf.resultSection addItem:[RETableViewItem itemWithTitle:company]];
            
            // 类型
            NSString *cardtype = [NSString stringWithFormat:@"类别:\t%@", dataDict[@"type"]];
            [weakSelf.resultSection addItem:[RETableViewItem itemWithTitle:cardtype]];
            
        } else {
            [weakSelf.resultSection addItem:[RETableViewItem itemWithTitle:@"查询失败，可能输入的IP地址有误"]];
        }
        
        // 重新加载section
        [weakSelf.resultSection reloadSectionWithAnimation:UITableViewRowAnimationAutomatic];
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"ZCIPSearchTableViewController dealloc");
}


@end
