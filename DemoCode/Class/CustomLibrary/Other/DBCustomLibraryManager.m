//
//  DBCustomLibraryManager.m
//  DemoCode
//
//  Created by zheng zhang on 2018/2/28.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBCustomLibraryManager.h"
#import "DBLibraryConfig.h"
#import <AVFoundation/AVFoundation.h>
#import "DBImageListModel.h"

@implementation DBCustomLibraryManager

+ (DBImageListModel *)getCameraRollAlbumList:(DBLibraryConfig *)config
{
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    if (!config.allowSelectVideo) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    if (!config.allowSelectImage) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",PHAssetMediaTypeVideo];
    if (!config.sortAscending) option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:0]];
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    __block DBImageListModel *model;
    WS(weakSelf);
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *  _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
        //获取相册内asset result
        if (collection.assetCollectionSubtype == 209) {
            PHFetchResult<PHAsset *> *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            NSString *title = [weakSelf getCollectionTitle:collection];
            model = [weakSelf getAlbumModeWithTitle:title result:result Sort:config.sortAscending];
            model.isCamera = 1;
        }
    }];
    return model;
}

+ (void)getCameraRollAlbumList:(DBLibraryConfig *)config complete:(void (^)(DBImageListModel *))complete
{
    if (complete) {
        complete([self getCameraRollAlbumList:config]);
    }
}

+ (void)getPhotoAblumList:(DBLibraryConfig *)config complete:(void (^)(NSArray<DBImageListModel *> *))complete
{
    if (!config.allowSelectImage && !config.allowSelectVideo) {
        if (complete) {
            complete(nil);
        }
    }
    else
    {
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        if (!config.allowSelectVideo) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        if (!config.allowSelectImage) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",PHAssetMediaTypeVideo];
        if (!config.sortAscending) option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:0]];
        
        //获取所有智能相册
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        PHFetchResult *streamAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];
        PHFetchResult *userAlbums = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        PHFetchResult *syncedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
        PHFetchResult *sharedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumCloudShared options:nil];
        NSArray *arrAllAlbums = @[smartAlbums, streamAlbums, userAlbums, syncedAlbums, sharedAlbums];
        /**
         PHAssetCollectionSubtypeAlbumRegular         = 2,///
         PHAssetCollectionSubtypeAlbumSyncedEvent     = 3,////
         PHAssetCollectionSubtypeAlbumSyncedFaces     = 4,////面孔
         PHAssetCollectionSubtypeAlbumSyncedAlbum     = 5,////
         PHAssetCollectionSubtypeAlbumImported        = 6,////
         
         // PHAssetCollectionTypeAlbum shared subtypes
         PHAssetCollectionSubtypeAlbumMyPhotoStream   = 100,///
         PHAssetCollectionSubtypeAlbumCloudShared     = 101,///
         
         // PHAssetCollectionTypeSmartAlbum subtypes        //// collection.localizedTitle
         PHAssetCollectionSubtypeSmartAlbumGeneric    = 200,///
         PHAssetCollectionSubtypeSmartAlbumPanoramas  = 201,///全景照片
         PHAssetCollectionSubtypeSmartAlbumVideos     = 202,///视频
         PHAssetCollectionSubtypeSmartAlbumFavorites  = 203,///个人收藏
         PHAssetCollectionSubtypeSmartAlbumTimelapses = 204,///延时摄影
         PHAssetCollectionSubtypeSmartAlbumAllHidden  = 205,/// 已隐藏
         PHAssetCollectionSubtypeSmartAlbumRecentlyAdded = 206,///最近添加
         PHAssetCollectionSubtypeSmartAlbumBursts     = 207,///连拍快照
         PHAssetCollectionSubtypeSmartAlbumSlomoVideos = 208,///慢动作
         PHAssetCollectionSubtypeSmartAlbumUserLibrary = 209,///所有照片
         PHAssetCollectionSubtypeSmartAlbumSelfPortraits NS_AVAILABLE_IOS(9_0) = 210,///自拍
         PHAssetCollectionSubtypeSmartAlbumScreenshots NS_AVAILABLE_IOS(9_0) = 211,///屏幕快照
         PHAssetCollectionSubtypeSmartAlbumDepthEffect PHOTOS_AVAILABLE_IOS_TVOS(10_2, 10_1) = 212,///人像
         PHAssetCollectionSubtypeSmartAlbumLivePhotos PHOTOS_AVAILABLE_IOS_TVOS(10_3, 10_2) = 213,//livephotos
         PHAssetCollectionSubtypeSmartAlbumAnimated = 214,///动图
         = 1000000201///最近删除知道值为（1000000201）但没找到对应的TypedefName
         // Used for fetching, if you don't care about the exact subtype
         PHAssetCollectionSubtypeAny = NSIntegerMax /////所有类型
         */
        WS(weakSelf);
        NSMutableArray<DBImageListModel *> *arrAlbum = [NSMutableArray array];
        for (PHFetchResult<PHAssetCollection *> *album in arrAllAlbums) {
            [album enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
                //过滤PHCollectionList对象
                if (![collection isKindOfClass:PHAssetCollection.class]) return;
                //过滤最近删除
                if (collection.assetCollectionSubtype > 215) return;
                //获取相册内asset result
                PHFetchResult<PHAsset *> *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
                if (!result.count) return;
                
                NSString *title = [weakSelf getCollectionTitle:collection];
                
                if (collection.assetCollectionSubtype == 209) {
                    DBImageListModel *m = [weakSelf getAlbumModeWithTitle:title result:result Sort:config.sortAscending];
                    m.isCamera = 1;
                    [arrAlbum insertObject:m atIndex:0];
                } else {
                    [arrAlbum addObject:[weakSelf getAlbumModeWithTitle:title result:result Sort:config.sortAscending]];
                }
            }];
        }
        
        if (complete) complete(arrAlbum);
    }
}

