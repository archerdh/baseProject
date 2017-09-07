//
//  BaseTabBarController.m
//  tuancheclient
//
//  Created by kongxc on 15/6/29.
//  Copyright (c) 2015年 tuanche. All rights reserved.
//

#import "BaseTabBarController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    [UIViewController attemptRotationToDeviceOrientation];
}

@end
