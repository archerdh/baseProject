//
//  DBUserDetailRefreshTopViewController.m
//  DemoCode
//
//  Created by zheng zhang on 2018/3/16.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBUserDetailRefreshTopViewController.h"
#import "UIScrollView+AURefreshMethods.h"
#import "DBUserDetailChildViewController.h"
#import "DBUserDetailContentViewController.h"
#import "DBGestureTableView.h"
@interface DBUserDetailRefreshTopViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) DBGestureTableView *tabView;
@property (nonatomic, strong) DBUserDetailContentViewController *pageVC;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;
@property (nonatomic, assign) BOOL canScroll;

@end

static NSString *userDetailContentCellID = @"userDetailContentCellID";

@implementation DBUserDetailRefreshTopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addNavigationBar];
    [self.view addSubview:self.tabView];
    self.tabView.tableHeaderView = [[UIView alloc] initWithFrame:kRect(0, 0, kMainBoundsWidth, kMainBoundsWidth * 3 / 4)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kLeaveTopNotificationName object:nil];
}

- (void)acceptMsg:(NSNotification *)notification {
    NSLog(@"%@",notification);
    if ([notification.name isEqualToString:kLeaveTopNotificationName]) {
        _canScroll = YES;
    }
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 获取pageTab的偏移量
    CGFloat pageTabOffsetY =  [_tabView rectForSection:0].origin.y;
    CGFloat offsetY = scrollView.contentOffset.y;
    // NSLog(@"%f---%f", offsetY, pageTabOffsetY);
    // 先保留状态
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    if (offsetY >= pageTabOffsetY) {
        // 置顶
        [scrollView setContentOffset:CGPointMake(0, pageTabOffsetY) animated:NO];
        // 不允许滚动 标记
        _isTopIsCanNotMoveTabView = YES;
    } else {
        // 允许滚动
        _isTopIsCanNotMoveTabView = NO;
    }
    // 状态有改变
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
        // 之前能滚动，现在不能滚动，表示进入置顶状态
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kGoTopNotificationName object:nil userInfo:nil];
            _canScroll = NO;
        }
        // 之前不能滚动，现在能滚动，表示进入取消置顶
        if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
            if (_canScroll == NO) {
                scrollView.contentOffset = CGPointMake(0, pageTabOffsetY);
                _isTopIsCanNotMoveTabView = YES;
            } else {
                NSLog(@"%s", __func__);
            }
        }
    }
    if (_isTopIsCanNotMoveTabView && _isTopIsCanNotMoveTabViewPre) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGoTopNotificationName object:nil userInfo:nil];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userDetailContentCellID];
    cell.exclusiveTouch = YES;
    DBUserDetailContentViewController *vc = self.pageVC;
    [cell.contentView addSubview:vc.view];
    
    [self addChildViewController:vc];
    [vc didMoveToParentViewController:self];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMainBoundsHeight - 50 - self.navigationBar.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 50;
    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.pageVC.slideBar;
    }
    return nil;
}

#pragma mark - getter
- (DBGestureTableView *)tabView
{
    if (!_tabView) {
        _tabView = ({
            DBGestureTableView *tab = [[DBGestureTableView alloc] initWithFrame:kRect(0, self.navigationBar.height, kMainBoundsWidth, kMainBoundsHeight - self.navigationBar.height) style:UITableViewStylePlain];
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
            [tab registerClass:[UITableViewCell class] forCellReuseIdentifier:userDetailContentCellID];
            tab;
        });
    }
    return _tabView;
}

- (DBUserDetailContentViewController *)pageVC {
    if (_pageVC == nil) {
        _pageVC = [DBUserDetailContentViewController new];
    }
    return _pageVC;
}

@end
