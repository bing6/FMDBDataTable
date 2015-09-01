# Description

    这是一个简易的ORM工具,只需要几步就可以完成对单表的操作CRUD操作.

# Setup

    首先需要将Model对象继承FMDataTable,并建立好属性字段.
    注意：
    1.只读字段不会建立持久化关系,我们可以利用这点把不需要保存到库中的字段建立排除关系.
    2.继承FMDataTable默认会加入三个属性字段pid(主键), createdAt(创建时间), updatedAt(更新时间)
      主键ID被定义为字符串类型
      
    @interface Member : FMDataTable
    
    @property (nonatomic, strong) NSString *firstName;
    @property (nonatomic, strong) NSString *lastName;
    @property (nonatomic, strong) NSString *avatar;
    @property (nonatomic, strong) NSinteger age;
    /**
    * @brief 用于显示全名,这是只读字段,不会保存到库中
    */
    @property (nonatomic, strong, readonly) NSString *fullName;
    
    + (instancetype)createInstance:(NSString *)firstName :(NSString *)lastName :(NSString *)avatar;
    
    @end
    
    
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
    
    
# Save    
    
    Member * obj1 = [Member createInstance:@"Jack" :@"Liu" :@"http://www.demo.com"];
    Member * obj2 = [Member createInstance:@"Lucy" :@"Wang" :@"http://www.demo.com"];
    Member * obj3 = [Member createInstance:@"Tom" :@"Zhang" :@"http://www.demo.com"];
    Member * obj4 = [Member createInstance:@"Howard" :@"Zhao" :@"http://www.demo.com"];

    //保存数据
    [obj1 save];
    [obj2 save];
    [obj3 save];
    [obj4 save];
    
    //修改数据
    obj1.firstName = @"XiaoMing";
    [obj1 save];

    //批量更橷数据,存在相同的pid更新,返之插入
    [Member batchSave:@[obj1, obj2, obj3, obj4] complete:^(id res, NSError *err) {
        
    }];
    
# Delete
    //删除数据
    [obj1 destroy];
    //清除所有数据
    [Member clear];

# Select 

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

    //链式查询
    FMDataTableQuery * query = [Member query];
    
    NSLog(@"%@", query.where(@"sss", @(4)).fetchFirst());
    
    NSArray *result = [Member query]
                        .where(@"sss", @(4))
                        .whereOr(@"lastName", @"Zhang")
                        .orderByDesc(@"createdAt")
                        .fetchArray();
    NSLog(@"%@", result);


# Installation

pod 'FMDBDataTable', '~> 0.2'

