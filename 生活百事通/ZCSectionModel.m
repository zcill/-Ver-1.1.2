//
//  ZCSectionModel.m
//  生活百事通
//
//  Created by 朱立焜 on 15/10/22.
//  Github: https://github.com/zcill
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCSectionModel.h"

@implementation ZCSectionModel

+ (instancetype)defaultSection {
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _items = [NSMutableArray array];
    }
    return self;
}

@end
