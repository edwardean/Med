//
//  Help.h
//  Med
//
//  Created by Edward on 13-3-31.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GCDiscreetNotificationView.h"
#import "QBFlatButton.h"
@interface Help : NSObject


+ (void)ShowGCDMessage:(NSString *)msg andView:(UIView *)view andDelayTime:(float)delay;
+(void)doSomething:(id)block afterDelay:(float)delay;

+ (void)CustomAnimationForView:(UIView *)view;

+ (QBFlatButton *)QBButton;


//做空串判断
+ (BOOL)isEmptyString:(NSString *)str;
@end
