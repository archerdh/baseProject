//
//  DBAnimationDetailHeadView.m
//  DemoCode
//
//  Created by zheng zhang on 2018/3/16.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBAnimationDetailHeadView.h"

//M
#import "DBPushAnimationModel.h"
#import "NSString+DBSizeForString.h"

//V
#import "UIImageView+WebCache.h"

@interface DBAnimationDetailHeadView ()

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UILabel *detailLabel;

@end

@implementation DBAnimationDetailHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.iconImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.headImageView];
        [self addSubview:self.detailLabel];
    }
    return self;
}

- (void)setModel:(DBPushAnimationModel *)model
{
    _model = model;
    
    self.detailLabel.text = self.model.des;
    self.nameLabel.text = self.model.name;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.icon]];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.model.img]];
    self.headImageView.height = self.width * (self.model.h.doubleValue / self.model.w.doubleValue);
    self.detailLabel.y = self.headImageView.bottom + 10;
    
    CGSize detailSize = [self.detailLabel.text sizeWithFont:self.detailLabel.font MaxSize:kSize(self.width - 20, MAXFLOAT)];
    self.detailLabel.size = detailSize;
}

#pragma mark - action
- (void)backClick
{
    if (self.backBlock) {
        self.backBlock();
    }
}

#pragma mark - getter
- (UIImageView *)headImageView
{
    if (!_headImageView) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:kRect(0, self.iconImageView.bottom + 10, self.width, 0)];
        view.contentMode = UIViewContentModeScaleToFill;
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backClick)]];
        self.headImageView = view;
    }
    return _headImageView;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:kRect(8, 0, 0, 0)];
        label.numberOfLines = 0;
        label.font = KFont(13, UIFontWeightRegular);
        label.textColor = UIColorFromRGB(0x000000);
        self.detailLabel = label;
    }
    return _detailLabel;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:kRect(10, 0, 30, 30)];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 15;
        self.iconImageView = view;
    }
    return _iconImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:kRect(self.iconImageView.right + 10, 0, kMainBoundsWidth - 20 - self.iconImageView.right, 30)];
        label.font = KFont(12, UIFontWeightRegular);
        label.textColor = UIColorFromRGB(0x000000);
        label.centerY = self.iconImageView.centerY;
        self.nameLabel = label;
    }
    return _nameLabel;
}

@end
