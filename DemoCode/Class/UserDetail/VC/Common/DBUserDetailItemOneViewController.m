//
//  DBUserDetailItemOneViewController.m
//  DemoCode
//
//  Created by zheng zhang on 2018/3/14.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBUserDetailItemOneViewController.h"
#import "DBUserDetailOneCell.h"
@interface DBUserDetailItemOneViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) UITableView *tabView;

@end

static NSString *detailOneCellID = @"DBUserDetailOneCell";

@implementation DBUserDetailItemOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabView.contentInset = self.contentInset;
    self.tabView.height = self.viewHeight;
    [self.view addSubview:self.tabView];
}

#pragma mark - scrollDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.offsetBlock) {
        self.offsetBlock(scrollView.contentOffset.y);
    }
}

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBUserDetailOneCell *cell = [tableView dequeueReusableCellWithIdentifier:detailOneCellID];
    //去除点击阴影
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (kMainBoundsWidth - 30) * 3 / 4 + 35 + 21 + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - getter
- (UITableView *)tabView
{
    if (!_tabView) {
        _tabView = ({
            UITableView *tab = [[UITableView alloc] initWithFrame:kRect(0, 0, kMainBoundsWidth, kMainBoundsHeight - 50) style:UITableViewStylePlain];
            tab.delegate = self;
            tab.dataSource = self;
            if (@available(iOS 11.0, *)) {
                tab.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            } else {
                // Fallback on earlier versions
            }
            //去掉分割线
            tab.separatorStyle = UITableViewCellSelectionStyleNone;
            [tab registerClass:NSClassFromString(@"DBUserDetailOneCell") forCellReuseIdentifier:detailOneCellID];
            tab.backgroundColor = kDefaultBackgroundColor;
            tab;
        });
    }
    return _tabView;
}

@end
