//
//  DBPushAnimationDetailViewController.h
//  DemoCode
//
//  Created by zheng zhang on 2018/3/12.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "BaseViewController.h"
#import "DBNavAnimationManager.h"
@class DBPushAnimationModel;
@interface DBPushAnimationDetailViewController : BaseViewController<DBNavAnimationManagerDelegate>

- (instancetype)initWithModel:(DBPushAnimationModel *)model desImageViewRect:(CGRect)desRect;

@end
