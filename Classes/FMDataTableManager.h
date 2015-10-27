//
//  FMDataTableManager.h
//  FMDBDataTableDemo
//
//  Created by bing.hao on 15/8/28.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import "FMDataTableSchema.h"
#import "FMDataTableStatement.h"

#define DTM_SHARE [FMDataTableManager shared]

@interface FMDataTableManager : NSObject

+ (FMDataTableManager *)shared;

/**
 * @brief 是否输出日志
 */
@property (nonatomic, assign) BOOL logEnabled;


/**
 * @brief 缓存
 */
@property (nonatomic, strong, readonly) NSMutableDictionary *cache;

/**
 * @brief 获取当前模型的Schema
 */
- (FMDataTableSchema *)fetchSchema:(Class)ctype;
/**
 * @brief 获取当前模型的标准SQL语句
 */
- (FMDataTableStatement *)fetchStatement:(Class)ctype;

/**
 * @brief 绑定模型与数据据库的存储关系,并不是所有模型都必须要调用这个绑定方法的，
 *        这个只是为了实现一些自定义存储位置而开发的。如果不自动建立绑定关系,
 *        数据会存储在沙盒下的Library/Caches/{Bundle Identifier}.db
 * 
 * @param classType 模型类型
 * @param dbName    数据库名称
 * @param dbPath    存储路径(默认存储在沙盒下的Library/Caches/)
 */
- (void)bindModelWithName:(NSString *)className dbName:(NSString *)dbName dbPath:(NSString *)dbPath;
- (void)bindModelWithName:(NSString *)className dbName:(NSString *)dbName;

/**
 * @brief 获取数据库存储路径
 */
- (NSString *)fetchPath:(Class)ctype;

/**
 * @brief 获取一个FMDatabase对象
 */
- (FMDatabase *)fetchDatabase:(Class)type;

/**
 * @brief 获取一个FMDatabaseQueue对象
 */
- (FMDatabaseQueue *)fetchDatabaseQueue:(Class)type;

/**
 * @brief 检查模型是否与物理数据库匹配完成
 */
- (void)checkModelIsReady:(Class)ctype;


@end
