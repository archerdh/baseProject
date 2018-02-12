//
//  AppDelegate.m
//  DemoCode
//
//  Created by zheng zhang on 2017/9/7.
//  Copyright © 2017年 auction. All rights reserved.
//

#import "AppDelegate.h"
//VC
#import "DBRootViewController.h"
#import "BaseNavigationController.h"

@interface AppDelegate ()

@end


CGFloat KTC_SCREEN_RATION = 1.0f;
CGFloat KTC_SCREEN_RATION_HOR = 1.0f;
CGFloat KTC_TOP_MARGIN = 20.0f; // iPhoneX顶部不可编辑高度
CGFloat KTC_BOTTOM_MARGIN = 0.0f;// iPhoneX底部不可编辑高度
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    // 设置布局辅助
    KTC_SCREEN_RATION = kMainBoundsWidth/375.0;
    if (@available(iOS 11.0, *)) {
        KTC_BOTTOM_MARGIN = self.window.safeAreaInsets.bottom;
        KTC_TOP_MARGIN = UIEdgeInsetsEqualToEdgeInsets(self.window.safeAreaInsets, UIEdgeInsetsZero) ? 20.0f : self.window.safeAreaInsets.top;
    } else {
        // Fallback on earlier versions
        KTC_BOTTOM_MARGIN = 0.0f;
        KTC_TOP_MARGIN = 20.0f;
    }
    
    // 设置window为主window，并可见
    [self.window makeKeyAndVisible];
    DBRootViewController *rootVC = [[DBRootViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:rootVC];
    self.window.rootViewController = nav;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
