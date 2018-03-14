//
//  DBUserDetailBackgroundView.m
//  DemoCode
//
//  Created by zheng zhang on 2018/3/14.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBUserDetailBackgroundView.h"
#import "DBUserDetailTwoViewController.h"
#import "DBUserDetailItemOneViewController.h"

@interface DBUserDetailBackgroundView ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *horScrollView;

@end


@implementation DBUserDetailBackgroundView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.horScrollView];
    }
    return self;
}

#pragma mark - getter
- (UIScrollView *)horScrollView
{
    if (!_horScrollView) {
        _horScrollView = ({
            UIScrollView *view = [[UIScrollView alloc] initWithFrame:self.bounds];
            view.pagingEnabled = YES;
            view;
        });
    }
    return _horScrollView;
}

@end
