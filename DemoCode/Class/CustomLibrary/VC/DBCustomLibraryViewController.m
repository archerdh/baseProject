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
#import "DBCustomLibraryManager.h"

//VC
#import "DBCustomLibraryForceTouchViewController.h"
#import "DBCustomLibraryNavViewController.h"
#import "DBCustomLibraryPreviewViewController.h"

@interface DBCustomLibraryViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerPreviewingDelegate>

@property (strong, nonatomic) UIButton *cancleBtn;
@property (strong, nonatomic) UICollectionView *collectionView;

@end

static NSString *libraryCellID = @"DBCustomLibraryImageCell";

@implementation DBCustomLibraryViewController

- (void)dealloc
{
    AULog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!self.model) {
        DBCustomLibraryNavViewController *nav = (DBCustomLibraryNavViewController *)self.navigationController;
        self.model = [DBCustomLibraryManager getCameraRollAlbumList:nav.config];
    }
    
    [self addNavigationBar];
    [self setNavTitle:self.model.title];
    self.navigationBar.rightBarItems = @[self.cancleBtn];
    [self.view addSubview:self.collectionView];
}

#pragma makr - UIViewControllerPreviewingDelegate
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    if (!indexPath) {
        return nil;
    }
    
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
//    if ([cell isKindOfClass:[ZLTakePhotoCell class]]) {
//        return nil;
//    }
    //设置突出区域
    previewingContext.sourceRect = [self.collectionView cellForItemAtIndexPath:indexPath].frame;
    DBCustomLibraryForceTouchViewController *vc = [DBCustomLibraryForceTouchViewController new];
    vc.model = self.model.models[indexPath.item];
    vc.preferredContentSize = [self getSize:vc.model];
    return vc;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
//    DBImageModel *model = [(DBCustomLibraryForceTouchViewController *)viewControllerToCommit model];
    
    DBCustomLibraryPreviewViewController *vc = [[DBCustomLibraryPreviewViewController alloc] init];
    if (vc) {
        [self showViewController:vc sender:self];
    }

}

- (CGSize)getSize:(DBImageModel *)model
{
    CGFloat w = MIN(model.asset.pixelWidth, kMainBoundsWidth);
    CGFloat h = w * model.asset.pixelHeight / model.asset.pixelWidth;
    if (isnan(h)) return CGSizeZero;
    
    if (h > kMainBoundsHeight || isnan(h)) {
        h = kMainBoundsHeight;
        w = h * model.asset.pixelWidth / model.asset.pixelHeight;
    }
    
    return CGSizeMake(w, h);
}

#pragma mark - CollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.model.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DBCustomLibraryImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:libraryCellID forIndexPath:indexPath];
    cell.model = self.model.models[indexPath.item];
    return cell;
}

#pragma mark - Action
- (void)cancleClick
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
            layout.itemSize = kSize((kMainBoundsWidth - 6 - 1.5 * (columnCount - 1)) / columnCount, (kMainBoundsWidth - 6 - 1.5 * (columnCount - 1)) / columnCount);
            layout.minimumInteritemSpacing = 1.5;
            layout.minimumLineSpacing = 1.5;
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            layout.sectionInset = UIEdgeInsetsMake(3, 3, 3, 3);
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:kRect(0, self.navigationBar.bottom, kMainBoundsWidth, kMainBoundsHeight - self.navigationBar.bottom) collectionViewLayout:layout];
            collectionView.backgroundColor = [UIColor whiteColor];
            collectionView.dataSource = self;
            collectionView.delegate = self;
            [collectionView registerClass:NSClassFromString(@"DBCustomLibraryImageCell") forCellWithReuseIdentifier:libraryCellID];
            if (@available(iOS 9.0, *)) {
                [self registerForPreviewingWithDelegate:self sourceView:collectionView];
            } else {
            }
            
            collectionView;
        });
    }
    return _collectionView;
}

@end
