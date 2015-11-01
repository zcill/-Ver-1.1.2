//
//  ZCWeatherModel.h
//  生活百事通
//
//  Created by 朱立焜 on 15/10/23.
//  Github: https://github.com/zcill
//  Copyright © 2015年 zcill. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZCIndex,ZCWeatherData;

@interface ZCWeatherModel : NSObject
/**
 *  当前城市
 */
@property (nonatomic, copy) NSString *currentCity;
/**
 *  pm2.5
 */
@property (nonatomic, copy) NSString *pm25;
/**
 *  当前日期
 */
@property (nonatomic, copy) NSString *date;

/**
 *  天气详情
 */
@property (nonatomic, strong) NSArray *weather_data;
/**
 *  细节
 */
@property (nonatomic, strong) NSArray *index;

@end


@interface ZCIndex : NSObject
/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  具体指数
 */
@property (nonatomic, copy) NSString *zs;
/**
 *  指数标题
 */
@property (nonatomic, copy) NSString *tipt;
/**
 *  详情
 */
@property (nonatomic, copy) NSString *des;

@end

@interface ZCWeatherData : NSObject
/**
 *  天气
 */
@property (nonatomic, copy) NSString *weather;
/**
 *  风力
 */
@property (nonatomic, copy) NSString *wind;
/**
 *  气温
 */
@property (nonatomic, copy) NSString *temperature;
/**
 *  日期
 */
@property (nonatomic, copy) NSString *date;

@end

