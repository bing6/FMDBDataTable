//
//  FMDTKeyValueStorage.m
//  FMDataTable
//
//  Created by bing.hao on 2017/2/22.
//  Copyright © 2017年 bing.hao. All rights reserved.
//

#import "FMDTKeyValueStorage.h"
#import "FMDTObject.h"

@interface FMDTKeyValueObject : FMDTObject

@property (nonatomic, strong) NSString *m_key;
@property (nonatomic, strong) NSDictionary *m_value;
//@property (nonatomic, strong) NSString *m_type;

@end

@implementation FMDTKeyValueObject

+ (NSString *)primaryKeyFieldName {
    return @"m_key";
}

@end

@interface FMDTKeyValueStorage ()

@property (nonatomic, strong) FMDTContext *kv;

@end

@implementation FMDTKeyValueStorage

+ (instancetype)shared {
    static id _staticObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _staticObject = [FMDTKeyValueStorage new];
    });
    return _staticObject;
}

- (FMDTContext *)kv {
//    NSMutableDictionary *s;
//    [s set]
    NSString *path = [NSString stringWithFormat:@"%@/kv.db", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    return [self cacheWithClass:[FMDTKeyValueObject class] dbPath:path];
}

//- (void)set:(NSString *)key valueForString:(NSString *)value {
//
//}
//
//- (void)set:(NSString *)key valueForNumber:(NSNumber *)value {
//
//}
//
//- (void)set:(NSString *)key valueForDictionary:(NSDictionary *)value {
//
//}
//
//- (void)set:(NSString *)key valueForArray:(NSArray *)value {
//    
//}
//

- (void)set:(NSString *)key value:(id)value {
    if (key == nil || value == nil) {
        return;
    }
    FMDTKeyValueObject *obj = [[FMDTKeyValueObject alloc] init];
    obj.m_key = key;
    obj.m_value = @{ @"value": value };
    FMDTInsertCommand *cmd = [self.kv createInsertCommand];
    [cmd add:obj];
    [cmd setRelpace:YES];
    [cmd saveChanges];
}

- (id)objectForKey:(NSString *)key {
    
    if (key == nil) {
        return nil;
    }
    
    FMDTSelectCommand *cmd = [self.kv createSelectCommand];
    [cmd where:@"m_key" equalTo:key];
    FMDTKeyValueObject *obj = [cmd fetchObject];
    if (obj) {
        return [obj.m_value objectForKey:@"value"];
    }
    return nil;
}

- (NSString *)stringForKey:(NSString *)key {
    return [self objectForKey:key];
}

- (NSNumber *)numberForKey:(NSString *)key {
    return [self objectForKey:key];
}

- (NSDictionary *)dictionaryForKey:(NSString *)key {
    return [self objectForKey:key];
};

- (NSArray *)arrayForKey:(NSString *)key {
    return [self objectForKey:key];
}

- (void)removeForKey:(NSString *)key {
    
    if (key == nil) {
        return;
    }
    FMDTDeleteCommand *cmd = [self.kv createDeleteCommand];
    [cmd where:@"m_key" equalTo:key];
    [cmd saveChanges];
}

- (void)removeAll {
    FMDTDeleteCommand *cmd = [self.kv createDeleteCommand];
    [cmd saveChanges];
}

@end
