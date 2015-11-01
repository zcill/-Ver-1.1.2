//
//  ZCHttpRequestTool.h
//  生活百事通
//
//  Created by 朱立焜 on 15/10/23.
//  Github: https://github.com/zcill
//  Copyright © 2015年 zcill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCHttpRequestTool : NSObject

/**
 *  发送一个post请求
 *
 *  @param url          请求路径
 *  @param params       请求参数
 *  @param successBlock 请求成功回调
 *  @param failureBlock 请求失败回调
 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock;

+ (void)postXMLWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))successBlock failure:(void (^)(NSError *error))failureBlock;


/**
 *  发送一个带文件的post请求
 *
 *  @param url           请求路径
 *  @param params        请求参数
 *  @param formDataArray 保存文件数据的数组
 *  @param successBlock  请求成功回调
 *  @param failureBlock  请求失败回调
 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id JSON))successBlock failure:(void (^)(NSError *error))failureBlock;

/**
 *  发送一个get请求
 *
 *  @param url          请求路径
 *  @param params       请求参数
 *  @param successBlock 请求成功回调
 *  @param failureBlock 请求失败回调
 */
+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id JSON))successBlock failure:(void (^)(NSError *error))failureBlock;

@end


/**
 *  封装文件数据类型的类
 */
@interface ZCFormatData : NSObject

/**
 *  文件数据
 */
@property (nonatomic, strong) NSData *data;
/**
 *  参数名
 */
@property (nonatomic, copy) NSString *name;
/**
 *  文件名
 */
@property (nonatomic, copy) NSString *fileName;
/**
 *  文件类型
 */
@property (nonatomic, copy) NSString *mimeType;



@end


