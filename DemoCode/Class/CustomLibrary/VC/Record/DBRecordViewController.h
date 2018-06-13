//
//  DBRecordViewController.h
//  DemoCode
//
//  Created by zheng zhang on 2018/6/13.
//  Copyright © 2018年 auction. All rights reserved.
//

#import <UIKit/UIKit.h>

//录制视频及拍照分辨率
typedef NS_ENUM(NSUInteger, DBCamerCaptureSessionPreset) {
    DBCamerCaptureSessionPreset325x288,
    DBCamerCaptureSessionPreset640x480,
    DBCamerCaptureSessionPreset1280x720,
    DBCamerCaptureSessionPreset1920x1080,
    DBCamerCaptureSessionPreset3840x2160,
};

@interface DBRecordViewController : UIViewController

@property (assign, nonatomic) DBCamerCaptureSessionPreset sessionPreset;

@end
