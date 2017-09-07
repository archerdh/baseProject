//
//  BaseLineView.m
//  TCGroupLeader
//
//  Created by user on 15/5/18.
//  Copyright (c) 2015年 www.tuanche.com. All rights reserved.
//

#import "BaseLineView.h"

@implementation BaseLineView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    if(!self.lineColor)
    {
        self.lineColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0];
    }
    // Drawing code
    //底部画一条线
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineWidth(context, 0.5);
    CGContextMoveToPoint(context, 0, rect.size.height-0.25);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height-0.25);
    CGContextStrokePath(context);
}

@end