#pragma mark - Other
//获取相册列表model
+ (DBImageListModel *)getAlbumModeWithTitle:(NSString *)title result:(PHFetchResult<PHAsset *> *)result Sort:(BOOL)isSort
{
    DBImageListModel *model = [[DBImageListModel alloc] init];
    model.title = title;
    model.count = result.count;
    model.result = result;
    model.headImageAsset = isSort ? result.lastObject : result.firstObject;
    
    //为了获取所有asset gif设置为yes
    model.models = [self getPhotoInResult:result];
    return model;
}

+ (NSArray<DBImageModel *> *)getPhotoInResult:(PHFetchResult<PHAsset *> *)result
{
    NSMutableArray<DBImageModel *> *arrModel = [NSMutableArray array];
    __block NSInteger count = 1;
    WS(weakSelf)
    [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DBAssetMediaType type = [weakSelf transformAssetType:obj];
        
        [arrModel addObject:[DBImageModel modelWithAsset:obj type:type duration:0]];
        count++;
    }];
    return arrModel;
}

//系统mediatype 转换为 自定义type
+ (DBAssetMediaType)transformAssetType:(PHAsset *)asset
{
    switch (asset.mediaType) {
            //        case PHAssetMediaTypeAudio:
            //            return DBAssetMediaType;
        case PHAssetMediaTypeVideo:
            return DBAssetMediaTypeVideo;
        case PHAssetMediaTypeImage:
            if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"])return DBAssetMediaTypeGif;
            
            if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive || asset.mediaSubtypes == 10) return DBAssetMediaTypeLivePhoto;
            
            return DBAssetMediaTypeImage;
        default:
            return DBAssetMediaTypeUnKnow;
    }
}


+ (NSString *)getCollectionTitle:(PHAssetCollection *)collection
{
    return collection.localizedTitle;
}


#pragma mark - 权限相关
+ (BOOL)havePhotoLibraryAuthority
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        return YES;
    }
    return NO;
}

+ (BOOL)haveCameraAuthority
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted ||
        status == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

+ (BOOL)haveMicrophoneAuthority
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status == AVAuthorizationStatusRestricted ||
        status == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

@end
