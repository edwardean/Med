//
//  Config.h
//  fmdbtest
//
//  Created by Edward on 13-3-1.
//  Copyright (c) 2013年 Edward. All rights reserved.
//


/**
 在debug阶段输出调试信息，
 在release阶段时可关闭调试信息
 **/
#import "UINavigationBar+CustomImage.h"
#define ALPHA	@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define UPPER  @"ABCDEFGHIJKLMNOPQRSTUVWXYZ "
#define NUMBERS	@"0123456789"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 "
#define NUMBERSPERIOD	@"0123456789."

#ifdef DEBUG
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s",__func__)

#define findAllMed() NSMutableArray *array = [Medicine findAllMedicineToArray]; for (int i=0; i<[array count]; i++) {NSLog(@"%@",[array objectAtIndex:i]);}

#else
#define debugLog(...)
#define debugMethod()
#define findAllMed()

#endif

#define dataBasePath [[(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)) lastObject]stringByAppendingPathComponent:dataBaseName]
#define dataBaseName @"dataBase.sqlite"
