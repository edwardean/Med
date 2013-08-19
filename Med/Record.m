//
//  Record.m
//  masterDemo
//
//  Created by Edward on 13-3-7.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "Record.h"
#import "CHCSVWriter.h"
@implementation Record

+ (NSArray *)findAllRecordsInRecordTableToArray
{
  FMDatabaseQueue *queue = [dataBaseManager queue];
  __block NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
  __block FMResultSet *resultSet,*resultSet1;
  [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
    if ([db open]) {
      resultSet = [db executeQuery:@"SELECt * FROM Record"];
      while ([resultSet next]) {
        NSString *ID = [resultSet stringForColumn:@"id"];//第一张表的id主键
        NSString *PatientName = [resultSet stringForColumn:@"PatientName"];//第一张表的PatientName
        NSString *Office = [resultSet  stringForColumn:@"Office"];//第一张表的Office
        NSString *Date = [resultSet stringForColumn:@"Date"];
        resultSet1 = [db executeQuery:@"SELECT * FROM Detail WHERE Number = ?",ID];
        NSMutableArray *detailArray = [NSMutableArray arrayWithCapacity:0];
        while ([resultSet1 next]) {
          NSDictionary *dic = @{@"Name": [resultSet1 stringForColumn:@"Name"],
                                @"Count":[resultSet1 stringForColumn:@"Count"],
                                @"PYM":[resultSet1 stringForColumn:@"PYM"]};
          [detailArray addObject:dic];
        }
        NSDictionary *recordDic = @{@"ID": ID,
                                    @"PatientName":PatientName,
                                    @"Office":Office,
                                    @"Date":Date,
                                    @"Detail":detailArray};
        [mutableArray addObject:recordDic];
      }
    }
  }];
  
  NSSortDescriptor *soter = [[NSSortDescriptor alloc] initWithKey:@"Office" ascending:YES];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&soter count:1];
  NSArray *array = [mutableArray sortedArrayUsingDescriptors:sortDescriptors];
  return array;
}

+ (NSMutableArray *)findSomeRecordByPatientName:(NSString *)patientName {
  
  __block NSMutableArray *mutableArray = [NSMutableArray array];
  __block NSMutableArray *detailArray = [NSMutableArray array];
  
  FMDatabaseQueue *queue = [dataBaseManager queue];
  [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
    if ([db open]) {
      FMResultSet *resultSet1 = [db executeQuery:@"SELECT * FROM Record WHERE PatientName = ?",patientName];
      NSDictionary *recordDic = [NSDictionary dictionary];
      NSDictionary *detailDic = nil;
      while ([resultSet1 next]) {
        NSString *ID = [resultSet1 stringForColumn:@"id"];
        NSString *PatientName = [resultSet1 stringForColumn:@"PatientName"];
        NSString *Office = [resultSet1 stringForColumn:@"Office"];
        NSString *Date = [resultSet1 stringForColumn:@"Date"];
        FMResultSet *resultSet2 = [db executeQuery:@"SELECT * FROM Detail WHERE id = ?",ID];
        while ([resultSet2 next]) {
          NSString *Name = [resultSet2 stringForColumn:@"Name"];
          NSString *Count = [resultSet2 stringForColumn:@"Count"];
          //detailDic = [NSDictionary dictionaryWithObjectsAndKeys:Name,@"Name",Count,@"Count", nil];
          detailDic = @{@"Name": Name,
                        @"Count":Count};
          [detailArray addObject:detailDic];
        }
        //recordDic = [NSDictionary dictionaryWithObjectsAndKeys:ID,@"ID",PatientName,@"PatientName",Office,@"Office",Date,@"Date",detailArray,@"Detail", nil];
        
        recordDic = @{@"ID": ID,
                      @"PatientName":PatientName,
                      @"Office":Office,
                      @"Date":Date,
                      @"Detail":detailArray};
      }
      [mutableArray addObject:recordDic];
    }
  }];
  return mutableArray;
}

