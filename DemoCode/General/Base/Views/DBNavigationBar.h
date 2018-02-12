//
//  DBNavigationBar.h
//  DemoCode
//
//  Created by zheng zhang on 2018/2/9.
//  Copyright © 2018年 auction. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DBNavigationBarDelegate;

@interface DBNavigationBar : UIView

+ (instancetype)navigationBar;

@property (weak, nonatomic) id <DBNavigationBarDelegate> delegate;

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
@property (nonatomic,assign) CGFloat bgAlpha;

// 改变之后，获取navigationBarHeight高度来重置frame
- (void)showAll;
- (void)showHalf;
- (void)showNone;
// 调用以上方法重置导航栏后，可获取剩余可布局内容frame
@property (assign, nonatomic, readonly) CGRect contentViewFrame;
// 调用以上方法重置导航栏后，可获取导航栏的height
@property (assign, nonatomic, readonly) CGFloat navigationBarHeight;
// 获取iPhone X底部不可编辑区域高度
@property (assign, nonatomic, readonly) CGFloat bottomMarginHeight;

// 刷新现有导航栏皮肤
- (void)refreshNavigationSkin;

@end


@protocol DBNavigationBarDelegate <NSObject>

- (void)navigationBarDidClickBack:(DBNavigationBar *)navigationBar;

@end
