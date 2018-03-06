//
//  DBCustomLibraryImageCell.m
//  DemoCode
//
//  Created by zheng zhang on 2018/2/26.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBCustomLibraryImageCell.h"
//V
#import "UIButton+DBEnlargeTouchArea.h"

//M
#import "DBImageListModel.h"

@interface DBCustomLibraryImageCell ()

@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) UIImageView *bottomImageView;
@property (strong, nonatomic) UIImageView *VideoImageView;
@property (strong, nonatomic) UIImageView *LiveImageView;
@property (strong, nonatomic) UIView *layerView;    //遮罩层

@property (strong, nonatomic) UILabel *bottomStatusLabel;

@property (nonatomic, assign) PHImageRequestID imageRequestID;
@property (nonatomic, copy) NSString *identifier;

@end

@implementation DBCustomLibraryImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.backImageView];
        [self addSubview:self.bottomImageView];
        [self.bottomImageView addSubview:self.VideoImageView];
        [self.bottomImageView addSubview:self.LiveImageView];
        [self.bottomImageView addSubview:self.bottomStatusLabel];
        [self addSubview:self.seletedBtn];
        [self addSubview:self.layerView];
    }
    return self;
}

- (void)setModel:(DBImageModel *)model
{
    _model = model;
    if (model.mediaType == DBAssetMediaTypeImage) {
        self.bottomImageView.hidden = YES;
        self.seletedBtn.hidden = NO;
        self.layerView.hidden = YES;
    }
    else if (model.mediaType == DBAssetMediaTypeGif)
    {
        self.seletedBtn.hidden = NO;
        self.bottomImageView.hidden = NO;
        self.LiveImageView.hidden = YES;
        self.VideoImageView.hidden = YES;
        self.layerView.hidden = YES;
        self.bottomStatusLabel.text = @"Gif";
    }
    else if (model.mediaType == DBAssetMediaTypeVideo)
    {
        self.seletedBtn.hidden = YES;
        self.bottomImageView.hidden = NO;
        self.LiveImageView.hidden = YES;
        self.VideoImageView.hidden = NO;
        self.bottomStatusLabel.text = @"Video";
        if (self.isChoosed) {
            self.layerView.hidden = NO;
        }
        else
        {
            self.layerView.hidden = YES;
        }
    }
    else if (model.mediaType == DBAssetMediaTypeLivePhoto)
    {
        self.seletedBtn.hidden = NO;
        self.bottomImageView.hidden = NO;
        self.LiveImageView.hidden = NO;
        self.layerView.hidden = YES;
        self.VideoImageView.hidden = YES;
        self.bottomStatusLabel.text = @"Live";
    }
    
    self.seletedBtn.selected = model.isSelected;
    
    WS(weakSelf);
    self.identifier = model.asset.localIdentifier;
    self.imageRequestID = [self requestImageForAsset:model.asset size:kSize(self.width * 1.5, self.height * 1.5) resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
        if ([weakSelf.identifier isEqualToString:model.asset.localIdentifier]) {
            weakSelf.backImageView.image = image;
        }
        
        if (![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) {
            weakSelf.imageRequestID = -1;
        }
    }];
    
}

#pragma mark - 获取asset对应的图片
- (PHImageRequestID)requestImageForAsset:(PHAsset *)asset size:(CGSize)size resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *, NSDictionary *))completion
{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    /**
     resizeMode：对请求的图像怎样缩放。有三种选择：None，默认加载方式；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
     deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。
     这个属性只有在 synchronous 为 true 时有效。
     */
    
    option.resizeMode = resizeMode;//控制照片尺寸
    //    option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;//控制照片质量
    option.networkAccessAllowed = YES;
    
    /*
     info字典提供请求状态信息:
     PHImageResultIsInCloudKey：图像是否必须从iCloud请求
     PHImageResultIsDegradedKey：当前UIImage是否是低质量的，这个可以实现给用户先显示一个预览图
     PHImageResultRequestIDKey和PHImageCancelledKey：请求ID以及请求是否已经被取消
     PHImageErrorKey：如果没有图像，字典内的错误信息
     */
    
    return [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey];
        //不要该判断，即如果该图片在iCloud上时候，会先显示一张模糊的预览图，待加载完毕后会显示高清图
        // && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]
        if (downloadFinined && completion) {
            completion(image, info);
        }
    }];
}

#pragma mark - Action
- (void)btnSelectClick
{
    if (!self.model.selected) {
        [self.seletedBtn.layer addAnimation:GetBtnStatusChangedAnimation() forKey:nil];
    }
    if (self.seleteBlock) {
        self.seleteBlock();
    }
}

static inline CAKeyframeAnimation * GetBtnStatusChangedAnimation() {
    CAKeyframeAnimation *animate = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animate.duration = 0.3;
    animate.removedOnCompletion = YES;
    animate.fillMode = kCAFillModeForwards;
    
    animate.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    return animate;
}

#pragma mark - Getter
- (UIImageView *)backImageView
{
    if (!_backImageView) {
        _backImageView = ({
            UIImageView *view = [[UIImageView alloc] initWithFrame:self.bounds];
            view.clipsToBounds = YES;
            view.contentMode = UIViewContentModeScaleAspectFill;
            view;
        });
    }
    return _backImageView;
}

- (UIImageView *)bottomImageView
{
    if (!_bottomImageView) {
        _bottomImageView = ({
            UIImageView *view = [[UIImageView alloc] initWithFrame:kRect(0, self.height - 15, self.width, 15)];
            view.image = [UIImage imageNamed:@"videoView"];
            view;
        });
    }
    return _bottomImageView;
}

- (UILabel *)bottomStatusLabel
{
    if (!_bottomStatusLabel) {
        _bottomStatusLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:kRect(30, 1, self.width - 35, 12)];
            label.textAlignment = NSTextAlignmentRight;
            label.textColor = UIColorFromRGB(0xffffff);
            label.font = KFont(13, UIFontWeightRegular);
            label;
        });
    }
    return _bottomStatusLabel;
}

- (UIImageView *)VideoImageView
{
    if (!_VideoImageView) {
        _VideoImageView = ({
            UIImageView *view = [[UIImageView alloc] initWithFrame:kRect(5, 1, 16, 12)];
            view.image = [UIImage imageNamed:@"video"];
            view;
        });
    }
    return _VideoImageView;
}

- (UIImageView *)LiveImageView
{
    if (!_LiveImageView) {
        _LiveImageView = ({
            UIImageView *view = [[UIImageView alloc] initWithFrame:kRect(5, -1, 15, 15)];
            view.image = [UIImage imageNamed:@"livePhoto"];
            view;
        });
    }
    return _LiveImageView;
}

- (UIView *)layerView
{
    if (!_layerView) {
        _layerView = ({
            UIView *view = [[UIView alloc] initWithFrame:self.backImageView.bounds];
            view.backgroundColor = UIColorFromRGBA(0xeeeeee, 0.5);
            view.hidden = YES;
            view;
        });
    }
    return _layerView;
}

- (UIButton *)seletedBtn
{
    if (!_seletedBtn) {
        _seletedBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = kRect(self.contentView.width - 26, 5, 23, 23);
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_unselected"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_selected"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnSelectClick) forControlEvents:UIControlEventTouchDown];
            //扩大点击区域
            [btn setEnlargeEdgeWithTop:0 right:0 bottom:20 left:20];
            btn;
        });
    }
    return _seletedBtn;
}

@end
