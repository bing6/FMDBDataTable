//
//  FMDataTableQuery.h
//  FMDataTable
//
//  Created by bing.hao on 15/9/1.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDataTableQuery : NSObject

- (instancetype)initWithClass:(Class)ctype;

/**
 * @brief 设置Where条件
 */
@property (nonatomic, copy) FMDataTableQuery * (^where)(NSString *field, id value);
/**
 * @brief 设置不相等的Where条件
 */
@property (nonatomic, copy) FMDataTableQuery * (^whereNotEqual)(NSString *field, id value);
/**
 * @brief 设置And条件
 */
@property (nonatomic, copy) FMDataTableQuery * (^whereAnd)(NSString *field, id value);
/**
 * @brief 设置不相等的And条件
 */
@property (nonatomic, copy) FMDataTableQuery * (^whereAndNotEqual)(NSString *field, id value);
/**
 * @brief 设置Or条件
 */
@property (nonatomic, copy) FMDataTableQuery * (^whereOr)(NSString *field, id value);
/**
 * @brief 设置不相等的Or条件
 */
@property (nonatomic, copy) FMDataTableQuery * (^whereOrNotEqual)(NSString *field, id value);
/**
 * @brief 设置排序字段,倒序
 */
@property (nonatomic, copy) FMDataTableQuery * (^orderByDesc)(NSString *field);
/**
 * @brief 设置排序字段,正序
 */
@property (nonatomic, copy) FMDataTableQuery * (^orderByAsc)(NSString *field);
/**
 * @brief 设置分页
 */
@property (nonatomic, copy) FMDataTableQuery * (^limit)(NSInteger page, NSInteger size);
/**
 * @brief 执行查询,返回一个数组
 */
@property (nonatomic, copy) NSArray * (^fetchArray)();
/**
 * @brief 执行查询,返回一个对象
 */
@property (nonatomic, copy) id (^fetchFirst)();
/**
 * @brief 执行查询,返回一个总数
 */
@property (nonatomic, copy) NSNumber * (^fetchCount)();

@end
