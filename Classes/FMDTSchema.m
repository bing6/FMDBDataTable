//
//  FMDTSchema.m
//  FMDataTable
//
//  Created by bing.hao on 16/3/8.
//  Copyright © 2016年 bing.hao. All rights reserved.
//

#import "FMDTSchema.h"
#import "NSObject+runtime.h"
#import "FMDTObject.h"

#define FMDT_DB_TYPE_TEXT   @"text"
#define FMDT_DB_TYPE_NUMBER @"integer"
#define FMDT_DB_TYPE_BLOB   @"blob"
#define FMDT_DB_TYPE_DATE   @"date"

#define FMDT_DTS_F_OBJ_NAME @"__DTS_F_OBJ_NAME"
#define FMDT_DTS_F_OBJ_TYPE @"__DTS_F_OBJ_TYPE"
#define FMDT_DTS_F_NAME     @"__DTS_F_NAME"
#define FMDT_DTS_F_TYPE     @"__DTS_F_TYPE"

BOOL FMDT_IsCollectionObject(NSString *type) {
    if ([type isEqualToString:@"T@\"NSDictionary\""] ||
        [type isEqualToString:@"T@\"NSMutableDictionary\""] ||
        [type isEqualToString:@"T@\"NSArray\""] ||
        [type isEqualToString:@"T@\"NSMutableArray\""]) {
        return YES;
    }
    return NO;
}

BOOL FMDT_IsDateObject(NSString *type) {
    if ([type isEqualToString:@"T@\"NSDate\""]) {
        return YES;
    }
    return NO;
}

BOOL FMDT_IsDataObject(NSString *type) {
    if ([type isEqualToString:@"T@\"NSData\""]) {
        return YES;
    }
    return NO;
}

NSDictionary * FMDTNewField(NSString *name, NSString *type)
{
    static NSDictionary *__map;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __map = @{ @"T@\"NSString\"":FMDT_DB_TYPE_TEXT,
                   @"T@\"NSNumber\"":FMDT_DB_TYPE_NUMBER,
                   @"T@\"NSDate\"":FMDT_DB_TYPE_DATE,
                   @"T@\"NSData\"":FMDT_DB_TYPE_BLOB,
                   @"Ti":FMDT_DB_TYPE_NUMBER,
                   @"T^i":FMDT_DB_TYPE_NUMBER,
                   @"Tf":FMDT_DB_TYPE_NUMBER,
                   @"Tq":FMDT_DB_TYPE_NUMBER,
                   @"Td":FMDT_DB_TYPE_NUMBER,
                   @"T@\"NSDictionary\"":FMDT_DB_TYPE_TEXT,
                   @"T@\"NSMutableDictionary\"":FMDT_DB_TYPE_TEXT,
                   @"T@\"NSArray\"":FMDT_DB_TYPE_TEXT,
                   @"T@\"NSMutableArray\"":FMDT_DB_TYPE_TEXT,
                   };
    });
    NSString *dbType = [__map objectForKey:type];
    if (dbType) {
        return @{ FMDT_DTS_F_OBJ_NAME:name, FMDT_DTS_F_OBJ_TYPE : type, FMDT_DTS_F_NAME:name, FMDT_DTS_F_TYPE:dbType };
    }
    return nil;
}

@implementation FMDTSchemaTable

- (NSString *)statementUpdate {
    if (_statementUpdate == nil) {
        
        Class cls = NSClassFromString(self.className);
        NSString *pk = [(id)cls performSelector:@selector(primaryKeyFieldName) withObject:nil];
        NSAssert(pk, @"必须指定主键字段");
        NSMutableString *where = [NSMutableString stringWithString:@"where "];
        NSArray *tmp = [pk componentsSeparatedByString:@","];
        if (tmp.count > 1) {
            for (NSString *entry in tmp) {
                [where appendFormat:@"[%@]=:%@ and ", entry, entry];
            }
            [where deleteCharactersInRange:NSMakeRange(where.length - 5, 5)];
        } else {
            [where appendFormat:@"[%@]=:%@", pk, pk];
        }
        NSMutableArray * keys = [NSMutableArray arrayWithCapacity:self.fields.count];
        for (int i = 0; i < self.fields.count; i++) {
            NSString *fname = [[self.fields objectAtIndex:i] name];
            if ((int)[pk rangeOfString:fname].location < 0) {
                [keys addObject:[NSString stringWithFormat:@"[%@]=:%@", fname, fname]];
            }
//            if ([fname isEqualToString:pk] == NO) {
//                [keys addObject:[NSString stringWithFormat:@"[%@]=:%@", fname, fname]];
//            }
        }
        NSString * key = [keys componentsJoinedByString:@","];
        _statementUpdate = [NSString stringWithFormat:@"update [%@] set %@ %@", self.tableName, key, where];
    }
    return _statementUpdate;
}

