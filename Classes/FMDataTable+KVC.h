//
//  FMDataTable+KVC.h
//  FMDataTable
//
//  Created by bing.hao on 15/11/17.
//  Copyright © 2015年 bing.hao. All rights reserved.
//

#import "FMDataTable.h"

@interface FMDataTable (KVC)

+ (id)createInstance:(NSDictionary *)data;
+ (id)createInstance:(NSDictionary *)data uniqueKey:(NSString *)key;

+ (NSArray *)createInstanceArray:(NSArray *)datas;
+ (NSArray *)createInstanceArray:(NSArray *)datas uniqueKey:(NSString *)key;

@end
