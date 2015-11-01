//
//  ZCHeader.h
//  生活百事通
//
//  Created by 朱立焜 on 15/10/21.
//  Copyright © 2015年 zcill. All rights reserved.
//

#ifndef ZCHeader_h
#define ZCHeader_h

#pragma mark ----------- 该项目使用第三方库
// 颜色第三方库
#import <ChameleonFramework/Chameleon.h>
// 请求
#import <AFNetworking/AFNetworking.h>
// 图片缓存
#import <SDWebImage/UIImageView+WebCache.h>
// 字典转模型
#import <MJExtension/MJExtension.h>
// tableView
#import <RETableViewManager.h>
// 弹窗
#import <SVProgressHUD/SVProgressHUD.h>

#pragma mark ----------- 该项目经常导入
#import "ZCSearchHttpRequest.h"
#import "ZCSubtitleItem.h"


#pragma mark ----------- 尺寸宏
// 状态栏高度
#define StatusBarHeight 20
// 导航栏高度
#define NavigationBarHeight 44

#define NavigationBarIcon 20
// tabBar高度
#define TabBarHeight 49

#define TabBarIcon 40
// 获取屏幕宽高
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)

#pragma mark ------------ 系统宏
// 获取iOS系统版本
#define GetSystemVersion [[[UIDevice currentDevices] systemVersion] floatValue]
#define CurrentSystemVersion ([[UIDevice currentDevice] systemVersion])

// 判断是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)

// 获取当前语言
#define CurrentLangage ([[NSLocale preferredLangages] objectAtIndex:0])

#pragma mark ------------ 颜色宏
// 经常使用的灰色
#define myGrayColor [UIColor colorWithRed:235/255.f green:235/255.f blue:235/255.f alpha:1]
// 经常使用的淡灰色
#define myLightGrayColor [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1]
// 背景色
#define myBackgroundColor [UIColor colorWithRed:242/255.f green:236/255.f blue:231/255.f alpha:1]
// 转化RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]


#endif /* ZCHeader_h */
