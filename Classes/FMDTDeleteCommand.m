
//
//  FMDTDeleteCommand.m
//  FMDataTable
//
//  Created by bing.hao on 16/3/8.
//  Copyright © 2016年 bing.hao. All rights reserved.
//

#import "FMDTDeleteCommand.h"

@interface FMDTDeleteCommand ()

@property (nonatomic, strong) NSMutableArray *whereArray;

@end

@implementation FMDTDeleteCommand
@synthesize schema = _schema;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.whereArray = [NSMutableArray new];
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

- (FMDTDeleteCommand *)where:(NSString *)key equalTo:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ = '%@'", key, object]];
    return self;
}

- (FMDTDeleteCommand *)where:(NSString *)key notEqualTo:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ <> '%@'", key, object]];
    return self;
}

- (FMDTDeleteCommand *)where:(NSString *)key lessThan:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ < '%@'", key, object]];
    return self;
}

- (FMDTDeleteCommand *)where:(NSString *)key lessThanOrEqualTo:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ <= '%@'", key, object]];
    return self;
}

- (FMDTDeleteCommand *)where:(NSString *)key greaterThan:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ > '%@'", key, object]];
    return self;
}

- (FMDTDeleteCommand *)where:(NSString *)key greaterThanOrEqualTo:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ >= '%@'", key, object]];
    return self;
}

- (FMDTDeleteCommand *)where:(NSString *)key containedIn:(NSArray *)array {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ in ('%@')", key, [array componentsJoinedByString:@"','"]]];
    return self;
}

- (FMDTDeleteCommand *)where:(NSString *)key notContainedIn:(NSArray *)array {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ not in ('%@')", key, [array componentsJoinedByString:@"','"]]];
    return self;
}

- (FMDTDeleteCommand *)where:(NSString *)key containsString:(NSString *)string {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ like '%@'", key, string]];
    return self;
}

- (FMDTDeleteCommand *)where:(NSString *)key notContainsString:(NSString *)string {
    [self.whereArray addObject:[NSString stringWithFormat:@"and %@ not like '%@'", key, string]];
    return self;
}

- (FMDTDeleteCommand *)whereOr:(NSString *)key equalTo:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ = '%@'", key, object]];
    return self;
}

- (FMDTDeleteCommand *)whereOr:(NSString *)key notEqualTo:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ <> '%@'", key, object]];
    return self;
}

- (FMDTDeleteCommand *)whereOr:(NSString *)key lessThan:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ < '%@'", key, object]];
    return self;
}

- (FMDTDeleteCommand *)whereOr:(NSString *)key lessThanOrEqualTo:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ <= '%@'", key, object]];
    return self;
}

- (FMDTDeleteCommand *)whereOr:(NSString *)key greaterThan:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ > '%@'", key, object]];
    return self;
}

- (FMDTDeleteCommand *)whereOr:(NSString *)key greaterThanOrEqualTo:(id)object {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ >= '%@'", key, object]];
    return self;
}

- (FMDTDeleteCommand *)whereOr:(NSString *)key containedIn:(NSArray *)array {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ in ('%@')", key, [array componentsJoinedByString:@"','"]]];
    return self;
}

- (FMDTDeleteCommand *)whereOr:(NSString *)key notContainedIn:(NSArray *)array {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ not in ('%@')", key, [array componentsJoinedByString:@"','"]]];
    return self;
}

- (FMDTDeleteCommand *)whereOr:(NSString *)key containsString:(NSString *)string {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ like '%@'", key, string]];
    return self;
}

- (FMDTDeleteCommand *)whereOr:(NSString *)key notContainsString:(NSString *)string {
    [self.whereArray addObject:[NSString stringWithFormat:@"or %@ not like '%@'", key, string]];
    return self;
}

- (void)saveChanges {
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.schema.storage];
    
    [db open];
    [db executeUpdate:[self runSql]];
    [db close];
    
    [self.whereArray removeAllObjects];
}

- (NSString *)runSql {
    NSMutableString *sql = [[NSMutableString alloc] initWithString:self.schema.statementDelete];
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

- (void)saveChangesInBackground:(void(^)())callback {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.schema.storage];
        [queue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:[self runSql]];
            [self.whereArray removeAllObjects];
            if (callback) {
                callback();
            }
        }];
        [queue close];
    });
}

@end