+ (NSMutableArray *)findSomeRecordByOffice:(NSString *)office {
  
  __block NSMutableArray *mutableArray = [NSMutableArray array];
  __block NSMutableArray *detailArray = [NSMutableArray array];
  
  FMDatabaseQueue *queue = [dataBaseManager queue];
  [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
    if ([db open]) {
      FMResultSet *resultSet1 = [db executeQuery:@"SELECT * FROM Record WHERE Office = ?",office];
      NSDictionary *recordDic = [NSDictionary dictionary];
      NSDictionary *detailDic = nil;
      while ([resultSet1 next]) {
        NSString *ID = [resultSet1 stringForColumn:@"id"];
        NSString *PatientName = [resultSet1 stringForColumn:@"PatientName"];
        NSString *Office = [resultSet1 stringForColumn:@"Office"];
        NSString *Date = [resultSet1 stringForColumn:@"Date"];
        FMResultSet *resultSet2 = [db executeQuery:@"SELECT * FROM Detail WHERE id = ?",ID];
        while ([resultSet2 next]) {
          NSString *Name = [resultSet2 stringForColumn:@"Name"];
          NSString *Count = [resultSet2 stringForColumn:@"Count"];
          //detailDic = [NSDictionary dictionaryWithObjectsAndKeys:Name,@"Name",Count,@"Count", nil];
          detailDic = @{@"Name": Name,
                        @"Count":Count};
          [detailArray addObject:detailDic];
        }
        //recordDic = [NSDictionary dictionaryWithObjectsAndKeys:ID,@"ID",PatientName,@"PatientName",Office,@"Office",Date,@"Date",detailArray,@"Detail", nil];
        recordDic = @{@"ID": ID,
                      @"PatientName":PatientName,
                      @"Office":Office,
                      @"Date":Date,
                      @"Detail":detailArray};
      }
      [mutableArray addObject:recordDic];
    }
  }];
  return mutableArray;
  
}

+ (BOOL)checkisExistSameRecordByOffice:(NSString *)office andPatientName:(NSString *)patientName {
  debugMethod();
  
  BOOL isOK = NO;
  
  FMDatabase *dataBase = [dataBaseManager createDataBase];
  if ([dataBase open]) {
    FMResultSet *rs = [dataBase executeQuery:@"SELECT * FROM Record WHERE Office = ? AND PatientName = ?",office,patientName];
    while ([rs next]) {
      
      isOK = ([office isEqualToString:[rs stringForColumn:@"Office"]]&&[patientName isEqualToString:[rs stringForColumn:@"PatientName"]]);
      if (isOK) {
        return isOK;
      }
    }

  }
    return isOK;
}

+ (BOOL)insertNewRecordIntoRecordTable:(NSString *)patientName Office:(NSString *)office Date:(NSString *)date{
  FMDatabaseQueue *queue = [dataBaseManager queue];
  __block BOOL isOK = NO;
  [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
    if ([db open]) {
      if ((isOK = [dataBaseManager isTableExist:@"Record"])) {
        debugLog(@"Record Not exists!");
        isOK = [db executeUpdate:@"INSERT INTO Record (PatientName,Office,Date) VALUES (?,?,?)",patientName,office,date];
      }
    }
  }];
  return isOK;
}
+ (BOOL)insertNewDetailsIntoDetailTable:(NSInteger)_id Name:(NSString *)name PYM:(NSString *)pym Count:(NSString *)count {
  
  FMDatabaseQueue *queue = [dataBaseManager queue];
  __block BOOL isOK = NO;
  [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
    if ([db open]) {
      if ((isOK = [dataBaseManager isTableExist:@"Detail"])) {
        isOK = [db executeUpdate:@"INSERT INTO Detail (Number,Name,PYM,Count) VALUES(?,?,?,?)",[NSNumber numberWithInteger:_id],name,pym,count];
      }
    }
  }];
  return isOK;
}
+ (NSInteger)findDetailIDByPatientName:(NSString *)patientName Office:(NSString *)office {
  
  __block NSInteger ID = -1;
  FMDatabaseQueue *queue = [dataBaseManager queue];
  [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
    if ([db open]) {
      FMResultSet *rs = [db executeQuery:@"SELECT * FROM Record WHERE PatientName = ? AND Office = ?",patientName,office];
      while ([rs next]) {
        ID = [rs intForColumn:@"id"];
        
      }
    }
  }];
  return ID;
}

