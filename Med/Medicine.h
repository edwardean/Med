//
//  Medicine.h
//  fmdbtest
//
//  Created by Edward on 13-3-2.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dataBaseManager.h"
@interface Medicine : NSObject

@property (nonatomic, copy) NSString *name;//药品名称
@property (nonatomic, copy) NSString *specifi;//规格
@property (nonatomic, copy) NSString *content;//产地
@property (nonatomic, copy) NSString *PYM;//药品拼音码
@property (nonatomic, copy) NSString *Unit;//药品单位mg/ml

@property (nonatomic, copy) NSString *stringID;//药品主键ID
//- (id) initMedicineWithName:(NSString *)_name andSpecifi:(NSString *)_specifi andContent:(NSString *)_Content;

+ (int)countAllMedicine;//统计所有药品数量
+ (NSMutableArray *)findAllMedicineToArray;//将所有药品打包进一个可变数组


//+ (int)countSomeMedicineByName:(NSString *)_name;//由药品名称统计某种药品数量(没啥用)
+ (NSMutableArray *)findSomeMedicineByName:(NSString *)_name;//通过名称查找

+ (NSDictionary *)findSomeMedicineByPYM:(NSString *)_pym;//因为拼音码唯一，根据拼音码查找某种药品

//+ (int)countSomeMedicineBySpecifi:(NSString *)_specifi;//统计同规格的药共有多少种(没啥用)
+ (NSMutableArray *)findSomeMedicineBySpecifi:(NSString *)_specifi;//通过规格查找

+ (BOOL)createNewMedicine:(NSString *)_name andSpecifi:(NSString *)_specifi andUnit:(NSString *)_unit andContent:(NSString *)_content PYM:(NSString *)_pym;//创建一种新药品

//+ (BOOL)deleteSomeMedicine:(NSString *)_name andSpecifi:(NSString *)_specifi;//在tableView编辑模式中删除某种药品,但同名药还有不同规格之分，所以这里有两个参数即药名和规格

+ (BOOL)deleteSomeMedicine:(NSString *)_pym;//根据拼音码删除信息

- (BOOL)findIfExitsSameName:(NSString *)_name;//查找是否有相同药名
- (BOOL)findIDByMedicinePYM:(NSString *)_pym;//根据药品主键更新其信息
- (BOOL)updateMedicine:(NSString *)_name andSpecifi:(NSString *)_specifi andUnit:(NSString *)_unit andContent:(NSString *)_content andPYM:(NSString *)_pym;//解释下，更新药品信息时不可能更新药品的全部信息，有可能只变更药品的名称，规格等，所以存在有的信息更新
//有的信息不更新的情况，所以这里要仔细处理
@end
