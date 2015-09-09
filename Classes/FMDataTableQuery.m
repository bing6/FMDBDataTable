//
//  FMDataTableQuery.m
//  FMDataTable
//
//  Created by bing.hao on 15/9/1.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import "FMDataTableQuery.h"
#import "FMDataTableManager.h"

@interface FMDataTableQuery ()
{
    NSMutableString * _myWhere;
    NSMutableString * _myOrder;
    NSMutableString * _myLimit;
    
    Class _formatClassType;
}

@end

@implementation FMDataTableQuery

- (instancetype)initWithClass:(Class)ctype
{
    self = [super init];
    if (self) {
        _formatClassType = ctype;
    }
    return self;
}

- (FMDataTableQuery *(^)(NSString *, id))where
{
    return ^(NSString *f, id v) {
        _myWhere = nil;
        _myWhere = [NSMutableString stringWithFormat:@"where %@='%@'", f, v];
        return self;
    };
}

- (FMDataTableQuery *(^)(NSString *, id))whereNotEqual
{
    return ^(NSString *f, id v) {
        _myWhere = nil;
        _myWhere = [NSMutableString stringWithFormat:@"where %@<>'%@'", f, v];
        return self;
    };
}

- (FMDataTableQuery *(^)(NSString *, id))whereAnd
{
    return ^(NSString *f, id v) {
        if (_myWhere == nil) {
            _myWhere = [NSMutableString stringWithFormat:@"where %@='%@'", f, v];
        } else {
            [_myWhere appendFormat:@" and %@='%@'", f, v];
        }
        return self;
    };
}

- (FMDataTableQuery *(^)(NSString *, id))whereAndNotEqual
{
    return ^(NSString *f, id v) {
        if (_myWhere == nil) {
            _myWhere = [NSMutableString stringWithFormat:@"where %@<>'%@'", f, v];
        } else {
            [_myWhere appendFormat:@" and %@<>'%@'", f, v];
        }
        return self;
    };
}

- (FMDataTableQuery *(^)(NSString *, id))whereOr
{
    return ^(NSString *f, id v) {
        if (_myWhere == nil) {
            _myWhere = [NSMutableString stringWithFormat:@"where %@='%@'", f, v];
        } else {
            [_myWhere appendFormat:@" or %@='%@'", f, v];
        }
        return self;
    };
}

- (FMDataTableQuery *(^)(NSString *, id))whereOrNotEqual
{
    return ^(NSString *f, id v) {
        if (_myWhere == nil) {
            _myWhere = [NSMutableString stringWithFormat:@"where %@<>'%@'", f, v];
        } else {
            [_myWhere appendFormat:@" or %@<>'%@'", f, v];
        }
        return self;
    };
}

- (FMDataTableQuery *(^)(NSString *))orderByAsc
{
    return ^(NSString *f) {
        if (_myOrder == nil) {
            _myOrder = [NSMutableString stringWithFormat:@"order by %@ asc", f];
        } else {
            [_myOrder appendFormat:@", %@ asc", f];
        }
        return self;
    };
}

- (FMDataTableQuery *(^)(NSString *))orderByDesc
{
    return ^(NSString *f) {
        if (_myOrder == nil) {
            _myOrder = [NSMutableString stringWithFormat:@"order by %@ desc", f];
        } else {
            [_myOrder appendFormat:@", %@ desc", f];
        }
        return self;
    };
}

- (FMDataTableQuery *(^)(NSInteger, NSInteger))limit
{
    return ^(NSInteger page, NSInteger size) {
        page = MAX(0, page -1);
        size = MAX(1, size);
        _myLimit = nil;
        _myLimit = [NSMutableString stringWithFormat:@"limit %d, %d", (int)(page * size), (int)size];
        return self;
    };
}

- (NSArray *(^)())fetchArray
{
    return ^(void){
        return [self toList];
    };
}

- (id (^)())fetchFirst
{
    return ^(void){
        return [self first];
    };
}

- (NSNumber *(^)())fetchCount
{
    return ^(void){
        
        NSString *name = NSStringFromClass(_formatClassType);
        NSMutableString * ms = [[NSMutableString alloc] initWithFormat:@"select count(*) from %@", name];
        if (_myWhere) {
            [ms appendString:@" "];
            [ms appendString:_myWhere];
        }
        if (_myOrder) {
            [ms appendString:@" "];
            [ms appendString:_myOrder];
        }
        if (_myLimit) {
            [ms appendString:@" "];
            [ms appendString:_myLimit];
        }
        FMDatabase * db = [DTM_SHARE fetchDatabase:_formatClassType];
        [db open];
        FMResultSet *set = [db executeQuery:ms];
        NSInteger result = 0;
        if ([set next]) {
            result = [set intForColumnIndex:0];
        }
        [db close];
        return @(result);
    };
}


- (NSArray *)toList
{
    NSString *name = NSStringFromClass(_formatClassType);
    NSMutableString * ms = [[NSMutableString alloc] initWithFormat:@"select * from %@", name];
    if (_myWhere) {
        [ms appendString:@" "];
        [ms appendString:_myWhere];
    }
    if (_myOrder) {
        [ms appendString:@" "];
        [ms appendString:_myOrder];
    }
    if (_myLimit) {
        [ms appendString:@" "];
        [ms appendString:_myLimit];
    }
    
    FMDataTableSchema *dts = [DTM_SHARE fetchSchema:_formatClassType];
    FMDatabase * db = [DTM_SHARE fetchDatabase:_formatClassType];
    NSMutableArray *result = [NSMutableArray new];
    [db open];
    FMResultSet *set = [db executeQuery:ms];
    while ([set next]) {
        id data = [[_formatClassType alloc] init];
        id item = [set resultDictionary];
        for (NSDictionary *entry in dts.fields) {
            NSString *name = entry[DTS_F_NAME];
            NSObject *value = [item objectForKey:name];
            if ([value isEqual:[NSNull null]] == NO) {
                [data setValue:value forKeyPath:name];
            }
        }
        [result addObject:data];
    }
    [db close];
    
    if (DTM_SHARE.logEnabled) {
        NSLog(@"SQL:%@", ms);
    }
    
    return result;
}

- (id)first
{
    return [[self toList] firstObject];
}

@end
