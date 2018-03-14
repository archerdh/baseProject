//
//  DBUserDetailTwoCell.m
//  DemoCode
//
//  Created by zheng zhang on 2018/3/14.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBUserDetailTwoCell.h"

@interface DBUserDetailTwoCell()

@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *moneyLabel;

@end

@implementation DBUserDetailTwoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.headImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.moneyLabel];
    }
    return self;
}

#pragma mark - getter
- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = ({
            UIImageView *view = [[UIImageView alloc] initWithFrame:kRect(0, 0, kMainBoundsWidth / 2, kMainBoundsWidth / 2 / 4 * 3)];
            view.backgroundColor = RGB_RANDOM_COLOR;
            view;
        });
    }
    return _headImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:kRect(15, self.headImageView.bottom + 8, self.headImageView.width - 30, 38)];
            label.text = @"EVER UGG 漆皮几何时尚新款皮鞋";
            label.font = KFont(15, UIFontWeightRegular);
            label.numberOfLines = 2;
            label.textColor = UIColorFromRGB(0x000000);
            label;
        });
    }
    return _nameLabel;
}

- (UILabel *)moneyLabel
{
    if (!_moneyLabel) {
        _moneyLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:kRect(self.nameLabel.x, self.nameLabel.bottom + 5, self.nameLabel.width, 24)];
            label.text = @"￥123.45";
            label.font = KFont(17, UIFontWeightSemibold);
            label.textColor = UIColorFromRGB(0x000000);
            label;
        });
    }
    return _moneyLabel;
}

@end
