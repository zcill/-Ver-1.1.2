//
//  ZCSearchUrl.h
//  生活百事通
//
//  Created by 朱立焜 on 15/10/31.
//  Copyright © 2015年 zcill. All rights reserved.
//

#ifndef SearchUrl_h
#define SearchUrl_h

#pragma mark <生活查询>

// 天气查询接口
#define WeatherURL @"http://api.map.baidu.com/telematics/v3/weather?"

// 身份证查询接口
#define IDCardURL @"http://api.jisuapi.com/idcard/query?"

// 手机归属地查询接口
#define PhoneNumberURL @"http://api.jisuapi.com/shouji/query?"

// IP地址查询接口
#define IPURL @"http://api.46644.com/ip/?"

// 货币汇率查询接口
#define CurrencyURL @"http://api.jisuapi.com/exchange/convert?"

// 公交路线查询接口
#define BusLineURL @"http://api.jisuapi.com/transit/line?"


#pragma mark <查询接口使用的AppKey>

// 天气查询AppKey
#define baiduAppID @"9suGmKvdlUGlSGGRrkQLD108"
// 一般查询AppKey
#define searchAppKey @"e810896de40995b7"
// IP地址查询Appkey
#define IPAPP_KEY @"1307ee261de8bbcf83830de89caae73f"


#endif /* SearchUrl_h */
