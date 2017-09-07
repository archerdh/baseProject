//
//  PPCache.h
//  PublicProject
//
//  Created by archer on 15/5/8.
//  Copyright (c) 2015年 archer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPCache : NSObject

+ (void)removeRequestDataOfDocWithFolderName:(NSString *)folderName ;
+ (void)cacheRequestData:(NSData *)data
              folderName:(NSString *)folderName
                  prefix:(NSString *)prefix
                  subfix:(NSString *)subfix;
+ (NSData *)requestDataOfCacheWithFolderName:(NSString *)folderName
                                      prefix:(NSString *)prefix
                                      subfix:(NSString *)subfix;
+ (NSData*)readCacheFolderName:(NSString *)folderName cacheName:(NSString *)cacheName;
+ (NSString *)getTimeStampWithFolderName:(NSString *)folderName prefix:(NSString *)prefix;
+ (void)writeCache:(NSData *)cache folderName:(NSString *)folderName cacheName:(NSString *)cacheName;

/**
 *  缓存一个对象
 *
 *  @param object   缓存对象
 *  @param fileName 文件名
 */
+ (BOOL)cacheObject:(id)object fileName:(NSString *)fileName;

/**
 *  取出缓存数据对象
 *
 *  @param fileName 文件名
 *
 */
+ (id)readCacheWithFileName:(NSString *)fileName;

/**
 *  删除缓存文件
 *
 *  @param fileName 文件名
 */
+ (void)removeCacheWithFileName:(NSString *)fileName;

@end
