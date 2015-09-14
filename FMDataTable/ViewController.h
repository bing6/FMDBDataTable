//
//  ViewController.h
//  FMDataTable
//
//  Created by bing.hao on 15/8/31.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDataTable.h"

@interface Employee : FMDataTable

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, assign) NSInteger age;

@property (nonatomic, strong, readonly) NSString *fullName;

@end

@interface Company : FMDataTable

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;


@end

@interface ViewController : UIViewController

@end

