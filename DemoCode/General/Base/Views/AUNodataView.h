//
//  AUNodataView.h
//  auction
//
//  Created by zheng zhang on 2017/8/2.
//  Copyright © 2017年 auction. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    /***********  新的枚举往末尾添加  **************/
    AUNodataViewNormalType            = 200,        //无数据
    AUNodataViewNoFansType,                        //我无粉丝
    AUNodataViewNoFollowType,                      //我无关注
    AUNodataViewNoMesssageType,                      //无记录
    AUNodataViewNoDraftType,                        //无草稿
    AUNodataViewOtherNoFansType,                    //TA无粉丝
    AUNodataViewOtherNoFollowType,                   //TA无关注
    AUNodataViewNoContentType,                        //无内容
    AUNodataViewDeleteType,                               //该内容已被删除
    AUNodataViewUserNoPostType,                             //Ta未发布任何动态
    AUNodataViewMyNoPostType,                               //我的未发布任何动态
    
    AUNodataViewSearchNoRecommendType,                               // 搜索 无已关注全部明星 无推介数据
    AUNodataViewUserNoRecordType,                               // 个人无已获奖记录
} AUNodataViewType;

@interface AUNodataView : UIView

- (id)initNoDataView;

@property (assign, nonatomic) AUNodataViewType type;
@property (assign, nonatomic) BOOL viewHidden;

@end
