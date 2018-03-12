//
//
//  UIComponent
//
//  Created by Bob on 14-5-12.
//  Copyright (c) 2014年 guobo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBNavAnimationManager.h"

typedef void (^BaseNavigationControllerBlock)(NSString *);

@interface BaseNavigationController : UINavigationController<UINavigationControllerDelegate>

/**
 *  小红书 Nav push
 *
 *  @param viewController 目标 VC
 *  @param imageView      动画ImageView
 *  @param desRect        imageView在 目标VC中的 rect
 *  @param delegate       目标VC 可能所需要实现的代理
 */
-(void)pushViewController:(UIViewController *)viewController withImageView:(UIImageView*)imageView desRect:(CGRect)desRect delegate:(id <DBNavAnimationManagerDelegate>) delegate;

@end
