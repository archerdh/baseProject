//
//  DBLibraryConfig.h
//  DemoCode
//
//  Created by zheng zhang on 2018/2/28.
//  Copyright © 2018年 auction. All rights reserved.
//

#import <Foundation/Foundation.h>

//录制视频及拍照分辨率
typedef NS_ENUM(NSUInteger, DBCaptureSessionPreset) {
    DBCaptureSessionPreset325x288,
    DBCaptureSessionPreset640x480,
    DBCaptureSessionPreset1280x720,
    DBCaptureSessionPreset1920x1080,
    DBCaptureSessionPreset3840x2160,
};

//导出视频类型
typedef NS_ENUM(NSUInteger, DBExportVideoType) {
    //default
    DBExportVideoTypeMov,
    DBExportVideoTypeMp4,
};

@interface DBLibraryConfig : NSObject

/**
 默认相册配置
 */
+ (instancetype)defaultPhotoConfiguration;

/**
 最大选择数 默认9张，最小 1
 */
@property (nonatomic, assign) NSInteger maxSelectCount;

/**
 cell的圆角弧度 默认为0
 */
@property (nonatomic, assign) CGFloat cellCornerRadio;

/**
 是否允许选择照片 默认YES
 */
@property (nonatomic, assign) BOOL allowSelectImage;

/**
 是否允许选择视频 默认YES
 */
@property (nonatomic, assign) BOOL allowSelectVideo;

/**
 是否允许Force Touch功能 默认YES
 */
@property (nonatomic, assign) BOOL allowForceTouch;

/**
 是否允许编辑图片，选择一张时候才允许编辑，默认YES
 */
@property (nonatomic, assign) BOOL allowEditImage;

/**
 是否允许编辑视频，选择一张时候才允许编辑，默认NO
 */
@property (nonatomic, assign) BOOL allowEditVideo;

/**
 是否允许选择原图，默认YES
 */
@property (nonatomic, assign) BOOL allowSelectOriginal;

/**
 编辑视频时最大裁剪时间，单位：秒，默认10s 且最低10s
 
 @discussion 当该参数为10s时，所选视频时长必须大于等于10s才允许进行编辑
 */
@property (nonatomic, assign) NSInteger maxEditVideoTime;

/**
 允许选择视频的最大时长，单位：秒， 默认 120s
 */
@property (nonatomic, assign) NSInteger maxVideoDuration;

/**
 是否允许滑动选择 默认 YES
 */
@property (nonatomic, assign) BOOL allowSlideSelect;

/**
 是否在相册内部拍照按钮上面实时显示相机俘获的影像 默认 YES
 */
@property (nonatomic, assign) BOOL showCaptureImageOnTakePhotoBtn;

/**
 是否升序排列，默认升序 YES
 */
@property (nonatomic, assign) BOOL sortAscending;

/**
 最大录制时长，默认 10s，最小为 1s
 */
@property (nonatomic, assign) NSInteger maxRecordDuration;

/**
 视频清晰度，默认DBCaptureSessionPreset1280x720
 */
@property (nonatomic, assign) DBCaptureSessionPreset sessionPreset;

/**
 录制视频及编辑视频时候的视频导出格式，默认DBExportVideoTypeMov
 */
@property (nonatomic, assign) DBExportVideoType exportVideoType;

@end
