//
//  AUFailView.h
//  auction
//
//  Created by zheng zhang on 2017/8/2.
//  Copyright © 2017年 auction. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    /***********  新的枚举往末尾添加  **************/
    AUFailViewType_Normal,        // 默认失败
    AUFailViewType_LoginExpired, //  登陆过期
}AUFailViewType;

@interface AUFailView : UIView

@property (nonatomic,assign) AUFailViewType type;
@property (assign, nonatomic) BOOL viewHidden;

@end
