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

#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

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
    
    //touch
    [self initTouchWith:application];
    
    //推送处理
    [self initPushWith:application];
    
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

#pragma mark - pushNotination
- (void)initPushWith:(UIApplication *)application
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS10特有
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        // 必须写代理，不然无法监听通知的接收与点击
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // 点击允许
                NSLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"%@", settings);
                }];
            } else {
                // 点击不允许
                NSLog(@"注册失败");
            }
        }];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >8.0){
        //iOS8 - iOS10
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
        
    }else if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        //iOS8系统以下
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    // 注册获得device Token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

// 获得Device Token
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    AULog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
}
// 获得Device Token失败
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    AULog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

// iOS 10收到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

// 通知的点击事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    // Warning: UNUserNotificationCenter delegate received call to -userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler: but the completion handler was never called.
    completionHandler();  // 系统要求执行这个方法
}

#pragma mark - touch相关
- (void)initTouchWith:(UIApplication *)application
{
    //Touch是从iOS9.0后开始使用
    if (@available(iOS 9.0, *)) {
        UIApplicationShortcutIcon *iconFitness = [UIApplicationShortcutIcon iconWithTemplateImageName:@"takePhoto"];
        //菜单文字
        UIMutableApplicationShortcutItem *itemFitness = [[UIMutableApplicationShortcutItem alloc] initWithType:@"1" localizedTitle:@"查看相册"];
        //绑定信息到指定菜单
        itemFitness.icon = iconFitness;
        //绑定到App icon
        application.shortcutItems = @[itemFitness];
    } else {
    }
}

#pragma mark - touch响应事件
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    if (shortcutItem.type.integerValue == 1) {
        BaseNavigationController *nav = (BaseNavigationController *)self.window.rootViewController;
        DBRootViewController *root = nav.childViewControllers.firstObject;
        [root chooseImage];
    }
}

@end
