//
//  ZCGoldTableViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/11/6.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCGoldTableViewController.h"
#import "ZCHeader.h"
#import <RETableViewManager/RETableViewOptionsController.h>

@interface ZCGoldTableViewController ()

@property (nonatomic, strong) RETableViewManager *manager;
@property (nonatomic, strong) RETableViewSection *headerSection;
@property (nonatomic, strong) RETableViewSection *resultSection;
@property (nonatomic, strong) RERadioItem *typeItem;

@property (nonatomic, strong) NSArray *typeArray;

@end

@implementation ZCGoldTableViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (NSArray *)typeArray {
    if (_typeArray == nil) {
        
        NSArray *tempArray = @[@"黄金延期", @"迷你黄金延期", @"沪金99", @"沪铂95", @"沪金100G", @"延期双金", @"延期单金", @"iAu100", @"iAu99.5", @"iAu99.9", @"沪金95"];
        NSMutableArray *array = [NSMutableArray array];
        
        for (int i = 0; i < 11; i++) {
            NSString *string = [NSString stringWithFormat:@"%d - %@", i, tempArray[i]];
            [array addObject:string];
        }
        
        _typeArray = [NSArray arrayWithArray:array];
    }
    
    
    return _typeArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"黄金价格";
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    self.manager.style.cellHeight = 36;
    
    // 添加section
    [self addSectionSearch];
    [self addSectionResult];
    [self addSectionButton];
    
    
}

// 添加第一个section
- (void)addSectionSearch {
    
    UIImage *image = [UIImage imageNamed:@"gold"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
    imageView.contentMode = UIViewContentModeCenter;
    
    // 添加头部视图
    RETableViewSection *headerSection = [RETableViewSection sectionWithHeaderView:imageView];
    [self.manager addSection:headerSection];
    headerSection.footerTitle = @"上海黄金交易所,提供AU9999、黄金995、黄金延期、迷你黄金延期、延期单金、延期双金、沪金100G、沪金50G、沪金95、沪金99、IAU100G、IAU99.5、IAU99.99、IAU99.9、M黄金延期、沪铂95等品种的买入价、卖出价、最低价、最高价、成交量等数据";
    self.headerSection = headerSection;
    
    // 选择查询黄金种类
    RERadioItem *typeItem = [self createSwapOutInItemWithTitle:@"选择黄金种类" value:@"0 - 黄金延期"];
    [headerSection addItem:typeItem];
    self.typeItem = typeItem;
    
}

// 抽出一个方法，专门写创建RERadioItem
- (RERadioItem *)createSwapOutInItemWithTitle:(NSString *)title value:(NSString *)value {
    
    __typeof(self) __weak weakSelf = self;
    
    RERadioItem *swapOutIn = [RERadioItem itemWithTitle:title value:value selectionHandler:^(RERadioItem *item) {
        
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:weakSelf.typeArray multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem) {
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
            [item reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
            
        }];
        
        optionsController.hidesBottomBarWhenPushed = YES;
        
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
        
    }];
    
    return swapOutIn;
    
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
        
        // 读取item数据
        RETextItem *typeItem = self.headerSection.items[0];
        
        if (typeItem.value) {
            // 查询数据
            [self getGoldPriceWithNumber:typeItem.value];
            [SVProgressHUD showWithStatus:@"查询中..."];
        }
        
        // item取消选择
        [item deselectRowAnimated:UITableViewRowAnimationAutomatic];
    }];
    buttonItem.textAlignment = NSTextAlignmentCenter;
    [section addItem:buttonItem];
    
}

- (void)getGoldPriceWithNumber:(NSString *)number {
    
    NSArray *numberArr = [number componentsSeparatedByString:@" - "];
    NSString *numberStr = [numberArr firstObject];
    
    [ZCSearchHttpRequest getGoldPriceBackSuccuss:^(id JSON) {
        
        NSDictionary *dic = JSON;
        
        NSArray *resultArr = dic[@"result"];
        
        NSString *msg = dic[@"msg"];
        
        // 清空
        [self.resultSection removeAllItems];
        
        // 是否成功
        if ([msg isEqualToString:@"ok"]) {
            
            NSDictionary *dict = resultArr[numberStr.intValue];

            // 品种
            NSString *type = [NSString stringWithFormat:@"品种: %@:%@", dict[@"type"], dict[@"typename"]];
            [self.resultSection addItem:[RETableViewItem itemWithTitle:type]];
            
            // 最新价
            NSString *price = [NSString stringWithFormat:@"最新价: %@", dict[@"price"]];
            RETableViewItem *priceItem = [RETableViewItem itemWithTitle:price];
            [self.resultSection addItem:priceItem];
            
            // 开盘价
            NSString *openingprice = [NSString stringWithFormat:@"开盘价: %@", dict[@"openingprice"]];
            RETableViewItem *openingpriceItem = [RETableViewItem itemWithTitle:openingprice];
            [self.resultSection addItem:openingpriceItem];
            
            // 最高最低价
            NSString *maxminPrice = [NSString stringWithFormat:@"最高价: %@ 最低价: %@", dict[@"maxprice"], dict[@"minprice"]];
            RETableViewItem *maxminPriceItem = [RETableViewItem itemWithTitle:maxminPrice];
            [self.resultSection addItem:maxminPriceItem];
            
            // 涨跌幅
            NSString *changepercent = [NSString stringWithFormat:@"涨跌幅: %@", dict[@"changepercent"]];
            [self.resultSection addItem:[RETableViewItem itemWithTitle:changepercent]];
            
            // 昨收盘价
            NSString *lastclosingprice = [NSString stringWithFormat:@"昨收盘价: %@", dict[@"lastclosingprice"]];
            RETableViewItem *lastclosingpriceItem = [RETableViewItem itemWithTitle:lastclosingprice];
            [self.resultSection addItem:lastclosingpriceItem];
            
            // 总成交量
            NSString *tradeamount = [NSString stringWithFormat:@"总成交量: %@", dict[@"tradeamount"]];
            RETableViewItem *tradeamountItem = [RETableViewItem itemWithTitle:tradeamount];
            [self.resultSection addItem:tradeamountItem];
            
            // 更新时间
            NSString *updatetime = [NSString stringWithFormat:@"更新时间: %@", dict[@"updatetime"]];
            RETableViewItem *updatetimeItem = [RETableViewItem itemWithTitle:updatetime];
            [self.resultSection addItem:updatetimeItem];
            
            
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
