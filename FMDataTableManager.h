//
//  FMDataTableManager.h
//  FMDBDataTableDemo
//
//  Created by bing.hao on 15/8/28.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
#import "FMDataTableSchema.h"

#define DTM_SHARE [FMDataTableManager shared]

@interface FMDataTableManager : NSObject

+ (FMDataTableManager *)shared;

/**
 * @brief 是否输出日志
 */
@property (nonatomic, assign) BOOL logEnabled;


/**
 * @brief 绑定模型与数据据库的存储关系,并不是所有模型都必须要调用这个绑定方法的，
 *        这个只是为了实现一些自定义存储位置而开发的。如果不自动建立绑定关系,
 *        数据会存储在沙盒下的Library/Caches/{Bundle Identifier}.db
 * 
 * @param classType 模型类型
 * @param dbName    数据库名称
 * @param dbPath    存储路径(默认存储在沙盒下的Library/Caches/)
 */
- (void)bindModelWithClass:(Class)classType dbName:(NSString *)dbName dbPath:(NSString *)dbPath;
- (void)bindModelWithClass:(Class)classType dbName:(NSString *)dbName;

/**
 * @brief 获取模型存储路径
 *
 * @param classType 模型类型
 */
- (NSString *)dbPathWithClass:(Class)classType;

/**
 * @brief 获取表结构
 * 
 * @param classType 模型类型
 */
- (FMDataTableSchema *)dbSchemaWithClass:(Class)classType;

/**
 * @brief 检查模型是否与物理数据库匹配完成
 */
- (void)checkModelIsReady:(Class)classType;

/**
 * @brief 获取查询SQL
 */
- (NSString *)getSelectStatements:(Class)classType;
- (NSString *)getReplaceStatements:(Class)classType;

@end
