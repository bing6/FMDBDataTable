//
//  FMDataTableSchema.m
//  FMDBDataTableDemo
//
//  Created by bing.hao on 15/8/28.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import "FMDataTableSchema.h"
#import "NSObject+runtime.h"

#define DB_TYPE_TEXT   @"text"
#define DB_TYPE_NUMBER @"integer"
#define DB_TYPE_BLOB   @"blob"
#define DB_TYPE_DATE   @"date"

NSDictionary * newField(NSString *name, NSString *type)
{
    static NSDictionary *__map;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __map = @{ @"T@\"NSString\"":DB_TYPE_TEXT,
                   @"T@\"NSNumber\"":DB_TYPE_NUMBER,
                   @"T@\"NSDate\"":DB_TYPE_DATE,
                   @"T@\"NSData\"":DB_TYPE_NUMBER,
                   @"Ti":DB_TYPE_NUMBER,
                   @"T^i":DB_TYPE_NUMBER,
                   @"Tf":DB_TYPE_NUMBER,
                   @"Tq":DB_TYPE_NUMBER,
                   @"Td":DB_TYPE_NUMBER };
    });
    NSString *dbType = [__map objectForKey:type];
    if (dbType) {
        return @{ DTS_F_OBJ_NAME:name, DTS_F_NAME:name, DTS_F_TYPE:dbType };
    }
    return nil;
}

@implementation FMDataTableSchema

+ (instancetype)create:(Class)ctype
{
    NSMutableArray * fields = [NSMutableArray new];
    [NSObject enumeratePropertiesWithClassType:ctype usingBlick:^(BOOL read, NSString *name, NSString *type, NSArray *attrs) {
        NSDictionary * item = nil;
        if (!read && (item = newField(name, type))) {
            [fields addObject:item];
        }
    }];
    return [[FMDataTableSchema alloc] initWithClassName:NSStringFromClass(ctype) fields:fields];
}

- (instancetype)initWithClassName:(NSString *)className fields:(NSArray *)fields
{
    self = [super init];
    if (self) {
        
        NSMutableArray * tmp = [NSMutableArray new];
        [tmp addObject:@{ DTS_F_OBJ_NAME:@"pid", DTS_F_NAME:@"pid", DTS_F_TYPE:@"text" }];
        [tmp addObjectsFromArray:fields];
        [tmp addObject:@{ DTS_F_OBJ_NAME:@"createdAt", DTS_F_NAME:@"createdAt", DTS_F_TYPE:@"integer" }];
        [tmp addObject:@{ DTS_F_OBJ_NAME:@"updatedAt", DTS_F_NAME:@"updatedAt", DTS_F_TYPE:@"integer" }];
        
        _className = className;
        _tableName = className;
        _fields    = [NSArray arrayWithArray:tmp];
    }
    return self;
}

- (NSString *)fetchFiledNameWithIndex:(NSInteger)index
{
    return [[_fields objectAtIndex:index] objectForKey:DTS_F_NAME];
}

- (NSString *)fetchFiledTypeWithIndex:(NSInteger)index
{
    return [[_fields objectAtIndex:index] objectForKey:DTS_F_TYPE];
}

@end
