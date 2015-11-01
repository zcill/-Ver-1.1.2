//
//  ZCSectionModel.h
//  生活百事通
//
//  Created by 朱立焜 on 15/10/22.
//  Github: https://github.com/zcill
//  Copyright © 2015年 zcill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZCSectionModel : NSObject

@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, copy) NSString *footerTitle;

@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, weak) UIView *footerView;

@property (nonatomic, copy) NSMutableArray *items;

+ (instancetype)defaultSection;

@end
