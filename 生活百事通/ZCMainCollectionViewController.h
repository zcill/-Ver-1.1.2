//
//  ZCMainCollectionViewController.h
//  生活百事通
//
//  Created by 朱立焜 on 15/10/22.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZCWeatherModel;

@interface ZCMainCollectionViewController : UICollectionViewController

@property (nonatomic, strong) ZCWeatherModel *weatherModel;

@end
