//
//  Help.m
//  Med
//
//  Created by Edward on 13-3-31.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "Help.h"

@implementation Help


+ (void)ShowGCDMessage:(NSString *)msg andView:(UIView *)view andDelayTime:(float)delay {

    GCDiscreetNotificationView *gcdNotification = [[GCDiscreetNotificationView alloc] initWithText:msg showActivity:NO inPresentationMode:GCDiscreetNotificationViewPresentationModeTop inView:view];
    [gcdNotification show:YES];
    [gcdNotification hideAnimatedAfter:delay];
}
+(void)doSomething:(id)block afterDelay:(float)delay
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        ((void (^)())block)();
    });
}

+ (void)CustomAnimationForView:(UIView *)view {
    
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setDuration:0.75f];
    
    CAMediaTimingFunction *tf = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [animation setTimingFunction:tf];
    [animation setType:@"rippleEffect"];
    [view.layer addAnimation:animation forKey:NULL];
}

+ (QBFlatButton *)QBButton {
    QBFlatButton *btn = [QBFlatButton buttonWithType:UIButtonTypeCustom];
    btn.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
    btn.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
    btn.radius = 8.0;
    btn.margin = 4.0;
    btn.depth = 3.0;
    
    btn.titleLabel.font = [UIFont fontWithName:@"Nokia Font YanTi" size:16];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    return btn;
}

+ (BOOL)isEmptyString:(NSString *)str {
    if (!str) {
        return YES;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length]==0) {
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}
@end
