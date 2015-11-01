//
//  ZCCitiesTableViewController.h
//  生活百事通
//
//  Created by 朱立焜 on 15/10/26.
//  Github: https://github.com/zcill
//  Copyright © 2015年 zcill. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZCCitiesTableViewControllerDelegate <NSObject>

- (void)didSelectCity:(NSString *)city;

@end

@interface ZCCitiesTableViewController : UITableViewController

@property (nonatomic, assign) id<ZCCitiesTableViewControllerDelegate> delegate;

@end
