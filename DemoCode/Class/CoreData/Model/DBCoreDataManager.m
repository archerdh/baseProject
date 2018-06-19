//
//  DBCoreDataManager.m
//  DemoCode
//
//  Created by zhangzheng on 2018/6/19.
//  Copyright © 2018年 auction. All rights reserved.
//

#import "DBCoreDataManager.h"
#import "AppDelegate.h"
#import <objc/objc.h>
#import <objc/runtime.h>
#import "AppDelegate.h"

@interface DBCoreDataManager ()

@property (strong, nonatomic) NSManagedObject *manageOBJ;

@end

@implementation DBCoreDataManager
static DBCoreDataManager *_instance;
static NSArray *_propertys;
static NSString * ENTITY_NAME = @"UserModel";

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!_instance)
        {
            _instance = [DBCoreDataManager new];
        }
    });
    return _instance;
}

+ (void)load
{
    _propertys = [self getAllPropertys];
}

+ (NSArray *)getAllPropertys
{
    NSMutableArray *arr = [NSMutableArray array];
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList(DBCoreDataModel.class, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithFormat:@"%s", property_getName(property)];
        [arr addObject:name];
    }
    free(properties);
    return arr;
}

//增
+ (NSManagedObject *)createManagedObjectWithUserModel:(DBCoreDataModel *)userModel
{
    NSError *error;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.manageObjContext;
    
    NSManagedObject *enti = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_NAME inManagedObjectContext:context];
    [self transformUserModel:userModel toEntity:enti];
    
    if ([context save:&error]) {
        return enti;
    }
    else
    {
        return nil;
    }
}

+ (NSArray *)getManagedObjectAllUser
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:ENTITY_NAME];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.manageObjContext;

    NSArray *resArray = [context executeFetchRequest:request error:nil];
    return resArray;
}

+ (void)transformUserModel:(DBCoreDataModel *)model toEntity:(NSManagedObject *)entity
{
    for (NSString *key in _propertys) {
        NSString *transforstr = [NSString stringWithFormat:@"%@", [model valueForKey:key]];
        [entity setValue:transforstr forKey:key];
    }
}

@end
