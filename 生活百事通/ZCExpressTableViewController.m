//
//  ZCExpressTableViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/11/4.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCExpressTableViewController.h"
#import "ZCHeader.h"
#import <RETableViewManager/RETableViewOptionsController.h>

@interface ZCExpressTableViewController ()

@property (nonatomic, strong) RETableViewManager *manager;
@property (nonatomic, strong) RETableViewSection *resultSection;
@property (nonatomic, strong) RETableViewSection *expressSection;
@property (nonatomic, strong) RERadioItem *companyItem;
@property (nonatomic, strong) RETextItem *numberItem;

@property (nonatomic, strong) NSArray *citiesArray;

@end

@implementation ZCExpressTableViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (NSArray *)citiesArray {
    
    if (_citiesArray == nil) {
        
        // 处理plist中的字典
        NSDictionary *tempDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"express" ofType:@"plist"]];
        NSArray *resultArr = tempDict[@"result"];
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSDictionary *dict in resultArr) {
            NSString *string = [NSString stringWithFormat:@"%@ - %@", dict[@"type"], dict[@"name"]];
            [array addObject:string];
        }
        
        _citiesArray = [NSArray arrayWithArray:array];
    }
    
    return _citiesArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"快递详情查询";
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    self.manager.style.cellHeight = 36;
    
    // 添加section
    [self addSectionSearch];
    [self addSectionResult];
    [self addSectionButton];
    
    
}

// 添加第一个section
- (void)addSectionSearch {
    
    UIImage *image = [UIImage imageNamed:@"express"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
    imageView.contentMode = UIViewContentModeCenter;
    
    // 添加头部视图
    RETableViewSection *expressSection = [RETableViewSection sectionWithHeaderView:imageView];
    expressSection.footerTitle = @"快递详单查询系统，可以查询指定快递公司的物流信息";
    
    [self.manager addSection:expressSection];
    self.expressSection = expressSection;
    
    __typeof (self) __weak weakSelf = self;
    
    RERadioItem *companyItem = [weakSelf createSwapOutInItemWithTitle:@"快递公司" value:@"请选择快递公司"];
    [expressSection addItem:companyItem];
    self.companyItem = companyItem;
    
    RETextItem *numberItem = [RETextItem itemWithTitle:@"快递单号" value:nil];
    [expressSection addItem:numberItem];
    self.numberItem = numberItem;
    
}

// 抽出一个方法，专门写创建RERadioItem
- (RERadioItem *)createSwapOutInItemWithTitle:(NSString *)title value:(NSString *)value {
    
    __typeof(self) __weak weakSelf = self;
    
    RERadioItem *swapOutIn = [RERadioItem itemWithTitle:title value:value selectionHandler:^(RERadioItem *item) {
        
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:weakSelf.citiesArray multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem) {
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
            [item reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
            
        }];
        
        optionsController.hidesBottomBarWhenPushed = YES;
        
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
        
    }];
    
    return swapOutIn;
    
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
        RETextItem *companyCode = weakSelf.expressSection.items[0];
        
        if (companyCode.value) {
            // 查询数据
            [weakSelf getExpressDataWithCompany:companyCode.value];
            [SVProgressHUD showWithStatus:@"查询中..."];
        }
        
        // item取消选择
        [item deselectRowAnimated:UITableViewRowAnimationAutomatic];
    }];
    buttonItem.textAlignment = NSTextAlignmentCenter;
    [section addItem:buttonItem];
    
}

- (void)getExpressDataWithCompany:(NSString *)company {
    
    NSArray *companyArr = [company componentsSeparatedByString:@" - "];
    NSString *companyID = [companyArr firstObject];
    
    [ZCSearchHttpRequest getExpressDataWithCompanyID:companyID number:self.numberItem.value succuss:^(id JSON) {
        
        NSLog(@"%@", JSON);
        NSDictionary *dic = JSON;
        NSString *msg = dic[@"msg"];
        
        // 判断result是否为@""字符串，是就返回msg错误信息
        if (![dic[@"result"] isKindOfClass:[NSDictionary class]]) {
            
            if ([dic[@"result"] isEqualToString:@""]) {
                [SVProgressHUD showErrorWithStatus:msg];
                return ;
            }
            
        }
        
        NSDictionary *resultDict = dic[@"result"];
        
        // 判断返回是否有list数组，没有就返回无信息
        if (!resultDict[@"list"]) {
            [SVProgressHUD showErrorWithStatus:@"没有信息"];
            return;
        }
        
        NSArray *list = resultDict[@"list"];
        
        // 清除所有items
        [self.resultSection removeAllItems];
        
        // 是否成功
        if ([msg isEqualToString:@"ok"]) {
            
            for (NSDictionary *dict in list) {
                
                // 具体状态
                NSString *station = [NSString stringWithFormat:@"状态%@: %@", dict[@"status"], dict[@"time"]];
                [self.resultSection addItem:[RETableViewItem itemWithTitle:station]];
                
            }
            
        } else {
            [self.resultSection addItem:[RETableViewItem itemWithTitle:@"查询失败，可能输入的路线有误"]];
        }
        
        // 重新加载section
        [self.resultSection reloadSectionWithAnimation:UITableViewRowAnimationAutomatic];
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}

@end
