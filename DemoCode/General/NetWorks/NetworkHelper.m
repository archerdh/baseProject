//
//  BaseRequestDefaultHelper.m
//  PublicProject
//
//  Created by user on 15/5/8.
//  Copyright (c) 2015年 archer. All rights reserved.
//

#import "NetworkHelper.h"
#import "BaseRequest.h"
#import "PPAFHTTPClient.h"
#import "PPJSONRequestSerializer.h"
#import "PPHTTPResponseSerializer.h"

/** 成功返回的返回码 */
const NSInteger RequestSuccessCode = 10000;
/** 标明客户端需要缓存的返回码 */
const NSInteger RequestCacheCode = 9999;
/** 服务器返回取code的key值 */
NSString * const RequestCodeKey = @"code";

static Class _instanceClass = nil;
static NetworkHelper *_sharedInstance = nil;
@implementation NetworkHelper

+ (void)registerHelper:(Class)helperClass{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class superClass = [helperClass superclass];
        Class defaultClass = [NetworkHelper class];
        //注册的类必须是NetworkHelper的子类
        if(superClass == defaultClass){
            _instanceClass = helperClass;
            _sharedInstance = [[helperClass alloc] init];
        }
        else{
            @throw [NSException exceptionWithName:@"registerRequestHelper: error" reason:@"注册的请求帮助类不是继承与BaseRequestDefaultHelper" userInfo:nil];
        }
    });
}

+ (instancetype)shareInstance{
    return _sharedInstance;
}

- (AFHTTPRequestSerializer *)requestSerializer{
    return [PPJSONRequestSerializer serializer];
}

- (AFHTTPResponseSerializer *)responseSerializer{
    return [PPHTTPResponseSerializer serializer];
}

- (NSString *)requestBaseUrl{
    //抛出异常
    @throw [NSException exceptionWithName:@"registerRequestHelper: error" reason:@"注册的请求帮助类不是继承与BaseRequestDefaultHelper" userInfo:nil];
    return @"127.0.0.1";
}

- (NSInteger)requestSuccessCode{
    return RequestSuccessCode;
}

- (NSString *)requestCodeKey{
    return RequestCodeKey;
}

- (NSInteger)requestCacheCode{
    return RequestCacheCode;
}

#pragma mark -
/** 请求的公共参数 */
- (NSMutableDictionary *)requestCommonParam:(NSDictionary *)parametersDic{
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)requestParameters:(NSDictionary *)parametersDic{
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithDictionary:[self requestCommonParam:parametersDic]];
    for (NSString *key in parametersDic) {
        NSString *value = parametersDic[key];
        [resultDic setObject:value forKey:key];
    }
    return resultDic;
}

#pragma mark -
- (NSString *)handleOnRequest:(NSURLRequest *)request parameters:(NSDictionary *)parameters{
    return nil;
}

- (id)handleOnRequest:(BaseRequest *)request body:(NSDictionary *)bodyDic{
    return bodyDic;
}

- (id)handleOnResponse:(NSURLResponse *)response data:(NSData *)responseData{
    return responseData;
}

#pragma mark -
- (NSDictionary *)requestHttpHeader{
    return @{
             @"Content-Type":@"application/x-www-form-urlencoded;charset=utf-8",
             @"User-Agent":@"tcphone"
             };
}
@end
