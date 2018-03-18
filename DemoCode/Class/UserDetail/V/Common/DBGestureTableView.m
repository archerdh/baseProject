//
//  DBGestureTableView.m
//  DemoCode
//
//  Created by zhangzheng on 2018/3/18.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBGestureTableView.h"

@implementation DBGestureTableView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    if (self.tableHeaderView && CGRectContainsPoint(self.tableHeaderView.frame, point)) {
//        return NO;
//    }
    return [super pointInside:point withEvent:event];
}

/// 是否支持多手势触发，返回YES，则可以多个手势一起触发方法，返回NO则为互斥
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
