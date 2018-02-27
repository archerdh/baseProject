//
//  DBImageListModel.m
//  DemoCode
//
//  Created by zheng zhang on 2018/2/26.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBImageListModel.h"

@implementation DBImageModel

+ (instancetype)modelWithAsset:(PHAsset *)asset type:(DBAssetMediaType)type duration:(NSString *)duration
{
    DBImageModel *model = [[DBImageModel alloc] init];
    model.asset = asset;
    model.mediaType = type;
//    model.duration = duration;
    model.selected = NO;
    return model;
}

@end

@implementation DBImageListModel

@end
