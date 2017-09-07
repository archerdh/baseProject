//
//  AULoadingView.h
//  auction
//
//  Created by 谭淇 on 2017/8/29.
//  Copyright © 2017年 auction. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AULoadingView : UIView

@property (strong, nonatomic) UIColor *animationColor;

@property (assign, nonatomic) CGSize animationSize;

@property (assign, nonatomic, getter=isAnimating) BOOL animating;

@property (assign, nonatomic) BOOL hidesWhenStopped;

- (void)startAnimation;
- (void)stopAnimation;

@end
