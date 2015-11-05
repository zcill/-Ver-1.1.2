//
//  ZCTabBar.m
//  生活百事通
//
//  Created by 朱立焜 on 15/11/1.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCTabBar.h"
#import "ZCHeader.h"
#import "CSStickyHeaderFlowLayout.h"
#import "ZCMainCollectionViewController.h"
#import "ZCRootViewController.h"
#import "ZCAllToolsCollectionViewController.h"
#import "ZCUserTableViewController.h"
#import "ZCMapSearchViewController.h"

@interface ZCTabBar ()

@property (nonatomic, weak) ZCMainCollectionViewController *main;

@end

@implementation ZCTabBar

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customTabbar];
    [self setupAllSubViewControllers];
}

#pragma mark - 定制TabBar

- (void)customTabbar {
    
    self.tabBarController.tabBar.hidden = YES;
    // 设置不透明
    self.tabBar.translucent = NO;
    
    // 镂空颜色
    self.tabBar.tintColor = RGBA(244, 59, 51, 1);
    
}

#pragma mark - 初始化所有子控制器
- (void)setupAllSubViewControllers {
    
#warning ZCMainCollectionController必须要初始化flowLayout，否则crash
    
    // 使用第三方库的FlowLayout来创建布局
    CSStickyHeaderFlowLayout *layout = [[CSStickyHeaderFlowLayout alloc] init];
    //    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(80, 80);
    // 设置水平间距
    layout.minimumInteritemSpacing = 0;
    // 设置垂直间距
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    layout.parallaxHeaderReferenceSize = CGSizeMake(ScreenWidth, 165);
    layout.headerReferenceSize = CGSizeMake(200, 50);
    
    ZCMainCollectionViewController *main = [[ZCMainCollectionViewController alloc] initWithCollectionViewLayout:layout];
    main.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"mainNormal"] selectedImage:[UIImage imageNamed:@"mainSelected"]];
    
    [self addChildViewController:main title:@"生活"];
    self.main = main;
    
    
    ZCMapSearchViewController *navi2 = [[ZCMapSearchViewController alloc] init];
    navi2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"map"] selectedImage:[UIImage imageNamed:@"map"]];
    [self addChildViewController:navi2 title:@"地图"];
    
    
    UICollectionViewFlowLayout *toolsLayout = [[UICollectionViewFlowLayout alloc] init];
    toolsLayout.itemSize = CGSizeMake(80, 80);
    toolsLayout.minimumInteritemSpacing = 0;
    toolsLayout.minimumLineSpacing = 10;
    toolsLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    toolsLayout.headerReferenceSize = CGSizeMake(200, 50);
    
    ZCAllToolsCollectionViewController *allTools = [[ZCAllToolsCollectionViewController alloc] initWithCollectionViewLayout:toolsLayout];
    allTools.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"dingyueItemNormal"] selectedImage:[UIImage imageNamed:@"dingyueItemSelected"]];
    [self addChildViewController:allTools title:@"工具"];
    
    
    ZCUserTableViewController *navi4 = [[ZCUserTableViewController alloc] init];
    navi4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"personNormal"] selectedImage:[UIImage imageNamed:@"personSelected"]];
    [self addChildViewController:navi4 title:@"我的"];
    
}

- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title {
    
    childController.title = title;
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:childController];
    
    [self addChildViewController:navi];
    
}



@end
