//
//  UIButton+DBEnlargeTouchArea.h
//  DemoCode
//
//  Created by zheng zhang on 2018/2/26.
//  Copyright © 2018年 auction. All rights reserved.
//  扩大点击区域方法

#import <UIKit/UIKit.h>

@interface UIButton (DBEnlargeTouchArea)

- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end
