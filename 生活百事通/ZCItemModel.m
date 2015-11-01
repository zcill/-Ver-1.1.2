//
//  ZCItemModel.m
//  生活百事通
//
//  Created by 朱立焜 on 15/10/22.
//  Github: https://github.com/zcill
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCItemModel.h"

@implementation ZCItemModel

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon {
    return [[self alloc] initWithTitle:title icon:icon];
}

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon destVcClass:(__unsafe_unretained Class)destVcClass {
    return [[self alloc] initWithTitle:title icon:icon destVcClass:destVcClass];
}

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon selectionHandler:(void (^)(id item))selectionHandler {
    return [[self alloc] initWithTitle:title icon:icon selectionHandler:selectionHandler];
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon {
    self = [self init];
    if (!self)
        return nil;
    self.title = title;
    self.icon = icon;
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon destVcClass:(Class)destVcClass {
    self = [self initWithTitle:title icon:icon];
    if (!self)
        return nil;
    self.destVcClass = destVcClass;
    return self;
}

- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon selectionHandler:(void (^)(id item))selectionHandler {
    self = [self initWithTitle:title icon:icon];
    if (!self) {
        return nil;
    }
    self.selectionHandler = selectionHandler;
    return self;
}

@end
