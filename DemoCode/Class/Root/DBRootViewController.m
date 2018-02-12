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

//V
#import "YYFPSLabel.h"

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
    DBCustomLibraryViewController *library = [[DBCustomLibraryViewController alloc] init];
    [self.navigationController pushViewController:library animated:YES];
}

@end
