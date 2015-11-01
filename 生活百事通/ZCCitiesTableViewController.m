//
//  ZCCitiesTableViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/10/26.
//  Github: https://github.com/zcill
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCCitiesTableViewController.h"
#import "ZCCustomTabBar.h"

@interface ZCCitiesTableViewController ()

// 数据源放省市地名
@property (nonatomic, strong) NSArray *provincesAndCities;

@end

@implementation ZCCitiesTableViewController

// 懒加载数据源
- (NSArray *)provincesAndCities {
    
    if (_provincesAndCities == nil) {
        _provincesAndCities = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ProvincesAndCities" ofType:@"plist"]];
    }
    return _provincesAndCities;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"选择城市";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

// 返回按钮
- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.provincesAndCities.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSDictionary *provinceDict = self.provincesAndCities[section];
    NSArray *cityArray = provinceDict[@"Cities"];
    return cityArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseID = @"citiesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
    }
    
    NSDictionary *citiesDict = self.provincesAndCities[indexPath.section];
    NSArray *citiesArray = citiesDict[@"Cities"];
    NSDictionary *cityTitleDict = citiesArray[indexPath.row];
    NSString *city = cityTitleDict[@"city"];
    
    cell.textLabel.text = city;
    
    return cell;
}

// 设置每组的标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *titleDict = self.provincesAndCities[section];
    return titleDict[@"State"];
}

// 设置每行被选中的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *citiesDict = self.provincesAndCities[indexPath.section];
    NSArray *citiesArray = citiesDict[@"Cities"];
    NSDictionary *cityTitleDict = citiesArray[indexPath.row];
    NSString *city = cityTitleDict[@"city"];
    if ([_delegate respondsToSelector:@selector(didSelectCity:)]) {
        [_delegate didSelectCity:city];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
