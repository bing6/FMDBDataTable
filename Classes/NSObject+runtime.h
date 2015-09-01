//
//  NSObject+runtime.h
//  FMDataTable
//
//  Created by bing.hao on 15/9/1.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (runtime)

+ (void)enumeratePropertiesWithClassType:(Class)ctype usingBlick:(void(^)(BOOL read, NSString *name, NSString *type, NSArray *attrs))block;

@end
