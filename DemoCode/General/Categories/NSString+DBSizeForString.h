//
//  NSString+DBSizeForString.h
//  DemoCode
//
//  Created by zheng zhang on 2018/3/12.
//  Copyright © 2018年 auction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface NSString (DBSizeForString)

/** 对象方法
 * 计算文本占用的宽高
 * @param font      字体
 * @param maxSize   最大的显示范围
 *
 * @return          label占用的宽高
 */

- (CGSize)sizeWithFont:(UIFont *)font MaxSize:(CGSize)maxSize;

/** 类方法
 * 计算文本占用的宽高
 * @param text      文本
 * @param font      字体
 * @param maxSize   最大的显示范围
 *
 * @return          label占用的宽高
 */
+ (CGSize)sizeWithText:(NSString *)text Font:(UIFont *)font MaxSize:(CGSize)maxSize;

/** 类方法
 * 计算文本占用的宽高
 * @param text      文本
 * @param font      字体
 * @param maxSize   最大的显示范围
 * @param lineBreak 换行方式
 * @param align     对齐方式
 *
 * @return          label占用的宽高
 */
+ (CGSize)sizeWithText:(NSString *)text Font:(UIFont *)font MaxSize:(CGSize)maxSize lineBreak:(NSLineBreakMode)lineBreak align:(NSTextAlignment)align;

/** 类方法
 * 计算字符串字符长度
 * @param strtemp      字符串
 *
 * @return          字符长度
 */
+  (NSInteger)stringConvertToNum:(NSString*)strtemp;

/** 对象方法
 * 根据字符长度反向截取字符串
 * @param maxCount      字符长度
 *
 * @return          字符串
 */
- (NSString *)subStringWithMaxCount:(NSUInteger)maxCount;

@end
