//
//  FMDTDeleteCommand.h
//  FMDataTable
//
//  Created by bing.hao on 16/3/8.
//  Copyright © 2016年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDTCommand.h"

@interface FMDTDeleteCommand : NSObject<FMDTCommand>

- (FMDTDeleteCommand *)where:(NSString *)key equalTo:(id)object;
- (FMDTDeleteCommand *)where:(NSString *)key notEqualTo:(id)object;
- (FMDTDeleteCommand *)where:(NSString *)key lessThan:(id)object;
- (FMDTDeleteCommand *)where:(NSString *)key lessThanOrEqualTo:(id)object;
- (FMDTDeleteCommand *)where:(NSString *)key greaterThan:(id)object;
- (FMDTDeleteCommand *)where:(NSString *)key greaterThanOrEqualTo:(id)object;
- (FMDTDeleteCommand *)where:(NSString *)key containedIn:(NSArray *)array;
- (FMDTDeleteCommand *)where:(NSString *)key notContainedIn:(NSArray *)array;
- (FMDTDeleteCommand *)where:(NSString *)key containsString:(NSString *)string;
- (FMDTDeleteCommand *)where:(NSString *)key notContainsString:(NSString *)string;

- (FMDTDeleteCommand *)whereOr:(NSString *)key equalTo:(id)object;
- (FMDTDeleteCommand *)whereOr:(NSString *)key notEqualTo:(id)object;
- (FMDTDeleteCommand *)whereOr:(NSString *)key lessThan:(id)object;
- (FMDTDeleteCommand *)whereOr:(NSString *)key lessThanOrEqualTo:(id)object;
- (FMDTDeleteCommand *)whereOr:(NSString *)key greaterThan:(id)object;
- (FMDTDeleteCommand *)whereOr:(NSString *)key greaterThanOrEqualTo:(id)object;
- (FMDTDeleteCommand *)whereOr:(NSString *)key containedIn:(NSArray *)array;
- (FMDTDeleteCommand *)whereOr:(NSString *)key notContainedIn:(NSArray *)array;
- (FMDTDeleteCommand *)whereOr:(NSString *)key containsString:(NSString *)string;
- (FMDTDeleteCommand *)whereOr:(NSString *)key notContainsString:(NSString *)string;

- (void)saveChanges;
- (void)saveChangesInBackground:(void(^)())callback;

@end
