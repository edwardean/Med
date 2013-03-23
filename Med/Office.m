//
//  Office.m
//  masterDemo
//
//  Created by Edward on 13-3-6.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "Office.h"

@implementation Office

+ (BOOL)createNewOffcie:(NSString *)office {
    
    debugMethod();
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    BOOL isOK = NO;
    if ([dataBase open]) {
        isOK = [dataBase executeUpdate:@"INSERT INTO Office (Name) VALUES (?)",office];
    }
    [dataBase close];
    return isOK;
}

+ (BOOL)findTheSameOffcie:(NSString *)office {
    
    debugMethod();
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    BOOL isOK  = NO;
    if ([dataBase open]) {
        FMResultSet *rs = [dataBase executeQuery:@"SELECT * FROM Office"];
        while ([rs next]&&(isOK == NO)) {
            NSString *str = [rs stringForColumn:@"Name"];
            if ([str isEqualToString:office]) {
                isOK = YES;
            }
        }
    }
    [dataBase close];
    return isOK;
}
+ (int)countAllOffcie {
    debugMethod();
    int count = 0;
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    if ([dataBase open]) {
        FMResultSet *rs = [dataBase executeQuery:@"SELECT * FROM Office"];
        while ([rs next]) {
            count++;
        }
    }
    [dataBase close];
    return count;
}

+ (NSMutableArray *)findAllOffcieIntoArray {
    
    debugMethod();
    NSMutableArray *arry = [NSMutableArray array];
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    if ([dataBase open]) {
        FMResultSet *rs = [dataBase executeQuery:@"SELECT * FROM Office"];
        while ([rs next]) {
            NSString *str = [rs stringForColumn:@"Name"];
            [arry addObject:str];
        }
    }
    [dataBase close];
    return arry;
}
@end