- (NSString *)statementDelete {
    if (_statementDelete == nil) {
        _statementDelete = [NSString stringWithFormat:@"delete from [%@]", self.tableName];;
    }
    return _statementDelete;
}

- (NSString *)statementInsert {
    if (_statementInsert == nil) {
        NSMutableArray * keys = [NSMutableArray arrayWithCapacity:self.fields.count];
        NSMutableArray * vals = [NSMutableArray arrayWithCapacity:self.fields.count];
        for (int i = 0; i < self.fields.count; i++) {
            FMDTSchemaField *field = self.fields[i];
            [keys addObject:[NSString stringWithFormat:@"[%@]", field.name]];
            [vals addObject:@"?"];
        }
        NSString * key = [keys componentsJoinedByString:@","];
        NSString * val = [vals componentsJoinedByString:@","];
        _statementInsert = [NSString stringWithFormat:@"insert into [%@] (%@) values (%@)", self.tableName, key, val];
    }
    return _statementInsert;
}

- (NSString *)statementReplace {
    if (_statementReplace == nil) {
        NSMutableArray * keys = [NSMutableArray arrayWithCapacity:self.fields.count];
        NSMutableArray * vals = [NSMutableArray arrayWithCapacity:self.fields.count];
        for (int i = 0; i < self.fields.count; i++) {
            FMDTSchemaField *field = self.fields[i];
            [keys addObject:[NSString stringWithFormat:@"[%@]", field.name]];
            [vals addObject:@"?"];
        }
        NSString * key = [keys componentsJoinedByString:@","];
        NSString * val = [vals componentsJoinedByString:@","];
        _statementReplace = [NSString stringWithFormat:@"replace into [%@] (%@) values (%@)", self.tableName, key, val];
    }
    return _statementReplace;
}

- (instancetype)initWithClass:(Class)cls storage:(NSString *)storage {
    self = [super init];
    if (self) {
        self.className = NSStringFromClass(cls);
        self.tableName = self.className;
        self.storage = storage;
        
        NSString *pk = [(id)cls performSelector:@selector(primaryKeyFieldName) withObject:nil];
        
        NSMutableArray * fields = [NSMutableArray new];
        [NSObject enumeratePropertiesWithClassType:cls usingBlick:^(BOOL read, NSString *name, NSString *type, NSArray *attrs) {
            NSDictionary * item = nil;
            if (!read && (item = FMDTNewField(name, type))) {
                FMDTSchemaField *field = [[FMDTSchemaField alloc] initWithDictionary:item];
                if (pk && [field.objName isEqualToString:pk]) {
                    field.primaryKey = YES;
                }
                [fields addObject:field];
            }
        }];
        
        self.fields = fields;
    }
    return self;
}

- (instancetype)initWithClass:(Class)cls customTableName:(NSString *)name storage:(NSString *)storage {
    self = [self initWithClass:cls storage:storage];
    if (self) {
        self.tableName = name;
    }
    return self;
}

@end

@implementation FMDTSchemaField

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.objName = [dictionary objectForKey:FMDT_DTS_F_OBJ_NAME];
        self.objType = [dictionary objectForKey:FMDT_DTS_F_OBJ_TYPE];
        self.name = [dictionary objectForKey:FMDT_DTS_F_NAME];
        self.type = [dictionary objectForKey:FMDT_DTS_F_TYPE];
    }
    return self;
}

@end
