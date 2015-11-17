//
//  ViewController.m
//  FMDataTable
//
//  Created by bing.hao on 15/8/31.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import "ViewController.h"
#import "FMDataTable+Query.h"
#import "FMDataTable+KVC.h"

@implementation Company

@end

@implementation Employee

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
    
//    /*******************************************************
//     * 全局设置
//     *
//     * DTM_SHARE是FMDataTableManager的一个共享实例,
//     * 我们可以它来设置日志输出,模型的存放位置等操作,
//     * 当然你什么都不做也是可以的。
//     *******************************************************/
//    
    //打开日志输出
    [DTM_SHARE setLogEnabled:YES];
//
//    //设定模型数据存储在那个库下
//    //默认会存储在沙盒下的Library/Caches/{Bundle Identifier}.db
//    //这时需要注意的是绑定之前,不要对模型做任何的方法调用,因为会触发initialize方法,
//    //数据表的建立都是在这个方法内做的.
//    //设置我们建议放到AppDelegate做去做
//    [DTM_SHARE bindModelWithName:@"Company" dbName:@"test1"];
//    [DTM_SHARE bindModelWithName:@"Employee" dbName:@"test2"];
//
//    
//    /*******************************************************
//     * 演示保存数据
//     *
//     * 模型继承FMDataTable默认有三个属性
//     * 1.pid 用于存放唯一ID,id类型(之所以使用ID类型是考虑到网站上拿到的数据可能是INT型),默认会产生一个GUID
//     * 2.createdAt 记录产生时间,double类型
//     * 3,udpatedAt 记录修改时间,double类型
//     * 
//     * 保存对象需要调用save方法,如果记录存在就更新,没有就添加.
//     *******************************************************/
//    
//    //单一记录保存
//    Company *myCom = [Company new];
//
//    [myCom setPid:@(8888)];
//    [myCom setName:@"北京清大世纪教育集团"];
//    [myCom setAddress:@"北京市鲁谷路74号院"];
//    [myCom save];
//
//    Employee *emp1 = [Employee new];
//    
//    [emp1 setPid:@(727)];
//    [emp1 setFirstName:@"KeQiang"];
//    [emp1 setLastName:@"Li"];
//    [emp1 setAge:18];
//    [emp1 save];
//
//    //批理数据保存
//    Employee *emp2 = [Employee new];
//    [emp2 setPid:@(800)];
//    [emp2 setFirstName:@"JinPin"];
//    [emp2 setLastName:@"Xi"];
//    [emp2 setAge:22];
//    Employee *emp3 = [Employee new];
//    [emp3 setPid:@(810)];
//    [emp3 setFirstName:@"QiShan"];
//    [emp3 setLastName:@"Wang"];
//    [emp3 setAge:20];
//    [Employee batchSave:@[ emp2, emp3 ] complete:^(id res, NSError *err) {
//        
//    }];
//
//    //修改数据
//    [emp2 setAge:25];
//    [emp1 save];
//
//    /*******************************************************
//     * 演示删除数据
//     *******************************************************/
//    
//    //删除一条数据
//    [emp1 destroy];
//    //根据唯一ID删除
//    [Employee destroyByPid:@(727)];
//    //根据字段删除
//    [Employee destroyWithField:@"lastName" value:@"Xi"];
//    //自定义条件删除
//    [Employee destroyWithWhere:@"lastName = ?" args:@[ @"Wang" ]];
//    //删除所有数据
//    [Employee clear];
//    
//    
//    /*******************************************************
//     * 演示查询数据
//     *******************************************************/
//    
//    //返回多条数据,条件
//    NSArray *result1 = [Employee where:@"age > ?" args:@[ @(22) ]];
//    
//    //返回多条数据,条件
//    NSArray *result2 = [Employee where:@"age > ?" args:@[ @(22)] order:@"age desc" limit:nil offset:nil];
//    
//    //返回多条数据,条件,排序,分页
//    NSArray *result3 = [Employee where:@"age > ?" args:@[ @(22)] order:@"age desc" limit:@(20) offset:@1];
//    
//    //返回多条数据,排序
//    NSArray *result4 = [Employee order:@"age desc"];
//    
//    //返回多条数据,排序,分页
//    NSArray *result5 = [Employee order:@"age desc" limit:@20 offset:@1];
//    
//    //返回一条数据
//    Employee *result6 = [Employee first:@"firstName = ?" args:@[ @"KeQiang" ]];
//    
//    //返回一条数据,根据主键ID查询获取数据
//    Employee *result7 = [Employee findByPid:@727];
//
//    //返回多条数据,根据字段值获取
//    NSArray *result8 = [Employee findEqualWithField:@"firstName" value:@"KeQiang"];
//    
//    //返回多条数据,根据字段值取返获取
//    NSArray *result9 = [Employee findNotEqualWithField:@"firstName" value:@"KeQiang"];
//    
//    //返回多条数据,根据字段值模糊匹配
//    NSArray *result10 = [Employee findLikeWithField:@"firstName" value:@"Ke"];
//    
//    
//    /*******************************************************
//     * 演示链式查询
//     *******************************************************/
//
    //返回多条数据,条件
    NSArray *result11 = [Employee query].where(@"firstName", @"KeQiang").whereOr(@"lastName", @"Xi").fetchArray();
    //返回多条数据,排序
    NSArray *result12 = [Employee query].orderByAsc(@"lastName").fetchArray();
    //返回数据条数
    NSNumber *result13 = [Employee query].fetchCount();
//
//    NSLog(@"%@", result1);
//    NSLog(@"%@", result2);
//    NSLog(@"%@", result3);
//    NSLog(@"%@", result4);
//    NSLog(@"%@", result5);
//    NSLog(@"%@", result6);
//    NSLog(@"%@", result7);
//    NSLog(@"%@", result8);
//    NSLog(@"%@", result9);
//    NSLog(@"%@", result10);
    NSLog(@"%@", result11);
    NSLog(@"%@", result12);
    NSLog(@"%@", result13);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
