//
//  ZCSearchHttpRequest.h
//  生活百事通
//
//  Created by 朱立焜 on 15/10/23.
//  Github: https://github.com/zcill
//  Copyright © 2015年 zcill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCSearchHttpRequest : NSObject

/**
 获取天气数据
 */
+ (void)getWeatherDataWithCity:(NSString *)city success:(void (^)(id JSON))successBlock failure:(void (^)(NSError *error))failureBlock;

/**
 获取身份证数据
 */
+ (void)getIDCardDataWithIDCardNumber:(NSString *)IDCardNumber success:(void (^)(id))successBlock failure:(void (^)(NSError *))failureBlock;

/**
 获取手机归属地数据
 */
+ (void)getPhoneNumberDataWithPhoneNumber:(NSString *)phoneNumber success:(void (^)(id JSON))successBlock failure:(void (^)(NSError *error))failureBlock;


/*
 获取IP地址数据
 */
+ (void)getIPDataWithIPNumber:(NSString *)IPNumber succuss:(void (^)(id JSON))successBlock failure:(void (^)(NSError *error))failureBlock;

/*
 获取货币汇率
 */
+ (void)getCurrencyDataWithFrom:(NSString *)from to:(NSString *)to amount:(NSString *)amount success:(void (^)(id JSON))successBlock failure:(void (^)(NSError *error))failureBlock;

/*
 获取公交路线数据
 */
+ (void)getBusLineDataWithCityID:(NSString *)cityID transitno:(NSString *)transitno succuss:(void (^)(id JSON))successBlock failure:(void (^)(NSError *error))failureBlock;

/*
 获取快递运单数据
 */
+ (void)getExpressDataWithCompanyID:(NSString *)companyID number:(NSString *)number succuss:(void (^)(id JSON))successBlock failure:(void (^)(NSError *error))failureBlock;

/*
 获取电视节目数据
 */
+ (void)getTVDataWithTVID:(NSString *)tvid date:(NSString *)date succuss:(void (^)(id JSON))successBlock failure:(void (^)(NSError *error))failureBlock;

/**
 根据区号查询城市
 */
+ (void)getCityDataWithAreacode:(NSString *)areacode succuss:(void (^)(id JSON))successBlock failure:(void (^)(NSError *error))failureBlock;

/**
 根据城市查询区号
 */
+ (void)getAreacodeWithCity:(NSString *)city succuss:(void (^)(id JSON))successBlock failure:(void (^)(NSError *error))failureBlock;

@end
