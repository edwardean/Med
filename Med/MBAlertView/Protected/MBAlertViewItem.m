//
//  MBAlertViewItem.m
//  AlertsDemo
//
//  Created by M B. Bitar on 1/15/13.
//  Copyright (c) 2013 progenius, inc. All rights reserved.
//

#import "MBAlertViewItem.h"

@implementation MBAlertViewItem

-(id)initWithTitle:(NSString*)text type:(MBAlertViewItemType)type block:(id)block
{
    if(self = [super init]) {
        _title = text;
        _type = type;
        _block = block;
    }
    return self;
}

@end
