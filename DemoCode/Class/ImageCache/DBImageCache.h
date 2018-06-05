//
//  DBImageCache.h
//  DemoCode
//
//  Created by zheng zhang on 2018/6/5.
//  Copyright © 2018年 auction. All rights reserved.
//  尝试模仿sdwebimage

#import <Foundation/Foundation.h>

typedef void(^DBImageCacheCompletionBlock)(UIImage *image, NSError *error, NSURL *imageURL);

@interface DBImageCache : NSObject

+ (id)shareImageCache;

- (void)db_setImageWithUrl:(NSURL *)imageURL completed:(DBImageCacheCompletionBlock)completedBlock;

@end
