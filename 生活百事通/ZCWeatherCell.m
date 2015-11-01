//
//  ZCWeatherCell.m
//  
//
//  Created by 朱立焜 on 15/10/22.
//
//

#import "ZCWeatherCell.h"
#import "ZCWeatherModel.h"

@implementation ZCWeatherCell

- (void)awakeFromNib {
    
    self.userInteractionEnabled = YES;
    
}

- (void)setWeatherModel:(ZCWeatherModel *)weatherModel {
    
//    ZCWeatherData *weatherData = weatherModel.weather_data[0];
#warning 注意这个地方，如果用的模型的话crash，使用字典接收就可以正常运行
    
    NSDictionary *weatherData = weatherModel.weather_data[0];
    
    self.cityLabel.text = weatherModel.currentCity;
    self.dateLabel.text = weatherModel.date;
    
    self.windLabel.text = weatherData[@"wind"];
    
    self.temperatureLabel.text = weatherData[@"temperature"];
    self.PMLabel.text = [NSString stringWithFormat:@"PM2.5: %@", weatherModel.pm25];
    
    NSString *weather = weatherData[@"weather"];
    // 定位到“转”的位置
    NSInteger strLocation = [weather rangeOfString:@"转"].location;
    if (strLocation != NSNotFound) {
        weather = [weather substringToIndex:strLocation];
    }
#warning UIImage未使用category
    self.weatherImageView.image = [UIImage imageNamed:weather];
    self.weatherLabel.text = weatherData[@"weather"];

    // 定位到“(”的位置
    NSString *nowTempDate = weatherData[@"date"];
    NSString *nowTemp = nil;
    NSInteger stringLocation = [nowTempDate rangeOfString:@"："].location;
    if (stringLocation != NSNotFound) {
        nowTempDate = [nowTempDate substringFromIndex:stringLocation];
        NSInteger dateLocation = [nowTempDate rangeOfString:@")"].location;
        nowTemp = [nowTempDate substringToIndex:dateLocation];
    }
    // 判断是否存在实时温度数据
    if (nowTemp) {
        self.nowTemp.text = [NSString stringWithFormat:@"实时%@", nowTemp];
    } else {
        self.nowTemp.text = [NSString stringWithFormat:@"实时："];
    }
    
}
 


@end
