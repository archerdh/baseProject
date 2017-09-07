//
//  AUFailView.m
//  auction
//
//  Created by zheng zhang on 2017/8/2.
//  Copyright © 2017年 auction. All rights reserved.
//

#import "AUFailView.h"

@interface AUFailView ()

@property (nonatomic,strong) UIImageView *failImageView;
@property (nonatomic,strong) UILabel *failLab;
@property (nonatomic,strong) UILabel *faildTipLab;

@end

@implementation AUFailView

- (instancetype)init
{
    if (self = [super initWithFrame:kRect(0, 64, kMainBoundsWidth, kMainBoundsHeight-64)]) {
        self.backgroundColor = kDefaultBackgroundColor;
        UIImage* failImage = [UIImage imageNamed:@"common_noWifi"];
        UIImageView *faildImg = [[UIImageView alloc] initWithImage:failImage];
        faildImg.frame = CGRectMake(0, 0, failImage.size.width, failImage.size.height);
        faildImg.center = CGPointMake(self.width * 0.5, self.height * 0.5 - 80);
        faildImg.contentMode = UIViewContentModeScaleAspectFit;
        self.failImageView = faildImg;
        [self addSubview:faildImg];
        
        NSString *failText = @"网络未连接";
        NSString *faildTipText = @"请连接网络后点击屏幕重试";
        UILabel *faildLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(faildImg.frame) + 40, kMainBoundsWidth, 20)];
        faildLab.text = failText;
        faildLab.textAlignment = NSTextAlignmentCenter;
        faildLab.textColor = UIColorFromRGB(0x666666);
        faildLab.font = [UIFont systemFontOfSize:15.0f];
        self.failLab = faildLab;
        [self addSubview:faildLab];
        
        UILabel *faildLab1 = [[UILabel alloc] initWithFrame:kRect(0, CGRectGetMaxY(faildLab.frame) + 20, kMainBoundsWidth, 15)];
        faildLab1.text = faildTipText;
        faildLab1.textAlignment = NSTextAlignmentCenter;
        faildLab1.textColor = UIColorFromRGB(0x999999);
        faildLab1.font = [UIFont systemFontOfSize:14.0f];
        self.faildTipLab = faildLab1;
        [self addSubview:faildLab1];
        
        
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

- (void)setType:(AUFailViewType)type
{
    if (type == AUFailViewType_LoginExpired) {
        self.failImageView.image = [UIImage imageNamed:@"user_login_expired"];
        self.failImageView.center = CGPointMake(self.width * 0.5+25, self.height * 0.5 - 80);
//        NSRange range = {9,2};
//        NSDictionary *dic = @{@(range.location):@(range.length)};
//        NSAttributedString *attStr = [Helper setNSStringCorlor:@"您当前未登录，请先登录" positon:dic withColor:[UIColor redColor]];
        self.failLab.text = @"您还没有登录~";
        self.faildTipLab.text = @"点击登录";
        self.faildTipLab.textColor = UIColorFromRGB(0xffffff);
        self.faildTipLab.backgroundColor = UIColorFromRGB(0xEB1010);
        self.faildTipLab.width = 220*KTC_SCREEN_RATION*0.5;
        self.faildTipLab.height = 80*KTC_SCREEN_RATION*0.5;
        self.faildTipLab.centerX = kMainBoundsWidth *0.5;
        self.faildTipLab.font = KFont(15, UIFontWeightRegular);
        self.faildTipLab.layer.cornerRadius = 3;
        self.faildTipLab.clipsToBounds = YES;
    }
    else{
        self.failImageView.image = [UIImage imageNamed:@"common_noWifi"];
        self.failLab.text = @"网络未连接";
        self.faildTipLab.text = @"请连接网络后点击屏幕重试";
    }
}

@end
