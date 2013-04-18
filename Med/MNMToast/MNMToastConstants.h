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

@class MNMToastValue;

/**
 * Completion handler fired when the toast disappears.
 *
 * @param toast The toast value.
 */
typedef void(^MNMToastCompletionHandler)(MNMToastValue *toast);

/**
 * Completion handler fired when the user taps on the toast.
 *
 * @param toast The toast value.
 */
typedef void(^MNMToastTapHandler)(MNMToastValue *toast);

/**
 * Priority of the toasts.
 */
typedef enum {
    
    MNMToastPriorityNormal = 0, // The toast is added to the end of the queue.
    MNMToastPriorityHigh // The toast is added at the first position of the queue, to be shown the next one.
    
} MNMToastPriority;

/**
 * Duration of the animation to show/hide.
 */
extern CGFloat const kFadeAnimationDuration;

/**
 * Time (in seconds) in which the toast will be visible if shown with autohiding.
 */
extern CGFloat const kAutohidingTime;

/**
 * Font size of the text.
 */
extern CGFloat const kFontSize;

/**
 * Left and right margin between the border of the toast's superviewview and the toast view.
 */
extern CGFloat const kHorizontalMargin;

/**
 * Margin between the bottom of the toast's superview and the toast view.
 */
extern CGFloat const kBottomMargin;

/**
 * Text inset, that is, the margin between the text its container view.
 */
extern CGFloat const kTextInset;

