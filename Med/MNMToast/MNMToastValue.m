/*
 * Copyright (c) 2012 Movilok. All Rights Reserved
 *
 * This software is the confidential and proprietary information of
 * Movilok ("Confidental Information"). You shall not disclose such
 * Confidential Information and shall use it only in accordance with
 * the terms of the license agreement you entered into with Movilok.
 */

#import "MNMToastValue.h"

@implementation MNMToastValue

@synthesize text;
@synthesize autoHide;
@synthesize completionHandler;
@synthesize tapHandler;

/*
 * Returns a Boolean value that indicates whether the receiver and a given object are equal
 */
- (BOOL)isEqual:(id)object {
    
    MNMToastValue *another = (MNMToastValue *)object;
    return [[self text] isEqualToString:[another text]];
}

/*
 * Returns the object description
 */
- (NSString *)description {
    
    return [NSString stringWithFormat:@"%@ %@", [super description], [self text]];
}

@end

