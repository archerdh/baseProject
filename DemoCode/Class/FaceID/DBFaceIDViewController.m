//
//  DBFaceIDViewController.m
//  DemoCode
//
//  Created by zheng zhang on 2018/3/2.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBFaceIDViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface DBFaceIDViewController ()

@end

@implementation DBFaceIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    LAContext *context = [[LAContext alloc]init];
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"验证面容以进入" reply:^(BOOL success, NSError * _Nullable error) {
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
