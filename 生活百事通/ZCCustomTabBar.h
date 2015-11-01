//
//  ZCCustomTabBar.h
//  生活百事通
//
//  Created by 朱立焜 on 15/10/21.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCCustomTabBar : UITabBarController

@property(nonatomic,retain)NSArray *titles;
@property(nonatomic,retain)NSArray *imageNames;
@property(nonatomic,retain)NSArray *selectedImageNames;
@property(nonatomic,retain)NSMutableArray *buttons;

@end
