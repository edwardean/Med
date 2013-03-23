//
//  BingQu.h
//  masterDemo
//
//  Created by Edward on 13-3-6.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dataBaseManager.h"
@interface BingQu : NSObject

+ (BOOL)createNewBingQu:(NSString *)bingqu;

+ (BOOL)findTheSameBingQu:(NSString *)bingqu;

+ (int)countAllBingQu;

+ (NSMutableArray *)findAllBingQuIntoArray;
@end
