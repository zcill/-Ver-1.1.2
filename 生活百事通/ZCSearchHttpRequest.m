//
//  ZCSearchHttpRequest.m
//  生活百事通
//
//  Created by 朱立焜 on 15/10/23.
//  Github: https://github.com/zcill
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCSearchHttpRequest.h"
#import "ZCHttpRequestTool.h"
#import "ZCSearchUrl.h"

@implementation ZCSearchHttpRequest

+ (void)getWeatherDataWithCity:(NSString *)city success:(void (^)(id JSON))successBlock failure:(void (^)(NSError *error))failureBlock {
    
    // 设置请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"location"] = city;
    params[@"output"] = @"json";
    params[@"ak"] = baiduAppID;
    
    // 请求
    [ZCHttpRequestTool getWithURL:WeatherURL params:params success:^(id JSON) {
        if (successBlock) {
            successBlock(JSON);
        }
    } failure:^(NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    
}

+ (void)getIDCardDataWithIDCardNumber:(NSString *)IDCardNumber success:(void (^)(id JSON))successBlock failure:(void (^)(NSError *error))failureBlock {
    
    // 设置请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"idcard"] = IDCardNumber;
    params[@"appkey"] = searchAppKey;
    
    // 发送请求
    [ZCHttpRequestTool getWithURL:IDCardURL params:params success:^(id JSON) {
        if (successBlock) {
            successBlock(JSON);
        }
    } failure:^(NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    
}

+ (void)getPhoneNumberDataWithPhoneNumber:(NSString *)phoneNumber success:(void (^)(id JSON))successBlock failure:(void (^)(NSError *error))failureBlock {
    
    // 设置请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"shouji"] = phoneNumber;
    params[@"appkey"] = searchAppKey;
    
    // 请求
    [ZCHttpRequestTool getWithURL:PhoneNumberURL params:params success:^(id JSON) {
        if (successBlock) {
            successBlock(JSON);
        }
    } failure:^(NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    
}

+ (void)getIPDataWithIPNumber:(NSString *)IPNumber succuss:(void (^)(id JSON))successBlock failure:(void (^)(NSError *error))failureBlock {
    
    // 设置请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"ip"] = IPNumber;
    params[@"appkey"] = IPAPP_KEY;
    
    // 请求
    [ZCHttpRequestTool getWithURL:IPURL params:params success:^(id JSON) {
        if (successBlock) {
            successBlock(JSON);
        }
    } failure:^(NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    
}

+ (void)getCurrencyDataWithFrom:(NSString *)from to:(NSString *)to amount:(NSString *)amount success:(void (^)(id JSON))successBlock failure:(void (^)(NSError *error))failureBlock {
    
    // 设置请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"from"] = from;
    params[@"to"] = to;
    params[@"amount"] = amount;
    params[@"appkey"] = searchAppKey;
    
    // 请求
    [ZCHttpRequestTool getWithURL:CurrencyURL params:params success:^(id JSON) {
        if (successBlock) {
            successBlock(JSON);
        }
    } failure:^(NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    
}

+ (void)getBusLineDataWithCityID:(NSString *)cityID transitno:(NSString *)transitno succuss:(void (^)(id JSON))successBlock failure:(void (^)(NSError *error))failureBlock {
    
    // 设置请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cityid"] = cityID;
    params[@"transitno"] = transitno;
    params[@"appkey"] = searchAppKey;
    
    // 请求
    [ZCHttpRequestTool getWithURL:BusLineURL params:params success:^(id JSON) {
        if (successBlock) {
            successBlock(JSON);
        }
    } failure:^(NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    
}



@end
