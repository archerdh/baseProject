//
//  AUNavigationBar.m
//  auction
//
//  Created by 谭淇 on 2017/7/11.
//  Copyright © 2017年 auction. All rights reserved.
//

#import "AUNavigationBar.h"

@interface AUNavigationBar ()

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UIView *statusBarView;
@property (weak, nonatomic) UIView *navigationBarView;
@property (weak, nonatomic) UIButton *backButton;
@property (weak, nonatomic) UIImageView *backgroundSkinView;
@property (weak, nonatomic) UIView *bottomLineView;

@end

@implementation AUNavigationBar
{
    CGFloat _currentHeight;
}


+ (instancetype)navigationBar
{
    CGFloat W = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    AUNavigationBar *bar = [[AUNavigationBar alloc] initWithFrame:CGRectMake(0, 0, W, 64)];
    
    [bar setupSubViews];
    return bar;
}

- (UIImageView *)backgroundSkinView
{
    if (_backgroundSkinView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.navigationBarView addSubview:imageView];
        _backgroundSkinView = imageView;
    }
    return _backgroundSkinView;
}

#pragma mark - public method

- (CGFloat)navigationBarHeight
{
    return _currentHeight;
}
- (void)showAll
{
    _currentHeight = 64;
    self.statusBarView.transform = CGAffineTransformIdentity;
    self.navigationBarView.transform = CGAffineTransformIdentity;
}
- (void)showHalf
{
    _currentHeight = 20;
    self.statusBarView.transform = CGAffineTransformIdentity;
    self.navigationBarView.transform = CGAffineTransformMakeTranslation(0, -44);
}
- (void)showNone
{
    _currentHeight = 0;
    self.statusBarView.transform = CGAffineTransformMakeTranslation(0, -64);
    self.navigationBarView.transform = CGAffineTransformMakeTranslation(0, -64);
}
- (CGRect)contentViewFrame
{
    CGFloat W = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    CGFloat H = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    return CGRectMake(0, _currentHeight, W, H - _currentHeight);
}

#pragma mark - private method

- (void)setupSubViews
{
    _currentHeight = 64;
    self.clipsToBounds = YES;
    
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.bounds.size.width, self.bounds.size.height - 20)];
    navigationView.backgroundColor = [UIColor colorWithRed:((float)(0xf6))/255.0 green:((float)(0xf6))/255.0 blue:((float)(0xf6))/255.0 alpha:1.0];
    self.navigationBarView = navigationView;
    [self addSubview:navigationView];
    
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
    statusView.backgroundColor = [UIColor colorWithRed:((float)(0xf6))/255.0 green:((float)(0xf6))/255.0 blue:((float)(0xf6))/255.0 alpha:1.0];
    self.statusBarView = statusView;
    [self addSubview:statusView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(3 * KTC_SCREEN_RATION, 0, 44, 44);
    backButton.exclusiveTouch = YES;
    backButton.titleLabel.font = KFont(15, UIFontWeightRegular);
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton setImage:[[UIImage imageNamed:@"common_back_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView addSubview:backButton];
    self.backButton = backButton;
    [self setBackItemTitle:@"返回"];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.navigationBarView.frame)-0.5, CGRectGetWidth(self.navigationBarView.frame), 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:((float)(0xb3))/255.0 green:((float)(0xb3))/255.0 blue:((float)(0xb3))/255.0 alpha:1.0];
    [self.navigationBarView addSubview:lineView];
    self.bottomLineView = lineView;
    
    // 如果需要展示皮肤
//    self.backgroundSkinView.frame = self.navigationBarView.bounds;
//    [self.backgroundSkinView sd_setImageWithURL:[NSURL URLWithString:[TBObjectCoding tb_navigationSkin]]];
    
    // 创建一个不穿透的响应
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDoNothing)];
    [self addGestureRecognizer:tapG];
}

// 刷新现有导航栏皮肤
- (void)refreshNavigationSkin
{
    // 如果需要展示皮肤
//    self.backgroundSkinView.frame = self.navigationBarView.bounds;
//    [self.backgroundSkinView sd_setImageWithURL:[NSURL URLWithString:[TBObjectCoding tb_navigationSkin]]];
}

