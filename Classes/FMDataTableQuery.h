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

@property (nonatomic, copy) FMDataTableQuery * (^dt_where)(NSString *field, id value);
@property (nonatomic, copy) FMDataTableQuery * (^dt_and)(NSString *field, id value);
@property (nonatomic, copy) FMDataTableQuery * (^dt_or)(NSString *field, id value);

@property (nonatomic, copy) FMDataTableQuery * (^dt_orderByDesc)(NSString *field);
@property (nonatomic, copy) FMDataTableQuery * (^dt_orderByAsc)(NSString *field);

@property (nonatomic, copy) FMDataTableQuery * (^dt_limit)(NSInteger page, NSInteger size);

- (NSArray *)toList;
- (id)first;

@end
