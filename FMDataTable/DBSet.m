//
//  DBSet.m
//  FMDataTable
//
//  Created by bing.hao on 16/3/9.
//  Copyright © 2016年 bing.hao. All rights reserved.
//

#import "DBSet.h"

@implementation DBSet

- (FMDTContext *)user {
    /**
     *  缓存FMDTContext对象,第一次创建时会自动生成表结构
     *  默认存储在默认会存储在沙盒下的Library/Caches/{Bundle Identifier}.db,
     *  如果想要对每一个用户生成一个库,可以自定义Path,
     *  使用[self cacheWithClass: dbPath:]方法
     */
    return [self cacheWithClass:[Users class]];
}

- (FMDTContext *)dynamicTable:(NSString *)name {
    
    /**
     *  设置将对象映射到不同的数据表
     */
    return [self cacheWithClass:[Message class] tableName:name];
}

@end