+ (BOOL)deleteSomeRecordByIDInTable:(NSString *)patientName andOffice:(NSString *)office {
  FMDatabase *dataBase = [dataBaseManager createDataBase];
  BOOL isOK = NO;
  if ([dataBase open]) {
    FMResultSet *rs = [dataBase executeQuery:@"SELECT * FROM Record WHERE PatientName = ? AND Office = ?",patientName,office];
    int num = 0;
    while ([rs next]) {
      num  = [rs intForColumn:@"id"];
    }
    isOK = [dataBase executeUpdate:@"DELETE FROM Record WHERE Patientname = ? AND Office = ?",patientName,office] && [dataBase executeUpdate:@"DELETE FROM Detail WHERE id = ?",[NSNumber numberWithInt:num]];
    [dataBase close];
  }
  return isOK;
}
+ (BOOL)deleteDetailByPatientID:(NSInteger)ID {
  BOOL isOK = NO;
  NSString *PatientID = [NSString stringWithFormat:@"%d",ID];
  FMDatabase *dataBase = [dataBaseManager createDataBase];
  if ([dataBase open]) {
    isOK = [dataBase executeUpdate:@"DELETE FROM Detail WHERE Number = ?",PatientID];
    [dataBase close];
  }
  
  return isOK;
}
+ (BOOL)deleteSomeMedicineByIDInDetail:(NSString *)patientName andOffice:(NSString *)office andMedicineID:(int)ID {
  
  FMDatabase *dataBase = [dataBaseManager createDataBase];
  BOOL isOK = NO;
  if ([dataBase open]) {
    FMResultSet *rs = [dataBase executeQuery:@"SELECT * FROM Record WHERE PatientName =? AND Office = ?",patientName,office];
    NSNumber *index = [NSNumber numberWithInt:0];
    while ([rs next]) {
      index = [NSNumber numberWithInt:[rs intForColumn:@"id"]];
    }
    isOK = [dataBase executeUpdate:@"DELETE FROM Detail WHERE id = ? AND Number = ?",index,[NSNumber numberWithInt:ID]];
    [dataBase close];
  }
  return isOK;
}
+ (BOOL)updateInfoInRecordTablePatientName:(NSString *)patientName Office:(NSString *)office Detail:(NSArray *)nameAndCountArry {
  FMDatabaseQueue *queue = [dataBaseManager queue];
  __block BOOL isOK = NO;
  [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
    if ([db open]) {
      FMResultSet *rs = [db executeQuery:@"SELECT * FROM Record WHERE PatientName = ?",patientName];
      NSNumber *index = [NSNumber numberWithInt:0];
      while ([rs next]) {
        index = [NSNumber numberWithInt:[rs intForColumn:@"id"]];
      }
      isOK = [db executeUpdate:@"UPDATE Record SET Office = ? WHERE PatientName = ?",office,patientName];
      for (int i = 0; i<[nameAndCountArry count]; i++) {
        NSDictionary *detailDic = [nameAndCountArry objectAtIndex:i];
        NSString *Name = [detailDic objectForKey:@"Name"];
        NSString *Count = [detailDic objectForKey:@"Count"];
        isOK = [db executeUpdate:@"UPDATE Detail SET Name = ? AND Count = ? WHERE id = ? AND Number = ?",Name,Count,index,[NSNumber numberWithInt:i]];
      }

    }
  }];
  return isOK;
}

