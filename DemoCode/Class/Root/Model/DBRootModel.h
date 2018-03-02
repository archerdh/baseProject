//
//  DBRootModel.h
//  DemoCode
//
//  Created by zheng zhang on 2018/3/2.
//  Copyright © 2018年 auction. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DBRootItemType) {
    DBRootItemCarmerType            = 0,        //相册
    DBRootItemFaceIDType,                       //face
};

@interface DBRootItemModel : NSObject

@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) DBRootItemType type;

@end

@interface DBRootModel : NSObject

@property (strong, nonatomic) NSArray<DBRootItemModel *> *sourceArr;
@property (strong, nonatomic) NSString *title;

@end
