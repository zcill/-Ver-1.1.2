//
//  ZCSearchUrl.h
//  生活百事通
//
//  Created by 朱立焜 on 15/10/31.
//  Copyright © 2015年 zcill. All rights reserved.
//

#ifndef SearchUrl_h
#define SearchUrl_h

#pragma mark - 生活查询

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

// 运单号查询接口
#define ExpressURL @"http://api.jisuapi.com/express/query?"

// TV节目查询接口
#define TVURL @"http://api.jisuapi.com/tv/query?"

// 区号查城市接口
#define AreaCodeURL @"http://api.jisuapi.com/areacode/query?"

// 城市查区号接口
#define CityToAreacodeURL @"http://api.jisuapi.com/areacode/city2code?"

// 邮编查地址接口
#define ZipcodeURL @"http://api.jisuapi.com/zipcode/query?"

#pragma mark - 查询接口使用的AppKey

// 天气查询AppKey
#define baiduAppID @"9suGmKvdlUGlSGGRrkQLD108"

// 一般查询AppKey
#define searchAppKey @"e810896de40995b7"

// IP地址查询Appkey
#define IPAPP_KEY @"1307ee261de8bbcf83830de89caae73f"


#endif /* SearchUrl_h */
