//
//  ViewController.m
//  FMDataTable
//
//  Created by bing.hao on 15/8/31.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import "ViewController.h"
#import "DBSet.h"
#import "FMDTKeyValueStorage.h"

@interface ViewController ()

@end

@implementation ViewController

//批量添加数据
- (void)insertData {
    NSMutableArray *userArray = [NSMutableArray new];
    for (int i = 0; i < 100; i++) {
        Users *userObjct = [Users new];
        userObjct.userId = i + 1;
        userObjct.nickname = [NSString stringWithFormat:@"user%d", i];
        userObjct.sex = i % 2 == 0 ? @"女" : @"男";
        [userArray addObject:userObjct];
    }

    //创建插入对象
    FMDTInsertCommand *icmd = [[DBSet shared].user createInsertCommand];
    //添加要插入的对象集合
    [icmd addWithArray:userArray];
    //设置添加操作是否使用replace语句
    [icmd setRelpace:YES];
    //执行插入操作
    [icmd saveChangesInBackground:^{
        NSLog(@"批量数据提交完成");
    }];
}

//更新数据
- (void)updateData {
    
    Users *userObjct = [Users new];

    userObjct.userId = 1;
    userObjct.nickname = @"小明";
    userObjct.sex = @"男";
    userObjct.other = @{ @"f1" : @(1), @"f2" : @"f2" };

    //通过对象更新数据
    FMDTUpdateObjectCommand *ucmd1 = [[DBSet shared].user createUpdateObjectCommand];

    //添加要更新的对象
    [ucmd1 add:userObjct];
    //执行更新操作
    [ucmd1 saveChangesInBackground:^{
        NSLog(@"更新完成");
    }];

    //通过条件更新数据
    FMDTUpdateCommand *ucmd2 = [[DBSet shared].user createUpdateCommand];
    //设置要更新的字段与值
    [ucmd2 fieldWithKey:@"sex" val:@"女"];
    //设置更新条件
    [ucmd2 where:@"userId" equalTo:@(2)];
    //执行更新操作
    [ucmd2 saveChanges];
}

//删除数据
- (void)deleteData {
    
    FMDTDeleteCommand *dcmd = FMDT_DELETE([DBSet shared].user);
    //设置条件
    [dcmd where:@"userId" greaterThan:@"50"];
    //执行删除操作
    [dcmd saveChanges];
}

//查询数据
- (void)selectData {
    //查询数据
    FMDTSelectCommand *cmd = [[DBSet shared].user createSelectCommand];

    //单一条件查询
    //SQL:select * from [Users] where sex = '男'
    [cmd where:@"sex" equalTo:@"男"];
    [cmd fetchArray];

    //多条件And查询
    //SQL:select * from [Users] where sex = '男' and nickname like '%1%'
    [cmd where:@"sex" equalTo:@"男"];
    [cmd where:@"nickname" containsString:@"%1%"];
    [cmd fetchArray];

    //多条件Or查询
    //SQL:select * from [Users] where nickname like '%1%' or sex = '男'
    [cmd where:@"nickname" containsString:@"%1%"];
    [cmd whereOr:@"sex" equalTo:@"男"];
    [cmd fetchArray];

    //In
    //SQL:select count(*) from Users where sex in ('女','男')
    [cmd where:@"sex" containedIn:@[ @"女", @"男"]];
    [cmd fetchArray];

    //Not In
    //SQL:select count(*) from Users where sex not in ('女','男')
    [cmd where:@"sex" notContainedIn:@[ @"女", @"男"]];
    [cmd fetchArray];

    //Like
    //SQL:select * from [Users] where nickname like '%1%'
    [cmd where:@"nickname" containsString:@"%1%"];
    [cmd fetchArray];

    //Not Like
    //SQL:select * from [Users] where nickname not like '%1%'
    [cmd where:@"nickname" notContainsString:@"%1%"];
    [cmd fetchArray];

    // <
    //SQL:select * from Users where  userId < '30'
    [cmd where:@"userId" lessThan:@(30)];
    [cmd fetchArray];

    // <=
    //SQL:select * from Users where  userId <= '30'
    [cmd where:@"userId" lessThanOrEqualTo:@(30)];
    [cmd fetchArray];

    // >
    //SQL:select * from Users where  userId > '30'
    [cmd where:@"userId" greaterThan:@(30)];
    [cmd fetchArray];

    // >=
    //SQL:select * from Users where  userId >= '30'
    [cmd where:@"userId" greaterThanOrEqualTo:@(30)];
    [cmd fetchArray];

    //排序 ascending.
    //SQL:select * from Users order by userId asc
    [cmd orderByAscending:@"userId"];
    [cmd fetchArray];

    //排序 descending.
    //SQL:select * from Users order by userId desc
    [cmd orderByDescending:@"userId"];
    [cmd fetchArray];

    //获取前10条
    //SQL:select * from Users limit 10
    [cmd setLimit:10];
    [cmd fetchArray];
    
    //分页获取数据
    //SQL:select * from Users limit 10 offset 10
    [cmd setLimit:10];
    [cmd setSkip:10];
    [cmd fetchArray];
    
    [cmd groupBy:@"sex"];
    [cmd fetchArrayInBackground:^(NSArray *result) {
        NSLog(@"%@", result);
    }];
}

- (void)dyInsertData {
    NSMutableArray *array = [NSMutableArray new];
    for (int i = 0; i < 100; i++) {
        Message *mobj = [Message new];
        mobj.mid = FMDT_UUID();
        mobj.text = FMDT_UUID();
        mobj.createdAt = [NSDate new];
        [array addObject:mobj];
    }
    
    //创建插入对象
    FMDTInsertCommand *icmd = [[[DBSet shared] dynamicTable:@"message_2B8970F2F4394B7CB4C8027FB198817A"] createInsertCommand];
    //添加要插入的对象集合
    [icmd addWithArray:array];
    //设置添加操作是否使用replace语句
    [icmd setRelpace:YES];
    //执行插入操作
    [icmd saveChangesInBackground:^{
        NSLog(@"批量数据提交完成");
    }];

}

- (void)testKeyValue {
    
    //字符串存储
    [STORE set:@"a1" value:@"我是字符串"];
    //数值存储
    [STORE set:@"a2" value:@(1)];
    //字典存储
    [STORE set:@"a3" value:@{@"test1": @"abc", @"test2": @"abc222"}];
    //数组存储
    [STORE set:@"a4" value:@[@(1),@(2),@(3),@(4)]];
    
    //读取字符串
    NSLog(@"%@", [STORE stringForKey:@"a1"]);
    //读取数值
    NSLog(@"%@", [STORE numberForKey:@"a2"]);
    //读取字典
    NSLog(@"%@", [STORE dictionaryForKey:@"a3"]);
    //读取数组
    NSLog(@"%@", [STORE arrayForKey:@"a4"]);
    
    //删除键值
    [STORE removeForKey:@"a1"];
    //清除所有的键值
    [STORE removeAll];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]);
    
//    [self insertData];  //插入数据
//    [self updateData];  //更新数据
//    [self deleteData];  //删除数据
//    [self selectData];  //查询数据
//    
//    [self dyInsertData]; //向动态表里添加数据
    
    [self testKeyValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
