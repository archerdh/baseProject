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
#import "DBUserDetailListViewController.h"
#import "DBPushAnimationListViewController.h"

//V
#import "YYFPSLabel.h"

//M
#import "DBLibraryConfig.h"
#import <UserNotifications/UserNotifications.h>

@interface DBRootViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *sourceArr;

@end

static NSString *rootCellID = @"rootCellID";

@implementation DBRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sourceArr = @[@"进入相册", @"转场动画", @"个人中心各种形式"];
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

#pragma mark - 测试通知
- (void)initNoti
{
    // 1.创建通知内容
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"徐不同测试通知";
    content.subtitle = @"测试通知";
    content.body = @"来自万里的简书";
    content.badge = @1;
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"playVideo@2x" ofType:@"png"];
    // 2.设置通知附件内容
    UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
    if (error) {
        NSLog(@"attachment error %@", error);
    }
    content.attachments = @[att];
    content.launchImageName = @"lock";
    // 2.设置声音
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;
    
    // 3.触发模式
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    
    // 4.设置UNNotificationRequest
    NSString *requestIdentifer = @"TestRequest";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
    
    //5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rootCellID];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.sourceArr[indexPath.item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self chooseImage];
    }
    else if(indexPath.row == 1)
    {
        DBPushAnimationListViewController *vc = [DBPushAnimationListViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 2)
    {
        DBUserDetailListViewController *vc = [[DBUserDetailListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    //face
//    DBFaceIDViewController *vc = [DBFaceIDViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
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
