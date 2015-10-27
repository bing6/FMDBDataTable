//
//  FMDataTable.h
//  FMDBDataTableDemo
//
//  Created by bing.hao on 15/8/28.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDataTableManager.h"


@interface FMDataTable : NSObject

/**
 * @brief 默认属性:主键ID
 * 2015-09-04 将NSString修改为id,这是为了适配NSNumber类型
 */
@property (nonatomic, strong) id pid;
/**
 * @brief 默认属性:记录创建时间
 */
@property (nonatomic, strong) NSNumber *createdAt;
/**
 * @brief 默认属性:记录修改时间
 */
@property (nonatomic, strong) NSNumber *updatedAt;


/**
 * @brief 将字典数据填充到对象中
 */
- (instancetype)initWithDict:(NSDictionary *)data;

/**
 * @brief 将对象所有属性值转成一个数组
 */
- (NSArray *)toValues;

/**
 * @brief 查询数据,按所给的条件排序并返回结果
 */
+ (NSArray *)order:(NSString *)order;
+ (NSArray *)order:(NSString *)order limit:(NSNumber *)limit offset:(NSNumber *)offset;

/**
 * @brief 查询数据,按所给的条件筛选并排序返回结果
 */
+ (NSArray *)where:(NSString *)where args:(NSArray *)args;
+ (NSArray *)where:(NSString *)where args:(NSArray *)args limit:(NSNumber *)limit offset:(NSNumber *)offset;
+ (NSArray *)where:(NSString *)where args:(NSArray *)args order:(NSString *)order limit:(NSNumber *)limit offset:(NSNumber *)offset;

/**
 * @brief 查询数据,按条件返回一个结果
 */
+ (id)first:(NSString *)w args:(NSArray *)args;

/**
 * @brief 执行一个非查询的SQL语句
 */
+ (NSArray *)executeQuery:(NSString *)query, ...;
/**
 * @brief 执行一个查询的SQL语句
 */
+ (void)executeNonQuery:(NSString *)sql, ...;

/**
 * @brief 保存数据
 */
- (void)save;
/**
 * @brief 删除数据
 */
- (void)destroy;
/**
 * @brief 根据唯一ID删除记录
 */
+ (void)destroyByPid:(id)pid;
/**
 * @brief 根据字段名做条件删除记录
 */
+ (void)destroyWithField:(NSString *)fieldName value:(id)value;
/**
 * @brief 自定义条件删除数据
 */
+ (void)destroyWithWhere:(NSString *)where args:(NSArray *)args;
/**
 * @brief 清楚所有数据
 */
+ (void)clear;
/**
 * @brief 批量保存数据
 */
+ (void)batchSave:(NSArray *)records complete:(void(^)(id res, NSError *err))complete;

/**
 * @brief 根据主键ID返回结果
 */
+ (id)findByPid:(id)pid;
/**
 * @brief 根据字段条件返回结果
 */
+ (NSArray *)findEqualWithField:(NSString *)f value:(id)v;
/**
 * @brief 根据字段条件取返
 */
+ (NSArray *)findNotEqualWithField:(NSString *)f value:(id)v;
/**
 * @brief 模糊匹配
 */
+ (NSArray *)findLikeWithField:(NSString *)f value:(id)v;

@end

//获取PID的Int值
static inline NSInteger __int(FMDataTable *dt) {
    if ([dt.pid isKindOfClass:[NSNumber class]]) {
        return [dt.pid integerValue];
    }
    return 0;
}


