//
//  FMDataTable.m
//  FMDBDataTableDemo
//
//  Created by bing.hao on 15/8/28.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import "FMDataTable.h"
#import "NSObject+runtime.h"

@implementation FMDataTable

+ (void)initialize
{
    //initialize会调用二次,第一次基类调用,第二次子类调用,那么我们需要在子类
    //调用时检查表结构是否建立
    if ([FMDataTable class] != [self class]) {
        [DTM_SHARE checkModelIsReady:[self class]];
    }
}

- (NSString *)GUID
{
    CFUUIDRef   uuid_ref        = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref = CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)pid
{
    if (_pid == nil) {
        _pid = [self GUID];
    }
    return _pid;
}

- (instancetype)initWithDict:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        FMDataTableSchema *dts = [DTM_SHARE fetchSchema:[self class]];
        for (NSDictionary *entry in dts.fields) {
            NSString * name = entry[DTS_F_NAME];
            NSObject * value = [data objectForKey:name];
            if (value && ![value isEqual:[NSNull null]]) {
                if ([self isSet:[entry objectForKey:DTS_F_OBJ_TYPE]]) {
             
                    id data = [NSJSONSerialization JSONObjectWithData:[(NSString *)value dataUsingEncoding:NSUTF8StringEncoding]
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:nil];
                    if (data) {
                        [self setValue:data forKeyPath:[entry objectForKey:DTS_F_OBJ_NAME]];
                    }
                } else {
                    [self setValue:value forKeyPath:[entry objectForKey:DTS_F_OBJ_NAME]];
                }
            }
        }
    }
    return self;
}

+ (NSArray *)order:(NSString *)order
{
    return [self order:order limit:nil offset:nil];
}

+ (NSArray *)order:(NSString *)order limit:(NSNumber *)limit offset:(NSNumber *)offset
{
    return [self where:nil args:nil order:order limit:limit offset:offset];
}

+ (NSArray *)where:(NSString *)where args:(NSArray *)args
{
    return [self where:where args:args order:@"createdAt DESC" limit:nil offset:nil];
}

+ (NSArray *)where:(NSString *)where args:(NSArray *)args limit:(NSNumber *)limit offset:(NSNumber *)offset
{
    return [self where:where args:args order:@"createdAt DESC" limit:limit offset:offset];
}

+ (NSArray *)where:(NSString *)where args:(NSArray *)args order:(NSString *)order limit:(NSNumber *)limit offset:(NSNumber *)offset
{
    FMDataTableStatement * statement = [DTM_SHARE fetchStatement:[self class]];
    NSMutableString * ms = [NSMutableString stringWithString:statement.s_select];
    
    if (where) {
        if ([[where lowercaseString] hasPrefix:@"where"] ) {
            [ms appendString:where];
            [ms appendString:@" "];
        } else {
            [ms appendFormat:@"where %@ ", where];
        }
    }
    if (order) {
        if ([[order lowercaseString] hasPrefix:@"order"]) {
            [ms appendString:order];
            [ms appendString:@" "];
        } else {
            [ms appendFormat:@"order by %@ ", order];
        }
    }
    if (limit && offset) {
        [ms appendFormat:@"limit %d offset %d", [limit intValue], [offset intValue]];
    } else if (limit && offset == nil) {
        [ms appendFormat:@"limit %d", [limit intValue]];
    } else if (limit == nil && offset) {
        [ms appendFormat:@"limit 20 offset %d", [offset intValue]];
    }
    
    NSMutableArray *result = [NSMutableArray new];
    FMDatabase * db = [DTM_SHARE fetchDatabase:[self class]];
    
    [db open];
    FMResultSet *set = [db executeQuery:ms withArgumentsInArray:args];
    while ([set next]) {
        id newObj = [[self alloc] initWithDict:[set resultDictionary]];
        [result addObject:newObj];
    }
    [db close];
    
    if (DTM_SHARE.logEnabled) {
        NSLog(@"SQL:%@", ms);
    }
    
    return result;
}

