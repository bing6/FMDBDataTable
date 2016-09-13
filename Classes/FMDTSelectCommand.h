//
//  FMDTQuery.h
//  FMDataTable
//
//  Created by bing.hao on 16/3/8.
//  Copyright © 2016年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDTCommand.h"

#define FMDT_SELECT_MAX(field) max(field) as field
#define FMDT_SELECT_MIN(field) min(field) as field
#define FMDT_SELECT_SUM(field) sum(field) as field
#define FMDT_SELECT_AVG(field) avg(field) as field

@interface FMDTSelectCommand : NSObject<FMDTCommand>

@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) NSInteger skip;

- (FMDTSelectCommand *)where:(NSString *)key equalTo:(id)object;
- (FMDTSelectCommand *)where:(NSString *)key notEqualTo:(id)object;
- (FMDTSelectCommand *)where:(NSString *)key lessThan:(id)object;
- (FMDTSelectCommand *)where:(NSString *)key lessThanOrEqualTo:(id)object;
- (FMDTSelectCommand *)where:(NSString *)key greaterThan:(id)object;
- (FMDTSelectCommand *)where:(NSString *)key greaterThanOrEqualTo:(id)object;
- (FMDTSelectCommand *)where:(NSString *)key containedIn:(NSArray *)array;
- (FMDTSelectCommand *)where:(NSString *)key notContainedIn:(NSArray *)array;
- (FMDTSelectCommand *)where:(NSString *)key containsString:(NSString *)string;
- (FMDTSelectCommand *)where:(NSString *)key notContainsString:(NSString *)string;
- (FMDTSelectCommand *)whereIsNull:(NSString *)key;
- (FMDTSelectCommand *)whereIsNotNull:(NSString *)key;

- (FMDTSelectCommand *)whereOr:(NSString *)key equalTo:(id)object;
- (FMDTSelectCommand *)whereOr:(NSString *)key notEqualTo:(id)object;
- (FMDTSelectCommand *)whereOr:(NSString *)key lessThan:(id)object;
- (FMDTSelectCommand *)whereOr:(NSString *)key lessThanOrEqualTo:(id)object;
- (FMDTSelectCommand *)whereOr:(NSString *)key greaterThan:(id)object;
- (FMDTSelectCommand *)whereOr:(NSString *)key greaterThanOrEqualTo:(id)object;
- (FMDTSelectCommand *)whereOr:(NSString *)key containedIn:(NSArray *)array;
- (FMDTSelectCommand *)whereOr:(NSString *)key notContainedIn:(NSArray *)array;
- (FMDTSelectCommand *)whereOr:(NSString *)key containsString:(NSString *)string;
- (FMDTSelectCommand *)whereOr:(NSString *)key notContainsString:(NSString *)string;
- (FMDTSelectCommand *)whereOrIsNull:(NSString *)key;
- (FMDTSelectCommand *)whereOrIsNotNull:(NSString *)key;

- (FMDTSelectCommand *)orderByDescending:(NSString *)key;
- (FMDTSelectCommand *)orderByAscending:(NSString *)key;

- (FMDTSelectCommand *)groupBy:(NSString *)key;

/**
 *  执行查询
 *
 *  @return NSArray
 */
- (NSArray *)fetchArray;

/**
 *  异步执行查询
 *
 *  @param callback 回调方法
 */
- (void)fetchArrayInBackground:(FMDT_CALLBACK_RESULT_ARRAY)callback;

/**
 *  执行查询
 *
 *  @return 返回单一对象
 */
- (id)fetchObject;

/**
 *  异步执行查询
 *
 *  @param callback 回调方法
 */
- (void)fetchObjectInBackground:(FMDT_CALLBACK_RESULT_OBJECT)callback;


/**
 *  执行查询
 *
 *  @return 返回记录总数
 */
- (NSInteger)fetchCount;

/**
 *  异步执行查询
 *
 *  @param callback 回调方法
 */
- (void)fetchCountInBackground:(FMDT_CALLBACK_RESULT_INT)callback;

/**
 *  执行查询,自定义返回字段
 *
 *  @param fields 返回字段
 *
 *  @return NSArray
 */
- (NSArray *)fetchArrayWithFields:(NSArray *)fields;

/**
 *  执行查询,自定义返回字段
 *
 *  @param fields   返回字段
 *  @param callback 回调方法
 */
- (void)fetchArrayInBackgroundWithFields:(NSArray *)fields callback:(FMDT_CALLBACK_RESULT_ARRAY)callback;

@end
