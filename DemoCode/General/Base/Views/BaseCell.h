//
//  BaseCell.h
//  I500user
//
//  Created by verne on 15/4/8.
//  Copyright (c) 2015年 archer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCell : UITableViewCell

/**
 *  用xib创建Cell
 *
 *  @return self;
 */
+(id)loadFromXib;

/**
 *  用代码创建Cell时候设置的cellIdentifier
 *
 *  @return cellIdentifier;
 */
+(NSString*)cellIdentifier;

/**
 *  用代码创建Cell
 *
 *  @return self;
 */
+(id)loadFromCellStyle:(UITableViewCellStyle)cellStyle;



@end
