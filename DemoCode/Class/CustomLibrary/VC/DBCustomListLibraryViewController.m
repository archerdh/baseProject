//
//  DBCustomListLibraryViewController.m
//  DemoCode
//
//  Created by zheng zhang on 2018/2/27.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBCustomListLibraryViewController.h"

//V
#import "DBCustomLibraryTabCell.h"

//VC
#import "DBCustomLibraryNavViewController.h"

//M
#import "DBImageListModel.h"
#import "DBCustomLibraryManager.h"

@interface DBCustomListLibraryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIButton *cancleBtn;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, copy) NSMutableArray<DBImageListModel *> *arrayDataSources;

@end

static NSString *libraryTabCellID = @"DBCustomLibraryTabCell";

@implementation DBCustomListLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addNavigationBar];
    self.navigationBar.rightBarItems = @[self.cancleBtn];
    [self setNavTitle:@"照片"];
    [self.view addSubview:self.tableView];
    
    DBCustomLibraryNavViewController *nav = (DBCustomLibraryNavViewController *)self.navigationController;

    WS(weakSelf);
    [DBCustomLibraryManager getPhotoAblumList:nav.config complete:^(NSArray<DBImageListModel *> *arr) {
        weakSelf.arrayDataSources = [NSMutableArray arrayWithArray:arr];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - Action
- (void)cancleClick
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayDataSources.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBCustomLibraryTabCell *cell = [tableView dequeueReusableCellWithIdentifier:libraryTabCellID];
    DBImageListModel *albumModel = self.arrayDataSources[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = albumModel;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self pushThumbnailVCWithIndex:indexPath.row animated:YES];
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
            [view registerClass:NSClassFromString(@"DBCustomLibraryTabCell") forCellReuseIdentifier:libraryTabCellID];
            view;
        });
    }
    return _tableView;
}

- (UIButton *)cancleBtn
{
    if (!_cancleBtn) {
        _cancleBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            [btn setTitle:@"取消" forState:UIControlStateHighlighted];
            btn.frame = kRect(0, 0, 60, self.navigationBar.backButton.height);
            [btn addTarget:self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:UIColorFromRGB(0x0000000) forState:UIControlStateHighlighted];
            [btn setTitleColor:UIColorFromRGB(0x0000000) forState:UIControlStateNormal];
            btn.titleLabel.font = self.navigationBar.backButton.titleLabel.font;
            btn;
        });
    }
    return _cancleBtn;
}
@end
