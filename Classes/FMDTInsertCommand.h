//
//  FMDTInsertCommand.h
//  FMDataTable
//
//  Created by bing.hao on 16/3/8.
//  Copyright © 2016年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDTCommand.h"

@interface FMDTInsertCommand : NSObject<FMDTCommand>

/**
 *  是否使用replace语句
 *  注:replace语句必须指定唯一键,也就是说需要设置FMDTObject的primaryKeyFieldName类方法,
 *  replace会根据唯一键来判断是否需要插入或者更新数据
 */
@property (nonatomic, assign) BOOL relpace;

/**
 *  添加要插入的实体对象
 *
 *  @param obj 实体对象
 *
 *  @return
 */
- (FMDTInsertCommand *)add:(FMDTObject *)obj;

/**
 *  添加一组要插入的实体对象
 *
 *  @param array 一组对象
 *
 *  @return
 */
- (FMDTInsertCommand *)addWithArray:(NSArray *)array;

/**
 *  提交到数据库
 */
- (void)saveChanges;

/**
 *  提交到数据库,后台执行
 *
 *  @param complete 回调方法
 */
- (void)saveChangesInBackground:(void(^)())complete;


@end
