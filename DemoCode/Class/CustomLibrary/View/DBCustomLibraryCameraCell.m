//
//  DBCustomLibraryCameraCell.m
//  DemoCode
//
//  Created by zheng zhang on 2018/3/1.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBCustomLibraryCameraCell.h"
#import <AVFoundation/AVFoundation.h>
@interface DBCustomLibraryCameraCell ()

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation DBCustomLibraryCameraCell

- (void)dealloc
{
    if ([_session isRunning]) {
        [_session stopRunning];
    }
    _session = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"takePhoto"]];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        CGFloat width = self.height / 3;
        self.imageView.frame = CGRectMake(0, 0, width, width);
        self.imageView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        [self addSubview:self.imageView];
        self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    }
    return self;
}

@end
