//
//  DBPushAnimationListViewController.m
//  DemoCode
//
//  Created by zheng zhang on 2018/3/12.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBPushAnimationListViewController.h"

//M
#import "DBPushAnimationModel.h"
#import "NSString+DBSizeForString.h"

//V
#import "DBPushAnimationListCell.h"
#import "DBAnimationListLayout.h"

//VC
#import "DBPushAnimationDetailViewController.h"
#import "BaseNavigationController.h"

@interface DBPushAnimationListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, DBAnimationListLayoutDelegate>

@property (nonatomic, strong) NSArray* modelArray;
@property (nonatomic, weak) UICollectionView* collectionView;
@property (nonatomic, strong) DBAnimationListLayout* collectionLayout;

@end

static NSString *animationListCellID = @"DBPushAnimationListCell";

@implementation DBPushAnimationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupDatas];
    [self setupViews];
}


- (void)setupDatas
{
    NSMutableArray* array = [NSMutableArray array];
    NSArray* dicArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"1.plist" ofType:nil]];
    
    for (NSDictionary* dic in dicArray) {
        DBPushAnimationModel* m = [DBPushAnimationModel objectFromDictionary:dic];
        [array addObject:m];
    }
    self.modelArray = array;
}

- (void)setupViews
{
    [self addNavigationBar];
    [self setNavTitle:@"转场动画"];
    [self.view addSubview:self.collectionView];
}

#pragma mark UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.modelArray.count;
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DBPushAnimationListCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:animationListCellID forIndexPath:indexPath];
    cell.model = self.modelArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DBPushAnimationModel* model = self.modelArray[indexPath.item];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat scale = width / [model.w floatValue];
    CGFloat height = [model.h floatValue] * scale;
    
    DBPushAnimationListCell* cell = (DBPushAnimationListCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    CGRect desImageViewRect = CGRectMake(0, KTC_TOP_MARGIN + 40, width, height);
    DBPushAnimationDetailViewController* vc = [[DBPushAnimationDetailViewController alloc] initWithModel:model desImageViewRect:desImageViewRect];
    
    [((BaseNavigationController *) self.navigationController) pushViewController:vc withImageView:cell.headImageView desRect:desImageViewRect delegate:vc];
}

#pragma mark - layout Delegate
- (CGFloat)OJLWaterLayout:(DBAnimationListLayout *)OJLWaterLayout itemHeightForIndexPath:(NSIndexPath *)indexPath
{
    DBPushAnimationModel* model = self.modelArray[indexPath.item];
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - self.collectionLayout.sectionInset.left - self.collectionLayout.sectionInset.right - (self.collectionLayout.colPanding * (self.collectionLayout.numberOfCol - 1))) / self.collectionLayout.numberOfCol;

    CGSize detailSize = [model.des sizeWithFont:KFont(12, UIFontWeightRegular) MaxSize:kSize(width - 16, MAXFLOAT)];
    
    CGFloat scale = [model.w floatValue] / width;
    CGFloat height =  [model.h floatValue] / scale + 52 + detailSize.height;
    return height;
}

#pragma mark - getter
- (DBAnimationListLayout *)collectionLayout
{
    if (!_collectionLayout) {
        DBAnimationListLayout *layout = [[DBAnimationListLayout alloc] init];
        layout.numberOfCol = 2;
        layout.rowPanding = 15;
        layout.colPanding = 15;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.delegate = self;
        self.collectionLayout = layout;
    }
    return _collectionLayout;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        [self.collectionLayout autuContentSize];
        
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:kRect(0, self.navigationBar.height, kMainBoundsWidth, kMainBoundsHeight - self.navigationBar.height) collectionViewLayout:self.collectionLayout];
        view.delegate = self;
        view.dataSource = self;
        view.backgroundColor = UIColorFromRGB(0xeeeeee);
        [view registerClass:NSClassFromString(@"DBPushAnimationListCell") forCellWithReuseIdentifier:animationListCellID];
        self.collectionView = view;
    }
    return _collectionView;
}

@end
