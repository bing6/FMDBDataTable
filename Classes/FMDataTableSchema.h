//
//  FMDataTableSchema.h
//  FMDBDataTableDemo
//
//  Created by bing.hao on 15/8/28.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DTS_F_OBJ_NAME @"__DTS_F_OBJ_NAME"
//#define DTS_F_OBJ_TYPE @"__DTS_F_OBJ_TYPE"
#define DTS_F_NAME     @"__DTS_F_NAME"
#define DTS_F_TYPE     @"__DTS_F_TYPE"


@interface FMDataTableSchema : NSObject


+ (instancetype)create:(Class)ctype;

- (instancetype)initWithClassName:(NSString *)className fields:(NSArray *)fields;

/**
 * @brief 模型ClassName
 */
@property (nonatomic, strong, readonly) NSString * className;
/**
 * @brief 表名
 */
@property (nonatomic, strong, readonly) NSString * tableName;
/**
 * @brief 字段
 */
@property (nonatomic, strong, readonly) NSArray  * fields;

/**
 * @brief 根据字段列表的索引值获取字段名称
 */
- (NSString *)fetchFiledNameWithIndex:(NSInteger)index;
/**
 * @brief 根据字段列表的索引值获取字段类型
 */
- (NSString *)fetchFiledTypeWithIndex:(NSInteger)index;

@end


//@interface FMDataTableSchemaTable : NSObject
//
///**
// * @brief 创建一个DataTableSchemaTable对象
// * @param 模型类型
// */
//+ (instancetype)createInstance:(Class)ctype;
//
///**
// * @brief 构造函数
// * @param className 类名
// * @param talbeName 表名
// * @param fieldList FMDataTableSchemaField集合
// */
//- (instancetype)initWith:(NSString *)className tableName:(NSString *)tableName fieldList:(NSArray *)flist;
//
//
//@end

