//
//  BaseRequest.h
//  
//
//  Created by archer on 15/4/7.
//  Copyright (c) 2015年 archer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum{
    REQUESTMETHODGET=0,
    REQUESTMETHODPOST=1
}REQUESTMETHOD;

@class BaseRequest;

@interface BaseRequest : NSObject
#pragma mark -
- (instancetype)initPostMethod:(NSString *)methodName;
- (instancetype)initPostMethod:(NSString *)methodName numOfRepeat:(NSInteger)numOfRepeat;
- (instancetype)initGetMethod:(NSString *)methodName;
- (instancetype)initGetMethod:(NSString *)methodName numOfRepeat:(NSInteger)numOfRepeat;
/**
 *  是否DES加密
 */
@property (nonatomic, assign) BOOL isDES;
#pragma mark -
/** 设置请求方式，POST还是GET */
- (void)setRequestMethod:(REQUESTMETHOD)requestMethod;
/** 设置请求方法名 */
- (void)setMethodName:(NSString *)methodName;
/** 设置网络请求失败后重复的次数 */
- (void)setNumOfRepeat:(NSInteger)numOfRepeat;

/**
 *@brief request 响应时间
 */
@property (nonatomic, strong) NSString *requestTime;

/**
 *@brief 每个请求的自定义的参数
 *@code  通过下面的方法进行设置
 */
- (void)setIntegerValue:(NSInteger)value forKey:(NSString *)key;
- (void)setDoubleValue:(double)value forKey:(NSString *)key;
- (void)setLongLongValue:(long long)value forKey:(NSString *)key;
- (void)setBOOLValue:(BOOL)value forKey:(NSString *)key;
- (void)setValue:(id)value forKey:(NSString *)key;


#pragma mark -
/*
 @brief发送网络请求，根据业务需求分别调用不同接口
 */
-(void)sendRequestSuccFinishBlock:(void(^)(id response))requestFinishBlock;

-(void)sendRequestSuccFinishBlock:(void(^)(id response))requestFinishBlock requestFailFinishBlock:(void(^)(NSError *error))requestFailFinishBlock;

-(void)sendRequestSuccFinishBlock:(void(^)(id response))requestFinishBlock requestBusinessFailureBlock:(void(^)(id response))requestBusinessFailureBlock requestFailFinishBlock:(void(^)(NSError *error))requestFailFinishBlock;


#pragma mark -
/*
 * @brief 服务器返回的数据解析成功后会调用
 * @note  可以访问self.result得到服务器返回的结果，一定是NSDictionary类型。
 * @note  对网络请求的数据结果进行封装(可选) 子类实现
 */
-(id)processResultWithDic:(NSMutableDictionary*)resultDic;

/** 本地链接，此处用来作为本地搭服务器测试用 */
- (NSString *)getLocalURL;

/*
 *@brief 请使用此方法取消网络请求
 */
+(void)cancelRequest;

/**
 *  @note 用户初始化子类request，调用完毕self.methodName=@"xxxx"后，此getUrlName方法有效。
 *  @note 否则返回为空字符串. @""
 *  @note 不允许子类实现
 */
+(NSString*)getUrlName;

/**
 *  @brief 此方法可以根据传入的urlArray判断是否http已经完成
 *  @note  don't OVERRIDE this method
 */
+(BOOL)isHttpQueueFinished:(NSArray*)httpUrlArray;

/**
 *  @brief 此方法可以根据传入的class类名判断是否http已经完成
 *  @note  don't OVERRIDE this method
 *  @example
 NSArray* classNameArray = @[@"LSUpdateDataRequest", @"LSSearchGoodsRequest",
 @"LSGoodsListRequest", @"LSCinemaListRequest"];
 BOOL isFinished = [LSBaseRequest isHttpQueueFinishedWithClassNameArray:classNameArray];
 */
+(BOOL)isHttpQueueFinishedWithClassNameArray:(NSArray*)requestClassArray;


@end
