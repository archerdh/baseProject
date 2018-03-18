//
//  DBUserDetailContentViewController.m
//  DemoCode
//
//  Created by zhangzheng on 2018/3/18.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBUserDetailContentViewController.h"
#import "DBUserDetailChildViewController.h"
@interface DBUserDetailContentViewController ()

@property (nonatomic, strong) DBUserDetailChildViewController *vc1;
@property (nonatomic, strong) DBUserDetailChildViewController *vc2;
@property (nonatomic, strong) DBUserDetailChildViewController *vc3;

@end

@implementation DBUserDetailContentViewController

- (void)viewDidLoad {
    self.slideBarCustom = YES;
    // 等宽
    self.slideBar.isUnifyWidth = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - ScrollPageViewControllerProtocol

- (NSArray *)arrayForControllerTitles {
    return @[@"分时", @"日K", @"周K"];
}

- (UIViewController *)viewcontrollerWithIndex:(NSInteger)index {
    if (index <0 || index > self.arrayForControllerTitles.count) return nil;
    if (index == 0) {
        return self.vc1;
    } else if (index == 1) {
        return self.vc2;
    } else if (index == 2) {
        return self.vc3;
    }
    return nil;
}

#pragma mark - Getter

- (DBUserDetailChildViewController *)vc1 {
    if (_vc1 == nil) {
        _vc1 = [DBUserDetailChildViewController new];
    }
    return _vc1;
}

- (DBUserDetailChildViewController *)vc2 {
    if (_vc2 == nil) {
        _vc2 = [DBUserDetailChildViewController new];
    }
    return _vc2;
}

- (DBUserDetailChildViewController *)vc3 {
    if (_vc3 == nil) {
        _vc3 = [DBUserDetailChildViewController new];
    }
    return _vc3;
}

@end
