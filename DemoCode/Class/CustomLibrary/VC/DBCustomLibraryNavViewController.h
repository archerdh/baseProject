//
//  DBCustomLibraryNavViewController.h
//  DemoCode
//
//  Created by zheng zhang on 2018/2/27.
//  Copyright © 2018年 auction. All rights reserved.
//  自定义相册框架nav

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@class DBImageModel;
@interface DBCustomLibraryNavViewController : BaseNavigationController

/**
 是否选择了原图
 */
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;

@property (nonatomic, copy) NSMutableArray<DBImageModel *> *arrSelectedModels;


@end
