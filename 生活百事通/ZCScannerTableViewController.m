//
//  ZCScannerTableViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/11/1.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCScannerTableViewController.h"
#import "ZCHeader.h"
#import <RETableViewManager/RETableViewOptionsController.h>

#import "ScanViewController.h"
#import "InfoViewController.h"
#import "MakerViewController.h"

#import "JKAlert.h"
#import "DateManager.h"
#import "Scanner.h"

@interface ZCScannerTableViewController ()
{
    ScanViewController *scan;
    UIButton *turnButton;
    UIButton *makerButton;
}

@property (nonatomic, strong) RETableViewManager *manager;
@property (nonatomic, strong) RETableViewItem *historyItem;
@property (nonatomic, strong) RETableViewItem *scanItem;
@property (nonatomic, strong) RETableViewItem *makeItem;
@property (nonatomic, strong) RETableViewSection *resultSection;

@end

@implementation ZCScannerTableViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"二维码扫描";
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    self.manager.style.cellHeight = 36;
    
    // 添加section
    [self addSectionHeader];
    [self addSectionScan];
}

// 添加section
- (void)addSectionHeader {
    
    UIImage *image = [UIImage imageNamed:@"a0"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
    imageView.contentMode = UIViewContentModeCenter;
    
    // 添加头部视图
    RETableViewSection *headerSection = [RETableViewSection sectionWithHeaderView:imageView];
    [self.manager addSection:headerSection];
    headerSection.footerTitle = @"扫描二维码、条形码，也可以生成二维码";
    
}

- (void)addSectionScan {
    
    // 添加头部视图
    RETableViewSection *headerSection = [RETableViewSection section];
    [self.manager addSection:headerSection];
    
    // 扫描
    RETableViewItem *scanItem = [RETableViewItem itemWithTitle:@"扫描二维码" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
        scan = [[ScanViewController alloc] init];
        [scan finishingBlock:^(NSString *string) {
            NSLog(@"string:%@",string);
            InfoViewController *info = [[InfoViewController alloc]init];
            NSDictionary *item =  @{@"time":[DateManager nowTimeStampString],@"date":[DateManager stringConvert_YMD_FromDate:[NSDate date]],@"content":string?:@""};
            info.item = item;
            [Scanner insert:item];
            [self.navigationController pushViewController:info animated:YES];
            
        }];
        
        turnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [turnButton setImage:[UIImage imageNamed:@"icon_light_normal.png"] forState:UIControlStateNormal];
        [turnButton setImage:[UIImage imageNamed:@"icon_light.png"] forState:UIControlStateSelected];
        
        turnButton.frame = CGRectMake(0, 0, 20, 20);
        [turnButton addTarget:self action:@selector(turnLightTouched:) forControlEvents:UIControlEventTouchUpInside];
        turnButton.selected = scan.lighting;
        [scan addRightBarButtonItem:turnButton];
        
        scan.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:scan animated:YES];
        
    }];
    [headerSection addItem:scanItem];
    self.scanItem = scanItem;
    
    // 生成二维码
    RETableViewItem *makeItem = [RETableViewItem itemWithTitle:@"生成二维码" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
        MakerViewController *maker = [[MakerViewController alloc] init];
        
        makerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [makerButton setImage:[UIImage imageNamed:@"icon_done.png"] forState:UIControlStateNormal];
        
        makerButton.frame = CGRectMake(0, 0, 25, 25);
        [makerButton addTarget:maker action:@selector(makerTouched:) forControlEvents:UIControlEventTouchUpInside];
        [maker addRightBarButtonItem:makerButton];
        
        maker.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:maker animated:YES];
        
    }];
    [headerSection addItem:makeItem];
    self.makeItem = makeItem;
    
}

- (void)turnLightTouched:(UIButton*)sender{
    if (!sender) {
        [scan turnLight:NO];
        turnButton.selected = NO;
    }else{
        [scan turnLight:!scan.lighting];
        turnButton.selected = scan.lighting;
    }
}

- (void)addLeftBarButtonItem:(UIButton *)button
{
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        // Add a negative spacer on iOS >= 7.0
        negativeSpacer.width = -10;
    } else {
        // Just set the UIBarButtonItem as you would normally
        negativeSpacer.width = 0;
        [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    }
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, leftBarButtonItem, nil]];
}
- (void)addRightBarButtonItem:(UIButton *)button
{
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        negativeSpacer.width = -10;
        
    } else {
        negativeSpacer.width = 0;
    }
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, rightBarButtonItem, nil]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
