//
//
//  UIComponent
//
//  Created by Bob on 14-5-12.
//  Copyright (c) 2014年 guobo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BaseNavigationControllerBlock)(NSString *);

@interface BaseNavigationController : UINavigationController<UINavigationControllerDelegate>

@end
