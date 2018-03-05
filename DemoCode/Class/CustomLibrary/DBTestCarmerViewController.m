//
//  DBTestCarmerViewController.m
//  DemoCode
//
//  Created by zheng zhang on 2018/3/5.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBTestCarmerViewController.h"
#import "TBCameraController.h"
#import "TBPreviewView.h"
@interface DBTestCarmerViewController ()<TBPreviewViewDelegate, TBCameraControllerDelegate>

@property (strong, nonatomic) TBCameraController *cameraController;
@property (strong, nonatomic) TBPreviewView *previewView;

@end

@implementation DBTestCarmerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.cameraController = [[TBCameraController alloc] init];
    self.previewView = [[TBPreviewView alloc] initWithFrame:self.view.bounds];

    NSError *error;
    if ([self.cameraController setupSession:&error]) {
        [self.previewView setSession:self.cameraController.captureSession];
        self.previewView.delegate = self;
        
        [self.cameraController startSession];
    } else {
        AULog(@"Error: %@", [error localizedDescription]);
    }
    self.previewView.tapToFocusEnabled = self.cameraController.cameraSupportsTapToFocus;
    self.previewView.tapToExposeEnabled = self.cameraController.cameraSupportsTapToExpose;
    [self.view addSubview:self.previewView];
}

#pragma mark - TBCameraControllerDelegate
- (void)deviceConfigurationFailedWithError:(NSError *)error
{
    
}

- (void)mediaCaptureFailedWithError:(NSError *)error
{
    
}

- (void)assetLibraryWriteFailedWithError:(NSError *)error
{
    
}

#pragma mark - TBPreviewViewDelegate
- (void)tappedToFocusAtPoint:(CGPoint)point {
    [self.cameraController focusAtPoint:point];
}

- (void)tappedToExposeAtPoint:(CGPoint)point {
    [self.cameraController exposeAtPoint:point];
}

- (void)tappedToResetFocusAndExposure {
    [self.cameraController resetFocusAndExposureModes];
}
@end
