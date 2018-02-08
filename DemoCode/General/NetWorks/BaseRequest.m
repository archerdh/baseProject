//
//  BaseRequest.m
//  
//
//  Created by archer on 15/4/7.
//  Copyright (c) 2015年 archer. All rights reserved.
//

#import "BaseRequest.h"
#import <objc/objc.h>
#import <objc/runtime.h>
#import "PPAFHTTPClient.h"
#import "Helper.h"
#import "NetworkHelper.h"

#define BASEREQUEST_METHODNAME_KEY @"BASEREQUEST_METHODNAME_KEY"

@interface BaseRequest ()
{
    void(^_requestSuccFinishBlock)(id);
    void(^_requestBusinessFailureBlock)(id);
    void(^_requestFailFinishBlock)(NSError *);
    
    NSMutableDictionary *_httpBodyDic;
    NSMutableDictionary *_parametersDic;
    
    BOOL                _isResetBlock;//是否进行复位block
    BOOL                _isFailBlockFinish; //failBlock调取完成
    NSInteger           _internalRet;//内部使用的ret
    
    NSInteger           _numOfRepeat; //重复请求次数
    REQUESTMETHOD       _requestMethod; //请求方式
    NSString            *_methodName; //请求的方法名
}
@end

@implementation BaseRequest
#pragma mark -
-(id)init{
    return [self initPostMethod:nil];
}

- (id)initGetMethod:(NSString *)methodName{
    return [self initGetMethod:methodName numOfRepeat:1];
}

- (id)initGetMethod:(NSString *)methodName numOfRepeat:(NSInteger)numOfRepeat{
    return [self initMethodName:methodName numOfRepeat:numOfRepeat requestMethod:REQUESTMETHODGET];
}

- (id)initPostMethod:(NSString *)methodName{
    return [self initPostMethod:methodName numOfRepeat:1];
}

- (id)initPostMethod:(NSString *)methodName numOfRepeat:(NSInteger)numOfRepeat{
    return [self initMethodName:methodName numOfRepeat:numOfRepeat requestMethod:REQUESTMETHODPOST];
}

- (id)initMethodName:(NSString *)methodName numOfRepeat:(NSInteger)numOfRepeat requestMethod:(REQUESTMETHOD)requestMethod{
    self = [super init];
    if(self){
        _requestMethod = requestMethod;
        _numOfRepeat = numOfRepeat;
        _parametersDic = [[NSMutableDictionary alloc] init];
        _httpBodyDic   = [[NSMutableDictionary alloc] init];
        [self setMethodName:methodName];
    }
    return self;
}

#pragma mark -
- (void)setMethodName:(NSString *)methodName{
    NSString *newUrl = [methodName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *resultURL = [NSString stringWithFormat:@"api/v1%@", newUrl];
    objc_setAssociatedObject([self class], BASEREQUEST_METHODNAME_KEY, methodName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    _methodName = resultURL;
}

- (void)setNumOfRepeat:(NSInteger)numOfRepeat{
    _numOfRepeat = numOfRepeat;
}

- (void)setRequestMethod:(REQUESTMETHOD)requestMethod{
    _requestMethod = requestMethod;
}

- (void)setIntegerValue:(NSInteger)value forKey:(NSString *)key
{
//    [self setValue:[NSString stringWithFormat:@"%zd", value] forKey:key];
    [self setValue:[NSNumber numberWithInteger:value] forKey:key];
}
- (void)setDoubleValue:(double)value forKey:(NSString *)key
{
    [self setValue:[NSString stringWithFormat:@"%f", value] forKey:key];
}
- (void)setLongLongValue:(long long)value forKey:(NSString *)key
{
    [self setValue:[NSString stringWithFormat:@"%zd", value] forKey:key];
}
- (void)setBOOLValue:(BOOL)value forKey:(NSString *)key
{
    [self setValue:[NSString stringWithFormat:@"%d", value] forKey:key];
}
- (void)setValue:(id)value forKey:(NSString *)key
{
    //value只能是字符串，如果不是字符串类型，[LSHelper getSignParam]会crash，暂时未做处理。
    if(!value){
        value = @"";
    }
    [_parametersDic setValue:value forKey:key];
}

-(void)sendRequestSuccFinishBlock:(void(^)(id response))requestFinishBlock requestBusinessFailureBlock:(void(^)(id response))requestBusinessFailureBlock requestFailFinishBlock:(void(^)(NSError *error))requestFailFinishBlock{
    _requestFailFinishBlock = requestFailFinishBlock;
    _requestBusinessFailureBlock = requestBusinessFailureBlock;
    _requestSuccFinishBlock = requestFinishBlock;
    _isResetBlock = NO;
    _isFailBlockFinish = NO;
    //serail send request
    dispatch_async([PPAFHTTPClient shareClient].workQueue, ^{
        if (_requestMethod == REQUESTMETHODGET) {
            [self doGetRequest];
        }else if(_requestMethod == REQUESTMETHODPOST){
            [self doPostRequest];
        }
    });
}

-(void)sendRequestSuccFinishBlock:(void(^)(id response))requestFinishBlock requestFailFinishBlock:(void(^)(NSError *error))requestFailFinishBlock
{
    [self sendRequestSuccFinishBlock:requestFinishBlock requestBusinessFailureBlock:nil requestFailFinishBlock:requestFailFinishBlock];
}

-(void)sendRequestSuccFinishBlock:(void(^)(id response))requestFinishBlock{
    [self sendRequestSuccFinishBlock:requestFinishBlock requestBusinessFailureBlock:nil requestFailFinishBlock:nil];
}

#pragma mark -
-(void)doGetRequest{
    PPAFHTTPClient *httpClient = [PPAFHTTPClient shareClient];
//    httpClient.localURL = [NSURL URLWithString:[self getLocalURL]];
    //设置参数
    [self setparamesDic];
    [httpClient GET:[_methodName copy] parameters:[_httpBodyDic copy] success:^(NSURLSessionDataTask *task, id responseObject) {
        //concurrent deal block
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self hanleSuccessResponseWithTask:task response:responseObject];
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handlerErrorResponse:error];
    }];
}

