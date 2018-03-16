//
//  DBUserDetailTwoViewController.m
//  DemoCode
//
//  Created by zheng zhang on 2018/3/14.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBUserDetailTwoViewController.h"
#import "DBUserDetailTwoCell.h"
#import "UIScrollView+AURefreshMethods.h"

@interface DBUserDetailTwoViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) UICollectionView *collView;

@end

static NSString *userDetailTwoCellID = @"DBUserDetailTwoCell";

@implementation DBUserDetailTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collView.contentInset = self.contentInset;
    self.collView.height = self.viewHeight;
    [self.view addSubview:self.collView];
}

- (void)setPointY:(CGFloat)pointY
{
    [super setPointY:pointY];
    [self.collView setContentOffset:kPoint(self.collView.contentOffset.x, pointY)];
}
#pragma mark - scrollDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.offsetBlock) {
        self.offsetBlock(scrollView.contentOffset.y);
    }
}

#pragma mark - collectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DBUserDetailTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:userDetailTwoCellID forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - getter
- (UICollectionView *)collView
{
    if (!_collView) {
        _collView = ({
            CGFloat width = kMainBoundsWidth / 2;
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
            layout.minimumInteritemSpacing = 0;
            layout.minimumLineSpacing = 0;
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方法：竖向
            layout.itemSize = kSize(width, width * 3 / 4 + 90);
            UICollectionView *collection = [[UICollectionView alloc] initWithFrame:kRect(0, 0, kMainBoundsWidth, kMainBoundsHeight - 50) collectionViewLayout:layout];
            collection.delegate = self;
            collection.backgroundColor = [UIColor whiteColor];
            collection.dataSource = self;
            [collection registerClass:NSClassFromString(@"DBUserDetailTwoCell") forCellWithReuseIdentifier:userDetailTwoCellID];
            if (@available(iOS 11.0, *)) {
                collection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            } else {
                // Fallback on earlier versions
                self.automaticallyAdjustsScrollViewInsets = NO;
            }
            WS(weakSelf);
            [collection addHeaderRefreshMethodWithCallback:^{
                [weakSelf.collView.mj_header endRefreshing];
            }];
            collection;
        });
    }
    return _collView;
}


@end
