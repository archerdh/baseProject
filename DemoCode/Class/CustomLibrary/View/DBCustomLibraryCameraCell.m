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
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutPut;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

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

- (void)restartCapture
{
    [self.session stopRunning];
    [self startCapture];
}

- (void)startCapture
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (![UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] ||
        status == AVAuthorizationStatusRestricted ||
        status == AVAuthorizationStatusDenied) {
        return;
    }
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (!granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.session stopRunning];
                [self.previewLayer removeFromSuperlayer];
            });
        }
    }];
    
    if (self.session && [self.session isRunning]) {
        return;
    }
    
    [self.session stopRunning];
    [self.session removeInput:self.videoInput];
    [self.session removeOutput:self.stillImageOutPut];
    self.session = nil;
    [self.previewLayer removeFromSuperlayer];
    self.previewLayer = nil;
    
    self.session = [[AVCaptureSession alloc] init];
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:[self backCamera] error:nil];
    self.stillImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    
    //这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    NSDictionary *dicOutputSetting = [NSDictionary dictionaryWithObject:AVVideoCodecJPEG forKey:AVVideoCodecKey];
    [self.stillImageOutPut setOutputSettings:dicOutputSetting];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutPut]) {
        [self.session addOutput:self.stillImageOutPut];
    }
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.contentView.layer setMasksToBounds:YES];
    
    self.previewLayer.frame = self.contentView.layer.bounds;
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.contentView.layer insertSublayer:self.previewLayer atIndex:0];
    
    [self.session startRunning];
}

- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

@end
