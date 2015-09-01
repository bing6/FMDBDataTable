
//
//  FMDataTableStatement.m
//  FMDataTable
//
//  Created by bing.hao on 15/9/1.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import "FMDataTableStatement.h"

@implementation FMDataTableStatement

@synthesize s_delete_all = _s_delete_all;
@synthesize s_delete     = _s_delete;
@synthesize s_insert     = _s_insert;
@synthesize s_replace    = _s_replace;
@synthesize s_select     = _s_select;
@synthesize s_update     = _s_update;

- (instancetype)initWithDataTableSchema:(FMDataTableSchema *)schema
{
    self = [super init];
    if (self) {
        _schema = schema;
    }
    return self;
}

- (NSString *)s_delete_all
{
    if (_s_delete_all == nil) {
        _s_delete_all = [NSString stringWithFormat:@"delete from [%@]", _schema.tableName];
    }
    return _s_delete_all;
}

- (NSString *)s_delete
{
    if (_s_delete == nil) {
        _s_delete = [NSString stringWithFormat:@"delete from [%@] where [pid]=?", _schema.tableName];
    }
    return _s_delete;
}

- (NSString *)s_replace
{
    if (_s_replace == nil) {
        NSMutableArray * keys = [NSMutableArray arrayWithCapacity:_schema.fields.count];
        NSMutableArray * vals = [NSMutableArray arrayWithCapacity:_schema.fields.count];
        for (int i = 0; i < _schema.fields.count; i++) {
            [keys addObject:[NSString stringWithFormat:@"[%@]", [_schema fetchFiledNameWithIndex:i]]];
            [vals addObject:@"?"];
        }
        NSString * key = [keys componentsJoinedByString:@","];
        NSString * val = [vals componentsJoinedByString:@","];
        _s_replace = [NSString stringWithFormat:@"replace into [%@] (%@) values (%@)", _schema.tableName, key, val];
    }
    return _s_replace;
}

- (NSString *)s_select
{
    if (_s_select == nil) {
        _s_select = [NSString stringWithFormat:@"select * from [%@] ", _schema.tableName];
    }
    return _s_select;
}

- (NSString *)s_insert
{
    if (_s_replace == nil) {
        NSMutableArray * keys = [NSMutableArray arrayWithCapacity:_schema.fields.count];
        NSMutableArray * vals = [NSMutableArray arrayWithCapacity:_schema.fields.count];
        for (int i = 0; i < _schema.fields.count; i++) {
            [keys addObject:[NSString stringWithFormat:@"[%@]", [_schema fetchFiledNameWithIndex:i]]];
            [vals addObject:@"?"];
        }
        NSString * key = [keys componentsJoinedByString:@","];
        NSString * val = [vals componentsJoinedByString:@","];
        _s_replace = [NSString stringWithFormat:@"insert into [%@] (%@) values (%@)", _schema.tableName, key, val];
    }
    return _s_replace;
}

- (NSString *)s_update
{
    if (_s_replace == nil) {
        NSMutableArray * keys = [NSMutableArray arrayWithCapacity:_schema.fields.count];
        for (int i = 0; i < _schema.fields.count; i++) {
            NSString *fname = [_schema fetchFiledNameWithIndex:i];
            if ([fname isEqualToString:@"pid"] == NO) {
                [keys addObject:[NSString stringWithFormat:@"[%@]=?", fname]];
            }
        }
        NSString * key = [keys componentsJoinedByString:@","];
        _s_replace = [NSString stringWithFormat:@"update [%@] set (%@) where [pid]=?", _schema.tableName, key];
    }
    return _s_replace;
}

@end
