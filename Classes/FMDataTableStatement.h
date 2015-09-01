//
//  FMDataTableStatement.h
//  FMDataTable
//
//  Created by bing.hao on 15/9/1.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDataTableSchema.h"

@interface FMDataTableStatement : NSObject
{
    FMDataTableSchema *_schema;
}

- (instancetype)initWithDataTableSchema:(FMDataTableSchema *)schema;

@property (nonatomic, strong, readonly) NSString *s_delete_all;
@property (nonatomic, strong, readonly) NSString *s_delete;
@property (nonatomic, strong, readonly) NSString *s_replace;
@property (nonatomic, strong, readonly) NSString *s_select;
@property (nonatomic, strong, readonly) NSString *s_insert;
@property (nonatomic, strong, readonly) NSString *s_update;

@end
