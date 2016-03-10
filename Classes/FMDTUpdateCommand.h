//
//  FMDTUpdateCommand.h
//  FMDataTable
//
//  Created by bing.hao on 16/3/8.
//  Copyright © 2016年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDTCommand.h"

@interface FMDTUpdateCommand : NSObject<FMDTCommand>

- (FMDTUpdateCommand *)where:(NSString *)key equalTo:(id)object;
- (FMDTUpdateCommand *)where:(NSString *)key notEqualTo:(id)object;
- (FMDTUpdateCommand *)where:(NSString *)key lessThan:(id)object;
- (FMDTUpdateCommand *)where:(NSString *)key lessThanOrEqualTo:(id)object;
- (FMDTUpdateCommand *)where:(NSString *)key greaterThan:(id)object;
- (FMDTUpdateCommand *)where:(NSString *)key greaterThanOrEqualTo:(id)object;
- (FMDTUpdateCommand *)where:(NSString *)key containedIn:(NSArray *)array;
- (FMDTUpdateCommand *)where:(NSString *)key notContainedIn:(NSArray *)array;
- (FMDTUpdateCommand *)where:(NSString *)key containsString:(NSString *)string;
- (FMDTUpdateCommand *)where:(NSString *)key notContainsString:(NSString *)string;

- (FMDTUpdateCommand *)whereOr:(NSString *)key equalTo:(id)object;
- (FMDTUpdateCommand *)whereOr:(NSString *)key notEqualTo:(id)object;
- (FMDTUpdateCommand *)whereOr:(NSString *)key lessThan:(id)object;
- (FMDTUpdateCommand *)whereOr:(NSString *)key lessThanOrEqualTo:(id)object;
- (FMDTUpdateCommand *)whereOr:(NSString *)key greaterThan:(id)object;
- (FMDTUpdateCommand *)whereOr:(NSString *)key greaterThanOrEqualTo:(id)object;
- (FMDTUpdateCommand *)whereOr:(NSString *)key containedIn:(NSArray *)array;
- (FMDTUpdateCommand *)whereOr:(NSString *)key notContainedIn:(NSArray *)array;
- (FMDTUpdateCommand *)whereOr:(NSString *)key containsString:(NSString *)string;
- (FMDTUpdateCommand *)whereOr:(NSString *)key notContainsString:(NSString *)string;

/**
 *  要更新的字段
 *
 *  @param key 数据库对应的字段名
 *  @param val 具体值
 *
 *  @return 
 */
- (FMDTUpdateCommand *)fieldWithKey:(NSString *)key val:(id)val;

/**
 *  提交到数据库
 */
- (void)saveChanges;

/**
 *  提交到数据库,后台执行
 *
 *  @param callback 回调方法
 */
- (void)saveChangesInBackground:(void(^)())callback;

@end
