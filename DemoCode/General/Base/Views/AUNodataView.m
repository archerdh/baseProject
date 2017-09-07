//
//  AUNodataView.m
//  auction
//
//  Created by zheng zhang on 2017/8/2.
//  Copyright © 2017年 auction. All rights reserved.
//

#import "AUNodataView.h"

@interface AUNodataView ()

@end

@implementation AUNodataView

- (id)initNoDataView
{
    if (self = [super initWithFrame:kRect(0, 64, kMainBoundsWidth, kMainBoundsHeight-64)]) {
        self.backgroundColor = kDefaultBackgroundColor;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setViewHidden:(BOOL)viewHidden
{
    _viewHidden = viewHidden;
    self.hidden = viewHidden;
    if (!self.hidden) {
        [[self superview] bringSubviewToFront:self];
    }
}

- (void)setType:(AUNodataViewType)type
{
    [self removeAllSubviews];
    _type = true;
    UIImage *nodataImage;
    NSString *nodataText;
    switch (type) {
        case AUNodataViewNormalType:
        {
            nodataImage = [UIImage imageNamed:@"common_noDatas"];
            nodataText = @"暂无数据显示~请先浏览其他页面";
        }
            break;
        case AUNodataViewNoFansType:
        {
            nodataImage = [UIImage imageNamed:@"common_noFans"];
            nodataText = @"您还没有粉丝~";
        }
            break;
        case AUNodataViewNoFollowType:
        {
            nodataImage = [UIImage imageNamed:@"common_noFollow"];
            nodataText = @"您还没有关注的人~";
        }
            break;
        case AUNodataViewNoDraftType:
        {
            nodataImage = [UIImage imageNamed:@"common_noDraft"];
            nodataText = @"您还没有保存过任何草稿哦~";
        }
            break;
        case AUNodataViewOtherNoFansType:
        {
            nodataImage = [UIImage imageNamed:@"common_noFans"];
            nodataText = @"TA还没有粉丝~";
        }
            break;
        case AUNodataViewOtherNoFollowType:
        {
            nodataImage = [UIImage imageNamed:@"common_noFollow"];
            nodataText = @"TA还没有关注的人~";
        }
            break;
        case AUNodataViewDeleteType:
        {
            nodataImage = [UIImage imageNamed:@"common_delete"];
            nodataText = @"该内容已被删除";
        }
            break;
        case AUNodataViewNoContentType:
        {
            nodataImage = [UIImage imageNamed:@"common_nocontent"];
            nodataText = @"暂无内容";
        }
            break;
        case AUNodataViewUserNoPostType:
        {
            nodataImage = [UIImage imageNamed:@"common_noPost"];
            nodataText = @"TA还没发布过任何动态";
        }
            break;
            
        case AUNodataViewMyNoPostType:
        {
            nodataImage = [UIImage imageNamed:@"common_noPost"];
            nodataText = @"您还没发布过任何动态";
        }
            break;
        case AUNodataViewSearchNoRecommendType:
        {
            nodataImage = [UIImage imageNamed:@"common_search_all"];
            nodataText = @"您已关注了所有入驻明星";
        }
            break;
        case AUNodataViewUserNoRecordType:
        {
            nodataImage = [UIImage imageNamed:@"common_no_user_record"];
            nodataText = @"您还未添加任何获奖记录";
        }
            break;
        default:
        {
            nodataImage = [UIImage imageNamed:@"common_noMessage"];
            nodataText = @"您现在还没有记录";
        }
            break;
    }
    UIImageView *faildImg = [[UIImageView alloc] initWithImage:nodataImage];
    faildImg.frame = CGRectMake(0, 0, nodataImage.size.width, nodataImage.size.height);
    faildImg.center = CGPointMake(self.width * 0.5, self.height * 0.5 - 80);
    [self addSubview:faildImg];
    
    UILabel *faildLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(faildImg.frame) + 40, kMainBoundsWidth, 20)];
    faildLab.text = nodataText;
    faildLab.textAlignment = NSTextAlignmentCenter;
    faildLab.textColor = UIColorFromRGB(0x666666);
    faildLab.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:faildLab];
}

@end
