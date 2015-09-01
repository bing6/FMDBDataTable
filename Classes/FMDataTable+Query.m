//
//  FMDataTable+Query.m
//  FMDataTable
//
//  Created by bing.hao on 15/9/1.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import "FMDataTable+Query.h"

@implementation FMDataTable (Query)

+ (FMDataTableQuery *)query
{
    return [[FMDataTableQuery alloc] initWithClass:[self class]];
}

@end
