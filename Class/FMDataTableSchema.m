//
//  FMDataTableSchema.m
//  FMDBDataTableDemo
//
//  Created by bing.hao on 15/8/28.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import "FMDataTableSchema.h"
#import <objc/runtime.h>

@implementation FMDataTableSchema

+ (instancetype)create:(Class)classType
{
    //获得类属性的数量
    u_int count;
    objc_property_t *allProperties = class_copyPropertyList(classType, &count);
    
    NSMutableArray * fs = [NSMutableArray new];
    
    for (int i = 0; i < count; i++) {
        NSString * attr = [NSString stringWithFormat:@"%s", property_getAttributes(allProperties[i])];
        //判断是否为只读属性,只读类型不需要管理
        if ([[attr componentsSeparatedByString:@","] indexOfObject:@"R"] != NSIntegerMax) {
            continue;
        }
        //获取属性名与属性类型
        NSString *name = [NSString stringWithUTF8String:property_getName(allProperties[i])];
        NSRange   r    = [attr rangeOfString:@","];
        NSString *oct  = [attr substringToIndex:r.location];
        NSString *dbt  = nil;
        if ([oct isEqualToString:@"T@\"NSString\""]) {
            dbt = @"TEXT";
        } else if ([oct isEqualToString:@"T@\"NSNumber\""]) {
            dbt = @"INTEGER";
        } else if ([oct isEqualToString:@"T@\"NSDate\""]) {
            dbt = @"DATE";
        }  else if ([oct isEqualToString:@"T@\"NSData\""]) {
            dbt = @"BLOB";
        } else if ([oct isEqualToString:@"Ti"] || [oct isEqualToString:@"T^i"]){
            dbt = @"INTEGER";
        } else if ([oct isEqualToString:@"Tf"]) {
            dbt = @"INTEGER";
        } else if ([oct isEqualToString:@"Tq"]) {
            dbt = @"INTEGER";
        } else if ([oct isEqualToString:@"Td"]) {
            dbt = @"INTEGER";
        } else {
            continue;
        }
        [fs addObject:@{ DTS_F_OBJ_NAME:name, DTS_F_NAME:name, DTS_F_TYPE:dbt }];
    }
    free(allProperties);
    
    return [[FMDataTableSchema alloc] initWithClassName:NSStringFromClass(classType) fields:fs];
}

- (instancetype)initWithClassName:(NSString *)className fields:(NSArray *)fields
{
    self = [super init];
    if (self) {
        
        NSMutableArray * tmp = [NSMutableArray new];
        [tmp addObject:@{ DTS_F_OBJ_NAME:@"pid", DTS_F_NAME:@"pid", DTS_F_TYPE:@"text" }];
        [tmp addObject:@{ DTS_F_OBJ_NAME:@"createdAt", DTS_F_NAME:@"createdAt", DTS_F_TYPE:@"integer" }];
        [tmp addObject:@{ DTS_F_OBJ_NAME:@"updatedAt", DTS_F_NAME:@"updatedAt", DTS_F_TYPE:@"integer" }];
        [tmp addObjectsFromArray:fields];
        
        _className = className;
        _tableName = className;
        _fields    = [NSArray arrayWithArray:tmp];
    }
    return self;
}

@end
