//
//  DBUserDetailRefreshTopViewController.m
//  DemoCode
//
//  Created by zheng zhang on 2018/3/16.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBUserDetailRefreshTopViewController.h"
#import "UIScrollView+AURefreshMethods.h"
@interface DBUserDetailRefreshTopViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tabView;

@end

@implementation DBUserDetailRefreshTopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addNavigationBar];
    [self.view addSubview:self.tabView];
}

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.00;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - getter
- (UITableView *)tabView
{
    if (!_tabView) {
        _tabView = ({
            UITableView *tab = [[UITableView alloc] initWithFrame:kRect(0, self.navigationBar.height, kMainBoundsWidth, kMainBoundsHeight - self.navigationBar.height) style:UITableViewStylePlain];
            tab.delegate = self;
            tab.dataSource = self;
            if (@available(iOS 11.0, *)) {
                tab.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            } else {
                // Fallback on earlier versions
            }
            //去掉分割线
            WS(weakSelf);
            [tab addHeaderRefreshMethodWithCallback:^{
                [weakSelf.tabView.mj_header endRefreshing];
            }];
            tab.separatorStyle = UITableViewCellSelectionStyleNone;
            tab.backgroundColor = kDefaultBackgroundColor;
            tab;
        });
    }
    return _tabView;
}

@end
