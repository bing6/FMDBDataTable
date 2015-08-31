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


+ (instancetype)create:(Class)classType;

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

@end
