//
//  FMDTSet.h
//  FMDataTable
//
//  Created by bing.hao on 16/3/8.
//  Copyright © 2016年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDTSelectCommand.h"
#import "FMDTInsertCommand.h"
#import "FMDTUpdateCommand.h"
#import "FMDTDeleteCommand.h"
#import "FMDTUpdateObjectCommand.h"
#import "FMDTSchema.h"
#import "FMDTObject.h"

#define FMDT_INSERT(ctx) [ctx createInsertCommand]
#define FMDT_UPDATE(ctx) [ctx createUpdateCommand]
#define FMDT_DELETE(ctx) [ctx createDeleteCommand]
#define FMDT_SELECT(ctx) [ctx createSelectCommand]
#define FMDT_UPDATE_OBJECT(ctx) [ctx createUpdateObjectCommand]

@interface FMDTContext : NSObject

@property (nonatomic, strong, readonly) FMDTSchemaTable *schema;

- (instancetype)initWithSchema:(FMDTSchemaTable *)schema;

/**
 *  创建一个查询指令对象
 *
 *  @return FMDTSelectCommand
 */
- (FMDTSelectCommand *)createSelectCommand;

/**
 *  创建一个条件更新指令对象
 *
 *  @return FMDTUpdateCommand
 */
- (FMDTUpdateCommand *)createUpdateCommand;

/**
 *  创建一个插入指令对象
 *
 *  @return FMDTInsertCommand
 */
- (FMDTInsertCommand *)createInsertCommand;

/**
 *  创建一个删除指令对象
 *
 *  @return FMDTDeleteCommand
 */
- (FMDTDeleteCommand *)createDeleteCommand;

/**
 *  创建一个更新指令对象
 *
 *  @return FMDTUpdateObjectCommand
 */
- (FMDTUpdateObjectCommand *)createUpdateObjectCommand;



@end
