//
//  NSString+DBSizeForString.m
//  DemoCode
//
//  Created by zheng zhang on 2018/3/12.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "NSString+DBSizeForString.h"

@implementation NSString (DBSizeForString)

- (CGSize)sizeWithFont:(UIFont *)font MaxSize:(CGSize)maxSize
{
    return [[self class] sizeWithText:self Font:font MaxSize:maxSize];
}

+ (CGSize)sizeWithText:(NSString *)text Font:(UIFont *)font MaxSize:(CGSize)maxSize
{
    return [self sizeWithText:text Font:font MaxSize:maxSize lineBreak:NSLineBreakByWordWrapping align:NSTextAlignmentLeft];
}

+ (CGSize)sizeWithText:(NSString *)text Font:(UIFont *)font MaxSize:(CGSize)maxSize lineBreak:(NSLineBreakMode)lineBreak align:(NSTextAlignment)align
{
    UILabel *label = [self labelForResize];
    label.numberOfLines = 0;
    label.lineBreakMode = lineBreak;
    label.textAlignment = align;
    label.text = text;
    label.font = font;
    CGSize labelSize = [label sizeThatFits:maxSize];
    return CGSizeMake(ceil(labelSize.width) + 1, ceil(labelSize.height) + 1);
}

static UILabel *_label;
+ (UILabel *)labelForResize
{
    if (_label == nil) {
        _label = [UILabel new];
    }
    return _label;
}

+  (NSInteger)stringConvertToNum:(NSString*)strtemp {
    NSInteger strlength = 0;
    NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    char* p = (char*)[strtemp cStringUsingEncoding:gbkEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:gbkEncoding] ;i++) {
        if (p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

- (NSString *)subStringWithMaxCount:(NSUInteger)maxCount
{
    if (maxCount == 0) {
        return @"";
    }
    NSUInteger count = 0;
    NSUInteger index = 0;
    for (NSUInteger i = 0; i < self.length; i++) {
        unichar c = [self characterAtIndex:i];
        if (isascii(c)) {
            count++;
        } else {
            count += 2;
        }
        if (count == maxCount) {
            index = i + 1;
            break;
        } else if (count > maxCount) {
            index = i;
            break;
        }
    }
    if (index == 0) {
        index = self.length;
    }
    NSString *subString = [self substringToIndex:index];
    return subString;
}

@end
