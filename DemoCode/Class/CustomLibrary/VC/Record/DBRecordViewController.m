//
//  DBRecordViewController.m
//  DemoCode
//
//  Created by zheng zhang on 2018/6/13.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBRecordViewController.h"

//
#import <AVFoundation/AVFoundation.h>

@interface DBRecordViewController ()

//输入、输出的中间件
@property (nonatomic, strong) AVCaptureSession *captureSession;/**<捕捉会话*/
//input
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;/**<视频输入流*/
@property (nonatomic, strong) AVCaptureDeviceInput *audioInput;/**<音频输入流*/
@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutPut;/**<照片输出流对象*/

//output
@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutPut;

//预览图层，显示相机拍摄到的画面
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation DBRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.captureSession = ({
        //分辨率设置
        AVCaptureSession *session = [[AVCaptureSession alloc] init];
        if ([session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
            [session setSessionPreset:AVCaptureSessionPresetHigh];
        }
        session;
    });
    
    //照片输出流
    self.imageOutPut = [[AVCaptureStillImageOutput alloc] init];
    //这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    NSDictionary *dicOutputSetting = [NSDictionary dictionaryWithObject:AVVideoCodecJPEG forKey:AVVideoCodecKey];
    [self.imageOutPut setOutputSettings:dicOutputSetting];
    
    //相机画面输入流
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:[self backCamera] error:nil];
    
    //音频输入流
    AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio].firstObject;
    self.audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:nil];
    
    //视频输出流
    //设置视频格式
    NSString *preset = [self transformSessionPreset];
    if ([self.captureSession canSetSessionPreset:preset]) {
        self.captureSession.sessionPreset = preset;
    } else {
        self.captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    self.movieFileOutPut = [[AVCaptureMovieFileOutput alloc] init];
    //将视频及音频输入流添加到session
    if ([self.captureSession canAddInput:self.videoInput]) {
        [self.captureSession addInput:self.videoInput];
    }
    if ([self.captureSession canAddInput:self.audioInput]) {
        [self.captureSession addInput:self.audioInput];
    }
    //将输出流添加到session
    if ([self.captureSession canAddOutput:self.imageOutPut]) {
        [self.captureSession addOutput:self.imageOutPut];
    }
    if ([self.captureSession canAddOutput:self.movieFileOutPut]) {
        [self.captureSession addOutput:self.movieFileOutPut];
    }
    
    //预览层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.view.layer setMasksToBounds:YES];
    self.previewLayer.frame = self.view.layer.bounds;
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
    [self.captureSession startRunning];
}

#pragma mark -
- (NSString *)transformSessionPreset
{
    switch (self.sessionPreset) {
        case DBCamerCaptureSessionPreset325x288:
            return AVCaptureSessionPreset352x288;
            
        case DBCamerCaptureSessionPreset640x480:
            return AVCaptureSessionPreset640x480;
            
        case DBCamerCaptureSessionPreset1280x720:
            return AVCaptureSessionPreset1280x720;
            
        case DBCamerCaptureSessionPreset1920x1080:
            return AVCaptureSessionPreset1920x1080;
            
        case DBCamerCaptureSessionPreset3840x2160:
            return AVCaptureSessionPreset3840x2160;
    }
}

#pragma mark - 切换前后相机
//切换摄像头
- (void)btnToggleCameraAction
{
//    NSUInteger cameraCount = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].count;
//    if (cameraCount > 1) {
//        NSError *error;
//        AVCaptureDeviceInput *newVideoInput;
//        AVCaptureDevicePosition position = self.videoInput.device.position;
//        if (position == AVCaptureDevicePositionBack) {
//            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
//        } else if (position == AVCaptureDevicePositionFront) {
//            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:&error];
//        } else {
//            return;
//        }
//
//        if (newVideoInput) {
//            [self.session beginConfiguration];
//            [self.session removeInput:self.videoInput];
//            if ([self.session canAddInput:newVideoInput]) {
//                [self.session addInput:newVideoInput];
//                self.videoInput = newVideoInput;
//            } else {
//                [self.session addInput:self.videoInput];
//            }
//            [self.session commitConfiguration];
//        } else if (error) {
//            NSLog(@"切换前后摄像头失败");
//        }
//    }
}

- (AVCaptureDevice *)frontCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
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
