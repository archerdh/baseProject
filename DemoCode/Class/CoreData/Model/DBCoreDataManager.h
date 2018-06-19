//
//  DBCoreDataManager.h
//  DemoCode
//
//  Created by zhangzheng on 2018/6/19.
//  Copyright © 2018年 auction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBCoreDataModel.h"
#import <CoreData/CoreData.h>

@interface DBCoreDataManager : NSObject

+ (NSManagedObject *)createManagedObjectWithUserModel:(DBCoreDataModel *)userModel;
+ (NSArray *)getManagedObjectAllUser;

@end
