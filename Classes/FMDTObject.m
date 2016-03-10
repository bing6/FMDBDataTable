//
//  FMDTObject.m
//  FMDataTable
//
//  Created by bing.hao on 16/3/8.
//  Copyright © 2016年 bing.hao. All rights reserved.
//

#import "FMDTObject.h"
#import "NSObject+runtime.h"

NSString * FMDT_UUID() {
    CFUUIDRef   uuid_ref        = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref = CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

@implementation FMDTObject

+ (NSString *)primaryKeyFieldName {
    return nil;
}

@end
