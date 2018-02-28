//
//  DBCustomListLibraryViewController.m
//  DemoCode
//
//  Created by zheng zhang on 2018/2/27.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBCustomListLibraryViewController.h"

//V
#import "DBCustomLibraryTabCell.h"

//M
#import "DBImageListModel.h"

@interface DBCustomListLibraryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIButton *cancleBtn;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, copy) NSMutableArray<DBImageListModel *> *arrayDataSources;


@end

static NSString *libraryTabCellID = @"DBCustomLibraryTabCell";

@implementation DBCustomListLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addNavigationBar];
    self.navigationBar.rightBarItems = @[self.cancleBtn];
    [self setNavTitle:@"照片"];
    [self.view addSubview:self.tableView];
    [self setupDatas];
}

- (void)setupDatas
{
    WS(weakSelf);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
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
                
                NSString *title = collection.localizedTitle;
                
                if (collection.assetCollectionSubtype == 209) {
                    DBImageListModel *m = [self getAlbumModeWithTitle:title result:result];
                    [arrAlbum insertObject:m atIndex:0];
                } else {
                    [arrAlbum addObject:[self getAlbumModeWithTitle:title result:result]];
                }
            }];
        }
        weakSelf.arrayDataSources = [NSMutableArray arrayWithArray:arrAlbum];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    });
}

#pragma mark - Others
//获取相册列表model
- (DBImageListModel *)getAlbumModeWithTitle:(NSString *)title result:(PHFetchResult<PHAsset *> *)result
{
    DBImageListModel *model = [[DBImageListModel alloc] init];
    model.title = title;
    model.count = result.count;
    model.result = result;
    model.headImageAsset = result.lastObject;

    //为了获取所有asset gif设置为yes
    model.models = [self getPhotoInResult:result];
    
    return model;
}


- (NSArray<DBImageModel *> *)getPhotoInResult:(PHFetchResult<PHAsset *> *)result
{
    NSMutableArray<DBImageModel *> *arrModel = [NSMutableArray array];
    __block NSInteger count = 1;
    [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DBAssetMediaType type = [self transformAssetType:obj];
        
        [arrModel addObject:[DBImageModel modelWithAsset:obj type:type duration:0]];
        count++;
    }];
    return arrModel;
}

//系统mediatype 转换为 自定义type
- (DBAssetMediaType)transformAssetType:(PHAsset *)asset
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

#pragma mark - Action
- (void)cancleClick
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayDataSources.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBCustomLibraryTabCell *cell = [tableView dequeueReusableCellWithIdentifier:libraryTabCellID];
    DBImageListModel *albumModel = self.arrayDataSources[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = albumModel;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self pushThumbnailVCWithIndex:indexPath.row animated:YES];
}

#pragma mark - getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = ({
            UITableView *view = [[UITableView alloc] initWithFrame:kRect(0, self.navigationBar.bottom, self.view.width, self.view.height - self.navigationBar.bottom) style:UITableViewStylePlain];
            view.delegate = self;
            view.dataSource = self;
            
            if (@available(iOS 11.0, *)) {
                view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            } else {
                // Fallback on earlier versions
            }
            view.estimatedRowHeight = 0;
            view.estimatedSectionFooterHeight = 0;
            view.estimatedSectionHeaderHeight = 0;
            //去掉分割线
            view.separatorStyle = UITableViewCellSelectionStyleNone;
            [view registerClass:NSClassFromString(@"DBCustomLibraryTabCell") forCellReuseIdentifier:libraryTabCellID];
            view;
        });
    }
    return _tableView;
}

- (UIButton *)cancleBtn
{
    if (!_cancleBtn) {
        _cancleBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            [btn setTitle:@"取消" forState:UIControlStateHighlighted];
            btn.frame = kRect(0, 0, 60, self.navigationBar.backButton.height);
            [btn addTarget:self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:UIColorFromRGB(0x0000000) forState:UIControlStateHighlighted];
            [btn setTitleColor:UIColorFromRGB(0x0000000) forState:UIControlStateNormal];
            btn.titleLabel.font = self.navigationBar.backButton.titleLabel.font;
            btn;
        });
    }
    return _cancleBtn;
}
@end
