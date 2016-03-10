//
//  DBSet.h
//  FMDataTable
//
//  Created by bing.hao on 16/3/9.
//  Copyright © 2016年 bing.hao. All rights reserved.
//

#import "FMDTManager.h"
#import "Users.h"
#import "Message.h"

@interface DBSet : FMDTManager

@property (nonatomic, strong, readonly) FMDTContext *user;

- (FMDTContext *)dynamicTable:(NSString *)name;

@end
