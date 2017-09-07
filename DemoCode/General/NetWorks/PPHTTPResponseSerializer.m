//
//  PPHTTPResponseSerializer.m
//  PublicProject
//
//  Created by user on 15/5/13.
//  Copyright (c) 2015年 archer. All rights reserved.
//

#import "PPHTTPResponseSerializer.h"
#import "NetworkHelper.h"

@implementation PPHTTPResponseSerializer
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",nil];
    
    return self;
}

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    NSData *handleOnData = [[NetworkHelper shareInstance] handleOnResponse:response data:data];
    return [super responseObjectForResponse:response data:handleOnData error:error];
}
@end