+ (id)first:(NSString *)w args:(NSArray *)args
{
    return [[self where:w args:args order:@"createdAt DESC" limit:nil offset:nil] firstObject];
}

+ (NSArray *)executeQuery:(NSString *)query, ...
{
    NSMutableArray *result = [NSMutableArray new];
    
    va_list args;
    va_start(args, query);
    NSString *cmd = [[NSString alloc] initWithFormat:query arguments:args];
    va_end(args);
    
    FMDatabase *db = [DTM_SHARE fetchDatabase:[self class]];
    [db open];
    FMResultSet *set = [db executeQuery:cmd];
    while ([set next]) {
        [result addObject:[set resultDictionary]];
    }
    [db close];
    if (DTM_SHARE.logEnabled) {
        NSLog(@"SQL:%@", cmd);
    }
    return result;
}

+ (void)executeNonQuery:(NSString *)sql, ...
{
    va_list args;
    va_start(args, sql);
    NSString *cmd = [[NSString alloc] initWithFormat:sql arguments:args];
    va_end(args);
    
    FMDatabase *db = [DTM_SHARE fetchDatabase:[self class]];
    [db open];
    [db executeUpdate:cmd];
    [db close];

    if (DTM_SHARE.logEnabled) {
        NSLog(@"SQL:%@", cmd);
    }
}

- (void)save
{
    self.updatedAt = [NSNumber numberWithDouble:[NSDate date].timeIntervalSince1970];
    
    if (self.createdAt == nil) {
        self.createdAt = self.updatedAt;
    }
    
    FMDataTableStatement * statement = [DTM_SHARE fetchStatement:[self class]];

    FMDatabase *db= [DTM_SHARE fetchDatabase:[self class]];
    [db open];
    [db executeUpdate:statement.s_replace withArgumentsInArray:[self toValues]];
    [db close];
    
    if (DTM_SHARE.logEnabled) {
        NSLog(@"SQL:%@", statement.s_replace);
    }
}

//是否为集合
- (BOOL)isSet:(NSString *)ocType {
    if ([ocType isEqualToString:@"T@\"NSDictionary\""] ||
        [ocType isEqualToString:@"T@\"NSMutableDictionary\""] ||
        [ocType isEqualToString:@"T@\"NSArray\""] ||
        [ocType isEqualToString:@"T@\"NSMutableArray\""]) {
        return YES;
    }
    return NO;
}

- (NSArray *)toValues
{
    FMDataTableSchema *dts = [DTM_SHARE fetchSchema:[self class]];
    NSMutableArray * ma = [NSMutableArray new];
    for (NSDictionary *entry in dts.fields) {
        id obj = [self valueForKeyPath:[entry objectForKey:DTS_F_OBJ_NAME]];
        if (obj == nil) {
            [ma addObject:[NSNull null]];
        } else {
            if ([self isSet:[entry objectForKey:DTS_F_OBJ_TYPE]]) {
                id val = [self valueForKeyPath:[entry objectForKey:DTS_F_OBJ_NAME]];
                NSData *data = [NSJSONSerialization dataWithJSONObject:val
                                                                options:NSJSONWritingPrettyPrinted
                                                                  error:nil];
                if (data) {
                    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    [ma addObject:str];
                } else {
                    [ma addObject:[NSNull null]];
                }
                
            } else {
                [ma addObject:[self valueForKeyPath:[entry objectForKey:DTS_F_OBJ_NAME]]];
            }
        }
    }
    return ma;
}

- (void)destroy
{
    FMDataTableStatement *statement = [DTM_SHARE fetchStatement:[self class]];
    FMDatabase *db = [DTM_SHARE fetchDatabase:[self class]];
    [db open];
    [db executeQuery:statement.s_delete withArgumentsInArray:@[ self.pid ]];
    [db close];
    if (DTM_SHARE.logEnabled) {
        NSLog(@"SQL:%@", statement.s_delete);
    }
}

+ (void)destroyByPid:(id)pid
{
    FMDataTableStatement *statement = [DTM_SHARE fetchStatement:[self class]];
    FMDatabase *db = [DTM_SHARE fetchDatabase:[self class]];
    [db open];
    [db executeUpdate:statement.s_delete withArgumentsInArray:@[ pid ]];
    [db close];
    if (DTM_SHARE.logEnabled) {
        NSLog(@"SQL:%@", statement.s_delete);
    }
}

