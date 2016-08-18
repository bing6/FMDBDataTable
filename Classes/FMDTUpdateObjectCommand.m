//
//  FMDTUpdateObjectCommand.m
//  FMDataTable
//
//  Created by bing.hao on 16/3/9.
//  Copyright © 2016年 bing.hao. All rights reserved.
//

#import "FMDTUpdateObjectCommand.h"

@interface FMDTUpdateObjectCommand ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation FMDTUpdateObjectCommand
@synthesize schema = _schema;

- (instancetype)initWithSchema:(FMDTSchemaTable *)schema {
    self = [super init];
    if (self) {
        _schema = schema;
        _dataArray = [NSMutableArray new];
    }
    return self;
}

- (FMDTUpdateObjectCommand *)add:(FMDTObject *)obj {
    [self.dataArray addObject:obj];
    return self;
}

- (FMDTUpdateObjectCommand *)addWithArray:(NSArray *)array {
    [self.dataArray addObjectsFromArray:array];
    return self;
}

- (void)saveChanges {
    
    if (self.dataArray.count == 0) {
        NSLog(@"没有发现要更新的数据.");
        return;
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.schema.storage];
    
    [db open];
    for (FMDTObject *entry in self.dataArray) {
        [db executeUpdate:self.schema.statementUpdate withParameterDictionary:[self getUpdateData:entry]];
    }
    [db close];
    
    [self.dataArray removeAllObjects];
}

- (void)saveChangesInBackground:(void (^)())complete {
    
    if (self.dataArray.count == 0) {
        NSLog(@"没有发现要更新的数据.");
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.schema.storage];
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            @try {
                for (FMDTObject *entry in self.dataArray) {
                    [db executeUpdate:self.schema.statementUpdate withParameterDictionary:[self getUpdateData:entry]];
                }
            }
            @catch (NSException *exception) {
                *rollback = YES;
            }
            
            [self.dataArray removeAllObjects];
            
            if (complete) {
                complete();
            }
        }];
    });
}

- (NSDictionary *)getUpdateData:(FMDTObject *)obj {
    NSMutableDictionary *result = [NSMutableDictionary new];
    for (FMDTSchemaField *entry in self.schema.fields) {
        id val = [obj valueForKey:entry.objName];
        if (val) {
            if (FMDT_IsCollectionObject(entry.objType)) {
                NSData *data = [NSJSONSerialization dataWithJSONObject:val
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:nil];
                if (data) {
                    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    [result setObject:str forKey:entry.name];
                } else {
                    [result setObject:[NSNull null] forKey:entry.name];
                }
            } else if (FMDT_IsDateObject(entry.objType)) {
                [result setObject:@([val timeIntervalSince1970]) forKey:entry.name];
            } else {
                [result setObject:val forKey:entry.name];
            }
        } else {
            [result setObject:[NSNull null] forKey:entry.name];
        }
    }
    return result;
}

@end
