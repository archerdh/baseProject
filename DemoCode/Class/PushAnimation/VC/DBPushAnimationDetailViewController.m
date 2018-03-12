//
//  DBPushAnimationDetailViewController.m
//  DemoCode
//
//  Created by zheng zhang on 2018/3/12.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBPushAnimationDetailViewController.h"
//M
#import "DBPushAnimationModel.h"
#import "NSString+DBSizeForString.h"

//V
#import "UIImageView+WebCache.h"

@interface DBPushAnimationDetailViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *backScrollView;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) DBPushAnimationModel *model;

@end

@implementation DBPushAnimationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithModel:(DBPushAnimationModel *)model desImageViewRect:(CGRect)desRect
{
    if (self = [super init]) {
        self.headImageView.frame = desRect;
        self.model = model;
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    [self.view addSubview:self.backScrollView];
    [self.backScrollView addSubview:self.iconImageView];
    [self.backScrollView addSubview:self.nameLabel];
    [self.backScrollView addSubview:self.headImageView];
    [self.backScrollView addSubview:self.detailLabel];
    
    self.detailLabel.text = self.model.des;
    self.nameLabel.text = self.model.name;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.icon]];
    
    self.headImageView.height = self.view.width * (self.model.h.doubleValue / self.model.w.doubleValue);
    self.detailLabel.y = self.headImageView.bottom + 10;
    
    CGSize detailSize = [self.detailLabel.text sizeWithFont:self.detailLabel.font MaxSize:kSize(self.view.width - 20, MAXFLOAT)];
    self.detailLabel.size = detailSize;
    
    [self.backScrollView setContentSize:kSize(kMainBoundsWidth, self.detailLabel.bottom + 10)];
}

#pragma mark - 转场动画
- (void)didFinishTransition
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.model.img]];
}

#pragma mark - action
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter
- (UIScrollView *)backScrollView
{
    if (!_backScrollView) {
        _backScrollView = ({
            UIScrollView *view = [[UIScrollView alloc] initWithFrame:self.view.bounds];
            view.delegate = self;
            view;
        });
    }
    return _backScrollView;
}

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:kRect(0, self.iconImageView.bottom + 10, self.view.width, 0)];
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
        UIImageView *view = [[UIImageView alloc] initWithFrame:kRect(10, KTC_TOP_MARGIN, 30, 30)];
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
