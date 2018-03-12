//
//  DBPushAnimationListCell.m
//  DemoCode
//
//  Created by zheng zhang on 2018/3/12.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBPushAnimationListCell.h"
//M
#import "DBPushAnimationModel.h"
#import "NSString+DBSizeForString.h"
//V
#import "UIImageView+WebCache.h"
@interface DBPushAnimationListCell ()

@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *nameLabel;

@end

@implementation DBPushAnimationListCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.headImageView];
        [self addSubview:self.detailLabel];
        [self addSubview:self.iconImageView];
        [self addSubview:self.nameLabel];
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}

- (void)setModel:(DBPushAnimationModel *)model
{
    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
    self.detailLabel.text = model.des;
    self.nameLabel.text = model.name;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    
    self.headImageView.height = self.width * (model.h.doubleValue / model.w.doubleValue);
    self.detailLabel.y = self.headImageView.bottom + 10;
    
    CGSize detailSize = [self.detailLabel.text sizeWithFont:self.detailLabel.font MaxSize:kSize(self.width - 16, MAXFLOAT)];
    self.detailLabel.size = detailSize;
    
    self.iconImageView.y  = self.detailLabel.bottom + 10;
    self.nameLabel.centerY = self.iconImageView.centerY;
    
    CGSize nameSize = [self.nameLabel.text sizeWithFont:self.nameLabel.font MaxSize:kSize(MAXFLOAT, 22)];
    self.nameLabel.width = MIN(nameSize.width, self.width - 5 - self.iconImageView.right);
}

#pragma mark - getter
- (UIImageView *)headImageView
{
    if (!_headImageView) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:kRect(0, 0, self.width, 0)];
        view.contentMode = UIViewContentModeScaleToFill;
        self.headImageView = view;
    }
    return _headImageView;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:kRect(8, 0, 0, 0)];
        label.numberOfLines = 0;
        label.font = KFont(12, UIFontWeightRegular);
        label.textColor = UIColorFromRGB(0x000000);
        self.detailLabel = label;
    }
    return _detailLabel;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:kRect(5, 0, 22, 22)];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 11;
        self.iconImageView = view;
    }
    return _iconImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:kRect(self.iconImageView.right + 5, 0, 0, 22)];
        label.font = KFont(11, UIFontWeightRegular);
        label.textColor = UIColorFromRGB(0x000000);
        self.nameLabel = label;
    }
    return _nameLabel;
}

@end
