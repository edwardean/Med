//
//  UINavigationBar+CustomImage.m
//  Med
//
//  Created by Edward on 13-3-21.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "UINavigationBar+CustomImage.h"

@implementation UINavigationBar (CustomImage)

- (void)setBackImage {
    [self setBackgroundImage:[UIImage imageNamed:@"ipad_top_bg2"] forBarMetrics:UIBarMetricsDefault];
}
@end
