//
//  DBCustomLibraryNavViewController.m
//  DemoCode
//
//  Created by zheng zhang on 2018/2/27.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBCustomLibraryNavViewController.h"
#import "SDWebImageManager.h"
#import "DBImageListModel.h"
@interface DBCustomLibraryNavViewController ()

@end

@implementation DBCustomLibraryNavViewController

- (void)dealloc
{
    [[SDWebImageManager sharedManager] cancelAll];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationBar.translucent = YES;
    }
    return self;
}

- (NSMutableArray<DBImageModel *> *)arrSelectedModels
{
    if (!_arrSelectedModels) {
        _arrSelectedModels = [NSMutableArray array];
    }
    return _arrSelectedModels;
}

@end
