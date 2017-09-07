//
//  DBLayoutMacroHeader.h
//  DemoCode
//
//  Created by zheng zhang on 2017/9/7.
//  Copyright © 2017年 auction. All rights reserved.
//

#ifndef DBLayoutMacroHeader_h
#define DBLayoutMacroHeader_h

#define kMainScreenWidth    ([UIScreen mainScreen].applicationFrame).size.width //应用程序的宽度
#define kMainScreenHeight   ([UIScreen mainScreen].applicationFrame).size.height //应用程序的高度
#define kMainBoundsHeight   ([UIScreen mainScreen].bounds).size.height //屏幕的高度
#define kMainBoundsWidth    ([UIScreen mainScreen].bounds).size.width //屏幕的宽度

#define KFont(s, w) [UIFont systemFontOfSize:(s*KTC_SCREEN_RATION) weight:w]

#define kTabBarHeight                        44.0f
#define kNaviBarHeight                       44.0f
#define kHeightFor4InchScreen                568.0f
#define kHeightFor3p5InchScreen              480.0f
#define kStatusBarHeight                     [UIApplication sharedApplication].statusBarFrame.size.height
#define kRect(x, y, w, h)                    CGRectMake(x, y, w, h)
#define kSize(w, h)                          CGSizeMake(w, h)
#define kPoint(x, y)                         CGPointMake(x, y)

#define PresentModalViewControllerAnimated(controller1,controller2,animated)     [Helper presentModalViewRootController:controller1 toViewController:controller2 Animated:animated];
#define DismissModalViewControllerAnimated(controller,animated) [Helper dismissModalViewController:controller Animated:animated];
#define kPushViewControllerAnimated(controller1,controller2,animated)  [Helper pushViewRootController:controller1 toViewController:controller2 Animated:animated];

#endif /* DBLayoutMacroHeader_h */
