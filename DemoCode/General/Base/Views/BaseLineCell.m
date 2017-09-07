//
//  BaseLineCell.m
//  I500user
//
//  Created by user on 15/4/10.
//  Copyright (c) 2015年 archer. All rights reserved.
//

#import "BaseLineCell.h"

@implementation BaseLineCell
- (void)awakeFromNib{
    [super awakeFromNib];
    //ios7下，需要将这两个背景色更改成clearColor
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if(!self.lineColor)
    {
        self.lineColor = UIColorFromRGB(0x9D9D9D);
    }
    // Drawing code
    //底部画一条线
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineWidth(context, 0.25);
    CGContextMoveToPoint(context, 0, rect.size.height-0.25);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height-0.25);
    CGContextStrokePath(context);
}

@end
