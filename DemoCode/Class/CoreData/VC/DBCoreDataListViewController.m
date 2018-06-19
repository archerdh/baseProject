//
//  DBCoreDataListViewController.m
//  DemoCode
//
//  Created by zhangzheng on 2018/6/18.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBCoreDataListViewController.h"
#import "DBCoreDataManager.h"
@interface DBCoreDataListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *sourceArr;

@end

static NSString *rootCellID = @"CoreDataListCellID";

@implementation DBCoreDataListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViews];
}

- (void)setupViews
{
    [self addNavigationBar];
    [self setNavTitle:@"coreData"];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - action
- (void)addCoreData
{
    DBCoreDataModel *model = [DBCoreDataModel new];
    model.name = @"小明";
    model.sex = @"18";
    [DBCoreDataManager createManagedObjectWithUserModel:model];
    
    self.sourceArr = [DBCoreDataManager getManagedObjectAllUser];
    [self.tableView reloadData];
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:kRect(0, 0, kMainBoundsWidth, 40.0f)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = kRect(30, 0, 50, 40);
    btn.backgroundColor = RGB_RANDOM_COLOR;
    [btn addTarget:self action:@selector(addCoreData) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rootCellID];
    DBCoreDataModel *model = self.sourceArr[indexPath.item];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = model.name;
    return cell;
}

#pragma mark - getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = ({
            UITableView *view = [[UITableView alloc] initWithFrame:kRect(0, self.navigationBar.bottom, self.view.width, self.view.height - self.navigationBar.bottom) style:UITableViewStyleGrouped];
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
