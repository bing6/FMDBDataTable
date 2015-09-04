//
//  ViewController.m
//  FMDataTable
//
//  Created by bing.hao on 15/8/31.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import "ViewController.h"
#import "FMDataTable+Query.h"

@implementation Member

+ (instancetype)createInstance:(NSString *)firstName :(NSString *)lastName :(NSString *)avatar
{
    Member * tmp = [Member new];
    tmp.firstName = firstName;
    tmp.lastName  = lastName;
    tmp.avatar    = avatar;
    return tmp;
}

- (NSString *)fullName
{
    return [NSString stringWithFormat:@"%@.%@", self.firstName, self.lastName];
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置输出日志
    DTM_SHARE.logEnabled = YES;

//    Member * obj1 = [Member createInstance:@"Jack" :@"Liu" :@"http://www.baidu.com"];
//    Member * obj2 = [Member createInstance:@"Lucy" :@"Wang" :@"http://www.baidu.com"];
//    Member * obj3 = [Member createInstance:@"Tom" :@"Zhang" :@"http://www.baidu.com"];
//    Member * obj4 = [Member createInstance:@"Howard" :@"Zhao" :@"http://www.baidu.com"];

//    obj1.pid = @(123);
//    obj1.sss = 1;
//    obj2.pid = @(124);
//    obj2.sss = 2;
//    obj3.pid = @(125);
//    obj3.sss = 3;
//    obj4.pid = @(126);
//    obj4.sss = 4;
//    
//    //单个保存数据
//    [obj1 save];
//    [obj2 save];
//    [obj3 save];
//    [obj4 save];

//
//    obj1.firstName = @"XiaoMing";
//    //修改数据
//    [obj1 save];

//    //批量更橷数据,存在相同的pid更新,返之插入
//    [Member batchSave:@[obj1, obj2, obj3, obj4] complete:^(id res, NSError *err) {
//        
//    }];
    
//    //删除数据
//    [obj1 destroy];
    
//    //各种查询
//    NSLog(@"%@", [Member order:@"createdAt desc"]);
//    NSLog(@"%@", [Member where:@"firstName = ?" args:@[ @"Jack" ]]);
//    NSLog(@"%@", [Member where:@"firstName = ?" args:@[ @"Lucy" ] order:@"createdAt desc" limit:@2 offset:@1]);
//    NSLog(@"%@", [Member executeQuery:@"select * from member"]);
//    NSLog(@"%@", [Member first:@"pid=?" args:@[@"D57F411A-0587-4E4C-9596-1C0C05041715"]]);
//    NSLog(@"%@", [Member findEqualWithField:@"firstName" value:@"XiaoMing"]);
//    NSLog(@"%@", [Member findNotEqualWithField:@"firstName" value:@"XiaoMing"]);
//    NSLog(@"%@", [Member findLikeWithField:@"firstName" value:@"Xiao"]);
//    NSLog(@"%@", [Member findByPid:@(126)]);
//
//    //清除所有数据
//    [Member clear];
    

//    //链式查询
//    FMDataTableQuery * query = [Member query];
//    
//    NSLog(@"%@", query.where(@"sss", @(4)).fetchFirst());
//    
//    NSArray *result = [Member query]
//                        .where(@"sss", @(4))
//                        .whereOr(@"lastName", @"Zhang")
//                        .orderByDesc(@"createdAt")
//                        .fetchArray();
//    NSLog(@"%@", result);


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
