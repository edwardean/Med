//
//  dataBaseManager.h
//  fmdbtest
//
//  Created by Edward on 13-3-1.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Config.h"
@interface dataBaseManager : NSObject

/**数据库对象单例方法**/
+ (FMDatabase *)createDataBase;

/**关闭数据库**/
+ (void)closeDataBase;

/**清空数据库内容**/
+ (void)deleteDataBase;

/**判断表是否存在**/
+ (BOOL) isTableExist:(NSString *)tableName;

/**
 分别创建药品Medicine   科室Office  病区BingQu表
 Medicine表：
 id(主键)  Name药品名称  Specifi规格(mg/ml)  Content(原来指含量，后改为产地)
 
 Office表:
 id(主键) Name科室名称
 
 BingQu表:
 id(主键) Name病区名称
 
 Record表：
 id(主键)  PatientName病人姓名  Office所属病区
 
 Detail表
 id(主键) Name药名  Count药的用量
 **/
- (BOOL)createTable;
@end
