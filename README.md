# FMDataTable

这是一个简易的ORM工具，满足了对单表操作增删改查等操作。


    Member * obj1 = [Member createInstance:@"Jack" :@"Liu" :@"http://www.baidu.com"];
    Member * obj2 = [Member createInstance:@"Lucy" :@"Wang" :@"http://www.baidu.com"];
    Member * obj3 = [Member createInstance:@"Tom" :@"Zhang" :@"http://www.baidu.com"];
    Member * obj4 = [Member createInstance:@"Howard" :@"Zhao" :@"http://www.baidu.com"];

    //单个保存数据
    [obj1 save];
    [obj2 save];
    [obj3 save];
    [obj4 save];
    
    obj1.firstName = @"XiaoMing";
    //修改数据
    [obj1 save];


    //批量更橷数据,存在相同的pid更新,返之插入
    [Member batchSave:@[obj1, obj2, obj3, obj4] complete:^(id res, NSError *err) {
        
    }];
    
    //删除数据
    [obj1 destroy];


    //各种查询
    NSLog(@"%@", [Member order:@"createdAt desc"]);
    NSLog(@"%@", [Member where:@"name = ?" args:@[ @"Jack" ]]);
    NSLog(@"%@", [Member where:@"name = ?" args:@[ @"Lucy" ] order:@"createdAt desc" limit:@2 offset:@1]);
    NSLog(@"%@", [Member executeQuery:@"select * from member"]);
    NSLog(@"%@", [Member first:@"pid=?" args:@[@"D57F411A-0587-4E4C-9596-1C0C05041715"]]);
    NSLog(@"%@", [Member findEqualWithField:@"name" value:@"XiaoMing"]);
    NSLog(@"%@", [Member findNotEqualWithField:@"name" value:@"XiaoMing"]);
    NSLog(@"%@", [Member findLikeWithField:@"name" value:@"Xiao"]);
    NSLog(@"%@", [Member findByPid:@"D57F411A-0587-4E4C-9596-1C0C05041715"]);



    //清除所有数据
    [Member clear];
