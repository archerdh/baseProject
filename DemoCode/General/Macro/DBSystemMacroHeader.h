//
//  DBSystemMacroHeader.h
//  DemoCode
//
//  Created by zheng zhang on 2017/9/7.
//  Copyright © 2017年 auction. All rights reserved.
//

#ifndef DBSystemMacroHeader_h
#define DBSystemMacroHeader_h

#pragma mark 系统版本判断
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define iOS7System (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? YES:NO)
#define AboveIOS8System (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) ? YES:NO)
#define CURRENTSYSTEM  [[[UIDevice currentDevice] systemVersion] floatValue]

#define PATH_AT_DOCDIR(name)        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:name]
#define PATH_AT_TMPDIR(name)        [NSTemporaryDirectory() stringByAppendingPathComponent:name]
#define PATH_AT_CACHEDIR(name)		[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:name]

//自定义log
#ifdef DEBUG  // 调试阶段
#define AULog(...) NSLog(__VA_ARGS__)
#else // 发布阶段
#define AULog(...)
#endif

#define kWindow [UIApplication sharedApplication].windows.lastObject
#define kRecommendCarPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"recommendCar.data"]
#define kUserDefaults [NSUserDefaults standardUserDefaults]

extern CGFloat KTC_SCREEN_RATION; // 此处为声明，定义在AppDelegate
extern CGFloat KTC_SCREEN_RATION_HOR; // 此处为声明，定义在AppDelegate

/**
 *  弱引用
 *
 *  @param weakSelf 对象
 *
 *  @return 若引用对象
 */
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

/**
 *  时间戳
 */
#define KTimeStr  [NSString stringWithFormat:@"%lld",(long long int)([[NSDate date] timeIntervalSince1970] *1000)]
/**
 *  key
 */
#define KCMKey  [NSString stringWithFormat:@"%@%@",KTimeStr,@"tuanche1234abcd1234"]
/**
 *  网络断开
 */
#define brokenNetwork     @"哎呀，断网了"
/**
 *  该主播不能进入自己的直播
 */
#define liveOnOhterDevice @"该账号正在其他设备上直播!"
/**
 *  用户背景key
 */
#define KUserBackgroundKey     @"KUserBackgroundKey"

// 头像占位图
#define K_HEAD_PLACEHOLDER @"common_defaultIcon"

// 统一又拍云图片前缀
#define kUpYunURLPrefix  @"https://collection-auction.b0.upaiyun.com"
// 获取准确又拍云图片URL
#define kUpYunGetFullUrl(urlString) [urlString containsString:@"upaiyun.com"] ? urlString : [kUpYunURLPrefix stringByAppendingString:urlString]

// 给图片添加
#define K_PIC(pic, suffix) [(pic) rangeOfString:@"collection-auction.b0.upaiyun.com"].location == NSNotFound ? (pic) : [NSString stringWithFormat:@"%@!%@",(pic),(suffix)]
#define K_PIC_250x250(pic)      K_PIC((pic), @"250x250")
#define K_PIC_300x300(pic)      K_PIC((pic), @"300x300")
#define K_PIC_300x225(pic)      K_PIC((pic), @"300x225")
#define K_PIC_345x345(pic)      K_PIC((pic), @"345x345")

#define K_PIC_750x563(pic)      K_PIC((pic), @"750x563")
#define K_PIC_750x0(pic)        K_PIC((pic), @"750x0")

#define K_PIC_750x0(pic)        K_PIC((pic), @"750x0")

#endif /* DBSystemMacroHeader_h */
