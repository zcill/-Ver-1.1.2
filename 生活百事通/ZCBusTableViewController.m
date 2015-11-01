//
//  ZCBusTableViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/10/30.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCBusTableViewController.h"
#import "ZCHeader.h"
#import <RETableViewManager/RETableViewOptionsController.h>

@interface ZCBusTableViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) RETableViewManager *manager;
@property (nonatomic, strong) RETableViewSection *resultSection;
@property (nonatomic, strong) RETableViewSection *busSection;
@property (nonatomic, strong) RERadioItem *busCityItem;
@property (nonatomic, strong) RETextItem *busLineItem;

@property (nonatomic, strong) NSArray *citiesArray;

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation ZCBusTableViewController

- (NSArray *)citiesArray {
    
    if (_citiesArray == nil) {
        
        // 处理plist中的字典
        NSArray *tempArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Bus_Cities" ofType:@"plist"]];
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSDictionary *dict in tempArray) {
            NSString *string = [NSString stringWithFormat:@"%@ - %@", dict[@"cityid"], dict[@"name"]];
            [array addObject:string];
        }
        
        _citiesArray = [NSArray arrayWithArray:array];
    }
    
    
    return _citiesArray;
}

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"全国公交查询";
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    self.manager.style.cellHeight = 36;
    
    // 添加section
    [self addSectionSearch];
    [self addSectionResult];
    [self addSectionButton];
    
    
}

// 添加第一个section
- (void)addSectionSearch {
    
    UIImage *image = [UIImage imageNamed:@"s4"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
    imageView.contentMode = UIViewContentModeCenter;
    
    // 添加头部视图
    RETableViewSection *busSection = [RETableViewSection sectionWithHeaderView:imageView];
    busSection.footerTitle = @"公交查询系统，可以查询指定城市以及全城公交线路";
    
    [self.manager addSection:busSection];
    self.busSection = busSection;
    
    __typeof (self) __weak weakSelf = self;
    
    RERadioItem *busCityItem = [weakSelf createSwapOutInItemWithTitle:@"城市" value:@"请选择城市"];
    [busSection addItem:busCityItem];
    self.busCityItem = busCityItem;
    
    RETextItem *busLineItem = [RETextItem itemWithTitle:@"线路" value:nil];
    [busSection addItem:busLineItem];
    self.busLineItem = busLineItem;
    

    
}

// 抽出一个方法，专门写创建RERadioItem
- (RERadioItem *)createSwapOutInItemWithTitle:(NSString *)title value:(NSString *)value {
    
    __typeof(self) __weak weakSelf = self;
    
    RERadioItem *swapOutIn = [RERadioItem itemWithTitle:title value:value selectionHandler:^(RERadioItem *item) {
        
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:weakSelf.citiesArray multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem) {
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
            [item reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
            
        }];
        
        [self addSearchBar];
        optionsController.tableView.tableHeaderView = self.searchBar;
        
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
        
    }];
    
    return swapOutIn;
    
}

#pragma mark 添加搜索框
- (void)addSearchBar {
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 36);
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入城市名或拼音";
//    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
    
}

#pragma 搜索框代理方法
// 监听搜索框文字的改变
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    

    
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
        RETextItem *cityCodeItem = weakSelf.busSection.items[0];
        
        if (cityCodeItem.value) {
            // 查询数据
            [weakSelf getLineData:cityCodeItem.value];
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
    "endstation" : "八一广场北",
    "endstation2" : "师大瑶湖停车场",
    "list" : {
        "0" : [
                {
                    "sequenceno" : "1",
                    "station" : "师大瑶湖停车场"
                },
            ],
     
        "1": [
                {
                    "sequenceno" : "27",
                    "station" : "师大瑶湖停车场"
                }
            ]
        },
     "price" : "无人售票1元 普通卡0.9元每次 学生卡0.5元每次",
     "startstation" : "师大瑶湖停车场",
     "startstation2" : "八一广场北",
     "time" : "夏令始末班：6：10-20：30；冬令始末班：6：10-20：00",
     "transitno" : "208路[空调]"
     },
 "status" : "0"
 }
 */

// 查询数据
- (void)getLineData:(NSString *)cityID {
    
    __typeof (self) __weak weakSelf = self;
    [ZCSearchHttpRequest getBusLineDataWithCityID:cityID transitno:weakSelf.busLineItem.value succuss:^(id JSON) {
        
        NSLog(@"%@", JSON);
        NSDictionary *dic = JSON;
        
        NSDictionary *resultDict = dic[@"result"];
        
        NSString *msg = dic[@"msg"];
//        NSString *status = dic[@"status"];
        
        // 清除所有items
        [weakSelf.resultSection removeAllItems];
        
        // 是否成功
        if ([msg isEqualToString:@"ok"]) {
            
            // 公交线路名
            NSString *transitno = [NSString stringWithFormat:@"公交:\t%@", resultDict[@"transitno"]];
            [weakSelf.resultSection addItem:[RETableViewItem itemWithTitle:transitno]];
            
            // 发车时间
            NSString *time = [NSString stringWithFormat:@"发车时间:\t%@", resultDict[@"time"]];
            [weakSelf.resultSection addItem:[RETableViewItem itemWithTitle:time accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
                [SVProgressHUD showInfoWithStatus:time maskType:SVProgressHUDMaskTypeGradient];
            }]];
            
            // 价格
            NSString *price = [NSString stringWithFormat:@"价格:\t%@", resultDict[@"price"]];
            [weakSelf.resultSection addItem:[RETableViewItem itemWithTitle:price accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
                [SVProgressHUD showInfoWithStatus:price maskType:SVProgressHUDMaskTypeGradient];
            }]];
            
            // 始发站
            NSString *startStation = [NSString stringWithFormat:@"始发站:\t%@", resultDict[@"startstation"]];
            [weakSelf.resultSection addItem:[RETableViewItem itemWithTitle:startStation]];
            
            // 终点站
            NSString *endstation = [NSString stringWithFormat:@"终点站:\t%@", resultDict[@"endstation"]];
            [weakSelf.resultSection addItem:[RETableViewItem itemWithTitle:endstation]];
            
            NSArray *array = [NSArray array];
            
            // 具体路线
            // 判断list是数组还是字典
            if ([resultDict[@"list"] isKindOfClass:[NSArray class]]) {
                
                NSArray *list = resultDict[@"list"];
                NSArray *list0 = [list firstObject];
                array = [NSArray arrayWithArray:list0];
                
            } else if ([resultDict[@"list"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *list = resultDict[@"list"];
                NSArray *list0 = list[@"0"];
                array = [NSArray arrayWithArray:list0];
            }
            
            
            for (NSDictionary *dict in array) {
                
                // 具体站点
                NSString *station = [NSString stringWithFormat:@"站点%@: %@", dict[@"sequenceno"], dict[@"station"]];
                [weakSelf.resultSection addItem:[RETableViewItem itemWithTitle:station]];
                
            }
            
        } else {
            [weakSelf.resultSection addItem:[RETableViewItem itemWithTitle:@"查询失败，可能输入的路线有误"]];
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
    NSLog(@"ZCBusTableViewController dealloc");
}


@end