-(void)doPostRequest{
    [self sendDataNumOfRepeat:_numOfRepeat];
}

-(void)sendDataNumOfRepeat:(NSInteger)numOfRepeat{
    
    PPAFHTTPClient *httpClient = [PPAFHTTPClient shareClient];
//    httpClient.localURL = [NSURL URLWithString:[self getLocalURL]];
    // header + param
    [self setparamesDic];
    //send Request
    [httpClient POST:[_methodName copy] parameters:[_httpBodyDic copy] success:^(NSURLSessionDataTask *task, id responseObject) {
        //concurrent deal block
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            self.requestTime = httpClient.requestTime;
            [self hanleSuccessResponseWithTask:task response:responseObject];
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(numOfRepeat <= 1){
            [self handlerErrorResponse:error];
        }
        else{
            dispatch_async([PPAFHTTPClient shareClient].workQueue, ^{
                [self sendDataNumOfRepeat:numOfRepeat-1];
            });
        }
    }];
}

-(void)setparamesDic
{
   //NOTE:RequestParamesDic
//    NSLog(@"paramesDic = %@",_parametersDic);
    _httpBodyDic = [[NetworkHelper shareInstance] requestParameters:[_parametersDic copy]];
}

#pragma mark -

-(void)hanleSuccessResponseWithTask:(NSURLSessionDataTask *)task response:(id)responseObject{
    [self handlerResponse:responseObject WithTask:task];
}

-(void)handlerResponse:(id)responseObject WithTask:(NSURLSessionDataTask *)task{
    NSData* resultData = nil;
    resultData = responseObject;
    NSMutableDictionary* resultDic = nil;
    if (resultData) {
        resultDic = [self parserJsonData:resultData];
        if(![resultDic isKindOfClass:[NSDictionary class]] && ![resultDic isKindOfClass:[NSArray class]]){
            resultDic = nil;
        }
    }
    
    if (!task) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_requestBusinessFailureBlock) {
                _requestBusinessFailureBlock(resultDic);
            }
        });
        
    }
    else
    {
        
        if (resultData && resultDic){
            [self handlerSuccFinishResponseWithDic:resultDic];
        }else{
            //数据不是json格式
            [self handlerErrorResponse:nil];
        }
    }
}

/** 如果缓存先返回，而且设置了resetBlock标记，网络返回99999时候进行reset。 */
-(void)handlerSuccFinishResponseWithNetFlag
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(_isResetBlock){
            [self resetFinishBlock];
        }
    });
}
/** @brief 获取数据完毕后的dic
 *  @param resultDic 网络请求字典结果
 */
