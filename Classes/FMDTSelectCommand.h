//
//  FMDTQuery.h
//  FMDataTable
//
//  Created by bing.hao on 16/3/8.
//  Copyright © 2016年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDTCommand.h"

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

- (FMDTSelectCommand *)orderByDescending:(NSString *)key;
- (FMDTSelectCommand *)orderByAscending:(NSString *)key;

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
- (void)fetchArrayInBackground:(void(^)(NSArray *result))callback;

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
- (void)fetchObjectInBackground:(void(^)(id result))callback;

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
- (void)fetchCountInBackground:(void(^)(NSInteger count))callback;

@end
