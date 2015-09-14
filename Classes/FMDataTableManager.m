//
//  FMDataTableManager.m
//  FMDBDataTableDemo
//
//  Created by bing.hao on 15/8/28.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import "FMDataTableManager.h"

#define CACHE_PATH [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define IDENTIFIER [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleIdentifier"]

@interface FMDataTableManager ()

@property (nonatomic, strong) NSMutableDictionary * map;
@property (nonatomic, strong) NSString * def;

@end

@implementation FMDataTableManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _map   = [NSMutableDictionary new];
        _cache = [NSMutableDictionary new];
        _def   = [NSString stringWithFormat:@"%@/%@.db", CACHE_PATH, IDENTIFIER];
    }
    return self;
}

+ (FMDataTableManager *)shared
{
    static id __staticObject;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __staticObject = [FMDataTableManager new];
    });
    return __staticObject;
}


#pragma mark
#pragma mark 缓存

- (NSDictionary *)featchCache:(Class)ctype
{
    NSDictionary * item = [self.cache objectForKey:NSStringFromClass(ctype)];
    if (item == nil) {
        FMDataTableSchema *s1 = [FMDataTableSchema create:ctype];
        FMDataTableStatement *s2 = [[FMDataTableStatement alloc] initWithDataTableSchema:s1];
        item = @{ @"s1":s1, @"s2":s2};
        [self.cache setObject:item forKey:NSStringFromClass(ctype)];
    }
    return item;
}

- (FMDataTableSchema *)fetchSchema:(Class)ctype
{
    return [[self featchCache:ctype] objectForKey:@"s1"];
}

- (FMDataTableStatement *)fetchStatement:(Class)ctype
{
    return [[self featchCache:ctype] objectForKey:@"s2"];
}

#pragma mark
#pragma mark 表与库的关系映射

- (void)bindModelWithName:(NSString *)className dbName:(NSString *)dbName
{
    [self bindModelWithName:className dbName:dbName dbPath:CACHE_PATH];
}

- (void)bindModelWithName:(NSString *)className dbName:(NSString *)dbName dbPath:(NSString *)dbPath
{
    [self.map setObject:[NSString stringWithFormat:@"%@/%@.db", dbPath, dbName] forKey:className];
}

//- (void)bindModelWithClass:(Class)ctype dbName:(NSString *)dbName
//{
//    [self bindModelWithClass:ctype dbName:dbName dbPath:CACHE_PATH];
//}
//
//- (void)bindModelWithClass:(Class)ctype dbName:(NSString *)dbName dbPath:(NSString *)dbPath
//{
//    [self.map setObject:[NSString stringWithFormat:@"%@/%@.db", dbPath, dbName] forKey:NSStringFromClass(ctype)];
//}

- (NSString *)fetchPath:(Class)ctype
{
    NSString * path = [self.map objectForKey:NSStringFromClass(ctype)];
    return path ? path : self.def;
}

- (FMDatabase *)fetchDatabase:(Class)type
{
    return [FMDatabase databaseWithPath:[self fetchPath:type]];
}

- (FMDatabaseQueue *)fetchDatabaseQueue:(Class)type
{
    return [FMDatabaseQueue databaseQueueWithPath:[self fetchPath:type]];
}

- (NSString *)getCrateSql:(FMDataTableSchema *)dts
{
    NSMutableString *text = [NSMutableString stringWithFormat:@"create table if not exists [%@] (", dts.tableName];
    for (NSDictionary *entry in dts.fields) {
        if ([entry[DTS_F_NAME] isEqualToString:@"pid"]) {
            [text appendFormat:@"[%@] %@ not null unique,", entry[DTS_F_NAME], entry[DTS_F_TYPE] ];
        } else {
            [text appendFormat:@"[%@] %@,", entry[DTS_F_NAME], entry[DTS_F_TYPE]];
        }
    }
    [text deleteCharactersInRange:NSMakeRange(text.length - 1, 1)];
    [text appendString:@")"];
    return text;
}

- (NSString *)getAlterTableSql:(FMDataTableSchema *)ldts dbts:(NSString *)dbts
{
    NSMutableString *text = [[NSMutableString alloc] init];
    NSRange s = [dbts rangeOfString:@"("];
    NSRange e = [dbts rangeOfString:@")"];
    NSString * findStr = [dbts substringWithRange:NSMakeRange(s.location, e.location - s.location)];
    for (NSDictionary *entry in ldts.fields) {
        if (![findStr containsString:entry[DTS_F_NAME]]) {
            [text appendFormat:@"alter table [%@] add column [%@] %@;", ldts.tableName, entry[DTS_F_NAME], entry[DTS_F_TYPE]];
        }
    }
    return text;
}

- (void)checkModelIsReady:(Class)ctype
{
    NSString *cname = NSStringFromClass(ctype);
    //获取表结构
    NSString   *ts = [NSString stringWithFormat:@"select * from sqlite_master where type='table' and name='%@'", cname];
    FMDatabase *db = [self fetchDatabase:ctype];
    if (self.logEnabled) {
        NSLog(@"Path:%@", db.databasePath);
    }
    [db open];
    FMResultSet *set = [db executeQuery:ts];
    FMDataTableSchema *dts = [self fetchSchema:ctype];
    //如果为YES，说明数据库已经有表了，那么我们需要判断是否要对字段更新
    if ([set next]) {
        NSString *text = [self getAlterTableSql:dts dbts:[set stringForColumn:@"sql"]];
        @try {
            if (text.length > 0) {
                [db executeStatements:text];
                if (self.logEnabled) {
                    NSLog(@"SQL:%@", text);
                }
            }
        }
        @catch (NSException *exception) {
            if (self.logEnabled) {
                NSLog(@"数据更新错误:更新字段冲突.");
            }
        }
        @finally {
            [db close];
        }
    } else {
        NSString * text = [self getCrateSql:dts];
        [db executeUpdate:text];
        if (self.logEnabled) {
            NSLog(@"SQL:%@", text);
        }
        [db close];
    }
}

@end