-(void)handlerSuccFinishResponseWithDic:(NSMutableDictionary*)resultDic
{
//    NSString *codeKey = [[NetworkHelper shareInstance] requestCodeKey];
//    NSInteger successCode = [[NetworkHelper shareInstance] requestSuccessCode];
//    NSInteger code = [resultDic[codeKey] integerValue];
//    if(code != successCode){
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (_requestBusinessFailureBlock) {
//                _requestBusinessFailureBlock(resultDic);
//                
//            }else{
//                if (_requestFailFinishBlock) {
//                    _requestFailFinishBlock(nil);
//                }
//            }
//            
//        });
//    }
//    else{
        [self handleSuccessBlockWithDic:[self processResultWithDic:resultDic]];
//    }
}
-(void)handleSuccessBlockWithDic:(id)dic
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_requestSuccFinishBlock) {
            _requestSuccFinishBlock(dic);
            [self resetFinishBlock];
        }
    });
}

//网络返回错误后的处理
-(void)handlerErrorResponse:(NSError*)error
{
    //取消请求，不调回block
    if (kCFURLErrorCancelled == error.code) {
        return;
    }
    [self handleErroBlock:error];
}

-(void)handleErroBlock:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_requestFailFinishBlock) {
            _requestFailFinishBlock(error);
            _isFailBlockFinish = YES;
            [self resetFinishBlock];
        }
    });
}

#pragma mark -
-(void)resetFinishBlock{
    _requestSuccFinishBlock = nil;
    _requestFailFinishBlock = nil;
    _requestBusinessFailureBlock = nil;
}

/*
 * @brief 服务器返回的数据解析成功后会调用
 * @note  可以访问self.result得到服务器返回的结果，一定是NSDictionary类型。
 */

-(id)processResultWithDic:(NSMutableDictionary*)resultDic
{
    return resultDic;
}

- (NSString *)getLocalURL
{
    return nil;
}

+ (void)cancelRequest{
    __weak PPAFHTTPClient *weakClient = [PPAFHTTPClient shareClient];
    NSString *urlString = [self getUrlName];
    dispatch_async([PPAFHTTPClient shareClient].workQueue, ^{
        if(urlString.length > 0){
            [weakClient cancelTasksWithUrl:urlString];
            objc_setAssociatedObject([self class], BASEREQUEST_METHODNAME_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    });
}

- (NSString *)description{
    NSString *className = NSStringFromClass([self class]);
    NSString *desStr = [NSString stringWithFormat:@"%@\nparam:\n%@", className, _parametersDic];
    return desStr;
}

/**
 *  用户初始化后，此url才有效。
 */
+ (NSString*)getUrlName{
    NSString* urlString =  objc_getAssociatedObject([self class], BASEREQUEST_METHODNAME_KEY);
    //为了外面使用isHttpQueueFinished的方便，不返回nil。
    if(!urlString){
        urlString = @"";
    }
    return urlString;
}

+ (BOOL)isHttpQueueFinished:(NSArray*)httpUrlArray{
    return [[PPAFHTTPClient shareClient]isHttpQueueFinished:httpUrlArray];
}

+ (BOOL)isHttpQueueFinishedWithClassNameArray:(NSArray*)requestClassArray{
    NSMutableArray* urlArray = [NSMutableArray array];
    
    for (NSString* className in requestClassArray) {
        if (className.length == 0) {
            continue;
        }
        
        Class currentClass = NSClassFromString(className);
        if(!currentClass){
            continue;
        }
        
        if(![currentClass isSubclassOfClass:[BaseRequest class]]){
            continue;
        }
        
        NSString* urlName = [currentClass getUrlName];
        if(urlName.length > 0){
            [urlArray addObject:urlName];
        }
    }
    return [self isHttpQueueFinished:urlArray];
}


/**
 *	@brief	将json数据转换成id
 *
 *	@param jsonData 数据
 *
 *	@return	 id类型的数据
 */
- (id)parserJsonData:(id)jsonData{
    NSError *error;
    id jsonResult = nil;
    //json对象
    if([NSJSONSerialization isValidJSONObject:jsonData]){
        return jsonData;
    }
    //NSData
    if (jsonData&&[jsonData isKindOfClass:[NSData class]]){
        jsonResult = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    }
    if (jsonResult != nil && error == nil){
        return jsonResult;
    }else{
        // 解析错误
        return nil;
    }
}

- (NSString *)requestTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    if (_requestTime.length > 0) {
        NSDate *result = [formatter dateFromString:_requestTime];
        return [formatter stringFromDate:result];
    }
    return [formatter stringFromDate:[NSDate new]];
}

@end
