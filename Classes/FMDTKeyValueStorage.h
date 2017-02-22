//
//  FMDTKeyValueStorage.h
//  FMDataTable
//
//  Created by bing.hao on 2017/2/22.
//  Copyright © 2017年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDTManager.h"

#define STORE [FMDTKeyValueStorage shared]

@interface FMDTKeyValueStorage : FMDTManager

/**
 添加键值存储

 @param key 关键字
 @param value 具体的值,可以是NSString, NSNumber, Dictionary, Array等类型
 */
- (void)set:(NSString *)key value:(id)value;


/**
 获取值

 @param key 关键字
 @return 返回值
 */
- (id)objectForKey:(NSString *)key;


/**
 获取值

 @param key 关键字
 @return 返回值
 */
- (NSString *)stringForKey:(NSString *)key;


/**
 获取值

 @param key 关键字
 @return 返回值
 */
- (NSNumber *)numberForKey:(NSString *)key;


/**
 获取值

 @param key 关键字
 @return 返回值
 */
- (NSDictionary *)dictionaryForKey:(NSString *)key;


/**
 获取值

 @param key 关键字
 @return 返回值
 */
- (NSArray *)arrayForKey:(NSString *)key;


/**
 删除

 @param key 关键字
 */
- (void)removeForKey:(NSString *)key;


/**
 删除所有
 */
- (void)removeAll;

@end
