//
//  DBImageCache.m
//  DemoCode
//
//  Created by zheng zhang on 2018/6/5.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBImageCache.h"

@interface DBImageCache ()

/**
 *  存放所有下载完的图片
 */
@property (nonatomic, strong) NSMutableDictionary *images;

/**
 *  存放所有的下载操作（key是url，value是operation对象）
 */
@property (nonatomic, strong) NSMutableDictionary *operations;

/**
 *  下载队列
 */
@property (nonatomic, strong) NSOperationQueue *queue;

/**
 *  拼接Cache文件夹的路径与url最后的部分，合并成唯一约定好的缓存路径
 */
#define CachedImageFile(url) [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[url lastPathComponent]]

@end

@implementation DBImageCache

static DBImageCache *sharedSingleCase;

+ (id)shareImageCache
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingleCase = [[DBImageCache allocWithZone:NULL] init];
    });
    return sharedSingleCase;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.images = [NSMutableDictionary dictionary];
        self.operations = [NSMutableDictionary dictionary];
        self.queue = [[NSOperationQueue alloc] init];
        //并发数量
        self.queue.maxConcurrentOperationCount = 5;
    }
    return self;
}

- (void)db_setImageWithUrl:(NSURL *)imageURL completed:(DBImageCacheCompletionBlock)completedBlock
{
    //取缓存
    UIImage *image = self.images[imageURL.lastPathComponent];
    if (image) {
        completedBlock(image, nil, imageURL);
    }
    else
    {
        // 不存在：说明图片并未下载成功过，或者成功下载但是在images里缓存失败，需要在沙盒里寻找对于的图片
        // 获得url对于的沙盒缓存路径
        NSString *file = CachedImageFile(imageURL);
        // 先从沙盒中取出图片
        NSData *data = [NSData dataWithContentsOfFile:file];
        if (data) {
            //找到了沙盒缓存
            UIImage *image = [UIImage imageWithData:data];
            //进行缓存，后期可以考虑权重问题
            [self.images setValue:image forKey:imageURL.lastPathComponent];
            completedBlock(image, nil, imageURL);
        }
        else
        {
            //查找下载任务
            NSBlockOperation *download = [self.operations objectForKey:imageURL.lastPathComponent];
            if (download) {
                //什么都不做，任务进行中或者已经进行了
            }
            else
            {
                WS(weakSelf);
                download = [NSBlockOperation blockOperationWithBlock:^{
                    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                    UIImage *image = [UIImage imageWithData:imageData];
                    //没有拿到图片
                    if (image == nil) {
                        NSError *err = [[NSError alloc] init];
                        [err.userInfo setValue:@"下载失败了，取不到图片数据" forKey:@"message"];
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            completedBlock(nil, err, imageURL);
                        }];
                        [weakSelf.operations removeObjectForKey:imageURL.lastPathComponent];
                        return;
                    }
                    
                    [weakSelf.images setValue:image forKey:imageURL.lastPathComponent];
                    //写进沙盒
                    [imageData writeToFile:file atomically:YES];
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        completedBlock(image, nil, imageURL);
                    }];
                }];
                [weakSelf.operations setValue:download forKey:imageURL.lastPathComponent];
                [weakSelf.queue addOperation:download];
            }
        }
    }
}

@end
