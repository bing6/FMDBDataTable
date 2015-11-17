//
//  FMDataTable+KVC.m
//  FMDataTable
//
//  Created by bing.hao on 15/11/17.
//  Copyright © 2015年 bing.hao. All rights reserved.
//

#import "FMDataTable+KVC.h"

@implementation FMDataTable (KVC)

+ (id)createInstance:(NSDictionary *)data {
    return [self createInstance:data uniqueKey:nil];
}

+ (id)createInstance:(NSDictionary *)data uniqueKey:(NSString *)key {
    id obj = [[self alloc] initWithDict:data];
    if (key) {
        [obj setPid:[data valueForKey:key]];
    }
    return obj;
}

+ (NSArray *)createInstanceArray:(NSArray *)datas {
    return [self createInstanceArray:datas uniqueKey:nil];
}

+ (NSArray *)createInstanceArray:(NSArray *)datas uniqueKey:(NSString *)key {
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:datas.count];
    for (NSDictionary *entry in datas) {
        [tmp addObject:[self createInstance:entry uniqueKey:key]];
    }
    return tmp;
}

@end
