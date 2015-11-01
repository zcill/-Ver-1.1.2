//
//  ZCSubtitleItem.m
//  生活百事通
//
//  Created by 朱立焜 on 15/10/28.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCSubtitleItem.h"

@implementation ZCSubtitleItem

+ (instancetype)itemWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    
    ZCSubtitleItem *item = [[ZCSubtitleItem alloc] init];
    item.title = title;
    item.subtitle = subtitle;
    
    return item;
    
}

+ (ZCSubtitleItem *)itemWithTitle:(NSString *)title rightSubtitle:(NSString *)rightSubtitle {
    
    ZCSubtitleItem *item = [ZCSubtitleItem itemWithTitle:title subtitle:rightSubtitle];
    item.subtitleFont = [UIFont systemFontOfSize:16];
    item.subtitleAlignment = NSTextAlignmentRight;
    
    return item;
    
}

+ (instancetype)itemWithTitle:(NSString *)title imageName:(NSString *)imageName {
    
    ZCSubtitleItem *item = [[ZCSubtitleItem alloc] init];
    item.title = title;
    item.image = [UIImage imageNamed:imageName];
    
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title subtitle:(NSString *)subtitle imageName:(NSString *)imageName {
    
    ZCSubtitleItem *item = [ZCSubtitleItem itemWithTitle:title subtitle:subtitle];
    item.image = [UIImage imageNamed:imageName];
    
    return item;
}

@end
