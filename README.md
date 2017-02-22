# FMDBDataTable

    这是一个简易的ORM工具,只需要几步就可以完成对单表的CRUD操作.


# 建立模型

    @interface Users : FMDTObject

	@property (nonatomic, assign) NSInteger userId;
	@property (nonatomic, strong) NSString *nickname;
	@property (nonatomic, strong) NSString *sex;
	@property (nonatomic, strong) NSDictionary *other;

	@end

	@interface Message : FMDTObject

	@property (nonatomic, strong) NSString *mid;
	@property (nonatomic, strong) NSString *text;
	@property (nonatomic, strong) NSDate *createdAt;

	@end

    
# 设置FMDTContext管理类

    @interface DBSet : FMDTManager

	@property (nonatomic, strong, readonly) FMDTContext *user;

	- (FMDTContext *)dynamicTable:(NSString *)name;

	@end


	@implementation DBSet

	- (FMDTContext *)user {
	    /**
	     *  缓存FMDTContext对象,第一次创建时会自动生成表结构
	     *  默认存储在默认会存储在沙盒下的Library/Caches/{Bundle Identifier}.db,
	     *  如果想要对每一个用户生成一个库,可以自定义Path,
	     *  使用[self cacheWithClass: dbPath:]方法
	     */
	    return [self cacheWithClass:[Users class]];
	}

	- (FMDTContext *)dynamicTable:(NSString *)name {
	    
	    /**
	     *  设置将对象映射到不同的数据表
	     */
	    return [self cacheWithClass:[Message class] tableName:name];
	}

	@end

#添加数据
    
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
    
#更新数据

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
    [ucmd2 fieldWithKey:@"nickname" val:@"小红"];
    //设置更新条件
    [ucmd2 where:@"userId" equalTo:@(2)];
    //执行更新操作
    [ucmd2 saveChanges];

    
#删除数据

    FMDTDeleteCommand *dcmd = FMDT_DELETE([DBSet shared].user);
    //设置条件
    [dcmd where:@"userId" greaterThan:@"50"];
    //执行删除操作
    [dcmd saveChanges];
    
#查询数据

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

# 基于KeyValue的存储功能

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
    NSLog(@"%@", [STORE stringForKey:@"a2"]);
    //读取字典
    NSLog(@"%@", [STORE stringForKey:@"a3"]);
    //读取数组
    NSLog(@"%@", [STORE stringForKey:@"a4"]);

    //删除键值
    [STORE removeForKey:@"a1"];
    //清除所有的键值
    [STORE removeAll];

# Installation

pod 'FMDBDataTable'

