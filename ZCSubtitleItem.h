//
//  ZCSubtitleItem.h
//  生活百事通
//
//  Created by 朱立焜 on 15/10/28.
//  Copyright © 2015年 zcill. All rights reserved.
//

#import <RETableViewItem.h>

@interface ZCSubtitleItem : RETableViewItem

@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) UIFont *subtitleFont;
@property (nonatomic, assign) NSTextAlignment subtitleAlignment;

+ (ZCSubtitleItem *)itemWithTitle:(NSString *)title subtitle:(NSString *)subtitle;

+ (ZCSubtitleItem *)itemWithTitle:(NSString *)title rightSubtitle:(NSString *)rightSubtitle;

+ (ZCSubtitleItem *)itemWithTitle:(NSString *)title subtitle:(NSString *)subtitle imageName:(NSString *)imageName;

+ (ZCSubtitleItem *)itemWithTitle:(NSString *)title imageName:(NSString *)imageName;

@end
