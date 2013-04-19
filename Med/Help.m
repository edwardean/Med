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
@end
