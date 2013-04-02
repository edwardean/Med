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

    GCDiscreetNotificationView *gcdNotification = [[[GCDiscreetNotificationView alloc] initWithText:msg showActivity:NO inPresentationMode:GCDiscreetNotificationViewPresentationModeTop inView:view] autorelease];
    [gcdNotification show:YES];
    [gcdNotification hideAnimatedAfter:delay];
}
@end
