//
//  ZCTVTableViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/11/4.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCTVTableViewController.h"
#import "ZCHeader.h"
#import <RETableViewManager/RETableViewOptionsController.h>

@interface ZCTVTableViewController ()

@property (nonatomic, strong) RETableViewManager *manager;
@property (nonatomic, strong) RETableViewSection *resultSection;
@property (nonatomic, strong) RETableViewSection *tvSection;
@property (nonatomic, strong) RERadioItem *channelItem;
//@property (nonatomic, strong) RETextItem *timeItem;
@property (nonatomic, strong) RENumberItem *timeItem;

@property (nonatomic, strong) NSArray *citiesArray;

@end

@implementation ZCTVTableViewController

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
        NSDictionary *tempDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TV_Channel" ofType:@"plist"]];
        NSArray *resultArr = tempDict[@"result"];
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSDictionary *dict in resultArr) {
            NSString *string = [NSString stringWithFormat:@"%@ - %@", dict[@"tvid"], dict[@"name"]];
            [array addObject:string];
        }
        
        _citiesArray = [NSArray arrayWithArray:array];
    }
    
    return _citiesArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"电视节目详情查询";
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    self.manager.style.cellHeight = 36;
    
    // 添加section
    [self addSectionSearch];
    [self addSectionResult];
    [self addSectionButton];
    
    
}

// 添加第一个section
- (void)addSectionSearch {
    
    UIImage *image = [UIImage imageNamed:@"tv"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
    imageView.contentMode = UIViewContentModeCenter;
    
    // 添加头部视图
    RETableViewSection *tvSection = [RETableViewSection sectionWithHeaderView:imageView];
    tvSection.footerTitle = @"电视节目查询系统，可以查询指定境内境外各大电视台的节目信息，数据库包含超过2000多家电视台的数据";
    
    [self.manager addSection:tvSection];
    self.tvSection = tvSection;
    
    __typeof (self) __weak weakSelf = self;
    
    RERadioItem *channelItem = [weakSelf createSwapOutInItemWithTitle:@"频道" value:@"请选择电视频道"];
    [tvSection addItem:channelItem];
    self.channelItem = channelItem;
    
    RENumberItem *timeItem = [RENumberItem itemWithTitle:@"日期" value:nil placeholder:@"请输入查询日期" format:@"XXXX-XX-XX"];
    [tvSection addItem:timeItem];
    self.timeItem = timeItem;
    
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
        RETextItem *tvid = weakSelf.tvSection.items[0];
        
        if (tvid.value) {
            // 查询数据
            [weakSelf getTVDataWithTvID:tvid.value];
            [SVProgressHUD showWithStatus:@"查询中..."];
        }
        
        // item取消选择
        [item deselectRowAnimated:UITableViewRowAnimationAutomatic];
    }];
    buttonItem.textAlignment = NSTextAlignmentCenter;
    [section addItem:buttonItem];
    
}

- (void)getTVDataWithTvID:(NSString *)tvid {
    
    NSArray *tvArr = [tvid componentsSeparatedByString:@" - "];
    NSString *tvID = [tvArr firstObject];
    
    [ZCSearchHttpRequest getTVDataWithTVID:tvID date:self.timeItem.value succuss:^(id JSON) {
        
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
        if (!resultDict[@"program"]) {
            [SVProgressHUD showErrorWithStatus:@"没有信息"];
            return;
        }
        
        NSArray *program = resultDict[@"program"];
        
        // 清除所有items
        [self.resultSection removeAllItems];
        
        // 是否成功
        if ([msg isEqualToString:@"ok"]) {
            
            for (NSDictionary *dict in program) {
                
                // 具体状态
                NSString *status = [NSString stringWithFormat:@"节目: %@: %@", dict[@"starttime"], dict[@"name"]];
                RETableViewItem *statusItem = [RETableViewItem itemWithTitle:status accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
                    
                    // 点击可以弹出弹框
                    [SVProgressHUD showInfoWithStatus:status];
                    
                }];
                [self.resultSection addItem:statusItem];
                
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
