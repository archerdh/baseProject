//
//  DBLibraryConfig.m
//  DemoCode
//
//  Created by zheng zhang on 2018/2/28.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBLibraryConfig.h"

@implementation DBLibraryConfig


+ (instancetype)defaultPhotoConfiguration
{
    DBLibraryConfig *configuration = [DBLibraryConfig new];
    
    configuration.maxSelectCount = 9;
    configuration.cellCornerRadio = .0;
    configuration.allowSelectImage = YES;
    configuration.allowSelectVideo = YES;
    configuration.allowForceTouch = YES;
    configuration.allowEditImage = YES;
    configuration.allowEditVideo = NO;
    configuration.allowSelectOriginal = YES;
    configuration.maxEditVideoTime = 10;
    configuration.maxVideoDuration = 120;
    configuration.allowSlideSelect = YES;
    configuration.showCaptureImageOnTakePhotoBtn = YES;
    configuration.sortAscending = YES;
    configuration.maxRecordDuration = 10;
    configuration.sessionPreset = DBCaptureSessionPreset1280x720;
    configuration.exportVideoType = DBExportVideoTypeMov;
    
    return configuration;
}

- (void)setMaxSelectCount:(NSInteger)maxSelectCount
{
    _maxSelectCount = MAX(maxSelectCount, 1);
}

- (void)setMaxEditVideoTime:(NSInteger)maxEditVideoTime
{
    _maxEditVideoTime = MAX(maxEditVideoTime, 10);
}

- (void)setMaxRecordDuration:(NSInteger)maxRecordDuration
{
    _maxRecordDuration = MAX(maxRecordDuration, 1);
}

@end
