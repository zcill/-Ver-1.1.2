//
//  ZCWeatherModel.m
//  生活百事通
//
//  Created by 朱立焜 on 15/10/23.
//  Github: https://github.com/zcill
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCWeatherModel.h"

@implementation ZCWeatherModel

- (NSDictionary *)objectClassInArray {
    
    return @{@"index":[ZCIndex class],
             @"weather_data":[ZCWeatherData class]
             };
    
}

@end

@implementation ZCIndex

@end

@implementation ZCWeatherData

@end
