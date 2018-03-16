//
//  DBUserDetailCommonCell.m
//  DemoCode
//
//  Created by zheng zhang on 2018/3/16.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBUserDetailCommonCell.h"

@interface DBUserDetailCommonCell ()

@property (strong, nonatomic) UIImageView *iconImageView;

@end

@implementation DBUserDetailCommonCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.iconImageView];
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}

#pragma mark - getter
- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:self.bounds];
        view.backgroundColor = RGB_RANDOM_COLOR;
        self.iconImageView = view;
    }
    return _iconImageView;
}

@end
