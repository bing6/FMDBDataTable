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
@property (nonatomic, strong) NSMutableDictionary * schems;
@property (nonatomic, strong) NSMutableArray * ready;
/**
 * @brief 缓存SQL脚本
 */
@property (nonatomic, strong) NSMutableDictionary * statements;

@end

@implementation FMDataTableManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.map = [NSMutableDictionary new];
        self.def = [NSString stringWithFormat:@"%@/%@.db", CACHE_PATH, IDENTIFIER];
        self.schems = [NSMutableDictionary new];
        self.ready = [NSMutableArray new];
        self.statements = [NSMutableDictionary new];
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

- (void)bindModelWithClass:(Class)classType dbName:(NSString *)dbName
{
    [self bindModelWithClass:classType dbName:dbName dbPath:CACHE_PATH];
}

- (void)bindModelWithClass:(Class)classType dbName:(NSString *)dbName dbPath:(NSString *)dbPath
{
    [self.map setObject:[NSString stringWithFormat:@"%@/%@.db", dbPath, dbName] forKey:NSStringFromClass(classType)];
}

- (NSString *)dbPathWithClass:(Class)classType
{
    NSString * path = [self.map objectForKey:NSStringFromClass(classType)];
    return path ? path : self.def;
}

- (FMDataTableSchema *)dbSchemaWithClass:(Class)classType
{
    NSString * cname = NSStringFromClass(classType);
    FMDataTableSchema *dts = [self.schems objectForKey:cname];
    if (dts == nil) {
        dts = [FMDataTableSchema create:classType];
    }
    return dts;
}

- (NSString *)getCrateSql:(FMDataTableSchema *)dts
{
    NSMutableString *text = [NSMutableString stringWithFormat:@"create table if not exists [%@] (", dts.tableName];
    for (NSDictionary *entry in dts.fields) {
        if ([entry[DTS_F_NAME] isEqualToString:@"pid"]) {
            [text appendFormat:@"[%@] %@ unique,", entry[DTS_F_NAME], entry[DTS_F_TYPE] ];
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

- (void)checkModelIsReady:(Class)classType
{
    NSString * cname = NSStringFromClass(classType);
    if (![self.ready containsObject:cname]) {
        //获取表结构
        NSString   *ts = [NSString stringWithFormat:@"select * from sqlite_master where type='table' and name='%@'", cname];
        FMDatabase *db = [[FMDatabase alloc] initWithPath:[self dbPathWithClass:classType]];
        if (self.logEnabled) {
            NSLog(@"Path:%@", db.databasePath);
        }
        [db open];
        FMResultSet *set = [db executeQuery:ts];
        FMDataTableSchema *dts = [self dbSchemaWithClass:classType];
        //如果为YES，说明数据库已经有表了，那么我们需要判断是否要对字段更新
        if ([set next]) {
//            NSDictionary *dbts = [self resolveDatabaseTableSchema:[set stringForColumn:@"sql"]];
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
        
        if (![self.ready containsObject:cname]) {
            [self.ready addObject:cname];
        }
    }
}


//- (NSDictionary *)resolveDatabaseTableSchema:(NSString *)sql
//{
//    NSInteger s = [sql rangeOfString:@"("].location;
//    NSInteger e = [sql length] - s - 1;
//    NSString *str = [sql substringWithRange:NSMakeRange(s+1, e)];
//
//    NSArray *items = [str componentsSeparatedByString:@","];
//    NSMutableDictionary * results = [NSMutableDictionary new];
//    for (int i = 0; i < items.count; i++) {
//        NSArray * fileds = [[items objectAtIndex:i] componentsSeparatedByString:@" "];
//        NSString *key = [fileds[0] stringByReplacingOccurrencesOfString:@"[" withString:@""];
//        key = [key stringByReplacingOccurrencesOfString:@"]" withString:@""];
//        
//        [results setObject:@{ @"Field": fileds[0], @"DbType": fileds[1]} forKey:key];
//    }
//    return results;
//}

- (NSString *)getSelectStatements:(Class)classType
{
    NSString * key = [NSString stringWithFormat:@"__select.%@", NSStringFromClass(classType)];
    NSString * sql = [self.statements objectForKey:key];
    if (sql == nil) {
        FMDataTableSchema *dts = [self dbSchemaWithClass:classType];
        NSMutableString *ms = [[NSMutableString alloc] initWithString:@"select "];
        for (NSDictionary *entry in dts.fields) {
            [ms appendFormat:@"[%@],", entry[DTS_F_NAME]];
        }
        [ms deleteCharactersInRange:NSMakeRange(ms.length - 1, 1)];
        [ms appendFormat:@" from [%@]", dts.tableName];
        sql = ms;
        [self.statements setObject:sql forKey:key];
    }
    return sql;
}

- (NSString *)getReplaceStatements:(Class)classType
{
    NSString *key = [NSString stringWithFormat:@"__replace.%@", NSStringFromClass(classType)];
    NSString *sql = [self.statements objectForKey:key];
    if (sql == nil) {
        FMDataTableSchema *dts = [self dbSchemaWithClass:classType];
        NSMutableString *ms = [NSMutableString stringWithFormat:@"replace into [%@] (", dts.tableName];
        for (NSDictionary *entry in dts.fields) {
            [ms appendFormat:@"[%@],", [entry objectForKey:DTS_F_NAME]];
        }
        [ms deleteCharactersInRange:NSMakeRange(ms.length - 1, 1)];
        [ms appendString:@") values ("];
        for (int i = 0; i < dts.fields.count; i++) {
            [ms appendString:@"?,"];
        }
        [ms deleteCharactersInRange:NSMakeRange(ms.length - 1, 1)];
        [ms appendString:@")"];
        sql = ms;
        [self.statements setObject:sql forKey:key];
    }
    return sql;
}

@end
