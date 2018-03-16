//
//  DBUserDetailListBackgroundViewController.m
//  DemoCode
//
//  Created by zheng zhang on 2018/3/14.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBUserDetailListBackgroundViewController.h"
#import "DBUserDetailTwoViewController.h"
#import "DBUserDetailItemOneViewController.h"
#import "DBUserDetailBackgroundView.h"
@interface DBUserDetailListBackgroundViewController ()

@property (strong, nonatomic) UIScrollView *horScrollView;
@property (strong, nonatomic) DBUserDetailBackgroundView *backgroundView;
@property (strong, nonatomic) DBUserDetailBaseListViewController *currentVC;

@end

@implementation DBUserDetailListBackgroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.backgroundView];
    [self addNavigationBar];
    
    self.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationBar.statusBarView.backgroundColor = [UIColor clearColor];
    self.navigationBar.navigationBarView.backgroundColor = [UIColor clearColor];
    self.navigationBar.bottomLineView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.horScrollView];
    [self.view addSubview:self.backgroundView];
    [self.view bringSubviewToFront:self.navigationBar];
    WS(weakSelf);
    for (int i = 0; i < 5; i++) {
        DBUserDetailBaseListViewController *list;
        if (i == 0) {
            DBUserDetailItemOneViewController *vc = [[DBUserDetailItemOneViewController alloc] init];
            list = vc;
            self.currentVC = vc;
        }
        else
        {
            DBUserDetailTwoViewController *vc = [[DBUserDetailTwoViewController alloc] init];
            list = vc;
        }
        list.viewHeight = self.horScrollView.height;
        list.offsetBlock = ^(CGFloat offset) {
            AULog(@"offfff ----- %f", offset);
            weakSelf.backgroundView.offset = offset;
            CGFloat headerViewHeight = kMainBoundsWidth * 3 / 4;
            CGFloat bottomViewHeight = 50;
            CGFloat navHeight = KTC_TOP_MARGIN + 44;
            if (-offset < headerViewHeight && -offset < bottomViewHeight + navHeight)
            {
            }
            else if(offset <- headerViewHeight - bottomViewHeight)
            {}
            else
            {
                for (UIView *view in weakSelf.horScrollView.subviews) {
                    if ([[Helper getCurrentViewControllerByView:view] isKindOfClass:[DBUserDetailTwoViewController class]]) {
                        DBUserDetailTwoViewController *vc = (DBUserDetailTwoViewController *)[Helper getCurrentViewControllerByView:view];
                        if (vc != weakSelf.currentVC) {
                            vc.pointY = offset;
                        }
                    }
                }
            }
            
//            CGFloat headerViewHeight = kMainBoundsWidth * 3 / 4;
//            CGFloat bottomViewHeight = 50;
//            CGFloat navHeight = KTC_TOP_MARGIN + 44;
//            if (-offset < headerViewHeight && -offset < bottomViewHeight)
//            {
//                //上面的划出屏幕 上面的固定
//                self.backgroundView.height = 0;
//                self.bottomView.y = self.headView.bottom;
//                self.frame = kRect(0, navHeight, kMainBoundsWidth, self.bottomView.bottom);
//            }
//            else if(offset <- headerViewHeight - bottomViewHeight)
//            {
//                //往下拉
//                CGFloat newOfferset = -(offset + headerViewHeight + bottomViewHeight);
//                self.headView.frame = kRect(0, 0 + newOfferset, self.headView.width, headerViewHeight);
//                self.bottomView.frame = kRect(0, self.headView.bottom, self.headView.width, bottomViewHeight);
//                self.frame = kRect(0, navHeight, kMainBoundsWidth, self.bottomView.bottom + newOfferset);
//            }
//            else
//            {
//                CGFloat newOfferset = -(offset + headerViewHeight + bottomViewHeight);
//                self.headView.frame = kRect(0, 0, self.headView.width, headerViewHeight + newOfferset);
//                self.bottomView.frame = kRect(0, self.headView.bottom, self.headView.width, bottomViewHeight);
//                self.frame = kRect(0, navHeight, kMainBoundsWidth, self.bottomView.bottom);
//            }
        };
        list.contentInset = UIEdgeInsetsMake(self.backgroundView.height, 0, 0, 0);
        list.view.frame = kRect(i * self.horScrollView.width, 0, self.horScrollView.width, self.horScrollView.height);
        [self.horScrollView addSubview:list.view];
        [self addChildViewController:list];
    }
    [self.horScrollView setContentSize:kSize(kMainBoundsWidth * 5, 0)];
}

#pragma mark - getter
- (DBUserDetailBackgroundView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = ({
            DBUserDetailBackgroundView *view = [[DBUserDetailBackgroundView alloc] initWithFrame:kRect(0, 0, kMainBoundsWidth, kMainBoundsWidth * 3 / 4 + 50)];
            view;
        });
    }
    return _backgroundView;
}

- (UIScrollView *)horScrollView
{
    if (!_horScrollView) {
        _horScrollView = ({
            UIScrollView *view = [[UIScrollView alloc] initWithFrame:kRect(0, 0, kMainBoundsWidth, kMainBoundsHeight)];
            view.pagingEnabled = YES;
            view;
        });
    }
    return _horScrollView;
}

@end
