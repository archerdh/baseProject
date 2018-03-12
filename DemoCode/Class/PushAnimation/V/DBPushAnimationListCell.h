//
//  DBPushAnimationListCell.h
//  DemoCode
//
//  Created by zheng zhang on 2018/3/12.
//  Copyright © 2018年 auction. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DBPushAnimationModel;
@interface DBPushAnimationListCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) DBPushAnimationModel *model;

@end
