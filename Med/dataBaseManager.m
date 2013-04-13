//
//  dataBaseManager.m
//  fmdbtest
//
//  Created by Edward on 13-3-1.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "dataBaseManager.h"

static FMDatabase *shareDataBase = nil;
@implementation dataBaseManager


/**
 创建数据库类的单例对象
 
 **/
+ (FMDatabase *)createDataBase {
    //debugMethod();
    @synchronized (self) {
        if (shareDataBase == nil) {
            
            shareDataBase = [[FMDatabase databaseWithPath:dataBasePath] retain];
        }
        return shareDataBase;
    }
}
/**
 判断数据库中表是否存在
 **/
+ (BOOL) isTableExist:(NSString *)tableName
{
    FMResultSet *rs = [shareDataBase executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        debugLog(@"%@ isOK %d", tableName,count);
        
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return NO;
}

/**
 创建表
 **/
- (BOOL)createTable {
    debugMethod();
    //NSFileManager *fileManager = [NSFileManager defaultManager];
    if (1){//[fileManager fileExistsAtPath:dataBasePath]) {
        shareDataBase = [dataBaseManager createDataBase];
        if ([shareDataBase open]) {
            NSString *sql = @"CREATE TABLE Medicine (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, Name text, Specifi text,Unit text,Content text,PYM text)";
            //Medicine药品表:
            //id 编号，主键，不为空;  name 药品名称  specifi 规格;  Content 含量 Unit单位(mg/ml)
            
            NSString *sql3 = @"CREATE TABLE BingQu (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,Name text)";
            //BingQu表:
            //id(主键) Name病区名称
            
            
            
            
            NSString *sql4 = @"CREATE TABLE Record (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,PatientName text, Office text,Date, text)";
            //Record表:
            //id(主键)  PatientName病人姓名  Office所属病区
            
            
            //NSString *sql5 = @"CREATE TABLE Detail (id INTEGER,Number INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,Name text,PYM text,Count text)";
             NSString *sql5 = @"CREATE TABLE Detail (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,Number INTEGER,Name text,PYM text,Count text)";
            //Detail表:
            //id(非主键，这个值与Record中每个病人的id相同) Number主键，每个病人每种药品的id Name药品名
            //PYM 拼音码   Count药的用量
            
            //NSString *sql6 = @"CREATE TABLE DATE (date_column DATE)";
            
            if (![dataBaseManager isTableExist:@"Medicine"]) {
                debugLog(@"no Medicine ");
                [shareDataBase executeUpdate:sql];
            }
            if (![dataBaseManager isTableExist:@"BingQu"]) {
                debugLog(@"no BingQu ");
                [shareDataBase executeUpdate:sql3];
            }
            if (![dataBaseManager isTableExist:@"Record"]) {
                debugLog(@"no Record ");
                [shareDataBase executeUpdate:sql4];
            }
            if (![dataBaseManager isTableExist:@"Detail"]) {
                debugLog(@"no Detail ");
                [shareDataBase executeUpdate:sql5];
            }
            if (!([dataBaseManager isTableExist:@"Medicine"]&&[dataBaseManager isTableExist:@"BingQu"]&&[dataBaseManager isTableExist:@"Record"]&&[dataBaseManager isTableExist:@"Detail"])) {
                debugLog(@"创建表失败");
                return NO;
            } else {
                debugLog(@"成功创建表");
            }
            [shareDataBase setShouldCacheStatements:YES];//设置缓存
        } else {
            debugLog(@"打开数据库时出现错误");
            return NO;
        }
    } else {
        debugLog(@"数据库不存在");
        return NO;
    }
    return YES;
}

/**
 关闭数据库
 **/
+ (void)closeDataBase {
    if(![shareDataBase close]) {
        debugLog(@"数据库关闭异常，请检查");
        return;
    }
}


/**
删除数据库
 **/
+ (void)deleteDataBase {
    if (shareDataBase != nil) {
        //这里进行数据库表的删除工作
    }
}
@end
