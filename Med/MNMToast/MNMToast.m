/*
 * Copyright (c) 09/10/2012 Mario Negro (@emenegro)
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

#import "MNMToast.h"
#import "MNMToastView.h"

@interface MNMToast()

/*
 * Queue of toast entities.
 */
@property (nonatomic, readwrite, strong) NSMutableArray *queue;

/*
 * The current toast view being shown.
 */
@property (nonatomic, readwrite, strong) MNMToastView *currentToastView;

/*
 * Shows a toast
 *
 * @param text The text to show.
 * @param autoHide YES to autohide after the fixed delay.
 * @param priority The priority of the toast
 * @param completionHandler The handler fired when the toast disappears.
 * @param tapHandler The handler fired when a user taps.
 */
- (void)showWithText:(NSString *)text
         autoHidding:(BOOL)autoHide
            priority:(MNMToastPriority)priority
   completionHandler:(MNMToastCompletionHandler)completionHandler
          tapHandler:(MNMToastTapHandler)tapHandler;

/*
 * Hides the current visible toast.
 */
- (void)hide;

/*
 * Show next toast.
 */
- (void)showNextToast;

@end

@implementation MNMToast

@synthesize queue = queue_;
@synthesize currentToastView = currentToastView_;

#pragma mark -
#pragma mark Singleton

/*
 * Returns the singleton only instance.
 */
+ (MNMToast *)getInstance {
    
    static dispatch_once_t once;
    static MNMToast *sharedInstance;
    
    dispatch_once(&once, ^{
        
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Initialization

/*
 * Designated initalizer
 */
- (id)init {
    
    if (self = [super init]) {
        
        queue_ = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark - Class methods

/*
 * Shows a toast.
 */
+ (void)showWithText:(NSString *)text
         autoHidding:(BOOL)autoHide
            priority:(MNMToastPriority)priority
   completionHandler:(MNMToastCompletionHandler)completionHandler
          tapHandler:(MNMToastTapHandler)tapHandler {
    
    [[MNMToast getInstance] showWithText:text
                             autoHidding:autoHide
                                priority:priority
                       completionHandler:completionHandler
                              tapHandler:tapHandler];
}

/*
 * Shows a toast with autohide and regular priority.
 */
+ (void)showWithText:(NSString *)text
   completionHandler:(MNMToastCompletionHandler)completionHandler
          tapHandler:(MNMToastTapHandler)tapHandler {
    
    [[MNMToast getInstance] showWithText:text
                             autoHidding:YES
                                priority:MNMToastPriorityNormal
                       completionHandler:completionHandler
                              tapHandler:tapHandler];
}

/*
 * Hides the current visible toast.
 */
+ (void)hide {
    
    [[MNMToast getInstance] hide];
}

#pragma mark - Showing

/*
 * Shows a toast.
 */
- (void)showWithText:(NSString *)text
         autoHidding:(BOOL)autoHide
            priority:(MNMToastPriority)priority
   completionHandler:(MNMToastCompletionHandler)completionHandler
          tapHandler:(MNMToastTapHandler)tapHandler {
    
    if ([text length] > 0) {
        
        MNMToastValue *value = [[MNMToastValue alloc] init];        
        [value setText:text];
        [value setAutoHide:autoHide];
        [value setCompletionHandler:completionHandler];
        [value setTapHandler:tapHandler];
        
        if (![queue_ containsObject:value]) {
            
            if (priority == MNMToastPriorityHigh) {
                
                [queue_ insertObject:value atIndex:0];
            
            } else {
                
                [queue_ addObject:value];
            }
            
            [self showNextToast];
        }
    }
}

/*
 * Show next toast
 */
- (void)showNextToast {

    if ([currentToastView_ superview] == nil && [queue_ count] > 0) {
        
        MNMToastValue *value = [queue_ objectAtIndex:0];
        UIViewController *controller = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        
        if ([controller isKindOfClass:[UITabBarController class]]) {
            
            controller = [(UITabBarController *)controller selectedViewController];
            
        } else if ([controller isKindOfClass:[UINavigationController class]]) {
            
            controller = [(UINavigationController *)controller visibleViewController];
        }
        
        MNMToastView *toastView = [[MNMToastView alloc] initWithFrame:CGRectZero];
        [toastView setToastSuperview:[controller view]];
        [toastView setValue:value];
        [[controller view] addSubview:toastView];
        [toastView setNeedsLayout];
        
        currentToastView_ = toastView;
        
        [toastView showWithCompletionBlock:^{
            
            if ([value autoHide]) {
                
                [toastView performSelector:@selector(hideWithCompletionBlock:)
                                withObject:^{
                                    
                                    [queue_ removeObject:[toastView value]];
                                    [self showNextToast];
                                }
                                afterDelay:kAutohidingTime];
            }
        }];
    }
}

#pragma mark - Hiding

/*
 * Hides the current visible toast.
 */
- (void)hide {
    
    [currentToastView_ hideWithCompletionBlock:^{
        
        [queue_ removeObject:[currentToastView_ value]];
        currentToastView_ = nil;
        [self showNextToast];
    }];
}

@end
