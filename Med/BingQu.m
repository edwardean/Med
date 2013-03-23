//
//  BingQu.m
//  masterDemo
//
//  Created by Edward on 13-3-6.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "BingQu.h"

@implementation BingQu

+ (BOOL)createNewBingQu:(NSString *)bingqu {
    
    debugMethod();
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    BOOL isOK = NO;
    if ([dataBase open]) {
            isOK = [dataBase executeUpdate:@"INSERT INTO BingQu (Name) VALUES (?)",bingqu];
    }
    [dataBase close];
    return isOK;

}

+ (BOOL)findTheSameBingQu:(NSString *)bingqu {
    
    debugMethod();
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    BOOL isOK  = NO;
    if ([dataBase open]) {
        FMResultSet *rs = [dataBase executeQuery:@"SELECT * FROM BingQu"];
        while ([rs next]&&(isOK == NO)) {
            NSString *str = [rs stringForColumn:@"Name"];
            if ([str isEqualToString:bingqu]) {
                isOK = YES;
            }
        }
    }
    [dataBase close];
    return isOK;

}

+ (int)countAllBingQu {
    
    debugMethod();
    int count = 0;
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    if ([dataBase open]) {
        FMResultSet *rs = [dataBase executeQuery:@"SELECT * FROM BingQu"];
        while ([rs next]) {
            count++;
        }
    }
    [dataBase close];
    return count;

}

+ (NSMutableArray *)findAllBingQuIntoArray {
    
    debugMethod();
    NSMutableArray *arry = [NSMutableArray array];
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    if ([dataBase open]) {
        FMResultSet *rs = [dataBase executeQuery:@"SELECT * FROM BingQu"];
        while ([rs next]) {
            NSString *str = [rs stringForColumn:@"Name"];
            [arry addObject:str];
        }
    }
    [dataBase close];
    return arry;
}
@end
