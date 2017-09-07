//
//  BaseView.h
//  Hands-Seller
//
//  Created by guobo on 14-4-18.
//  Copyright (c) 2014年 李 家伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView

+(id)loadFromXib;

-(void)viewLayoutWithData:(id)data;

@end
