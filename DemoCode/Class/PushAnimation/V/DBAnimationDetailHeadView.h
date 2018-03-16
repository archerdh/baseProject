//
//  DBAnimationDetailHeadView.h
//  DemoCode
//
//  Created by zheng zhang on 2018/3/16.
//  Copyright © 2018年 auction. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DBPushAnimationModel;

typedef void(^DBAnimationDetailHeadViewBlock)();

@interface DBAnimationDetailHeadView : UICollectionReusableView

@property (copy, nonatomic) DBAnimationDetailHeadViewBlock backBlock;
@property (strong, nonatomic) DBPushAnimationModel *model;

@end
