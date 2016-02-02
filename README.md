# 描述

    这是一个简易的ORM工具,只需要几步就可以完成对单表的操作CRUD操作.
    
# 建立模型

    //首先需要将Model对象继承FMDataTable,并建立好属性字段.
    //注意：
    //1.只读字段不会建立持久化关系,我们可以利用这点把不需要保存到库中的字段建立排除关系.
    //2.继承FMDataTable默认会加入三个属性字段pid(主键), createdAt(创建时间), updatedAt(更新时间)
    //3.pid默认是一个GUID类型字符串,默认值产生的规则是第一次调用pid值为nil时自动添加,
    //  pid可以是NSNumber或者是NSString
    
    //==========================================================================================>
    
    @interface Company : FMDataTable
    
    @property (nonatomic, strong) NSString *name;
    @property (nonatomic, strong) NSString *address;
    
    @end
    
    @implementation Company
    
    @end
    
    //==========================================================================================>
    
    @interface Employee : FMDataTable

    @property (nonatomic, strong) NSString *firstName;
    @property (nonatomic, strong) NSString *lastName;
    @property (nonatomic, assign) NSInteger age;
    
    @property (nonatomic, strong, readonly) NSString *fullName;
    
    @end

    @implementation Employee
    
    - (NSString *)fullName
    {
        return [NSString stringWithFormat:@"%@.%@", self.firstName, self.lastName];
    }
    
    @end
    
# 设置
    /*******************************************************
     * 全局设置
     *
     * DTM_SHARE是FMDataTableManager的一个共享实例,
     * 我们可以它来设置日志输出,模型的存放位置等操作,
     * 当然你什么都不做也是可以的。
     *******************************************************/
    
    //打开日志输出
    [DTM_SHARE setLogEnabled:YES];
    
    //设定模型数据存储在那个库下
    //默认会存储在沙盒下的Library/Caches/{Bundle Identifier}.db
    //这时需要注意的是绑定之前,不要对模型做任何的方法调用,因为会触发initialize方法,
    //数据表的建立都是在这个方法内做的.
    //设置我们建议放到AppDelegate做去做
    [DTM_SHARE bindModelWithName:@"Company" dbName:@"test1"];
    [DTM_SHARE bindModelWithName:@"Employee" dbName:@"test2"];

#保存数据
    
    //保存记录只需要调用save方法,如果记录存在就更新,没有就添加.
    Company *myCom = [Company new];

    [myCom setPid:@(8888)];
    [myCom setName:@"北京清大世纪教育集团"];
    [myCom setAddress:@"北京市鲁谷路74号院"];
    [myCom save];

    Employee *emp1 = [Employee new];
    
    [emp1 setPid:@(727)];
    [emp1 setFirstName:@"KeQiang"];
    [emp1 setLastName:@"Li"];
    [emp1 setAge:18];
    [emp1 save];

#批量保存数据

    Employee *emp2 = [Employee new];
    [emp2 setPid:@(800)];
    [emp2 setFirstName:@"JinPin"];
    [emp2 setLastName:@"Xi"];
    [emp2 setAge:22];
    Employee *emp3 = [Employee new];
    [emp3 setPid:@(810)];
    [emp3 setFirstName:@"QiShan"];
    [emp3 setLastName:@"Wang"];
    [emp3 setAge:20];
    
    [Employee batchSave:@[ emp2, emp3 ] complete:^(id res, NSError *err) {
        
    }];
    
#更新数据

    Employee *emp = [Employee findByPid:@727];
    [emp setAge:25];
    [emp save];
    
#返回多条数据查询

    //返回多条数据,条件
    NSArray *result1 = [Employee where:@"age > ?" args:@[ @(22) ]];
    
    //返回多条数据,条件
    NSArray *result2 = [Employee where:@"age > ?" args:@[ @(22)] order:@"age desc" limit:nil offset:nil];
    
    //返回多条数据,条件,排序,分页
    NSArray *result3 = [Employee where:@"age > ?" args:@[ @(22)] order:@"age desc" limit:@(20) offset:@1];
    
    //返回多条数据,排序
    NSArray *result4 = [Employee order:@"age desc"];
    
    //返回多条数据,排序,分页
    NSArray *result5 = [Employee order:@"age desc" limit:@20 offset:@1];
    
#返回一条数据查询

    //返回一条数据
    Employee *result6 = [Employee first:@"firstName = ?" args:@[ @"KeQiang" ]];
    
    //返回一条数据,根据主键ID查询获取数据
    Employee *result7 = [Employee findByPid:@727];

#根据字段查询结果

    //返回多条数据,根据字段值获取
    NSArray *result8 = [Employee findEqualWithField:@"firstName" value:@"KeQiang"];
    
    //返回多条数据,根据字段值取返获取
    NSArray *result9 = [Employee findNotEqualWithField:@"firstName" value:@"KeQiang"];
    
    //返回多条数据,根据字段值模糊匹配
    NSArray *result10 = [Employee findLikeWithField:@"firstName" value:@"Ke"];


#使用链式表达示查询

    //返回多条数据,条件
    NSArray *result11 = [Employee query].where(@"firstName", @"KeQiang").whereOr(@"lastName", @"Xi").fetchArray();
    //返回多条数据,排序
    NSArray *result12 = [Employee query].orderByAsc(@"lastName").fetchArray();
    //返回数据条数
    NSNumber *result13 = [Employee query].fetchCount();

#动态创建表

    //首先要创建一个基类,在根据基类创建动态类型
    id ctype = __GetDynamicTableType(@"Message_12324883", [Message class]);
    
    Message *msg = __NEW(ctype);
    msg.body = @"你好";
    [msg save];
    
    FMDataTableQuery *query = nil;
    if ([ctype respondsToSelector:@selector(query)]) {
        query = [ctype performSelector:@selector(query)];
    }
    
    NSLog(@"%@", query.fetchArray());

# Installation

pod 'FMDBDataTable', '~> 0.7.4'

