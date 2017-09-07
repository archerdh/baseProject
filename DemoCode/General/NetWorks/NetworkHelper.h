//
//  BaseRequestDefaultHelper.h
//  PublicProject
//
//  Created by user on 15/5/8.
//  Copyright (c) 2015年 archer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPRequestSerializer;
@class AFHTTPResponseSerializer;
/**
 @brief BaseReuqest的helper类，主要是帮助BaseRequest处理跟业务相关的部分，如请求参数的组装、加密解密、是否缓存。
 @note  根据需求不同，需要子类化此类，覆写相关方法。首先必须覆写baseURL（返回服务器地址），其次需要在新建的Helper类中的+(void)load方法中通过+ (void)registerHelper:(Class)helper方法进行注册
 */
@interface NetworkHelper : NSObject

/**
 *@brief 注册helper类
 */
+ (void)registerHelper:(Class)helper;

/**
 *@brief 返回注册的对象
 */
+ (instancetype)shareInstance;

/**
 *@brief 服务器的地址，默认为空，必须覆写此方法
 */
- (NSString *)requestBaseUrl;

/**
 *@brief 请求成功返回码，默认为10000，根据需求覆写此方法
 */
- (NSInteger)requestSuccessCode;

/**
 *@brief 取返回码的key值，默认为"code"
 */
- (NSString *)requestCodeKey;

/**
 *@brief 服务器返回一个状态码，标明客户端取缓存数据，默认9999
 */
- (NSInteger)requestCacheCode;

/**
 @brief 组装最终传递给AF的参数字典，默认是一些公共的参数放在同一个字典当中
 @param parametersDic 每个Request的请求参数
 @return 返回最终传给AF的请求参数
 */
- (NSMutableDictionary *)requestParameters:(NSDictionary *)parametersDic;

#pragma mark -
/**
 @brief   对请求的body进行处理，若是需要加密，子类请覆写此方法。默认不加密，直接返回bodyDic；若是需加密，则返回一个加密后的NSData类型数据
 @param   request 当前的请求，扩展可用
 @param   parameters 请求参数的参数字典
 @return  在BaseRequest当中判断是否加密，是通过此方法返回的内容来判断；若为NSData类型，则说明加密；否则，说明没有加密
 */
- (id)handleOnRequest:(NSURLRequest *)request parameters:(NSDictionary *)parameters;

/** 
 @brief   对返回的数据进行处理，根据业务需求若是需要解密，则可以通过此方法对reponseData的数据进行解密
 @param   response       AF返回的AFHTTPRequestOperation中的response
 @param   responseData  请求返回的数据
 @code
 例子：
 //从服务器中返回的请求头取值判断是否进行了des加密
 BOOL isDes = [response.allHeaderFields[@"des"] boolValue];
 if(isDes){
    //des解密之后，返回解密后的内容
 }
 else{
    return responseData;
 }
 */
- (id)handleOnResponse:(NSURLResponse *)response data:(NSData *)responseData;

/** 
 @return  返回请求头，默认是Content-Type=application/x-www-form-urlencoded,User-Agent=iPhone
 */
- (NSDictionary *)requestHttpHeader;

/**
 *@breif 返回一个Request序列化器，默认返回PPJSONRequestSerializer，一般不需要覆写此方法
 *@note 业务简单时，可以返回AFHTTPRequestSerializer、AFJSONRequestSerializer和AFPropertyListRequestSerializer对Request进行序列化
 *@note 业务复杂需要加密，则使用默认的PPJSONRequestSerializer对Request进行序列化，加密只需要覆写NetworkHelper类中的- (id)handleOnRequest:(NSURLRequest *)request parameters:(NSDictionary *)parameters方法
 *@note 若是以上序列化器都满足不了业务，则可以自定义一个序列化器
 */
- (AFHTTPRequestSerializer *)requestSerializer;

/**
 *@breif 返回一个response序列化器，默认返回PPHTTPRequestSerializer，一般不需要覆写此方法
 *@note 业务简单时，可以返回AFHTTPResponseSerializer、AFJSONResponseSerializer和AFPropertyListResponseSerializer对response进行反序列化
 *@note 业务复杂需要加密，则使用默认的PPHTTPResponseSerializer对Request进行反序列化，加密只需要覆写NetworkHelper类中的- (id)handleOnResponse:(NSURLResponse *)response data:(NSData *)responseData方法
 *@note 若是以上序列化器都满足不了业务，则可以自定义一个序列化器
 */
- (AFHTTPResponseSerializer *)responseSerializer;

@end
