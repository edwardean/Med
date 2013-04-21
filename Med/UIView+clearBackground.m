//
//  UIView+clearBackground.m
//  Med
//
//  Created by Edward on 13-4-21.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "UIView+clearBackground.h"

@implementation UIView (clearBackground)
- (void)clear {
    self.backgroundColor = [UIColor clearColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, [[UIScreen mainScreen] bounds].size.height)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self insertSubview:view atIndex:0];
}
@end
