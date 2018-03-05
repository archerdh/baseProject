//
//  DBCustomLibraryImageCell.h
//  DemoCode
//
//  Created by zheng zhang on 2018/2/26.
//  Copyright © 2018年 auction. All rights reserved.
//  相册照片itemcell

#import <UIKit/UIKit.h>
@class DBImageModel;
typedef void(^DBCustomLibraryImageCellBlock)();

@interface DBCustomLibraryImageCell : UICollectionViewCell

@property (nonatomic, copy) DBCustomLibraryImageCellBlock seleteBlock;
@property (nonatomic, strong) DBImageModel *model;
@property (strong, nonatomic) UIButton *seletedBtn;

@property (assign, nonatomic) BOOL isChoosed;   //是否被选中，用来显示视频的遮罩层


@end
