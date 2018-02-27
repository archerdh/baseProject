//
//  DBCustomLibraryTabCell.m
//  DemoCode
//
//  Created by zheng zhang on 2018/2/27.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBCustomLibraryTabCell.h"

//M
#import "DBImageListModel.h"

@interface DBCustomLibraryTabCell ()

@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UILabel *titleLabel;

@property (nonatomic, copy) NSString *identifier;

@end

@implementation DBCustomLibraryTabCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)setModel:(DBImageListModel *)model
{
    _model = model;
    self.identifier = model.headImageAsset.localIdentifier;
    
    NSString *msgStr = [NSString stringWithFormat:@"%@  (%li)",model.title, model.count];
    
    NSDictionary *attDict = @{NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:msgStr];
    
    [attributedStr addAttributes:attDict range:[msgStr rangeOfString:[NSString stringWithFormat:@"(%li)", model.count]]];
    
    self.titleLabel.attributedText = attributedStr;
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    /**
     resizeMode：对请求的图像怎样缩放。有三种选择：None，默认加载方式；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
     deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。
     这个属性只有在 synchronous 为 true 时有效。
     */
    
    option.resizeMode = PHImageRequestOptionsResizeModeFast;//控制照片尺寸
    //    option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;//控制照片质量
    option.networkAccessAllowed = YES;
    
    /*
     info字典提供请求状态信息:
     PHImageResultIsInCloudKey：图像是否必须从iCloud请求
     PHImageResultIsDegradedKey：当前UIImage是否是低质量的，这个可以实现给用户先显示一个预览图
     PHImageResultRequestIDKey和PHImageCancelledKey：请求ID以及请求是否已经被取消
     PHImageErrorKey：如果没有图像，字典内的错误信息
     */
    WS(weakSelf);
    [[PHCachingImageManager defaultManager] requestImageForAsset:model.headImageAsset targetSize:kSize(self.contentView.height * 2.5, self.contentView.height * 2.5) contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey];
        //不要该判断，即如果该图片在iCloud上时候，会先显示一张模糊的预览图，待加载完毕后会显示高清图
        // && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]
        if (downloadFinined) {
            if ([weakSelf.identifier isEqualToString:model.headImageAsset.localIdentifier]) {
                weakSelf.headImageView.image = image?:[UIImage imageNamed:@"defaultphoto"];
            }
        }
    }];
}

#pragma mark - getter
- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = ({
            UIImageView *view = [[UIImageView alloc] initWithFrame:kRect(12, 0, 63, 63)];
            view.centerY = self.contentView.height / 2;
            view.contentMode = UIViewContentModeScaleAspectFit;
            view.clipsToBounds = YES;
            view;
        });
    }
    return _headImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:kRect(self.headImageView.right + 8, 0, kMainBoundsWidth - 50 - self.headImageView.right, 25)];
            label.centerY = self.headImageView.centerY;
            label.font = KFont(13, UIFontWeightRegular);
            label.textColor = UIColorFromRGB(0x000000);
            label;
        });
    }
    return _titleLabel;
}

@end
