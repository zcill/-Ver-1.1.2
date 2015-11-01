//
//  ZCWeatherCell.h
//  
//
//  Created by 朱立焜 on 15/10/22.
//
//

#import <UIKit/UIKit.h>

@class ZCWeatherModel;

@interface ZCWeatherCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *PMLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;

@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *nowTemp;

@property (nonatomic, strong) ZCWeatherModel *weatherModel;

@end
