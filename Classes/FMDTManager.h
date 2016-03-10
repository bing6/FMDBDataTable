//
//  FMDTManager.h
//  FMDataTable
//
//  Created by bing.hao on 16/3/8.
//  Copyright © 2016年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDTContext.h"

/**
 *  FMDTContext管理类
 */
@interface FMDTManager : NSObject

+ (instancetype)shared;

/**
 *  缓存FMDTContext对象
 *
 *  @param cls 继承FMDBObject的类型
 *
 *  @return FMDTContext
 */
- (FMDTContext *)cacheWithClass:(Class)cls;

/**
 *  缓存FMDTContext对象
 *
 *  @param cls    继承FMDBObject的类型
 *  @param dbPath 存储位置
 *
 *  @return
 */
- (FMDTContext *)cacheWithClass:(Class)cls dbPath:(NSString *)dbPath;

/**
 *  缓存FMDTContext对象
 *
 *  @param cls       继承FMDBObject的类型
 *  @param tableName 自定义数据库表名
 *
 *  @return
 */
- (FMDTContext *)cacheWithClass:(Class)cls tableName:(NSString *)tableName;

/**
 *  缓存FMDTContext对象
 *
 *  @param cls       继承FMDBObject的类型
 *  @param tableName 自定义数据库表名
 *  @param dbPath    存储位置
 *
 *  @return
 */
- (FMDTContext *)cacheWithClass:(Class)cls tableName:(NSString *)tableName dbPath:(NSString *)dbPath;

/**
 *  清除缓存
 */
- (void)clearCache;

@end
