//
//  DBCustomLibraryForceTouchViewController.m
//  DemoCode
//
//  Created by zheng zhang on 2018/2/27.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBCustomLibraryForceTouchViewController.h"
#import <PhotosUI/PhotosUI.h>
#import "DBImageListModel.h"

@interface DBCustomLibraryForceTouchViewController ()

@end

@implementation DBCustomLibraryForceTouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithWhite:.8 alpha:.5];
    if (self.model.mediaType == DBAssetMediaTypeImage) {
        [self loadNormalImage];
    }
    else if (self.model.mediaType == DBAssetMediaTypeLivePhoto)
    {
        [self loadLivePhoto];
    }
    else if (self.model.mediaType == DBAssetMediaTypeGif)
    {
        [self loadGifImage];
    }
    else if (self.model.mediaType == DBAssetMediaTypeVideo)
    {
        [self loadVideo];
    }
}

#pragma mark - 加载静态图
- (void)loadNormalImage
{
    __block UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    CGSize size = [self getSize];
    imageView.frame = (CGRect){CGPointZero, size};
    [self.view addSubview:imageView];
    
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
    
    [[PHCachingImageManager defaultManager] requestImageForAsset:self.model.asset targetSize:CGSizeMake(size.width*2, size.height*2)  contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey];
        //不要该判断，即如果该图片在iCloud上时候，会先显示一张模糊的预览图，待加载完毕后会显示高清图
        // && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]
        if (downloadFinined) {
            imageView.image = image;
        }
    }];
}

#pragma mark - 加载livePhoto
- (void)loadLivePhoto
{
    PHLivePhotoView *lpView = [[PHLivePhotoView alloc] init];
    lpView.contentMode = UIViewContentModeScaleAspectFit;
    lpView.frame = (CGRect){CGPointZero, [self getSize]};
    [self.view addSubview:lpView];
    
    PHLivePhotoRequestOptions *option = [[PHLivePhotoRequestOptions alloc] init];
    option.version = PHImageRequestOptionsVersionCurrent;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    option.networkAccessAllowed = YES;
    
    [[PHCachingImageManager defaultManager] requestLivePhotoForAsset:self.model.asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:option resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
        lpView.livePhoto = livePhoto;
        [lpView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleFull];
    }];
}

#pragma mark - 加载video
- (void)loadVideo
{
    AVPlayerLayer *playLayer = [[AVPlayerLayer alloc] init];
    playLayer.frame = (CGRect){CGPointZero, [self getSize]};
    [self.view.layer addSublayer:playLayer];
    
    [[PHCachingImageManager defaultManager] requestPlayerItemForVideo:self.model.asset options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
            playLayer.player = player;
            [player play];
        });
    }];
}

#pragma mark - 加载gif
- (void)loadGifImage
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = (CGRect){CGPointZero, [self getSize]};
    [self.view addSubview:imageView];
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
    option.networkAccessAllowed = YES;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    WS(weakSelf);
    [[PHImageManager defaultManager] requestImageDataForAsset:self.model.asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && imageData) {
            imageView.image = [weakSelf sd_animatedGIFWithData:imageData];
        }
    }];
}

- (UIImage *)sd_animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    } else {
        NSMutableArray *images = [NSMutableArray array];
        
        NSTimeInterval duration = 0.0f;
        
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            
            duration += [self sd_frameDurationAtIndex:i source:source];
            
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            
            CGImageRelease(image);
        }
        
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    
    CFRelease(source);
    
    return animatedImage;
}

- (float)sd_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    } else {
        
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    // Many annoying ads specify a 0 duration to make an image flash as quickly as possible.
    // We follow Firefox's behavior and use a duration of 100 ms for any frames that specify
    // a duration of <= 10 ms. See <rdar://problem/7689300> and <http://webkit.org/b/36082>
    // for more information.
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}

#pragma mark - Others
- (CGSize)getSize
{
    CGFloat w = MIN(self.model.asset.pixelWidth, kMainBoundsWidth);
    CGFloat h = w * self.model.asset.pixelHeight / self.model.asset.pixelWidth;
    if (isnan(h)) return CGSizeZero;
    
    if (h > kMainBoundsHeight) {
        h = kMainBoundsHeight;
        w = h * self.model.asset.pixelWidth / self.model.asset.pixelHeight;
    }
    
    return CGSizeMake(w, h);
}


@end
