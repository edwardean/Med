//
//  Record.m
//  masterDemo
//
//  Created by Edward on 13-3-7.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "Record.h"

@implementation Record
@synthesize PatientName,Office,Name,Count;

+ (NSMutableArray *)findAllRecordsInRecordTableToArray {
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSMutableArray *detailArray = [NSMutableArray array];
    if ([dataBase open]) {
        FMResultSet *resultSet1 = [dataBase executeQuery:@"SELECT * FROM Record"];
        NSDictionary *recordDic = [NSDictionary dictionary];
        NSDictionary *detailDic = nil;
        while ([resultSet1 next]) {
            NSString *ID = [resultSet1 stringForColumn:@"id"];//第一张表的id主键
            debugLog(@"Record中找到ID = %@",ID);
            NSString *PatientName = [resultSet1 stringForColumn:@"PatientName"];//第一张表的PatientName
            NSString *Office = [resultSet1 stringForColumn:@"Office"];//第一张表的Office

            FMResultSet *resultSet2 = [dataBase executeQuery:@"SELECT * FROM Detail WHERE Number = ?",ID];
            while ([resultSet2 next]) {
                NSString *Name = [resultSet2 stringForColumn:@"Name"];
                NSString *Count = [resultSet2 stringForColumn:@"Count"];
                detailDic = [NSDictionary dictionaryWithObjectsAndKeys:Name,@"Name",Count ,@"Count",nil];
                [detailArray addObject:detailDic];
                //debugLog(@"Detail表中，detailArray = %@",detailArray);
            }
            recordDic = [NSDictionary dictionaryWithObjectsAndKeys:PatientName,@"PatientName",Office,@"Office",
                         detailArray,@"Detail",nil];
            debugLog(@"dic =  %@",recordDic);
            [mutableArray addObject:recordDic];
            [detailArray removeAllObjects];
        }
    }
    [dataBase close];
    return mutableArray;
}

+ (NSMutableArray *)findSomeRecordByPatientName:(NSString *)patientName {
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSMutableArray *detailArray = [NSMutableArray array];
    if ([dataBase open]) {
        FMResultSet *resultSet1 = [dataBase executeQuery:@"SELECT * FROM Record WHERE PatientName = ?",patientName];
        NSDictionary *recordDic = [NSDictionary dictionary];
        NSDictionary *detailDic = nil;//[NSDictionary dictionary];
        while ([resultSet1 next]) {
            NSString *ID = [resultSet1 stringForColumn:@"id"];
            NSString *PatientName = [resultSet1 stringForColumn:@"PatientName"];
            NSString *Office = [resultSet1 stringForColumn:@"Office"];
            
            FMResultSet *resultSet2 = [dataBase executeQuery:@"SELECT * FROM Detail WHERE id = ?",ID];
            while ([resultSet2 next]) {
                NSString *Name = [resultSet2 stringForColumn:@"Name"];
                NSString *Count = [resultSet2 stringForColumn:@"Count"];
                detailDic = [NSDictionary dictionaryWithObjectsAndKeys:Name,@"Name",Count,@"Count", nil];
                [detailArray addObject:detailDic];
            }
        recordDic = [NSDictionary dictionaryWithObjectsAndKeys:PatientName,@"PatientName",Office,@"Office",detailArray,@"Detail", nil];
        }
        [mutableArray addObject:recordDic];
    }
    [dataBase close];
    return mutableArray;
}

+ (NSMutableArray *)findSomeRecordByOffice:(NSString *)office {
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSMutableArray *detailArray = [NSMutableArray array];
    if ([dataBase open]) {
       
        
        FMResultSet *resultSet1 = [dataBase executeQuery:@"SELECT * FROM Record WHERE Office = ?",office];
        NSDictionary *recordDic = [NSDictionary dictionary];
        NSDictionary *detailDic = nil;//[NSDictionary dictionary];
        while ([resultSet1 next]) {
            NSString *ID = [resultSet1 stringForColumn:@"id"];
            NSString *PatientName = [resultSet1 stringForColumn:@"PatientName"];
            NSString *Office = [resultSet1 stringForColumn:@"Office"];
            
            FMResultSet *resultSet2 = [dataBase executeQuery:@"SELECT * FROM Detail WHERE id = ?",ID];
            while ([resultSet2 next]) {
                NSString *Name = [resultSet2 stringForColumn:@"Name"];
                NSString *Count = [resultSet2 stringForColumn:@"Count"];
                detailDic = [NSDictionary dictionaryWithObjectsAndKeys:Name,@"Name",Count,@"Count", nil];
                [detailArray addObject:detailDic];
            }
            recordDic = [NSDictionary dictionaryWithObjectsAndKeys:PatientName,@"PatientName",Office,@"Office",detailArray,@"Detail", nil];
        }
        [mutableArray addObject:recordDic];
    }
    [dataBase close];
    return mutableArray;

}

