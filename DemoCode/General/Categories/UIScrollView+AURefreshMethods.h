//
//  UIScrollView+AURefreshMethods.h
//  auction
//
//  Created by zheng zhang on 2017/8/1.
//  Copyright © 2017年 auction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface UIScrollView (AURefreshMethods)

/**
 *  添加下拉刷新
 *
 *  @param target   动作对象
 *  @param selector 动作方法
 *
 *  @return 下拉刷新控件
 */
- (MJRefreshNormalHeader *)addHeaderRefreshMethodWithTarget:(id)target action:(SEL)selector;
/**
 *  添加下拉刷新
 *
 *  @param refreshingBlock 下拉刷新回调
 *
 *  @return 下拉刷新控件
 */
- (MJRefreshNormalHeader *)addHeaderRefreshMethodWithCallback:(MJRefreshComponentRefreshingBlock)refreshingBlock;

/**
 *  添加上拉加载
 *
 *  @param target   动作对象
 *  @param selector 动作方法
 *      注：如果发现上拉隐藏起来了，可以试试self.tableView.mj_footer.automaticallyHidden = NO;覆盖
 *  @return 上拉加载控件
 */
- (MJRefreshAutoNormalFooter *)addFooterRefreshMethodWithTarget:(id)target action:(SEL)selector;
/**
 *  添加上拉加载
 *
 *  @param refreshingBlock 上拉加载回调
 *      注：如果发现上拉隐藏起来了，可以试试self.tableView.mj_footer.automaticallyHidden = NO;覆盖
 *  @return 上拉加载控件
 */
- (MJRefreshAutoNormalFooter *)addFooterRefreshMethodWithCallback:(MJRefreshComponentRefreshingBlock)refreshingBlock;

@end
