//
//  DBUserDetailOneCell.m
//  DemoCode
//
//  Created by zheng zhang on 2018/3/14.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBUserDetailOneCell.h"

@interface DBUserDetailOneCell ()

@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UILabel *nameLabel;


@end

@implementation DBUserDetailOneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.backView];
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.nameLabel];
        self.contentView.backgroundColor = kDefaultBackgroundColor;
    }
    return self;
}

#pragma mark - getter
- (UIView *)backView
{
    if (!_backView) {
        _backView = ({
            UIView *view = [[UIView alloc] initWithFrame:kRect(0, 0, kMainBoundsWidth, (kMainBoundsWidth - 30) * 3 / 4 + 35 + 21)];
            view.backgroundColor = UIColorFromRGB(0xffffff);
            view;
        });
    }
    return _backView;
}

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = ({
            UIImageView *view = [[UIImageView alloc] initWithFrame:kRect(15, 10, (kMainBoundsWidth - 30), (kMainBoundsWidth - 30) * 3 / 4)];
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
            UILabel *label = [[UILabel alloc] initWithFrame:kRect(self.headImageView.x, self.headImageView.bottom + 10, self.headImageView.width, 21)];
            label.text = @"2017最大的看点在这里，维密狂欢之夜";
            label.font = KFont(15, UIFontWeightRegular);
            label.textColor = UIColorFromRGB(0x000000);
            label;
        });
    }
    return _nameLabel;
}

@end
