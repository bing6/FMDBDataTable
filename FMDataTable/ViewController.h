//
//  ViewController.h
//  FMDataTable
//
//  Created by bing.hao on 15/8/31.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDataTable.h"

@interface Member : FMDataTable

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *avatar;

@property (nonatomic, strong, readonly) NSString *fullName;

+ (instancetype)createInstance:(NSString *)firstName :(NSString *)lastName :(NSString *)avatar;

@end

@interface ViewController : UIViewController


@end

