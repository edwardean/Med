//
//  BingQu.m
//  masterDemo
//
//  Created by Edward on 13-3-6.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "BingQu.h"
#import "FMDatabaseQueue.h"

@implementation BingQu

+ (BOOL)createNewBingQu:(NSString *)bingqu {
  
  //    debugMethod();
  //    FMDatabase *dataBase = [dataBaseManager createDataBase];
  __block BOOL isOK = NO;
  //    if ([dataBase open]) {
  //            isOK = [dataBase executeUpdate:@"INSERT INTO BingQu (Name) VALUES (?)",bingqu];
  //        [dataBase close];
  //    }
  FMDatabaseQueue *queue = [dataBaseManager queue];
  [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
    isOK = [db executeUpdate:@"INSERT INTO BingQu (Name) VALUES (?)",bingqu];
  }];
  return isOK;
  
}

+ (BOOL)findTheSameBingQu:(NSString *)bingqu {
  
  //  debugMethod();
  //  FMDatabase *dataBase = [dataBaseManager createDataBase];
  //  BOOL isOK  = NO;
  //  if ([dataBase open]) {
  //    FMResultSet *rs = [dataBase executeQuery:@"SELECT * FROM BingQu"];
  //    while ([rs next]&&(isOK == NO)) {
  //      NSString *str = [rs stringForColumn:@"Name"];
  //      if ([str isEqualToString:bingqu]) {
  //        isOK = YES;
  //      }
  //    }
  //    [dataBase close];
  //  }
  //  return isOK;
  __block BOOL isOK  = NO;
  FMDatabaseQueue *queue = [dataBaseManager queue];
  [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
    if ([db open]) {
      FMResultSet *rs = [db executeQuery:@"SELECT * FROM BingQu"];
      while ([rs next] && (isOK == NO)) {
        NSString *str = [rs stringForColumn:@"Name"];
        if ([str isEqualToString:bingqu]) {
          isOK = YES;
        }
      }
    }
  }];
  return isOK;
}

+ (int)countAllBingQu {
  
  debugMethod();
  __block int count = 0;
  
  //  FMDatabase *dataBase = [dataBaseManager createDataBase];
  //  if ([dataBase open]) {
  //    FMResultSet *rs = [dataBase executeQuery:@"SELECT COUNT(*) FROM BingQu"];
  //    if ([rs next]) {
  //      count = [rs intForColumnIndex:0];
  //    }
  //    [dataBase close];
  //  }
  
  FMDatabaseQueue *queue = [dataBaseManager queue];
  [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
    if ([db open]) {
      FMResultSet *rs = [db executeQuery:@"SELECT COUNT(*) FROM BingQu"];
      if ([rs next]) {
        count = [rs intForColumnIndex:0];
      }
    }
  }];
  return count;
}

+ (NSMutableArray *)findAllBingQuIntoArray {
  
  debugMethod();
 __block NSMutableArray *arry = [NSMutableArray array];
  
  FMDatabaseQueue *queue = [dataBaseManager queue];
  [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
    if ([db open]) {
      FMResultSet *rs = [db executeQuery:@"SELECT * FROM BingQu"];
      while ([rs next]) {
        NSString *str = [rs stringForColumn:@"Name"];
        [arry addObject:str];
      }
    }
  }];
  return arry;
}
@end