// setter
- (void)setTitle:(NSString *)title
{
    _title = title;
    if (self.title && self.title.length > 0) {
        self.titleLabel.text = title;
        [self layoutTitleLabel];
    }
}
- (void)setBackItemTitle:(NSString *)backItemTitle
{
    _backItemTitle = backItemTitle;
    
    if (backItemTitle && backItemTitle.length > 0) {
        [self.backButton setTitle:[NSString stringWithFormat:@"%@  ", backItemTitle] forState:UIControlStateNormal];
        [self.backButton sizeToFit];
        self.backButton.x = 16 * KTC_SCREEN_RATION - 5;
        self.backButton.height = 44;
        self.backButton.centerY = CGRectGetHeight(self.navigationBarView.frame) * 0.5;
    } else {
        [self.backButton setTitle:@"" forState:UIControlStateNormal];
        self.backButton.frame = CGRectMake(3 * KTC_SCREEN_RATION, 0, 44, 44);
    }
    [self layoutTitleLabel];
}
- (void)setLeftBarItems:(NSArray<UIView *> *)leftBarItems
{
    for (UIView *view in _leftBarItems) {
        [view removeFromSuperview];
    }
    
    _leftBarItems = leftBarItems;
    CGFloat x = 0.0,y = 0.0,w = 0.0,h = 30.0;
    CGFloat left = 16 * KTC_SCREEN_RATION;
    CGFloat margin = 8 * KTC_SCREEN_RATION;
    for (int i = 0; i < leftBarItems.count; i++) {
        UIView *leftView = leftBarItems[i];
        CGSize viewSize = leftView.frame.size;
        if (CGSizeEqualToSize(CGSizeZero, viewSize)) {
            w = h;
        } else {
            w = viewSize.width;
            h = viewSize.height;
        }
        x = left + (i == 0 ? 0 : margin);
        y = (self.navigationBarView.bounds.size.height - h) * 0.5;
        
        leftView.frame = CGRectMake(x, y, w, h);
        [self.navigationBarView addSubview:leftView];
        
        left = CGRectGetMaxX(leftView.frame);
    }
    
    if (!self.backButton.isHidden && leftBarItems.count > 0) {
        self.backButton.hidden = YES;
    }
    
    [self layoutTitleLabel];
}

- (void)setRightBarItems:(NSArray<UIView *> *)rightBarItems
{
    for (UIView *view in _rightBarItems) {
        [view removeFromSuperview];
    }
    
    _rightBarItems = rightBarItems;
    CGFloat x = 0.0,y = 0.0,w = 0.0,h = 30.0;
    CGFloat right = 16 * KTC_SCREEN_RATION;
    CGFloat margin = 8 * KTC_SCREEN_RATION;
    for (int i = 0; i < rightBarItems.count; i++) {
        UIView *rightView = rightBarItems[i];
        CGSize viewSize = rightView.frame.size;
        if (CGSizeEqualToSize(CGSizeZero, viewSize)) {
            w = h;
        } else {
            w = viewSize.width;
            h = viewSize.height;
        }
        x = self.navigationBarView.bounds.size.width - (right + w + (i == 0 ? 0 : margin));
        y = (self.navigationBarView.bounds.size.height - h) * 0.5;
        
        rightView.frame = CGRectMake(x, y, w, h);
        [self.navigationBarView addSubview:rightView];
        
        right = self.navigationBarView.bounds.size.width - CGRectGetMinX(rightView.frame);
    }
    
    [self layoutTitleLabel];
}

// getter
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.font = KFont(17, UIFontWeightRegular);
        [self.navigationBarView addSubview:label];
        _titleLabel = label;
    }
    return _titleLabel;
}

// actions
- (void)backClick:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigationBarDidClickBack:)]) {
        [self.delegate navigationBarDidClickBack:self];
    }
}

- (void)layoutTitleLabel
{
    if (_titleLabel != nil) {
        CGFloat barW = CGRectGetWidth(self.navigationBarView.frame);
        CGFloat h = 20 * KTC_SCREEN_RATION;
        CGFloat y = (CGRectGetHeight(self.navigationBarView.frame) - h) * 0.5;
        CGRect titleframe = CGRectMake(16 * KTC_SCREEN_RATION, y, barW - 32 * KTC_SCREEN_RATION, h);
        if (!self.backButton.isHidden) {
            titleframe.origin.x = CGRectGetMaxX(self.backButton.frame);
            titleframe.size.width = barW - titleframe.origin.x * 2;
        } else if (self.leftBarItems.count > 0) {
            titleframe.origin.x = CGRectGetMaxX(self.leftBarItems.lastObject.frame) + 5 * KTC_SCREEN_RATION;
            titleframe.size.width = barW - titleframe.origin.x * 2;
        }
        if (self.rightBarItems.count > 0) {
            CGFloat right = (barW - CGRectGetMinX(self.rightBarItems.lastObject.frame)) - 5 * KTC_SCREEN_RATION;
            CGFloat left = titleframe.origin.x;
            if (left >= right) {
                titleframe.size.width = barW - left * 2;
            } else {
                titleframe.origin.x = right;
                titleframe.size.width = barW - right * 2;
            }
        }
        self.titleLabel.frame = titleframe;
    }
}

// do nothing..
- (void)tapDoNothing {}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}

@end
