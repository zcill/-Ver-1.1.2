//
//  ZCHttpRequestTool.m
//  生活百事通
//
//  Created by 朱立焜 on 15/10/23.
//  Github: https://github.com/zcill
//  Copyright © 2015年 zcill. All rights reserved.
//

#import "ZCHttpRequestTool.h"
#import <AFNetworking/AFNetworking.h>

@implementation ZCHttpRequestTool

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))successBlock failure:(void (^)(NSError *error))failureBlock {
    
    // 使用AFNetworking
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // 发送请求
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (successBlock) {
            successBlock(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        if (failureBlock) {
            failureBlock(error);
        }
        
    }];
    
}

+ (void)postXMLWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))successBlock failure:(void (^)(NSError *error))failureBlock {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    NSDictionary *params = @{@"format":@"xml"};
    
    // 发送请求
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id JSON))successBlock failure:(void (^)(NSError *error))failureBlock {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (ZCFormatData *formdata in formDataArray) {
            [formData appendPartWithFileData:formdata.data name:formdata.name fileName:formdata.fileName mimeType:formdata.mimeType];
        }
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    
}

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id JSON))successBlock failure:(void (^)(NSError *error))failureBlock {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    
}

@end


/**
 *  封装文件数据类型的类
 */
@implementation ZCFormatData


@end
