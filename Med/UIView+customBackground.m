//
//  UIView+customBackground.m
//  Med
//
//  Created by Edward on 13-4-22.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "UIView+customBackground.h"

@implementation UIView (customBackground)

- (void)custom:(UINavigationBar *)bar {
    if ([bar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [bar setBackgroundImage:[UIImage imageNamed:@"Title"] forBarMetrics:UIBarMetricsDefault];
    } else {
        [bar drawRect:bar.bounds];
    }
    CGRect bounds = self.bounds;
    bounds.size.height = [[UIScreen mainScreen]bounds].size.height;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    
    [self.layer addSublayer:maskLayer];
    self.layer.mask = maskLayer;
    self.layer.shadowOffset = CGSizeMake(3, 3);
    self.layer.shadowOpacity = 0.7;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    [self customBar:bar];
}
- (void)customBar:(UINavigationBar *)bar {
    bar.layer.shadowOffset = CGSizeMake(3, 3);
    bar.layer.shadowOpacity = 0.70;
}
- (void)drawRect:(CGRect)rect {
    [[UIImage imageNamed:@"Title"] drawInRect:rect];
}
@end
