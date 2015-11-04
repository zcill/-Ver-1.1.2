//
//  ZCRevenueTableViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/11/3.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCRevenueTableViewController.h"
#import "ZCHeader.h"
#import <RETableViewManager/RETableViewOptionsController.h>

@interface ZCRevenueTableViewController ()

@property (nonatomic, strong) RETableViewManager *manager;
@property (nonatomic, strong) NSArray *currencyArray;
@property (nonatomic, strong) RETableViewSection *resultSection;
@property (nonatomic, strong) RETextItem *numberItem;
@property (nonatomic, strong) REPickerItem *pickerItem;

@property (nonatomic, assign) float taxPayable;
@property (nonatomic, assign) float afterTax;

@end

@implementation ZCRevenueTableViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"税收计算";
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    self.manager.style.cellHeight = 36;
    
    // 添加section
    [self addSectionSearch];
    [self addSectionResult];
    [self addSectionButton];
    
    
}

// 添加第一个section
- (void)addSectionSearch {
    
    UIImage *image = [UIImage imageNamed:@"s7"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
    imageView.contentMode = UIViewContentModeCenter;
    
    // 添加头部视图
    RETableViewSection *headerSection = [RETableViewSection sectionWithHeaderView:imageView];
    [self.manager addSection:headerSection];
    headerSection.footerTitle = @"根据最新的个人所得税税率表，计算个人税收情况";
    
    // 工资收入
    RETextItem *numberItem = [RETextItem itemWithTitle:@"工资收入" value:nil placeholder:@"请输入收入总额"];
    numberItem.keyboardType = UIKeyboardTypeDecimalPad;
    [headerSection addItem:numberItem];
    self.numberItem = numberItem;
    
    // 选择种类
    REPickerItem *pickerItem = [REPickerItem itemWithTitle:@"收入类型:" value:@[@"个人税收"] placeholder:nil options:@[@[@"个人税收", @"个体商户税收"]]];
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
        
        if (self.numberItem.value) {
            
            NSString *value = [self.pickerItem.value lastObject];
            
            if ([value isEqualToString:@"个人税收"]) {
                [self caculateRevenue:self.numberItem.value.doubleValue];
            } else {
                [self caculateRevenueOfBusiness:self.numberItem.value.doubleValue];
            }
            
            // 清除所有items
            [self.resultSection removeAllItems];
            
            // 应缴纳税款
            NSString *payTax = [NSString stringWithFormat:@"应缴税款: %.3f", self.taxPayable];
            [self.resultSection addItem:[RETableViewItem itemWithTitle:payTax]];
            
            // 税后收入
            NSString *afterTax = [NSString stringWithFormat:@"税后收入: %.3f", self.afterTax];
            [self.resultSection addItem:[RETableViewItem itemWithTitle:afterTax]];
            
            
            // 重新加载section
            [self.resultSection reloadSectionWithAnimation:UITableViewRowAnimationAutomatic];
        }
        // item取消选择
        [item deselectRowAnimated:UITableViewRowAnimationAutomatic];
    }];
    
    buttonItem.textAlignment = NSTextAlignmentCenter;
    [section addItem:buttonItem];
    
}

// 计算个人税收
- (void)caculateRevenue:(NSInteger)number {
    
    // 低于起征点的话，不需要交税
    if (number <= 3500) {
        self.taxPayable = 0;
        self.afterTax = number;
        return;
    }
    
    // 减去3500的起征点
    NSInteger difference = number - 3500;
    
    // 税率计算相关
    int tax[] = {0, 105, 555, 1005, 2775, 5505, 13505};
    float percent[] = {0.03, 0.1, 0.2, 0.25, 0.3, 0.35, 0.45};
    
    float Money = difference;
    float taxTotal = 0;
    
    int i = (Money >= 1500) + (Money >= 4500) + (Money >= 9000) + (Money >= 35000) + (Money >= 55000) + (Money >= 80000);
    
    taxTotal = Money * percent[i] - tax[i];
    
    NSLog(@"%f", taxTotal);
    
    self.taxPayable = taxTotal;
    self.afterTax = number - taxTotal;

}

// 计算个体商户税收
- (void)caculateRevenueOfBusiness:(double)number {
    
    // 低于起征点的话，不需要交税
    if (number <= 20000) {
        self.taxPayable = 0;
        self.afterTax = number;
        return;
    }
    
    // 减去20000的起征点
    NSInteger difference = number - 20000;
    
    int tax[] = {0, 750, 3750, 9750, 14750};
    float percent[] = {0.05, 0.1, 0.2, 0.3, 0.35};
    
    float Money = difference;
    float taxTotal = 0;
    
    int i = (Money >= 15000) + (Money >= 30000) + (Money >= 60000) + (Money >= 100000);
    
    taxTotal = Money * percent[i] - tax[i];
    
    NSLog(@"%f", taxTotal);
    
    self.taxPayable = taxTotal;
    self.afterTax = number - taxTotal;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    NSLog(@"ZCRevenueTableViewController dealloc");
}

@end
