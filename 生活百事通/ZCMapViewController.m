//
//  ZCMapViewController.m
//  生活百事通
//
//  Created by 朱立焜 on 15/11/5.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCMapViewController.h"
#import <MAMapKit/MAMapKit.h>

@interface ZCMapViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation ZCMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initMap];
}

- (void)initMap {
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    
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
    
}

#pragma mark - mapView协议代理
// 更新用户位置时获取用户的实时位置信息
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
    if (updatingLocation) {
        NSLog(@"latitude:%f\nlongtitude:%f\ntitle:%@\nsubtitle:%@", userLocation.coordinate.latitude, userLocation.coordinate.longitude, userLocation.title, userLocation.subtitle);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
