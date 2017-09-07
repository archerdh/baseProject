//
//  UIScrollView+AURefreshMethods.m
//  auction
//
//  Created by zheng zhang on 2017/8/1.
//  Copyright © 2017年 auction. All rights reserved.
//

#import "UIScrollView+AURefreshMethods.h"

@implementation UIScrollView (AURefreshMethods)


// MARK: 下拉刷新
- (MJRefreshNormalHeader *)addHeaderRefreshMethodWithTarget:(id)target action:(SEL)selector
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:selector];
    header.arrowNotRotate = YES;
    header.stateLabel.hidden = YES;
    header.loadingView.color = UIColorFromRGB(0xeb1010);
    header.lastUpdatedTimeLabel.hidden = YES;
    header.arrowView.image = [UIImage imageNamed:@"home_logo"];
    self.mj_header = header;
    return header;
}
- (MJRefreshNormalHeader *)addHeaderRefreshMethodWithCallback:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshingBlock];
    header.arrowNotRotate = YES;
    header.stateLabel.hidden = YES;
    header.loadingView.color = UIColorFromRGB(0xeb1010);
    header.lastUpdatedTimeLabel.hidden = YES;
    header.arrowView.image = [UIImage imageNamed:@"home_logo"];
    self.mj_header = header;
    return header;
}


// MARK: 上拉加载
- (MJRefreshAutoNormalFooter *)addFooterRefreshMethodWithTarget:(id)target action:(SEL)selector;
{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target refreshingAction:selector];
    footer.automaticallyHidden = YES;
    footer.triggerAutomaticallyRefreshPercent = 0.5;
    footer.loadingView.color = UIColorFromRGB(0xeb1010);
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    self.mj_footer = footer;
    return footer;
}

- (MJRefreshAutoNormalFooter *)addFooterRefreshMethodWithCallback:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:refreshingBlock];
    footer.automaticallyHidden = YES;
    footer.triggerAutomaticallyRefreshPercent = 0.5;
    footer.loadingView.color = UIColorFromRGB(0xeb1010);
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    self.mj_footer = footer;
    return footer;
}


@end
