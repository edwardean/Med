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

#import <CoreFoundation/CoreFoundation.h>
#import "MNMToastValue.h"

/**
 * Object that manages a queue of toast entities, showing a floating view with a text to be shown at the bottom of the __current view of the application window root view controller__.
 *
 * **_NOTE_:** the toasts does not being stacked one over another if push one before the previous has been dismissed or
 * you hide it manually. If you want to prioritize the showing of a toast give it Hight priority.
 *
 * @warning See `Constants` for more documentation.
 */
@interface MNMToast : NSObject

/**
 * Shows a toast with the given information.
 *
 * @param text The text to show.
 * @param autoHide YES to autohide after the fixed delay.
 * @param priority The priority of the toast
 * @param completionHandler The handler fired when the toast disappears.
 * @param tapHandler The handler fired when a user taps.
 */
+ (void)showWithText:(NSString *)text
         autoHidding:(BOOL)autoHide
            priority:(MNMToastPriority)priority
   completionHandler:(MNMToastCompletionHandler)completionHandler
          tapHandler:(MNMToastTapHandler)tapHandler;

/**
 * Shows a toast with autohide and regular priority.
 *
 * @param text The text to show.
 * @param completionHandler The handler fired when the toast disappears.
 * @param tapHandler The handler fired when a user taps. 
 */
+ (void)showWithText:(NSString *)text
   completionHandler:(MNMToastCompletionHandler)completionHandler
          tapHandler:(MNMToastTapHandler)tapHandler;

/**
 * Hides the current visible toast.
 *
 * Can be called even if was shown with autohiding.
 * After being dismissed the completion handler passed when shown will be invoked.
 */
+ (void)hide;

@end
