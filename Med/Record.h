//
//  Record.h
//  masterDemo
//
//  Created by Edward on 13-3-7.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dataBaseManager.h"
@interface Record : NSObject

/**
    数据库查找
 **/
+ (NSMutableArray *)findAllRecordsInRecordTableToArray;//将所有病人用药记录打包进数组内


+ (NSMutableArray *)findSomeRecordByPatientName:(NSString *)patientName;//通过病人名查找用药记录

+ (NSMutableArray *)findSomeRecordByOffice:(NSString *)office;//通过病区查找用药记录

+ (BOOL)checkisExistSameRecordByOffice:(NSString *)office andPatientName:(NSString *)patientName;

/**
        数据库插入这里对两个表进行操作
 Record表里只保存病人姓名，所属病区等基本信息，
 每个病人开的多种药保存到另外一个Detail表中，Detail表的主键也就是Record表的外键id
 **/


+ (BOOL)insertNewRecordIntoRecordTable:(NSString *)patientName Office:(NSString *)office;//
+ (NSInteger)findDetailIDByPatientName:(NSString *)patientName Office:(NSString *)office;
+ (BOOL)insertNewDetailsIntoDetailTable:(int)_id Name:(NSString *)name PYM:(NSString *)pym Count:(NSString *)count;//


+ (NSArray *)findPatientIDInDetailTable:(NSString *)_pym;
/*
 在Detail表中查找所有服用该种药品的病人记录
 */


/**
    数据库项删除操作也要在两个表中同时进行
 1.删除整条记录
 因为第一个表的主键是自增变量，当删除其中一条记录后还要根据这条
 记录的主键删除第二张表中对应的数据
 2.删除一条记录中某些药品记录
 **/
+ (BOOL)deleteSomeRecordByIDInTable:(NSString *)patientName andOffice:(NSString *)office;
+ (BOOL)deleteDetailByPatientID:(NSInteger)ID;//跟上个方法对应，删除指定病人的所有用药记录
+ (BOOL)deleteSomeMedicineByIDInDetail:(NSString *)patientName andOffice:(NSString *)office andMedicineID:(int)ID;
/**
 更新数据也要在两个表中操作
 如果只更新病人姓名，病区等基本信息只需在第一张表中进行，
 若要更新该病人所开的每种药信息比如药品名称或用药量的话还要
 根据这个病人所有药中的每种药的具体编号来修改信息(很复杂的样子.....)
 **/
+ (BOOL)updateInfoInRecordTablePatientName:(NSString *)patientName Office:(NSString *)office Detail:(NSArray *)nameAndCountArry;

+ (NSArray *)searchAllRecordsByPYM:(NSString *)pym;
@end
