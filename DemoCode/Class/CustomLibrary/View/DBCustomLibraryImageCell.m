//
//  DBCustomLibraryImageCell.m
//  DemoCode
//
//  Created by zheng zhang on 2018/2/26.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBCustomLibraryImageCell.h"
//V
#import "UIButton+DBEnlargeTouchArea.h"
//M
#import "DBImageListModel.h"

@interface DBCustomLibraryImageCell ()

@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) UIButton *seletedBtn;
@property (strong, nonatomic) UIImageView *bottomImageView;
@property (strong, nonatomic) UIImageView *VideoImageView;
@property (strong, nonatomic) UIImageView *LiveImageView;
@property (strong, nonatomic) UILabel *bottomStatusLabel;

@end

@implementation DBCustomLibraryImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.backImageView];
        [self addSubview:self.bottomImageView];
        [self.bottomImageView addSubview:self.VideoImageView];
        [self.bottomImageView addSubview:self.LiveImageView];
        [self.bottomImageView addSubview:self.bottomStatusLabel];
        [self addSubview:self.seletedBtn];
    }
    return self;
}

- (void)setModel:(DBImageModel *)model
{
    _model = model;
    
}

#pragma mark - Action
- (void)btnSelectClick:(UIButton *)btn
{
    
}

#pragma mark - Getter
- (UIImageView *)backImageView
{
    if (!_backImageView) {
        _backImageView = ({
            UIImageView *view = [[UIImageView alloc] initWithFrame:self.bounds];
            view.clipsToBounds = YES;
            view.contentMode = UIViewContentModeScaleAspectFill;
            view;
        });
    }
    return _backImageView;
}

- (UIImageView *)bottomImageView
{
    if (!_bottomImageView) {
        _bottomImageView = ({
            UIImageView *view = [[UIImageView alloc] initWithFrame:kRect(0, self.height - 15, self.width, 15)];
            view.image = [UIImage imageNamed:@"videoView"];
            view;
        });
    }
    return _bottomImageView;
}

- (UILabel *)bottomStatusLabel
{
    if (!_bottomStatusLabel) {
        _bottomStatusLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:kRect(30, 1, self.width - 35, 12)];
            label.textAlignment = NSTextAlignmentRight;
        });
    }
}

- (UIButton *)seletedBtn
{
    if (!_seletedBtn) {
        _seletedBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = kRect(self.contentView.width - 26, 5, 23, 23);
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_unselected"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_selected"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnSelectClick:) forControlEvents:UIControlEventTouchUpInside];
            //扩大点击区域
            [btn setEnlargeEdgeWithTop:0 right:0 bottom:20 left:20];
            btn;
        });
    }
    return _seletedBtn;
}

@end
