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
#import "Help.h"
#import "MBProgressHUD.h"
#define ALPHA	@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define UPPER  @"ABCDEFGHIJKLMNOPQRSTUVWXYZ "
#define NUMBERS	@"0123456789"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789. "
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

#define OS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define DOCUMENT [(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)) lastObject]

#define dataBasePath [[(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)) lastObject]stringByAppendingPathComponent:dataBaseName]
#define dataBaseName @"dataBase.sqlite"

#define ModifyColor [UIColor colorWithRed:77/255.0 green:140/255.0 blue:236/255.0 alpha:1.0]

#define OKColor [UIColor colorWithRed:195/255.0 green:66/255.0 blue:77/255.0 alpha:1.0]

#define EnableColor [UIColor colorWithRed:221/255.0 green:223/255.0 blue:226/255.0 alpha:1.0]

#define AbleBackgroundColor [UIColor colorWithRed:109/255.0 green:109/255.0 blue:118/255.0 alpha:1.0]

#define ImageNamed(imageName) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]]

#define US [NSUserDefaults standardUserDefaults]

#define DirectoryName @"每种药品的筛选记录"