//
//  FMDTSchema.h
//  FMDataTable
//
//  Created by bing.hao on 16/3/8.
//  Copyright © 2016年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>

BOOL FMDT_IsCollectionObject(NSString *type);
BOOL FMDT_IsDateObject(NSString *type);
BOOL FMDT_IsDataObject(NSString *type);

/**
 *  数据表与类对象的映射关系
 */
@interface FMDTSchemaTable : NSObject

@property (nonatomic, strong) NSString * storage;
/**
 * @brief 类名
 */
@property (nonatomic, strong) NSString * className;
/**
 * @brief 表名
 */
@property (nonatomic, strong) NSString * tableName;
/**
 * @brief 字段
 */
@property (nonatomic, strong) NSArray  * fields;

- (instancetype)initWithClass:(Class)cls storage:(NSString *)storage;
- (instancetype)initWithClass:(Class)cls customTableName:(NSString *)name storage:(NSString *)storage;

@property (nonatomic, strong) NSString *statementUpdate;
@property (nonatomic, strong) NSString *statementDelete;
@property (nonatomic, strong) NSString *statementInsert;
@property (nonatomic, strong) NSString *statementReplace;

@end

@interface FMDTSchemaField : NSObject

@property (nonatomic, strong) NSString *objName;
@property (nonatomic, strong) NSString *objType;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) BOOL primaryKey;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end