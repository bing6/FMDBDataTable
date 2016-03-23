//
//  FMDTCommand.h
//  FMDataTable
//
//  Created by bing.hao on 16/3/9.
//  Copyright © 2016年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import "FMDTSchema.h"
#import "FMDTObject.h"

typedef void(^FMDT_CALLBACK_RESULT_OBJECT)(id result);
typedef void(^FMDT_CALLBACK_RESULT_ARRAY)(NSArray *result);
typedef void(^FMDT_CALLBACK_RESULT_INT)(NSInteger result);
typedef void(^FMDT_CALLBACK_RESULT_NOT)();


@protocol FMDTCommand <NSObject>

@property (nonatomic, weak, readonly) FMDTSchemaTable *schema;

- (instancetype)initWithSchema:(FMDTSchemaTable *)schema;

@end
