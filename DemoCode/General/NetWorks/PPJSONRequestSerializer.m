//
//  PPHTTPRequestSerializer.m
//  PublicProject
//
//  Created by user on 15/5/13.
//  Copyright (c) 2015年 archer. All rights reserved.
//

#import "PPJSONRequestSerializer.h"
#import "NetworkHelper.h"

@implementation PPJSONRequestSerializer

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request withParameters:(id)parameters error:(NSError *__autoreleasing *)error{
    NSParameterAssert(request);
    
    if ([self.HTTPMethodsEncodingParametersInURI containsObject:[[request HTTPMethod] uppercaseString]]) {
        return [super requestBySerializingRequest:request withParameters:parameters error:error];
    }
    
    //处理请求
    id result = [[NetworkHelper shareInstance] handleOnRequest:request parameters:[parameters copy]];
    if(result == nil){
        return [super requestBySerializingRequest:request withParameters:parameters error:error];
    }
    if(error){
        return nil;
    }
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    // NOTE:RequestHeader
    NSDictionary *httpRequestHeaderDic = [[NetworkHelper shareInstance] requestHttpHeader];
    [httpRequestHeaderDic enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![request valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];
    
    // NOTE:RequestBody
    if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
        [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    if([result isKindOfClass:[NSData class]]){
        [mutableRequest setHTTPBody:result];
    }
    else if([NSJSONSerialization isValidJSONObject:result]){
        [mutableRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:result options:0 error:error]];
    }
    else{
        return nil;
    }
    
    return mutableRequest;
    
}
@end
