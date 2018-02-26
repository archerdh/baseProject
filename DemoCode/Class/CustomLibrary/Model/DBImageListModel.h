//
//  DBImageListModel.h
//  DemoCode
//
//  Created by zheng zhang on 2018/2/26.
//  Copyright © 2018年 auction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef NS_ENUM(NSUInteger, DBAssetMediaType) {
    DBAssetMediaTypeImage,
    DBAssetMediaTypeGif,
    DBAssetMediaTypeLivePhoto,
    DBAssetMediaTypeVideo,
};

@interface DBImageModel : NSObject

//asset对象
@property (nonatomic, strong) PHAsset *asset;
//是否被选择
@property (nonatomic, assign, getter=isSelected) BOOL selected;

@property (nonatomic, assign) DBAssetMediaType mediaType;


@end

@interface DBImageListModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger count;

//你访问结果中的内容可以像使用NSArray类的方法获取内容一样来获取PHFetchResult中的内容。与NSArray对象不同的是，一个PHFetchResult对象中的内容是动态加载的，如果你需要一些内容它才会去照片库中去获取对应的内容，这可以在处理大量的结果的时候提供一个最佳的性能。
@property (nonatomic, strong) PHFetchResult *result;

//相册第一张图asset对象，用于封面
@property (nonatomic, strong) PHAsset *headImageAsset;

@property (nonatomic, strong) NSArray *selectedModels;

@property (nonatomic, strong) NSArray<DBImageModel *> *models;

@end
