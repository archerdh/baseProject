//
//  DBAnimationListLayout.h
//  DemoCode
//
//  Created by zheng zhang on 2018/3/12.
//  Copyright © 2018年 auction. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBAnimationListLayout;
@protocol DBAnimationListLayoutDelegate <NSObject>

/**
 *  item 高度代理
 *
 *  @param OJLWaterLayout layout
 *  @param indexPath      indexPath
 *
 *  @return item高度
 */
-(CGFloat)OJLWaterLayout:(DBAnimationListLayout*)OJLWaterLayout itemHeightForIndexPath:(NSIndexPath*)indexPath;

@end

@interface DBAnimationListLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id <DBAnimationListLayoutDelegate> delegate;

/**
 *  每行之间的间距
 */
@property (nonatomic, assign) CGFloat rowPanding;
/**
 *  每列之间的间距
 */
@property (nonatomic, assign) CGFloat colPanding;
/**
 *  列数
 */
@property (nonatomic, assign) NSInteger numberOfCol;
/**
 *  contentSize
 */
@property (nonatomic, assign) CGSize contentSize;
/**
 *  自动配置 contentSize
 */
@property (nonatomic, assign) UIEdgeInsets sectionInset;


@property (nonatomic, assign) CGSize headSize;


-(void)autuContentSize;

@end
