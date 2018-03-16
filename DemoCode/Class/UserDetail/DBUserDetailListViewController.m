//
//  DBUserDetailListViewController.m
//  DemoCode
//
//  Created by zheng zhang on 2018/3/14.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBUserDetailListViewController.h"

//VC
#import "DBUserDetailListBackgroundViewController.h"
#import "DBUserDetailRefreshTopViewController.h"

@interface DBUserDetailListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *sourceArr;

@end

static NSString *userDetailListCellID = @"UserDetailListCellID";

@implementation DBUserDetailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sourceArr = @[@"下拉放大背景的形式", @"下拉刷新在顶部的形式", @"下拉刷新在中间的形式"];

    [self addNavigationBar];
    [self setNavTitle:@"个人中心的几种形式"];
    [self.view addSubview:self.tableView];
}


#pragma mark - tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userDetailListCellID];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.sourceArr[indexPath.item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[DBUserDetailListBackgroundViewController new] animated:YES];
    }
    else if(indexPath.row == 1)
    {
        DBUserDetailRefreshTopViewController *vc = [DBUserDetailRefreshTopViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 2)
    {
//        DBUserDetailListViewController *vc = [[DBUserDetailListViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = ({
            UITableView *view = [[UITableView alloc] initWithFrame:kRect(0, self.navigationBar.bottom, self.view.width, self.view.height - self.navigationBar.bottom) style:UITableViewStylePlain];
            view.delegate = self;
            view.dataSource = self;
            
            if (@available(iOS 11.0, *)) {
                view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            } else {
                // Fallback on earlier versions
            }
            view.estimatedRowHeight = 0;
            view.estimatedSectionFooterHeight = 0;
            view.estimatedSectionHeaderHeight = 0;
            //去掉分割线
            view.separatorStyle = UITableViewCellSelectionStyleNone;
            [view registerClass:NSClassFromString(@"UITableViewCell") forCellReuseIdentifier:userDetailListCellID];
            view;
        });
    }
    return _tableView;
}

@end
