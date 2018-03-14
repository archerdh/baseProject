//
//  DBUserDetailBaseListViewController.h
//  DemoCode
//
//  Created by zheng zhang on 2018/3/14.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^DBUserDetailBaseListViewControllerBlock)(CGFloat offset);

@interface DBUserDetailBaseListViewController : BaseViewController

@property (assign, nonatomic) UIEdgeInsets contentInset;
@property (assign, nonatomic) CGFloat viewHeight;
@property (copy, nonatomic) DBUserDetailBaseListViewControllerBlock offsetBlock;

@end
