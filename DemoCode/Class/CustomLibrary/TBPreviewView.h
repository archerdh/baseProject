//
//  TBPreviewView.h
//  StarTuBe
//
//  Created by zhangzheng on 16/5/16.
//  Copyright © 2016年 StarShow. All rights reserved.
//  

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol TBPreviewViewDelegate <NSObject>
@optional
- (void)tappedToFocusAtPoint:(CGPoint)point;
- (void)tappedToExposeAtPoint:(CGPoint)point;
- (void)tappedToResetFocusAndExposure;

@end

@interface TBPreviewView : UIView

@property (strong, nonatomic) AVCaptureSession *session;
@property (weak, nonatomic) id<TBPreviewViewDelegate> delegate;

@property (nonatomic) BOOL tapToFocusEnabled;
@property (nonatomic) BOOL tapToExposeEnabled;

- (void)routeView;

@end
