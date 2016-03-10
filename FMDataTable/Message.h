//
//  Message.h
//  FMDataTable
//
//  Created by bing.hao on 16/3/10.
//  Copyright © 2016年 bing.hao. All rights reserved.
//

#import "FMDTObject.h"

@interface Message : FMDTObject

@property (nonatomic, strong) NSString *mid;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;

@end
