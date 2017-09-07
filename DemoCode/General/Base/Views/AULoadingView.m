//
//  AULoadingView.m
//  auction
//
//  Created by 谭淇 on 2017/8/29.
//  Copyright © 2017年 auction. All rights reserved.
//

#import "AULoadingView.h"

#define DEFAULT_COLOR UIColorFromRGB(0xeb1010)
#define DEFAULT_SIZE CGSizeMake(kMainBoundsWidth*0.1, kMainBoundsWidth*0.1)
#define DEFAULT_Y_PRESENT 0.382

@interface AULoadingView ()

@end

@implementation AULoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.animationColor = UIColorFromRGB(0xeb1010);
        self.animationSize = DEFAULT_SIZE;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

/**
 Start animation.
 */
- (void)startAnimation
{
    if (self.hidesWhenStopped && self.isHidden) {
        self.hidden = NO;
    }
    if (self.layer.sublayers == nil) {
        [self setUpAnimation];
    }
    self.layer.speed = 1;
    self.animating = YES;
}
/**
 Stop animation.
 */
- (void)stopAnimation
{
    self.layer.sublayers = nil;
    self.animating = NO;
    if (self.hidesWhenStopped && !self.isHidden) {
        self.hidden = YES;
    }
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    [self layoutAnimationLayersInLayer:layer size:self.animationSize];
}
- (void)layoutAnimationLayersInLayer:(CALayer *)layer size:(CGSize)size
{
    CGFloat circleSpacing = 2;
    CGFloat circleSize = (size.width - 2 * circleSpacing) / 3;
    CGFloat x = (layer.bounds.size.width - size.width) / 2;
    CGFloat y = (layer.bounds.size.height - circleSize) * DEFAULT_Y_PRESENT;
    
    for (int i = 0; i < layer.sublayers.count; i++) {
        CALayer *subLayer = layer.sublayers[i];
        CGRect frame = CGRectMake(x + (circleSize + circleSpacing) * i, y, circleSize, circleSize);
        subLayer.frame = frame;
    }
}

- (void)setUpAnimation
{
    self.layer.sublayers = nil;
    [self setUpAnimationInLayer:self.layer size:self.animationSize color:self.animationColor];
}
- (void)setUpAnimationInLayer:(CALayer *)layer size:(CGSize)size color:(UIColor *)color
{
    CGFloat circleSpacing = 2;
    CGFloat circleSize = (size.width - 2 * circleSpacing) / 3;
    CGFloat x = (layer.bounds.size.width - size.width) / 2;
    CGFloat y = (layer.bounds.size.height - circleSize) * DEFAULT_Y_PRESENT;
    CFTimeInterval duration = 0.75;
    CFTimeInterval beginTime = CACurrentMediaTime();
    NSArray *beginTimes = @[@0.12, @0.24, @0.36];
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.2 :0.68 :0.18 :1.08];
    
    // Scale animation
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.keyTimes = @[@0, @0.3, @1];
    scaleAnimation.timingFunctions = @[timingFunction, timingFunction];
    scaleAnimation.values = @[@1, @0.3, @1];
    scaleAnimation.duration = duration;
    
    // Opacity animation
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.keyTimes = @[@0, @0.3, @1];
    opacityAnimation.values = @[@1, @0.2, @1];
    opacityAnimation.duration = duration;
    
    // Aniamtion
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, opacityAnimation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = duration;
    animation.repeatCount = HUGE;
    animation.removedOnCompletion = NO;
    
    // Draw circles
    for (int i = 0; i < 3; i++) {
        CALayer *circle = [self createLayerWithSize:CGSizeMake(circleSize, circleSize) color:color];
        CGRect frame = CGRectMake(x + (circleSize + circleSpacing) * i, y, circleSize, circleSize);
        circle.frame = frame;
        animation.beginTime = beginTime + [beginTimes[i] doubleValue];
        [circle addAnimation:animation forKey:@"animation"];
        [layer addSublayer:circle];
    }
}
- (CALayer *)createLayerWithSize:(CGSize)size color:(UIColor *)color
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path addArcWithCenter:CGPointMake(size.width / 2, size.height / 2) radius:size.width / 2 startAngle:0 endAngle:2 * M_PI clockwise:NO];
    layer.fillColor = color.CGColor;
    layer.backgroundColor = nil;
    layer.path = path.CGPath;
    return layer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
