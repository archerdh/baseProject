//
//  DBCustomLibraryViewController.m
//  DemoCode
//
//  Created by zheng zhang on 2018/2/8.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBCustomLibraryViewController.h"
#import <Photos/Photos.h>

//V
#import "DBCustomLibraryImageCell.h"

//M
#import "DBImageListModel.h"

@interface DBCustomLibraryViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UIButton *cancleBtn;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) DBImageListModel *model;

@end

static NSString *libraryCellID = @"DBCustomLibraryImageCell";

@implementation DBCustomLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.model = [self getImageSource];

    [self addNavigationBar];
    [self setNavTitle:self.model.title];
    self.navigationBar.rightBarItems = @[self.cancleBtn];
    [self.view addSubview:self.collectionView];
}

- (DBImageListModel *)getImageSource
{
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    __block DBImageListModel *model;
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *  _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
        //获取相册内asset result
        if (collection.assetCollectionSubtype == 209) {
            PHFetchResult<PHAsset *> *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            model = [[DBImageListModel alloc] init];
            model.title = [self getCollectionTitle:collection];
            model.count = result.count;
            model.result = result;
            model.headImageAsset = result.lastObject;
        }
    }];
    return model;
}

#pragma mark - Others
- (NSString *)getCollectionTitle:(PHAssetCollection *)collection
{
    return collection.localizedTitle;
}

#pragma mark - CollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.allowTakePhoto) {
        return self.model.count + 1;
    }
    return self.model.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DBCustomLibraryImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:libraryCellID forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Action
- (void)cancleClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getter
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

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = ({
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            NSInteger columnCount = 4;
            layout.itemSize = kSize((kMainBoundsWidth - 1.5 * (columnCount + 2)) / columnCount, (kMainBoundsWidth - 1.5 * (columnCount + 2)) / columnCount);
            layout.minimumInteritemSpacing = 1.5;
            layout.minimumLineSpacing = 1.5;
            layout.sectionInset = UIEdgeInsetsMake(3, 3, 3, 3);
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:kRect(0, self.navigationBar.bottom, kMainBoundsWidth, kMainBoundsHeight - self.navigationBar.bottom) collectionViewLayout:layout];
            collectionView.backgroundColor = [UIColor whiteColor];
            collectionView.dataSource = self;
            collectionView.delegate = self;
            [collectionView registerClass:NSClassFromString(@"DBCustomLibraryImageCell") forCellWithReuseIdentifier:libraryCellID];
            collectionView;
        });
    }
    return _collectionView;
}

@end
