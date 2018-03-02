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
#import "DBFaceIDViewController.h"

//V
#import "YYFPSLabel.h"

//M
#import "DBLibraryConfig.h"

@interface DBRootViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

static NSString *rootCellID = @"rootCellID";

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
    [self.view addSubview:self.tableView];
}

#pragma mark - tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rootCellID];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"进入相册";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self chooseImage];
    DBFaceIDViewController *vc = [DBFaceIDViewController new];
    [self.navigationController pushViewController:vc animated:YES];
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
    [self presentViewController:nav animated:YES completion:nil];
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
            [view registerClass:NSClassFromString(@"UITableViewCell") forCellReuseIdentifier:rootCellID];
            view;
        });
    }
    return _tableView;
}

@end
