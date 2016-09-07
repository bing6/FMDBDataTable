//
//  FMDTUpdateCommand.m
//  FMDataTable
//
//  Created by bing.hao on 16/3/8.
//  Copyright © 2016年 bing.hao. All rights reserved.
//

#import "FMDTUpdateCommand.h"

@interface FMDTUpdateCommand ()

@property (nonatomic, strong) NSMutableArray *whereArray;
@property (nonatomic, strong) NSMutableDictionary *dataDict;

@end

@implementation FMDTUpdateCommand
@synthesize schema = _schema;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.whereArray = [NSMutableArray new];
        self.dataDict = [NSMutableDictionary new];
    }
    return self;
}

- (instancetype)initWithSchema:(FMDTSchemaTable *)schema {
    self = [self init];
    if (self) {
        _schema = schema;
    }
    return self;
}

- (FMDTUpdateCommand *)where:(NSString *)key equalTo:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ = '%@'", key, object]];
    return self;
}

- (FMDTUpdateCommand *)where:(NSString *)key notEqualTo:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ <> '%@'", key, object]];
    return self;
}

- (FMDTUpdateCommand *)where:(NSString *)key lessThan:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ < '%@'", key, object]];
    return self;
}

- (FMDTUpdateCommand *)where:(NSString *)key lessThanOrEqualTo:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ <= '%@'", key, object]];
    return self;
}

- (FMDTUpdateCommand *)where:(NSString *)key greaterThan:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ > '%@'", key, object]];
    return self;
}

- (FMDTUpdateCommand *)where:(NSString *)key greaterThanOrEqualTo:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ >= '%@'", key, object]];
    return self;
}

- (FMDTUpdateCommand *)where:(NSString *)key containedIn:(NSArray *)array {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ in ('%@')", key, [array componentsJoinedByString:@"','"]]];
    return self;
}

- (FMDTUpdateCommand *)where:(NSString *)key notContainedIn:(NSArray *)array {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ not in ('%@')", key, [array componentsJoinedByString:@"','"]]];
    return self;
}

- (FMDTUpdateCommand *)where:(NSString *)key containsString:(NSString *)string {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ like '%@'", key, string]];
    return self;
}

- (FMDTUpdateCommand *)where:(NSString *)key notContainsString:(NSString *)string {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ not like '%@'", key, string]];
    return self;
}

- (FMDTUpdateCommand *)whereOr:(NSString *)key equalTo:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ = '%@'", key, object]];
    return self;
}

- (FMDTUpdateCommand *)whereOr:(NSString *)key notEqualTo:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ <> '%@'", key, object]];
    return self;
}

- (FMDTUpdateCommand *)whereOr:(NSString *)key lessThan:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ < '%@'", key, object]];
    return self;
}

- (FMDTUpdateCommand *)whereOr:(NSString *)key lessThanOrEqualTo:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ <= '%@'", key, object]];
    return self;
}

- (FMDTUpdateCommand *)whereOr:(NSString *)key greaterThan:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ > '%@'", key, object]];
    return self;
}

- (FMDTUpdateCommand *)whereOr:(NSString *)key greaterThanOrEqualTo:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ >= '%@'", key, object]];
    return self;
}

- (FMDTUpdateCommand *)whereOr:(NSString *)key containedIn:(NSArray *)array {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ in ('%@')", key, [array componentsJoinedByString:@"','"]]];
    return self;
}

- (FMDTUpdateCommand *)whereOr:(NSString *)key notContainedIn:(NSArray *)array {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ not in ('%@')", key, [array componentsJoinedByString:@"','"]]];
    return self;
}

- (FMDTUpdateCommand *)whereOr:(NSString *)key containsString:(NSString *)string {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ like '%@'", key, string]];
    return self;
}

- (FMDTUpdateCommand *)whereOr:(NSString *)key notContainsString:(NSString *)string {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ not like '%@'", key, string]];
    return self;
}

- (FMDTUpdateCommand *)fieldWithKey:(NSString *)key val:(id)val {
    [self.dataDict setObject:val forKey:key];
    return self;
}

- (void)saveChanges {

    if (self.dataDict.count == 0) {
        return;
    }

    FMDatabase *db = [FMDatabase databaseWithPath:self.schema.storage];
    
    [db open];
    [db executeUpdate:[self runSql] withParameterDictionary:self.dataDict];
    [db close];
    
    [self.whereArray removeAllObjects];
    [self.dataDict removeAllObjects];
}

- (void)saveChangesInBackground:(void (^)())callback {
    
    if (self.dataDict.count == 0) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.schema.storage];
        [queue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:[self runSql] withParameterDictionary:self.dataDict];
            [self.whereArray removeAllObjects];
            [self.dataDict removeAllObjects];
            callback();
        }];
        [queue close];
    });
}

- (NSString *)runSql {
    NSMutableString *sql = [[NSMutableString alloc] initWithFormat:@"update [%@] set", self.schema.tableName];
    
    for (NSString *key in self.dataDict.allKeys) {
        [sql appendFormat:@" %@=:%@,", key, key];
    }
    if (self.dataDict.count > 0) {
        [sql deleteCharactersInRange:NSMakeRange(sql.length-1, 1)];
    }
    if (self.whereArray.count > 0) {
        NSString *str = [self.whereArray componentsJoinedByString:@" "];
        if ([str hasPrefix:@"and"]) {
            str = [str substringFromIndex:3];
        } else {
            str = [str substringFromIndex:2];
        }
        [sql appendFormat:@" where %@", str];
    }
    return sql;
}

@end
