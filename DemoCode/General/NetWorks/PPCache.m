//
//  PPCache.m
//  PublicProject
//
//  Created by archer on 15/5/8.
//  Copyright (c) 2015年 archer. All rights reserved.
//

#import "PPCache.h"

static NSString * const PPCacheCustomDir = @"PPCacheCustomDir";
@implementation PPCache

/**
 *@brief 获取Documents下的路径
 */
+ (NSString *)pathAtDocumentFileName:(NSString *)fileName{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
}

/**
 *@brief 获取Library下Caches得路径
 */
+ (NSString *)pathAtLibraryCachesWithFileName:(NSString *)fileName{
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
}

+ (NSData *)requestDataOfCacheWithFolderName:(NSString *)folderName
                                      prefix:(NSString *)prefix
                                      subfix:(NSString *)subfix {
    
    NSString *requestDataCachePath = [self pathAtDocumentFileName:((folderName ? folderName : @""))];
    NSString *filePrefix = (prefix ? [NSString stringWithFormat:@"%@_", prefix] : @"_");
    NSString *fileSubfix = (subfix ? [NSString stringWithFormat:@"_%@", subfix] : nil);
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:requestDataCachePath];
    
    for(NSString *fileName in files) {
        if([fileName hasPrefix:filePrefix] && (!fileSubfix || (fileSubfix && [fileName hasSuffix:fileSubfix]))) {
            return [NSData dataWithContentsOfFile:[requestDataCachePath stringByAppendingPathComponent:fileName]];
        }
    }
    
    return nil;
}

+ (void)removeRequestDataOfDocWithFolderName:(NSString *)folderName {
    NSString *requestDataCachePath = [self pathAtDocumentFileName:((folderName ? folderName : @""))];
    if([[NSFileManager defaultManager] fileExistsAtPath:requestDataCachePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:requestDataCachePath error:nil];
    }
}

+ (void)cacheRequestData:(NSData *)data
              folderName:(NSString *)folderName
                  prefix:(NSString *)prefix
                  subfix:(NSString *)subfix{
    
    NSString *requestDataCachePath = [self pathAtDocumentFileName:((folderName ? folderName : @""))];
    NSString *filePrefix = (prefix ? [NSString stringWithFormat:@"%@_", prefix] : @"_");
    NSString *fileSubfix = (subfix ? [NSString stringWithFormat:@"%@", subfix] : nil);
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:requestDataCachePath];
    
    for(NSString *fileName in files) {
        if([fileName hasPrefix:filePrefix] && (!fileSubfix || (fileSubfix && [fileName hasSuffix:fileSubfix]))) {
            [[NSFileManager defaultManager] removeItemAtPath:[requestDataCachePath stringByAppendingPathComponent:fileName] error:nil];
            break;
        }
    }
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",requestDataCachePath,filePrefix];
    
    if (fileSubfix) {
        filePath = [filePath stringByAppendingString:fileSubfix];
    }
    
    [PPCache createFolder:filePath isDirectory:NO];
    [data writeToFile:filePath atomically:NO];
}

+ (NSData*)readCacheFolderName:(NSString *)folderName cacheName:(NSString *)cacheName
{
    NSString *folder = PATH_AT_CACHEDIR(folderName);
    NSString *filePath = [folder stringByAppendingPathComponent:cacheName];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return data;
}

+ (NSString *)getTimeStampWithFolderName:(NSString *)folderName prefix:(NSString *)prefix {
    if (!folderName  || !prefix) {
        return @"0";
    }
    NSString *requestDataCachePath = PATH_AT_CACHEDIR(folderName);
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:requestDataCachePath];
    for(NSString *fileName in files) {
        if([fileName hasPrefix:prefix]) {
            if (fileName.length == prefix.length) {
                return [fileName substringFromIndex:prefix.length];
            } else {
                return [fileName substringFromIndex:prefix.length + 1];
            }
        }
    }
    
    return @"0";
}

+ (void)writeCache:(NSData *)cache folderName:(NSString *)folderName cacheName:(NSString *)cacheName {
    NSString *folder = PATH_AT_CACHEDIR(folderName);
    NSString *filePath = [folder stringByAppendingPathComponent:cacheName];
    
    [PPCache deleteContentsOfFolder:folder];
    [cache writeToFile:filePath atomically:NO];
}

+ (BOOL)createFolder:(NSString*)folderPath isDirectory:(BOOL)isDirectory {
    NSString *path = nil;
    if(isDirectory) {
        path = folderPath;
    } else {
        path = [folderPath stringByDeletingLastPathComponent];
    }
    
    if(folderPath && [[NSFileManager defaultManager] fileExistsAtPath:path] == NO) {
        NSError *error = nil;
        BOOL ret;
        
        ret = [[NSFileManager defaultManager] createDirectoryAtPath:path
                                        withIntermediateDirectories:YES
                                                         attributes:nil
                                                              error:&error];
        if(!ret && error) {
            NSLog(@"create folder failed at path '%@',error:%@,%@",folderPath,[error localizedDescription],[error localizedFailureReason]);
            return NO;
        }
    }
    
    return YES;
}


+ (void) deleteContentsOfFolder:(NSString *)folderPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:folderPath error:nil];
    
    
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
    if ( !(isDir && existed) ) {
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (BOOL)cacheObject:(id)object fileName:(NSString *)fileName{
    if(fileName == nil){
        return NO;
    }
    //创建文件夹
    NSString *floderPath = [self pathAtDocumentFileName:fileName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:floderPath isDirectory:nil]){
        BOOL isSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:floderPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!isSuccess){
            //创建文件夹失败
            return NO;
        }
    }
    //写入文件
    NSString *filePath = [floderPath stringByAppendingPathComponent:fileName];
    if(![NSKeyedArchiver archiveRootObject:object toFile:filePath]){
        return NO;
    }
    return YES;
}

+ (id)readCacheWithFileName:(NSString *)fileName{
    if(fileName == nil){
        return nil;
    }
    NSString *floderPath = [self pathAtDocumentFileName:fileName];
    NSString *filePath = [floderPath stringByAppendingPathComponent:fileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}


+ (void)removeCacheWithFileName:(NSString *)fileName{
    if(fileName == nil){
        return;
    }
    NSString *floderPath = [self pathAtDocumentFileName:fileName];
    NSString *filePath = [floderPath stringByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

@end
