//
//  DBPushAnimationDetailViewController.m
//  DemoCode
//
//  Created by zheng zhang on 2018/3/12.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBPushAnimationDetailViewController.h"
//M
#import "DBPushAnimationModel.h"
#import "NSString+DBSizeForString.h"

//V
#import "DBAnimationDetailHeadView.h"
#import "DBAnimationListLayout.h"
#import "DBPushAnimationListCell.h"

//VC
#import "BaseNavigationController.h"

@interface DBPushAnimationDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, DBAnimationListLayoutDelegate>

@property (strong, nonatomic) DBPushAnimationModel *model;
@property (nonatomic, weak) UICollectionView* collectionView;
@property (nonatomic, strong) DBAnimationListLayout* collectionLayout;
@property (nonatomic, strong) NSArray* modelArray;
@property (nonatomic, assign) CGRect desRect;

@end

static NSString *animationDetailCellID = @"DBPushAnimationListCell";
static NSString *animationDetailHeadID = @"DBAnimationDetailHeadViewHeadCellID";

@implementation DBPushAnimationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)dealloc
{
    
}

- (instancetype)initWithModel:(DBPushAnimationModel *)model desImageViewRect:(CGRect)desRect
{
    if (self = [super init]) {
        self.desRect = desRect;
        self.model = model;
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    NSMutableArray* array = [NSMutableArray array];
    NSArray* dicArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"1.plist" ofType:nil]];
    
    for (NSDictionary* dic in dicArray) {
        DBPushAnimationModel* m = [DBPushAnimationModel objectFromDictionary:dic];
        [array addObject:m];
    }
    self.modelArray = array;
    [self.view addSubview:self.collectionView];
}

#pragma mark - 转场动画
- (void)didFinishTransition
{
    CGSize detailSize = [self.model.des sizeWithFont:KFont(13, UIFontWeightRegular) MaxSize:kSize(kMainBoundsWidth - 20, MAXFLOAT)];
    
    self.collectionLayout.headSize = kSize(kMainBoundsWidth, detailSize.height + 50 + self.desRect.size.height);
    [self.collectionView reloadData];
}

#pragma mark - action
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.modelArray.count;
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DBPushAnimationListCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:animationDetailCellID forIndexPath:indexPath];
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *header = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:animationDetailHeadID forIndexPath:indexPath];
        DBAnimationDetailHeadView *view = (DBAnimationDetailHeadView *)header;
        view.model = self.model;
        WS(weakSelf);
        view.backBlock = ^{
            [weakSelf backClick];
        };
    }
    return header;
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
        [view registerClass:NSClassFromString(@"DBPushAnimationListCell") forCellWithReuseIdentifier:animationDetailCellID];
        [view registerClass:[DBAnimationDetailHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:animationDetailHeadID];

        self.collectionView = view;
    }
    return _collectionView;
}



@end
