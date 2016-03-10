//
//  NSObject+runtime.m
//  FMDataTable
//
//  Created by bing.hao on 15/9/1.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import "NSObject+runtime.h"
#import <objc/runtime.h>

@implementation NSObject (runtime)

+ (void)enumeratePropertiesWithClassType:(Class)ctype usingBlick:(void (^)(BOOL, NSString *, NSString *, NSArray *))block
{
    if (ctype == NULL) {
        return;
    }
    if (block) {
        while (true) {
            //获得类属性的数量
            u_int count;
            objc_property_t *ps = class_copyPropertyList(ctype, &count);
            for (int i = 0; i < count; i++) {
                NSString * attr = [NSString stringWithFormat:@"%s", property_getAttributes(ps[i])];
                NSString * name = [NSString stringWithUTF8String:property_getName(ps[i])];
                NSArray  * list = [attr componentsSeparatedByString:@","];
                NSString * type = [list objectAtIndex:0];
                block([list containsObject:@"R"], name, type, list);
            }
            free(ps);
            ctype = [ctype superclass];
            if (ctype == [NSObject class]) {
                break;
            }
        }
    }
}

@end