+ (NSArray *)findPatientIDInDetailTable:(NSString *)_pym {
  debugMethod();
  NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
  __weak NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
  __block NSDictionary *dic = [NSDictionary dictionary];
  __block NSDictionary *recordDic = [NSDictionary dictionary];
  FMDatabase *dataBase = [dataBaseManager createDataBase];
  if ([dataBase open]) {
    FMResultSet *rs1 = [dataBase executeQuery:@"SELECT * FROM Detail WHERE PYM = ?",_pym];
    while ([rs1 next]) {
      NSInteger index = [rs1 intForColumn:@"Number"];
      [mutableArray addObject:[NSNumber numberWithInteger:index]];
    }
    [mutableArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      NSNumber *patientID = [mutableArray objectAtIndex:idx];
      FMResultSet *rs2 = [dataBase executeQuery:@"SELECT * FROM Record WHERE id = ?",patientID];
      while ([rs2 next]) {
        NSInteger ind = [rs2 intForColumn:@"id"];
        NSString *ID = [NSString stringWithFormat:@"%d",ind];
        NSString *PatientName = [rs2 stringForColumn:@"PatientName"];
        NSString *Office = [rs2 stringForColumn:@"Office"];
        NSString *Date = [rs2 stringForColumn:@"Date"];
        FMResultSet *resultSet2 = [dataBase executeQuery:@"SELECT * FROM Detail WHERE Number = ?",ID];
        NSMutableArray *detailArray = [NSMutableArray array];
        while ([resultSet2 next]) {
          NSString *Name = [resultSet2 stringForColumn:@"Name"];
          NSString *Count = [resultSet2 stringForColumn:@"Count"];
          NSString *PYM = [resultSet2 stringForColumn:@"PYM"];
          //dic = [NSDictionary dictionaryWithObjectsAndKeys:Name,@"Name",Count,@"Count",PYM,@"PYM", nil];
          dic = @{@"Name": Name,
                  @"Count":Count,
                  @"PYM":PYM};
          [detailArray addObject:dic];
        }
        //recordDic = [NSDictionary dictionaryWithObjectsAndKeys:ID,@"ID",PatientName,@"PatientName",Office,@"Office",Date,@"Date",detailArray,@"Detail", nil];
        recordDic = @{@"ID": ID,
                      @"PatientName":PatientName,
                      @"Office":Office,
                      @"Date":Date,
                      @"Detail":detailArray};
        [resultArray addObject:recordDic];
      }
    }];
    [dataBase close];
  }
  return resultArray;
}

+ (NSArray *)searchAllRecordsByPYM:(NSString *)pym {
  
  __block NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];

  FMDatabaseQueue *queue = [dataBaseManager queue];
  [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
    if ([db open]) {
      FMResultSet *rs = [db executeQuery:@"SELECT Record.PatientName,Record.Office,Record.Date,Detail.Name,Detail.Count FROM Record,Detail WHERE Record.id = Detail.Number AND Detail.PYM = ?",[pym uppercaseString]];
      while ([rs next]) {
        NSString *PatientName = [rs stringForColumn:@"PatientName"];
        NSString *Office = [rs stringForColumn:@"Office"];
        NSString *Date = [rs stringForColumn:@"Date"];
        NSString *Name = [rs stringForColumn:@"Name"];
        NSString *Count = [rs stringForColumn:@"Count"];
        // NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:PatientName,@"PatientName",Office,@"Office",Date,@"Date",Name,@"Name",Count,@"Count", nil];
        NSDictionary *dic = @{@"PatientName": PatientName,
                              @"Office":Office,
                              @"Date":Date,
                              @"Name":Name,
                              @"Count":Count};
        [mutableArray addObject:dic];
      }

    }
  }];
  
  NSArray *resultArray = [mutableArray copy];
  NSSortDescriptor *sotre = [[NSSortDescriptor alloc] initWithKey:@"Office" ascending:YES];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sotre count:1];
  NSArray *array = [resultArray sortedArrayUsingDescriptors:sortDescriptors];
  return array;
}
@end