+ (void)destroyWithField:(NSString *)fieldName value:(id)value
{
    NSString *where = [NSString stringWithFormat:@"[%@] = ?", fieldName];
    [self destroyWithWhere:where args:@[ value ]];
}

+ (void)destroyWithWhere:(NSString *)where args:(NSArray *)args
{
    FMDataTableStatement * statement = [DTM_SHARE fetchStatement:[self class]];
    NSMutableString * ms = [NSMutableString stringWithString:statement.s_delete_all];
    
    if (where) {
        if ([[where lowercaseString] hasPrefix:@"where"] ) {
            [ms appendString:where];
            [ms appendString:@" "];
        } else {
            [ms appendFormat:@" where %@ ", where];
        }
    }
    
    FMDatabase * db = [DTM_SHARE fetchDatabase:[self class]];
    [db open];
    [db executeUpdate:ms withArgumentsInArray:args];
    [db close];
    if (DTM_SHARE.logEnabled) {
        NSLog(@"SQL:%@", ms);
    }
}

+ (void)clear
{
    [self executeNonQuery:@"delete from %@", NSStringFromClass([self class])];
}

+ (void)batchSave:(NSArray *)records complete:(void (^)(id, NSError *))complete
{
    FMDatabaseQueue *queue = [DTM_SHARE fetchDatabaseQueue:[self class]];
    FMDataTableStatement *statement = [DTM_SHARE fetchStatement:[self class]];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            for (id entry in records) {
                [entry setUpdatedAt:@([NSDate date].timeIntervalSince1970)];
                if ([entry createdAt] == nil) {
                    [entry setCreatedAt:[entry updatedAt]];
                }
                [db executeUpdate:statement.s_replace withArgumentsInArray:[entry toValues]];
                if (DTM_SHARE.logEnabled) {
                    NSLog(@"SQL:%@", statement.s_replace);
                }
            }
        }
        @catch (NSException *exception) {
            *rollback = YES;
            if (complete) {
                complete(nil, [[NSError alloc] initWithDomain:@"localhost" code:-1021 userInfo:nil]);
            }
            if (DTM_SHARE.logEnabled) {
                NSLog(@"%@", exception);
            }
        }
    }];
}

+ (id)findByPid:(id)pid
{
    return [[self findEqualWithField:@"pid" value:[NSString stringWithFormat:@"%@", pid]] firstObject];
}

+ (NSArray *)findEqualWithField:(NSString *)f value:(id)v
{
    NSString *where = [NSString stringWithFormat:@"%@ = ?", f];
    NSArray *result = [self where:where args:@[ v ]];
    return result;
}

+ (NSArray *)findNotEqualWithField:(NSString *)f value:(id)v
{
    NSString *where = [NSString stringWithFormat:@"%@ <> ?", f];
    NSArray *result = [self where:where args:@[ v ]];
    return result;
}

+ (NSArray *)findLikeWithField:(NSString *)f value:(id)v
{
    NSString *where = [NSString stringWithFormat:@"%@ like '%%%@%%'", f, v];
    NSArray *result = [self where:where args:nil];
    return result;
}

#pragma mark
#pragma makr override base class

- (NSString *)description
{
    NSMutableString * ms = [[NSMutableString alloc] init];
    [ms appendString:@"\r########################################"];
    [ms appendFormat:@"\r[pid]=%@", self.pid];
    [NSObject enumeratePropertiesWithClassType:[self class] usingBlick:^(BOOL read, NSString *name, NSString *type, NSArray *attrs) {
        [ms appendFormat:@"\r[%@]=%@", name, [self valueForKeyPath:name]];
    }];
    [ms appendFormat:@"\r[createdAt]=%@", self.createdAt];
    [ms appendFormat:@"\r[updatedAt]=%@", self.updatedAt];
    [ms appendString:@"\r########################################\r"];
    return ms;
}

@end
