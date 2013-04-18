/*
 * Copyright (c) 04/02/2013 Mario Negro (@emenegro)
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "MNMToastView.h"
#import "MNMToastValue.h"
#import <QuartzCore/QuartzCore.h>

@interface MNMToastView()

/*
 * Text label.
 */
@property (nonatomic, readwrite, strong) UILabel *textLabel;

/*
 * YES if the completion handler has been invoked (to be called only once).
 */
@property (nonatomic, readwrite, assign) BOOL completionHandlerInvoked;

/*
 * Toast tapped
 */
- (void)toastTapped;

@end

@implementation MNMToastView

@synthesize value = value_;
@synthesize textLabel = textLabel_;
@synthesize toastSuperview = toastSuperview_;
@synthesize completionHandlerInvoked = completionHandlerInvoked_;

#pragma mark - Initilization

/*
 * Initializes and returns a newly allocated view object with the specified frame rectangle.
 */
- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        UIColor *borderColor = [UIColor colorWithRed:0.25f green:0.0f blue:0.0f alpha:0.5f];
        UIColor *backgroundColor = [UIColor colorWithRed:0.5f green:0.0f blue:0.0f alpha:0.5f];
        
        [self setBackgroundColor:backgroundColor];
        [self setAlpha:0.0f];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
        [[self layer] setCornerRadius:6];
        [[self layer] setBorderColor:[borderColor CGColor]];
        [[self layer] setBorderWidth:1.0f];
        
        textLabel_ = [[UILabel alloc] initWithFrame:frame];
        [textLabel_ setFont:[UIFont systemFontOfSize:kFontSize]];
        [textLabel_ setTextAlignment:NSTextAlignmentCenter];
        [textLabel_ setBackgroundColor:[UIColor clearColor]];
        [textLabel_ setTextColor:[UIColor whiteColor]];
        [textLabel_ setShadowColor:borderColor];
        [textLabel_ setShadowOffset:CGSizeMake(1.0f, 1.0f)];
        [textLabel_ setLineBreakMode:NSLineBreakByWordWrapping];
        [textLabel_ setNumberOfLines:0];
        
        [self addSubview:textLabel_];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toastTapped)];
        [tapGestureRecognizer setNumberOfTapsRequired:1];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    
    return self;
}

#pragma mark - Visuals

/*
 * Layout subviews
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth([toastSuperview_ bounds]) - kHorizontalMargin * 2.0f;
    CGFloat height = [[value_ text] sizeWithFont:[UIFont systemFontOfSize:kFontSize] constrainedToSize:CGSizeMake(width - kTextInset * 2.0f, CGFLOAT_MAX)].height + (kTextInset * 2.0f);
    CGFloat y = CGRectGetHeight([toastSuperview_ bounds]) - height - kBottomMargin;
    
    [textLabel_ setFrame:CGRectMake(kTextInset, kTextInset, width - kTextInset * 2.0f, height - kTextInset * 2.0f)];
    [textLabel_ setText:[value_ text]];
    
    [self setFrame:CGRectMake(kHorizontalMargin, y, width, height)];
}

/*
 * Shows this toast view.
 */
- (void)showWithCompletionBlock:(void(^)(void))completionBlock {
    
    [UIView animateWithDuration:kFadeAnimationDuration animations:^{
        
        [self setAlpha:1.0f];
        
    } completion:^(BOOL finished) {
        
        if (completionBlock != nil) {
            
            completionBlock();
        }
    }];
}

/*
 * Hides this toast view.
 */
- (void)hideWithCompletionBlock:(void(^)(void))completionBlock {
    
    [UIView animateWithDuration:kFadeAnimationDuration animations:^{
        
        [self setAlpha:0.0f];
        
    } completion:^(BOOL finished) {
        
        if (!completionHandlerInvoked_) {
         
            completionHandlerInvoked_ = YES;
            
            MNMToastCompletionHandler completionHandler = [value_ completionHandler];
            
            if (completionHandler != nil) {
                
                completionHandler(value_);
            }
        }
        
        [self removeFromSuperview];
        
        if (completionBlock != nil) {
            
            completionBlock();
        }
    }];
}

#pragma mark - Tap

/*
 * Toast tapped
 */
- (void)toastTapped {
    
    MNMToastTapHandler tapHandler = [value_ tapHandler];
    
    if (tapHandler != nil) {
        
        tapHandler(value_);
    }
}

@end
