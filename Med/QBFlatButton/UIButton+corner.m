//
//  UIButton+corner.m
//  Med
//
//  Created by Edward on 13-4-22.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "UIButton+corner.h"

@implementation UIButton (corner)


/***
 很蛋疼，QBButton的圆角在view上
 变得很难看，没办法所以在类别里再
 重新画一下圆角 (-:
 ***/
- (void)corner {
    CGRect bounds = self.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:
                              (UIRectCornerAllCorners) cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    [self.layer addSublayer:maskLayer];
    self.layer.mask = maskLayer;
}
@end
