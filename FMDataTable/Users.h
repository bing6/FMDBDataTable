//
//  Users.h
//  FMDataTable
//
//  Created by bing.hao on 16/3/9.
//  Copyright © 2016年 bing.hao. All rights reserved.
//

#import "FMDTObject.h"

@interface Users : FMDTObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSDictionary *other;

@end
