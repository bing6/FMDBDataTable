//
//  FMDataTable.m
//  FMDBDataTableDemo
//
//  Created by bing.hao on 15/8/28.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import "FMDataTable.h"

@implementation FMDataTable

- (NSString *)GUID
{
    CFUUIDRef   uuid_ref        = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref = CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    
    CFRelease(uuid_string_ref);
    
    return uuid;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pid = [self GUID];
    }
    return self;
}

- (instancetype)initWithDict:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        FMDataTableSchema *dts = [DTM_SHARE dbSchemaWithClass:[self class]];
        for (NSDictionary *entry in dts.fields) {
            NSString * name = entry[DTS_F_NAME];
            NSObject * value = [data objectForKey:name];
            if (value) {
                [self setValue:value forKeyPath:[entry objectForKey:DTS_F_OBJ_NAME]];
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
    [DTM_SHARE checkModelIsReady:[self class]];
    
    NSString *from = [DTM_SHARE getSelectStatements:[self class]];
    NSMutableString * ms = [NSMutableString stringWithString:from];
    
    [ms appendString:@" "];
    
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
    FMDatabase * db = [FMDatabase databaseWithPath:[DTM_SHARE dbPathWithClass:[self class]]];
    
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
    [DTM_SHARE checkModelIsReady:[self class]];
    
    NSMutableArray *result = [NSMutableArray new];
    
    va_list args;
    va_start(args, query);
    NSString *cmd = [[NSString alloc] initWithFormat:query arguments:args];
    va_end(args);
    
    FMDatabase *db = [FMDatabase databaseWithPath:[DTM_SHARE dbPathWithClass:[self class]]];
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
    [DTM_SHARE checkModelIsReady:[self class]];

    va_list args;
    va_start(args, sql);
    NSString *cmd = [[NSString alloc] initWithFormat:sql arguments:args];
    va_end(args);
    
    FMDatabase *db = [FMDatabase databaseWithPath:[DTM_SHARE dbPathWithClass:[self class]]];
    [db open];
    [db executeUpdate:cmd];
    [db close];

    if (DTM_SHARE.logEnabled) {
        NSLog(@"SQL:%@", cmd);
    }
}

- (void)save
{
    [DTM_SHARE checkModelIsReady:[self class]];
    
    self.updatedAt = [NSNumber numberWithDouble:[NSDate date].timeIntervalSince1970];
    
    if (self.createdAt == nil) {
        self.createdAt = self.updatedAt;
    }
    
    NSString * sql = [DTM_SHARE getReplaceStatements:[self class]];
    
    FMDatabase *db= [FMDatabase databaseWithPath:[DTM_SHARE dbPathWithClass:[self class]]];
    [db open];
    [db executeUpdate:sql withArgumentsInArray:[self toValues]];
    [db close];
    
    if (DTM_SHARE.logEnabled) {
        NSLog(@"SQL:%@", sql);
    }
}

- (NSArray *)toValues
{
    FMDataTableSchema *dts = [DTM_SHARE dbSchemaWithClass:[self class]];
    NSMutableArray * ma = [NSMutableArray new];
    for (NSDictionary *entry in dts.fields) {
        id obj = [self valueForKeyPath:[entry objectForKey:DTS_F_OBJ_NAME]];
        if (obj == nil) {
            [ma addObject:[NSNull null]];
        } else {
            [ma addObject:[self valueForKeyPath:[entry objectForKey:DTS_F_OBJ_NAME]]];
        }
    }
    return ma;
}

- (void)destroy
{
    [DTM_SHARE checkModelIsReady:[self class]];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[DTM_SHARE dbPathWithClass:[self class]]];
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where pid = '%@'", NSStringFromClass([self class]), self.pid];
    [db open];
    [db executeUpdate:sql];
    [db close];
    if (DTM_SHARE.logEnabled) {
        NSLog(@"SQL:%@", sql);
    }
}

+ (void)clear
{
    [self executeNonQuery:@"delete from %@", NSStringFromClass([self class])];
}

+ (void)batchSave:(NSArray *)records complete:(void (^)(id, NSError *))complete
{
    [DTM_SHARE checkModelIsReady:[self class]];
    
    FMDatabaseQueue * queue = [[FMDatabaseQueue alloc] initWithPath:[DTM_SHARE dbPathWithClass:[self class]]];
    
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            NSString * sql = [DTM_SHARE getReplaceStatements:[self class]];
            for (id entry in records) {
                
                [entry setUpdatedAt:@([NSDate date].timeIntervalSince1970)];
                
                if ([entry createdAt] == nil) {
                    [entry setCreatedAt:[entry updatedAt]];
                }
                
                [db executeUpdate:sql withArgumentsInArray:[entry toValues]];
                if (DTM_SHARE.logEnabled) {
                    NSLog(@"SQL:%@", sql);
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

- (NSString *)description
{
    FMDataTableSchema *dts = [DTM_SHARE dbSchemaWithClass:[self class]];
    NSMutableArray * tmp = [NSMutableArray new];
    for (NSDictionary *entry in dts.fields) {
        [tmp addObject:[NSString stringWithFormat:@"[%@]=%@", entry[DTS_F_OBJ_NAME], [self valueForKeyPath:entry[DTS_F_OBJ_NAME]]]];
    }
    return [NSString stringWithFormat:@"\r########################################\r%@\r########################################", [tmp componentsJoinedByString:@",\r"]];
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

@end
