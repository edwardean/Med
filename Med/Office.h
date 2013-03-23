//
//  Office.h
//  masterDemo
//
//  Created by Edward on 13-3-6.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dataBaseManager.h"
@interface Office : NSObject

+ (BOOL)createNewOffcie:(NSString *)office;

+ (BOOL)findTheSameOffcie:(NSString *)office;

+ (int)countAllOffcie;

+ (NSMutableArray *)findAllOffcieIntoArray;
@end
