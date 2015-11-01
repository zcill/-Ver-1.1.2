//
//  ZCCurrencyTableViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/10/29.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCCurrencyTableViewController.h"
#import "ZCHeader.h"
#import <RETableViewManager/RETableViewOptionsController.h>

@interface ZCCurrencyTableViewController ()

@property (nonatomic, strong) RETableViewManager *manager;
@property (nonatomic, strong) NSArray *currencyArray;
@property (nonatomic, strong) RETextItem *numberItem;
@property (nonatomic, strong) RERadioItem *swapOut;
@property (nonatomic, strong) RERadioItem *swapIn;
@property (nonatomic, strong) RETableViewSection *resultSection;

@end

@implementation ZCCurrencyTableViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (NSArray *)currencyArray {
    
    if (_currencyArray == nil) {
        
        // 处理plist中的字典
        NSArray *tempArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CurrencyCode" ofType:@"plist"]];
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSDictionary *dict in tempArray) {
            NSString *string = [NSString stringWithFormat:@"%@ - %@", dict[@"currency"], dict[@"name"]];
            [array addObject:string];
        }
        
        _currencyArray = [NSArray arrayWithArray:array];
        
    }
    return _currencyArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"货币汇率查询";
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    self.manager.style.cellHeight = 36;
    
    // 添加section
    [self addSectionSearch];
    [self addSectionResult];
    [self addSectionButton];
    
    
}

// 添加第一个section
- (void)addSectionSearch {
    
    UIImage *image = [UIImage imageNamed:@"a7"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
    imageView.contentMode = UIViewContentModeCenter;
    
    // 添加头部视图
    RETableViewSection *headerSection = [RETableViewSection sectionWithHeaderView:imageView];
    [self.manager addSection:headerSection];
    headerSection.footerTitle = @"强大的货币汇率!包括人民币、美元、英镑、日元、港币等绝大多数国家和地区的货币汇率换算。实时汇率换算查询，货币汇率自动按照国际价进行调整";
    
    __typeof(self) __weak weakSelf = self;
    // 兑换货币
    RERadioItem *swapOut = [weakSelf createSwapOutInItemWithTitle:@"兑换货币" value:@"CNY - 人民币"];
    [headerSection addItem:swapOut];
    self.swapOut = swapOut;
    
    // 换入货币
    RERadioItem *swapIn = [weakSelf createSwapOutInItemWithTitle:@"换入货币" value:@"USD - 美元"];
    [headerSection addItem:swapIn];
    self.swapIn = swapIn;
    
    RETextItem *numberItem = [RETextItem itemWithTitle:@"兑换金额" value:nil placeholder:@"请输入兑换金额"];
    numberItem.keyboardType = UIKeyboardTypeDecimalPad;
    [headerSection addItem:numberItem];
    self.numberItem = numberItem;
    
}

// 抽出一个方法，专门写创建RERadioItem
- (RERadioItem *)createSwapOutInItemWithTitle:(NSString *)title value:(NSString *)value {
    
    __typeof(self) __weak weakSelf = self;
    
    RERadioItem *swapOutIn = [RERadioItem itemWithTitle:title value:value selectionHandler:^(RERadioItem *item) {

        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:weakSelf.currencyArray multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem) {
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
            [item reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
            
        }];
        
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
    
    // 消除强引用
    __typeof (self) __weak weakSelf = self;
    RETableViewItem *buttonItem = [RETableViewItem itemWithTitle:@"查询" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        
        if (weakSelf.numberItem.value) {
            
            // 查询数据
            [weakSelf getCurrencyDataWithFrom:[weakSelf.swapOut.value substringToIndex:3] to:[weakSelf.swapIn.value substringToIndex:3]];
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
         "camount" : "635.56",
         "from" : "USD",
         "fromname" : "美元",
         "rate" : "6.3556",
         "to" : "CNY",
         "toname" : "人民币",
         "updatetime" : "2015-10-29 19:32:32"
     },
     "status" : "0"
 }
 */

- (void)getCurrencyDataWithFrom:(NSString *)from to:(NSString *)to {
    
    __typeof (self) __weak weakSelf = self;
    [ZCSearchHttpRequest getCurrencyDataWithFrom:from to:to amount:weakSelf.numberItem.value success:^(id JSON) {
        
        NSDictionary *dic = JSON;
        
        NSDictionary *resultDict = dic[@"result"];
        
        NSString *msg = dic[@"msg"];
        
        // 清空
        [weakSelf.resultSection removeAllItems];
        
        // 是否成功
        if ([msg isEqualToString:@"ok"]) {
            // from货币
            NSString *fromCurrency = [NSString stringWithFormat:@"%@ - %@: \t%@", resultDict[@"from"], resultDict[@"fromname"], weakSelf.numberItem.value];
            [weakSelf.resultSection addItem:[RETableViewItem itemWithTitle:fromCurrency]];
            
            // 当前汇率
            NSString *rate = [NSString stringWithFormat:@"当前兑换汇率: \t\t%@", resultDict[@"rate"]];
            [weakSelf.resultSection addItem:[RETableViewItem itemWithTitle:rate]];
            
            // to货币
            NSString *toCurrency = [NSString stringWithFormat:@"%@ - %@: \t%@", resultDict[@"to"], resultDict[@"toname"], resultDict[@"camount"]];
            [weakSelf.resultSection addItem:[RETableViewItem itemWithTitle:toCurrency]];
            
            // 当前汇率更新日期
            NSString *updatetime = [NSString stringWithFormat:@"汇率更新日期: %@", resultDict[@"updatetime"]];
            [weakSelf.resultSection addItem:[RETableViewItem itemWithTitle:updatetime]];
            
        } else {
            [weakSelf.resultSection addItem:[RETableViewItem itemWithTitle:@"查询失败，可能输入有误"]];
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
    NSLog(@"ZCCurrencyTableViewController dealloc");
}

@end
