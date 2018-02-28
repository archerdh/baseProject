//
//  DBRootViewController.m
//  DemoCode
//
//  Created by zheng zhang on 2018/2/8.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBRootViewController.h"

//vc
#import "DBCustomLibraryViewController.h"
#import "DBCustomListLibraryViewController.h"
#import "DBCustomLibraryNavViewController.h"

//V
#import "YYFPSLabel.h"

//M
#import "DBLibraryConfig.h"

@interface DBRootViewController ()

@end

@implementation DBRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViews];
}

- (void)setupViews
{
    [self addNavigationBar];
    [self setNavTitle:@"主干"];
    
    YYFPSLabel *label = [[YYFPSLabel alloc] initWithFrame:CGRectMake(kMainBoundsWidth - 100, 30, 100, 30)];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = kRect(0, 200, 100, 50);
    btn.backgroundColor = RGB_RANDOM_COLOR;
    btn.centerX = kMainBoundsWidth / 2;
    [btn addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

#pragma mark - action
- (void)chooseImage
{
    DBCustomListLibraryViewController *list = [DBCustomListLibraryViewController new];
    DBLibraryConfig *config = [DBLibraryConfig defaultPhotoConfiguration];
    config.sortAscending = 0;
    DBCustomLibraryViewController *library = [[DBCustomLibraryViewController alloc] init];
    DBCustomLibraryNavViewController *nav = [[DBCustomLibraryNavViewController alloc] initWithRootViewController:list];
    nav.config = config;
    [nav pushViewController:library animated:NO];

//    [self showDetailViewController:nav sender:nil];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
