//
//  ZCSingleton.h
//  生活百事通
//
//  Created by 朱立焜 on 15/11/7.
//  Copyright © 2015年 zcill. All rights reserved.
//

#ifndef ZCSingleton_h
#define ZCSingleton_h

// 单例

// @interface
#define singleton_interface(className) \
+ (className *)shared##className;

// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
)

#endif /* ZCSingleton_h */
