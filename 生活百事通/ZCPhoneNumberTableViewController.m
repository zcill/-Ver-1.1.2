//
//  ZCPhoneNumberTableViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/10/29.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCPhoneNumberTableViewController.h"
#import "ZCHeader.h"

@interface ZCPhoneNumberTableViewController ()

@property (nonatomic, strong) RETableViewManager *manager;
@property (nonatomic, strong) RETableViewSection *resultSection;
@property (nonatomic, strong) RETableViewSection *phoneNumberSection;

@end

@implementation ZCPhoneNumberTableViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"国内手机归属地查询";
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    self.manager.style.cellHeight = 36;
    
    // 添加section
    [self addSectionSearch];
    [self addSectionResult];
    [self addSectionButton];
    
    
}

// 添加第一个section
- (void)addSectionSearch {
    
    UIImage *image = [UIImage imageNamed:@"a1"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
    imageView.contentMode = UIViewContentModeCenter;
    
    // 添加头部视图
    RETableViewSection *phoneNumberSection = [RETableViewSection sectionWithHeaderView:imageView];
    phoneNumberSection.footerTitle = @"手机归属地查询系统，可以查询中国移动、中国联通、中国电信手机号段归属地信息";
    
    [self.manager addSection:phoneNumberSection];
    self.phoneNumberSection = phoneNumberSection;
    
    RETextItem *phoneNumber = [RETextItem itemWithTitle:@"手机号码:" value:nil placeholder:@"请输入手机号码"];
    [phoneNumberSection addItem:phoneNumber];
    
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
        RETextItem *phoneNumberItem = weakSelf.phoneNumberSection.items[0];
        
        if (phoneNumberItem.value) {
            // 查询数据
            [weakSelf getPhoneNumberData:phoneNumberItem.value];
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
 "cardtype" : "GSM",
 "city" : "鍗楁槍",
 "company" : "涓浗绉诲姩",
 "province" : "姹熻タ"
 },
 "status" : "0"
 }
 */

// 查询数据
- (void)getPhoneNumberData:(NSString *)phoneNumber {
    
    __typeof (self) __weak weakSelf = self;
    [ZCSearchHttpRequest getPhoneNumberDataWithPhoneNumber:phoneNumber success:^(id JSON) {
        NSLog(@"%@", JSON);
        
        NSDictionary *dic = JSON;
        NSString *msg = dic[@"msg"];
        // 错误码
        NSString *status = dic[@"status"];
        
        NSDictionary *resultDict = dic[@"result"];
        
        // 清除所有items
        [weakSelf.resultSection removeAllItems];
        
        // 是否成功
        if ([msg isEqualToString:@"ok"]) {
            
            // 运营商
            NSString *company = [NSString stringWithFormat:@"运营商:\t%@", resultDict[@"company"]];
            [weakSelf.resultSection addItem:[RETableViewItem itemWithTitle:company]];
            
            // 卡类别
            NSString *cardtype = [NSString stringWithFormat:@"卡类别:\t%@", resultDict[@"cardtype"]];
            [weakSelf.resultSection addItem:[RETableViewItem itemWithTitle:cardtype]];
            
            // 归属地
            NSString *region = [NSString stringWithFormat:@"归属地:\t%@%@", resultDict[@"province"], resultDict[@"city"]];
            [weakSelf.resultSection addItem:[RETableViewItem itemWithTitle:region]];
            
        } else if (status.integerValue == 203 || status.integerValue == 202){
            [weakSelf.resultSection addItem:[RETableViewItem itemWithTitle:@"查询失败，可能是手机号码输入有误"]];
        } else if (status.integerValue == 201) {
            [weakSelf.resultSection addItem:[RETableViewItem itemWithTitle:@"查询失败，手机号码不能为空"]];
        }
        
        // 重新加载section
        [weakSelf.resultSection reloadSectionWithAnimation:UITableViewRowAnimationAutomatic];
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [SVProgressHUD dismiss];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)dealloc
{
    NSLog(@"ZCPhoneNumberTableViewCollection dealloc");
}


@end