+ (BOOL)checkisExistSameRecordByOffice:(NSString *)office andPatientName:(NSString *)patientName {
    debugMethod();
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    BOOL isOK = NO;
    if ([dataBase open]) {
        FMResultSet *rs = [dataBase executeQuery:@"SELECT * FROM Record WHERE Office = ? AND PatientName = ?",office,patientName];
        while ([rs next]) {
            isOK = ([office isEqualToString:[rs stringForColumn:@"Office"]]&&[patientName isEqualToString:[rs stringForColumn:@"PatientName"]]);
            if (isOK) {
                [dataBase close];
                return isOK;
            }
        }
        
    }
    [dataBase close];
    return isOK;
}

+ (BOOL)insertNewRecordIntoRecordTable:(NSString *)patientName Office:(NSString *)office {
    
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    BOOL isOK = NO;
    if ([dataBase open]) {
        if (![dataBaseManager isTableExist:@"Record"]) {
            debugLog(@"Record 不存在");
            return isOK;
        }
               isOK = [dataBase executeUpdate:@"INSERT INTO Record (PatientName,Office) VALUES (?,?)",patientName,office];
        
    }
    [dataBase close];
    return isOK;
}
+ (BOOL)insertNewDetailsIntoDetailTable:(NSInteger)_id Name:(NSString *)name PYM:(NSString *)pym Count:(NSString *)count {
    debugMethod();
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    BOOL isOK = NO;
    if ([dataBase open]) {
        if (![dataBaseManager isTableExist:@"Detail"]) {
            debugLog(@"Record 不存在");
            return isOK;
        }
        debugLog(@"inserting........");
        isOK = [dataBase executeUpdate:@"INSERT INTO Detail (Number,Name,PYM,Count) VALUES(?,?,?,?)",[NSNumber numberWithInteger:_id],name,pym,count];
    }
    [dataBase close];
    if (isOK) {
        debugLog(@"insert OK");
    }
    return isOK;
}
+ (NSInteger)findDetailIDByPatientName:(NSString *)patientName Office:(NSString *)office {
    NSInteger ID = -1;
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    if ([dataBase open]) {
        FMResultSet *rs = [dataBase executeQuery:@"SELECT * FROM Record WHERE PatientName = ? AND Office = ?",patientName,office];
        while ([rs next]) {
            ID = [rs intForColumn:@"id"];
            if (ID != -1) {
                [dataBase close];
                return ID;
            }
        }
    }
    [dataBase close];
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
    }
    [dataBase close];
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
    }
    [dataBase close];
    return isOK;
}
+ (BOOL)updateInfoInRecordTablePatientName:(NSString *)patientName Office:(NSString *)office Detail:(NSArray *)nameAndCountArry {
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    BOOL isOK = NO;
    if ([dataBase open]) {
        FMResultSet *rs = [dataBase executeQuery:@"SELECT * FROM Record WHERE PatientName = ?",patientName];
        NSNumber *index = [NSNumber numberWithInt:0];
        while ([rs next]) {
            index = [NSNumber numberWithInt:[rs intForColumn:@"id"]];
        }
        isOK = [dataBase executeUpdate:@"UPDATE Record SET Office = ? WHERE PatientName = ?",office,patientName];
        for (int i = 0; i<[nameAndCountArry count]; i++) {
            NSDictionary *detailDic = [nameAndCountArry objectAtIndex:i];
            NSString *Name = [detailDic objectForKey:@"Name"];
            NSString *Count = [detailDic objectForKey:@"Count"];
            isOK = [dataBase executeUpdate:@"UPDATE Detail SET Name = ? AND Count = ? WHERE id = ? AND Number = ?",Name,Count,index,[NSNumber numberWithInt:i]];
        }
    }
    [dataBase close];
    return isOK;
}
@end
