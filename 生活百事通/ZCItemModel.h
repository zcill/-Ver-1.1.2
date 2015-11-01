//
//  ZCItemModel.h
//  生活百事通
//
//  Created by 朱立焜 on 15/10/22.
//  Github: https://github.com/zcill
//  Copyright © 2015年 zcill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCItemModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;
// 点击cell 运行的控制器
@property (nonatomic, assign) Class destVcClass;
// 点击cell 运行的block
@property (nonatomic, copy) void (^selectionHandler)();

// 增量开发
+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon;
+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon destVcClass:(Class)destVcClass;
+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon selectionHandler:(void (^)(id item))selectionHandler;

@end
