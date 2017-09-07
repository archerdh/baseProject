//
//  BaseDoubleLineView.m
//  TCGroupLeader
//
//  Created by user on 15/5/20.
//  Copyright (c) 2015年 www.tuanche.com. All rights reserved.
//

#import "BaseDoubleLineView.h"

@implementation BaseDoubleLineView
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    // Drawing code
    //顶部画一条线
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineWidth(context, 0.5);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, rect.size.width, 0);
    CGContextStrokePath(context);
}
@end
