//
//  FMDTManager.m
//  FMDataTable
//
//  Created by bing.hao on 16/3/8.
//  Copyright © 2016年 bing.hao. All rights reserved.
//

#import "FMDTManager.h"

#define FMDT_DEF_PATH [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define FMDT_IDENTIFIER [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleIdentifier"]

@interface FMDTManager ()
{
    NSObject *_lock;
}

@property (nonatomic, strong) NSMutableDictionary *cache;

@end

@implementation FMDTManager

+ (instancetype)shared {
    static id _staticObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _staticObject = [self new];
    });
    return _staticObject;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cache = [NSMutableDictionary new];
        _lock = [NSObject new];
    }
    return self;
}

- (FMDTContext *)cacheWithClass:(Class)cls {
    return [self cacheWithClass:cls tableName:nil dbPath:nil];
}

- (FMDTContext *)cacheWithClass:(Class)cls dbPath:(NSString *)dbPath {
    return [self cacheWithClass:cls tableName:nil dbPath:dbPath];
}

- (FMDTContext *)cacheWithClass:(Class)cls tableName:(NSString *)tableName {
    return [self cacheWithClass:cls tableName:tableName dbPath:nil];
}

- (FMDTContext *)cacheWithClass:(Class)cls tableName:(NSString *)tableName dbPath:(NSString *)dbPath {
    
    if (tableName == nil) {
        tableName = NSStringFromClass(cls);
    }
    if (![self.cache.allKeys containsObject:tableName]) {
        @synchronized(_lock) {
            if (![self.cache.allKeys containsObject:tableName]) {
                if (dbPath == nil) {
                    dbPath = [NSString stringWithFormat:@"%@/%@.db", FMDT_DEF_PATH, FMDT_IDENTIFIER];
                }
                FMDTSchemaTable *schema = [[FMDTSchemaTable alloc] initWithClass:cls customTableName:tableName storage:dbPath];
                FMDTContext *set = [[FMDTContext alloc] initWithSchema:schema];
                
                [self.cache setObject:set forKey:tableName];
            }
        }
    }
    return [self.cache objectForKey:tableName];
}

- (void)clearCache {
    [self.cache removeAllObjects];
}


@end
