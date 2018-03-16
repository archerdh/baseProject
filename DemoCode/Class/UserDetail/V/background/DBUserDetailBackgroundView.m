//
//  DBUserDetailBackgroundView.m
//  DemoCode
//
//  Created by zheng zhang on 2018/3/14.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBUserDetailBackgroundView.h"
#import "DBUserDetailCommonCell.h"

@interface DBUserDetailBackgroundView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIView *bottomView;

@end

static NSString *userDetailCommonCellID = @"DBUserDetailCommonCell";

@implementation DBUserDetailBackgroundView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
        [self addSubview:self.bottomView];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setOffset:(CGFloat)offset
{
    _offset = offset;
    CGFloat headerViewHeight = kMainBoundsWidth * 3 / 4;
    CGFloat bottomViewHeight = 50;
    CGFloat navHeight = KTC_TOP_MARGIN + 44;
    if (-offset < headerViewHeight && -offset < bottomViewHeight + navHeight)
    {
        //上面的划出屏幕 上面的固定
        self.collectionView.height = navHeight;
        self.bottomView.y = self.collectionView.bottom;
    }
    else if(offset <- headerViewHeight - bottomViewHeight)
    {
        //往下拉
//        CGFloat newOfferset = -(offset + headerViewHeight + bottomViewHeight);
        self.collectionView.frame = kRect(0, 0, self.collectionView.width, headerViewHeight);
        self.bottomView.frame = kRect(0, self.collectionView.bottom, self.collectionView.width, bottomViewHeight);
    }
    else
    {
        CGFloat newOfferset = -(offset + headerViewHeight + bottomViewHeight + navHeight);
        self.collectionView.frame = kRect(0, 0, self.collectionView.width, headerViewHeight + newOfferset + navHeight);
        self.bottomView.frame = kRect(0, self.collectionView.bottom, self.collectionView.width, bottomViewHeight);
    }
    self.frame = kRect(0, 0, kMainBoundsWidth, self.bottomView.bottom);
}

#pragma mark UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DBUserDetailCommonCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:userDetailCommonCellID forIndexPath:indexPath];
    return cell;
}

#pragma mark - getter
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = kSize(kMainBoundsWidth, kMainBoundsWidth * 3 / 4);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:kRect(0, 0, kMainBoundsWidth, kMainBoundsWidth * 3 / 4) collectionViewLayout:layout];
        view.delegate = self;
        view.dataSource = self;
        view.pagingEnabled = YES;
        view.backgroundColor = UIColorFromRGB(0x000000);
        [view registerClass:NSClassFromString(@"DBUserDetailCommonCell") forCellWithReuseIdentifier:userDetailCommonCellID];
        self.collectionView = view;
    }
    return _collectionView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = ({
            UIView *view = [[UIView alloc] initWithFrame:kRect(0, self.collectionView.bottom, kMainBoundsWidth, 50)];
            view.backgroundColor = RGB_RANDOM_COLOR;
            view;
        });
    }
    return _bottomView;
}

@end
