//
//  AUNavigationBar.h
//  auction
//
//  Created by 谭淇 on 2017/7/11.
//  Copyright © 2017年 auction. All rights reserved.
//  通用导航栏(baseViewController页面)

#import <UIKit/UIKit.h>

@protocol AUNavigationBarDelegate;

@interface AUNavigationBar : UIView

+ (instancetype)navigationBar;

@property (weak, nonatomic) id <AUNavigationBarDelegate> delegate;

/// setter
@property(copy, nonatomic) NSString *title;
@property(copy, nonatomic) NSString *backItemTitle;
@property(copy, nonatomic) NSArray<UIView *> *leftBarItems;
@property(copy, nonatomic) NSArray<UIView *> *rightBarItems;

/// readonly
@property (weak, nonatomic, readonly) UILabel *titleLabel;
@property (weak, nonatomic, readonly) UIView *statusBarView;
@property (weak, nonatomic, readonly) UIView *navigationBarView;
@property (weak, nonatomic, readonly) UIButton *backButton; // 默认如果是跟控制器，隐藏返回按钮
@property (weak, nonatomic, readonly) UIView *bottomLineView; // 底部一根线

// 改变之后，获取navigationBarHeight高度来重置frame
- (void)showAll;
- (void)showHalf;
- (void)showNone;
// 调用以上方法重置导航栏后，可获取剩余可布局内容frame
@property (assign, nonatomic, readonly) CGRect contentViewFrame;
// 调用以上方法重置导航栏后，可获取导航栏的height
@property (assign, nonatomic, readonly) CGFloat navigationBarHeight;

// 刷新现有导航栏皮肤
- (void)refreshNavigationSkin;

@end

@protocol AUNavigationBarDelegate <NSObject>

- (void)navigationBarDidClickBack:(AUNavigationBar *)navigationBar;

@end
