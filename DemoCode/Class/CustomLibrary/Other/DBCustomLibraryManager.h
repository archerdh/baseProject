//
//  DBCustomLibraryManager.h
//  DemoCode
//
//  Created by zheng zhang on 2018/2/28.
//  Copyright © 2018年 auction. All rights reserved.
//  相册管理器

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@class DBLibraryConfig, DBImageListModel;

@interface DBCustomLibraryManager : NSObject

/**
 * @brief 获取相机胶卷相册列表对象
 */
+ (DBImageListModel *)getCameraRollAlbumList:(DBLibraryConfig *)config;

/**
 block 获取相机胶卷相册列表对象
 */
+ (void)getCameraRollAlbumList:(DBLibraryConfig *)config complete:(void (^)(DBImageListModel *album))complete;

/**
 * @brief 获取用户所有相册列表
 */
+ (void)getPhotoAblumList:(DBLibraryConfig *)config complete:(void (^)(NSArray<DBImageListModel *> *))complete;

#pragma mark - 相册、相机、麦克风权限相关
/**
 是否有相册访问权限
 */
+ (BOOL)havePhotoLibraryAuthority;

/**
 是否有相机访问权限
 */
+ (BOOL)haveCameraAuthority;

/**
 是否有麦克风访问权限
 */
+ (BOOL)haveMicrophoneAuthority;

@end
