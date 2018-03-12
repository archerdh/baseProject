//
//  DBNavAnimationManager.h
//  DemoCode
//
//  Created by zheng zhang on 2018/3/12.
//  Copyright © 2018年 auction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol DBNavAnimationManagerDelegate <NSObject>

-(void)didFinishTransition;

@end

@interface DBNavAnimationManager : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, assign) CGRect origionRect;
@property (nonatomic, assign) CGRect desRect;
@property (nonatomic, assign) BOOL isPush;
@property (nonatomic, weak) id <DBNavAnimationManagerDelegate> delegate;

@end
