//
//  ZCIDCardSearchTableViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/10/28.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCIDCardSearchTableViewController.h"
#import "ZCHeader.h"

@interface ZCIDCardSearchTableViewController ()

@property (nonatomic, strong) RETableViewManager *manager;
@property (nonatomic, strong) RETableViewSection *resultSection;
@property (nonatomic, strong) RETableViewSection *IDCardSection;

@end

@implementation ZCIDCardSearchTableViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
    
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"国内身份证查询验证";
    
//    self.view.backgroundColor = RGBA(231, 231, 231, 1);
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    self.manager.style.cellHeight = 36;
    
    // 添加section
    [self addSectionSearch];
    [self addSectionResult];
    [self addSectionButton];
    
    
}

// 添加第一个section
- (void)addSectionSearch {
    
    UIImage *image = [UIImage imageNamed:@"s3"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
    imageView.contentMode = UIViewContentModeCenter;
    
    // 添加头部视图
    RETableViewSection *IDCardSection = [RETableViewSection sectionWithHeaderView:imageView];
    IDCardSection.footerTitle = @"身份证查询系统，可以查询户口所在地和性别。请勿用于非法途径!";
    
    [self.manager addSection:IDCardSection];
    self.IDCardSection = IDCardSection;
    
    RETextItem *IDCardItem = [RETextItem itemWithTitle:@"身份证号码:" value:nil placeholder:@"请输入身份证号码"];
    [IDCardSection addItem:IDCardItem];
    
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
        RETextItem *IDCardItem = weakSelf.IDCardSection.items[0];
        
        if (IDCardItem.value) {
            // 查询数据
            [weakSelf getIDCardData:IDCardItem.value];
            [SVProgressHUD showWithStatus:@"查询中..."];
        }
        
        // item取消选择
        [item deselectRowAnimated:UITableViewRowAnimationAutomatic];
    }];
    buttonItem.textAlignment = NSTextAlignmentCenter;
    [section addItem:buttonItem];
    
}

/*
 birth = "1995\U5e7403\U670820\U65e5";
 city = "\U6ec1\U5dde\U5e02";
 lastflag = 0;
 province = "\U5b89\U5fbd\U7701";
 sex = "\U7537";
 town = "\U6765\U5b89\U53bf";
 */

// 查询数据
- (void)getIDCardData:(NSString *)IDCard {
    
    __typeof (self) __weak weakSelf = self;
    [ZCSearchHttpRequest getIDCardDataWithIDCardNumber:IDCard success:^(id JSON) {
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
            
            // 生日
            NSString *birth = [NSString stringWithFormat:@"生日:\t%@", resultDict[@"birth"]];
            [weakSelf.resultSection addItem:[RETableViewItem itemWithTitle:birth]];
            
            // 性别
            NSString *sex = [NSString stringWithFormat:@"性别:\t%@", resultDict[@"sex"]];
            [weakSelf.resultSection addItem:[RETableViewItem itemWithTitle:sex]];
            
            // 地区
            NSString *region = [NSString stringWithFormat:@"地区:\t%@%@%@", resultDict[@"province"], resultDict[@"city"], resultDict[@"town"]];
            [weakSelf.resultSection addItem:[RETableViewItem itemWithTitle:region]];
            
        } else if (status.integerValue == 203 || status.integerValue == 202){
            [weakSelf.resultSection addItem:[RETableViewItem itemWithTitle:@"查询失败，可能是身份证号码输入有误"]];
        } else if (status.integerValue == 201) {
            [weakSelf.resultSection addItem:[RETableViewItem itemWithTitle:@"查询失败，身份证号码不能为空"]];
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
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"ZCIDCardSearchTableViewController dealloc");
}

@end
