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
#import "DBCustomLibraryCameraCell.h"

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
static NSString *libraryCarmerID = @"DBCustomLibraryCameraCell";

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
    [self.view bringSubviewToFront:self.navigationBar];
    self.navigationBar.backgroundColor = UIColorFromRGBA(0xffffff, 0.8);
    self.navigationBar.statusBarView.backgroundColor = UIColorFromRGBA(0xffffff, 0.8);
    self.navigationBar.navigationBarView.backgroundColor = UIColorFromRGBA(0xffffff, 0.8);
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
    if (self.model.isCamera) {
        return self.model.count + 1;
    }
    return self.model.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakSelf);
    DBCustomLibraryNavViewController *nav = (DBCustomLibraryNavViewController *)self.navigationController;
    DBLibraryConfig *config = nav.config;
    if (self.model.isCamera && ((indexPath.item == 0 && !config.sortAscending) || (indexPath.item == self.model.count && config.sortAscending))) {
        DBCustomLibraryCameraCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:libraryCarmerID forIndexPath:indexPath];
        if (config.showCaptureImageOnTakePhotoBtn) {
            [cell startCapture];
        }
        return cell;
    }
    NSInteger index = self.model.isCamera ? (!config.sortAscending ? indexPath.item - 1 : indexPath.item) : indexPath.item;
    DBCustomLibraryImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:libraryCellID forIndexPath:indexPath];
    __strong typeof(cell) strongCell = cell;
    __strong typeof(nav) strongNav = nav;
    cell.isChoosed = nav.arrSelectedModels.count > 0;
    cell.seleteBlock = ^{
        strongCell.model.selected = !strongCell.model.selected;
        strongCell.seletedBtn.selected = strongCell.model.selected;
        if (strongCell.model.selected) {
            [strongNav.arrSelectedModels addObject:strongCell.model];
        }
        else
        {
            [strongNav.arrSelectedModels removeObject:strongCell.model];
        }
        //去掉隐世动画
        [weakSelf.collectionView reloadData];
    };
    cell.model = self.model.models[index];
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
            layout.headerReferenceSize = kSize(kMainBoundsWidth, self.navigationBar.height);
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:kRect(0, 0, kMainBoundsWidth, kMainBoundsHeight) collectionViewLayout:layout];
            collectionView.backgroundColor = [UIColor whiteColor];
            collectionView.dataSource = self;
            collectionView.delegate = self;
            [collectionView registerClass:NSClassFromString(@"DBCustomLibraryImageCell") forCellWithReuseIdentifier:libraryCellID];
            [collectionView registerClass:NSClassFromString(@"DBCustomLibraryCameraCell") forCellWithReuseIdentifier:libraryCarmerID];
            if (@available(iOS 9.0, *)) {
                [self registerForPreviewingWithDelegate:self sourceView:collectionView];
            } else {
            }
            if (@available(iOS 11.0, *)) {
                [collectionView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
            }
            collectionView;
        });
    }
    return _collectionView;
}

@end
