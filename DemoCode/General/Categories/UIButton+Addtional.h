//
//  UIButton+Addtional.h
//  PublicProject
//
//  Created by user on 15/8/26.
//  Copyright (c) 2015年 archer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Addtional)
+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor;

+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor;

+ (instancetype)buttonWithTitleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor;

+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor;

+ (instancetype)buttonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor;

+ (instancetype)buttonWithType:(UIButtonType)buttonType frame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor;
@end
