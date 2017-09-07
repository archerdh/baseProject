//
//  BaseLineButton.m
//  tuancheclient
//
//  Created by kongxc on 15/6/29.
//  Copyright (c) 2015年 tuanche. All rights reserved.
//

#import "BaseLineButton.h"

@implementation BaseLineButton

- (void)drawRect:(CGRect)rect {
    
    // Drawing code
    [super drawRect:rect];
    if(!self.lineColor)
    {
        self.lineColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];
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
