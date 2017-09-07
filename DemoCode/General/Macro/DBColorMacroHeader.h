//
//  DBColorMacroHeader.h
//  DemoCode
//
//  Created by zheng zhang on 2017/9/7.
//  Copyright © 2017年 auction. All rights reserved.
//

#ifndef DBColorMacroHeader_h
#define DBColorMacroHeader_h

#pragma mark 宏定义方法

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
#define RGB_RANDOM_COLOR [UIColor colorWithHue:(arc4random() % 256 / 256.0) saturation:(( arc4random() % 128 / 256.0 ) + 0.5) brightness:(( arc4random() % 128 / 256.0 ) + 0.5) alpha:1]

#pragma mark 背景色

/** 默认背景颜色 */
#define kDefaultBackgroundColor    UIColorFromRGB(0xf1f1f1)
/** 分割线的颜色 #e5e5e5 */
#define kDefaultLineColor  UIColorFromRGB(0xb3b3b3)

/** 图片占位色 #ececec */
#define kDefaultImageColor  UIColorFromRGB(0xe1e1e1)

#endif /* DBColorMacroHeader_h */
