//
//  ZCMapSearchViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/11/5.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCMapSearchViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "ZCHeader.h"

#define APP_Search_Key @"c7c5bda9430aa7408c30a6c38672d39d"

@interface ZCMapSearchViewController ()<MAMapViewDelegate, AMapSearchDelegate, UITextFieldDelegate>

// 创建搜索对象
@property (nonatomic, strong) AMapSearchAPI *searchAPI;
// 创建高德地图
@property (nonatomic, strong) MAMapView *mapView;
// 创建数组，存放大头针
@property (nonatomic, strong) NSMutableArray *pinsArray;
// 创建搜索框
@property (nonatomic, strong) UITextField *searchField;

@end

@implementation ZCMapSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    // 添加key值
    [MAMapServices sharedServices].apiKey = APP_Search_Key;
    
    // 1. 创建搜索对象
    self.searchAPI = [[AMapSearchAPI alloc] initWithSearchKey:APP_Search_Key Delegate:self];
    
    // 2. 初始化数据
    self.pinsArray = [[NSMutableArray alloc] init];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 20, ScreenWidth, 40)];
    view.backgroundColor = [UIColor clearColor];
    
    // 3. 创建textField和button
    CGFloat fieldX = 0;
    CGFloat fieldY = 0;
    CGFloat fieldW = ScreenWidth * 0.7;
    CGFloat fieldH = 40;
    self.searchField = [[UITextField alloc] initWithFrame:CGRectMake(fieldX, fieldY, fieldW, fieldH)];
    self.searchField.placeholder = @"请输入关键字";
    self.searchField.borderStyle = UITextBorderStyleRoundedRect;
    self.searchField.delegate = self;
    [view addSubview:self.searchField];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat buttonX = fieldW + 10;
    CGFloat buttonY = fieldY;
    CGFloat buttonW = ScreenWidth - fieldW - 30;
    CGFloat buttonH = 40;
    button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    [button setTitle:@"搜索" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    // 定位按钮
    CGFloat locationX = ScreenWidth - 40;
    CGFloat locationY = ScreenHeight - 49 - 60;
    CGFloat locationW = 30;
    CGFloat locationH = 30;
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    locationButton.frame = CGRectMake(0, 0, locationW, locationH);
    [locationButton setImage:[UIImage imageNamed:@"navigation_locationicon"] forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(locationButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *locationView = [[UIView alloc] initWithFrame:CGRectMake(locationX, locationY, locationW, locationH)];
    locationView.backgroundColor = [UIColor whiteColor];
    locationView.layer.cornerRadius = 5;
    [locationView addSubview:locationButton];
    
    // 4. 地图
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight - 20)];
    [self.mapView addSubview:view];
    [self.mapView addSubview:locationView];
    [self.view addSubview:self.mapView];
}

// 定位事件
- (void)locationButtonAction {
    
    [SVProgressHUD showWithStatus:@"定位中..."];
    
    // 开始定位
    // 打开显示用户位置
    self.mapView.showsUserLocation = YES;
    
    // 设置地图的缩放级别
    [self.mapView setZoomLevel:10.0 animated:YES];
    
    // 追踪用户的位置
    self.mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    [self.view addSubview:self.mapView];
    
    // 将定位坐标图标换成大头针
    MAPointAnnotation *point = [[MAPointAnnotation alloc] init];
    // 用户的位置信息
    MAUserLocation *userLocation = self.mapView.userLocation;
    
    point.coordinate = userLocation.coordinate;
    point.title = userLocation.title;
    point.subtitle = userLocation.subtitle;
    
    [self.mapView addAnnotation:point];
    [SVProgressHUD dismiss];
    
}

#pragma mark - mapView协议代理
// 更新用户位置时获取用户的实时位置信息
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
    if (updatingLocation) {
        NSLog(@"latitude:%f\nlongtitude:%f\ntitle:%@\nsubtitle:%@", userLocation.coordinate.latitude, userLocation.coordinate.longitude, userLocation.title, userLocation.subtitle);
    }
    
}

// 响应点击事件
- (void)buttonAction:(UIButton *)button {
    
    // 创建搜索对象，关键字搜索
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    
    // 设置搜索类型
    request.searchType = AMapSearchType_PlaceKeyword;
    // 关键字搜索
    request.keywords = self.searchField.text;
    
    // 设置搜索的城市
    request.city = @[@"南京", @"北京"];
    
    // 开始搜索
    [self.searchAPI AMapPlaceSearch:request];
    [self.searchField resignFirstResponder];
    
}

#pragma mark - 搜索代理
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response {
    
    if (response) {
        for (AMapPOI *poi in response.pois) {
            // 搜索结果插入大头针
            MAPointAnnotation *point = [[MAPointAnnotation alloc] init];
            point.title = poi.name;
            point.subtitle = poi.address;
            point.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
            [self.mapView addAnnotation:point];
            [self.pinsArray addObject:point];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:@"未搜到"];
    }
    
}

// 大头针的代理
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    
    static NSString *reuseID = @"point";
    MAPinAnnotationView *pin = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseID];
    if (!pin) {
        pin = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseID];
    }
    
    pin.animatesDrop = YES;
    pin.draggable = YES;
    pin.canShowCallout = YES;
    pin.pinColor = MAPinAnnotationColorPurple;
    
    return pin;
}

// textFielf代理
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    // 将大头针移除
    [self.mapView removeAnnotations:self.pinsArray];
    
    // 清空数据
    [self.pinsArray removeAllObjects];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
