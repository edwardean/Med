//
//  MBAlertView.m
//  Notestand
//
//  Created by M B. Bitar on 9/8/12.
//  Copyright (c) 2012 progenius, inc. All rights reserved.
//

#import "MBAlertView.h"
#import "MBHUDView.h"
#import <QuartzCore/QuartzCore.h>

#import "MBAlertViewButton.h"
#import "MBSpinningCircle.h"
#import "MBCheckMarkView.h"

#import "UIView+Animations.h"
#import "NSString+Trim.h"
#import "UIFont+Alert.h"

#import "MBAlertViewSubclass.h"

NSString *const MBAlertViewDidAppearNotification = @"MBAlertViewDidAppearNotification";
NSString *const MBAlertViewDidDismissNotification = @"MBAlertViewDidDismissNotification";

CGFloat MBAlertViewMaxHUDDisplayTime = 10.0;
CGFloat MBAlertViewDefaultHUDHideDelay = 0.65;

@interface MBAlertView ()
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation MBAlertView
{
    NSMutableArray *_buttons;
    BOOL isPendingDismissal;
    UIButton *_backgroundButton;

}
// when dismiss is called, it takes about 0.5 seconds to complete animations. you want to remove it from the queue in the beginning, but want something to hold on to it. this is what retain queue is for

static NSMutableArray *retainQueue;
static NSMutableArray *displayQueue;
static NSMutableArray *dismissQueue;
static MBAlertView *currentAlert;

+(BOOL)alertIsVisible
{
    if(currentAlert)
        return YES;
    return NO;
}

+(CGSize)halfScreenSize
{
    return CGSizeMake(280, 240);
}

+(MBAlertView*)alertWithBody:(NSString*)body cancelTitle:(NSString*)cancelTitle cancelBlock:(id)cancelBlock
{
    MBAlertView *alert = [[MBAlertView alloc] init];
    alert.bodyText = body;
    if(cancelTitle)
        [alert addButtonWithText:cancelTitle type:MBAlertViewItemTypeDefault block:cancelBlock];
    return alert;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(id)init
{
    if(self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRotation:)name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    
    return self;
}

-(void)addToDisplayQueue
{
    if(!displayQueue)
        displayQueue = [[NSMutableArray alloc] init];
    if(!dismissQueue)
        dismissQueue = [[NSMutableArray alloc] init];
    
    [displayQueue addObject:self];
    [dismissQueue addObject:self];
    
    if(retainQueue.count == 0 && !currentAlert)
    {
        // show now
        currentAlert = self;
        [self addToWindow];
        if([self isMemberOfClass:[MBAlertView class]])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:MBAlertViewDidAppearNotification object:nil];
        }
    }
}

-(void)addToWindow
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    if (!window)
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];

    if(self.addsToWindow)
        [window addSubview:self.view];
    else [[[window subviews] objectAtIndex:0] addSubview:self.view];
    
    [self performLayoutOfButtons];
    [self centerViews];
    
    [window resignFirstRespondersForSubviews];
    
    [self addBounceAnimationToLayer:self.view.layer];
    [displayQueue removeObject:self];

}

// calling this removes the last queued alert, whether it has been displayed or not
+(void)dismissCurrentHUD
{
    if(dismissQueue.count > 0)
    {
        MBAlertView *current = [dismissQueue lastObject];
        [displayQueue removeObject:current];
        [current dismiss];
        [dismissQueue removeLastObject];
    }
}

+(void)dismissCurrentHUDAfterDelay:(float)delay
{
    [[MBAlertView class] performSelector:@selector(dismissCurrentHUD) withObject:nil afterDelay:delay];
}

-(void)dismiss
{
    if(isPendingDismissal)
        return;
    isPendingDismissal = YES;
    
    if(!retainQueue)
        retainQueue = [[NSMutableArray alloc] init];
    
    [self.hideTimer invalidate];
    [retainQueue addObject:self];
    [dismissQueue removeObject:self];

    currentAlert = nil;
    [self addDismissAnimation];
}

-(void)removeAlertFromView
{
    id block = self.uponDismissalBlock;
    if (![block isEqual:[NSNull null]] && block)
    {
        ((void (^)())block)();
    }
   
    [self.view removeFromSuperview];
    [retainQueue removeObject:self];
    
    if(displayQueue.count > 0)
    {
        MBAlertView *alert = [displayQueue objectAtIndex:0];
        currentAlert = alert;
        [currentAlert addToWindow];
    }
}

-(void)didSelectButton:(MBAlertViewButton*)button
{
    if(button.tag >= _items.count)
        return;
    MBAlertViewItem *item = [_items objectAtIndex:button.tag];
    if(!item)
        return;
    
    id block = item.block;
    if (![block isEqual:[NSNull null]] && block)
    {
        if(self.shouldPerformBlockAfterDismissal && block)
            self.uponDismissalBlock = block;
        else ((void (^)())block)();
        [[NSNotificationCenter defaultCenter] postNotificationName:MBAlertViewDidDismissNotification object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:MBAlertViewDidDismissNotification object:nil];
    }
    
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.12];
}


// if there is only one button on the alert, we're going to assume its just an OK option, so we'll let the user tap anywhere to dismiss the alert
-(void)didSelectBackgroundButton:(UIButton*)button
{
    if(_buttons.count == 1)
    {
        MBAlertViewButton *alertButton = [_buttons objectAtIndex:0];
        [self didSelectButton:alertButton];
    }
}

-(NSMutableArray*)items
{
    if(_items)
        return _items;
    _items = [[NSMutableArray alloc] init];
    return _items;
}

-(void)addButtonWithText:(NSString*)text type:(MBAlertViewItemType)type block:(id)block
{
    MBAlertViewItem *item = [[MBAlertViewItem alloc] initWithTitle:text type:type block:block];
    [self.items addObject:item];
}

-(int)defaultAutoResizingMask
{
    return UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
}

#define kBodyFont [UIFont boldSystemFontOfSize:20]
#define kSpaceBetweenButtons 30

-(BOOL)isFullScreen
{
    return CGSizeEqualToSize(self.size, CGSizeZero);
}

-(void)loadView
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.view = [[UIView alloc] initWithFrame:bounds];
    [self.view setBackgroundColor:[UIColor clearColor]];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    
    BOOL isFullScreen = [self isFullScreen];
    if(isFullScreen)
    {
        _contentRect = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
        _backgroundButton = [[UIButton alloc] initWithFrame:CGRectMake(-100, -100, bounds.size.width + 200, bounds.size.height + 200)];
        self.size = _contentRect.size;
    }
    else
    {
        _backgroundButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2.0 - self.size.width/2.0 , self.view.bounds.size.height/2.0 - self.size.height/2.0, self.size.width, self.size.height)];
        _backgroundButton.layer.cornerRadius = 8;
        _contentRect = _backgroundButton.frame;
    }
    
    [_backgroundButton setBackgroundColor:[UIColor blackColor]];
    _backgroundButton.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    _backgroundButton.alpha = _backgroundAlpha > 0 ? _backgroundAlpha : 0.85;
    [_backgroundButton addTarget:self action:@selector(didSelectBackgroundButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backgroundButton];
}

-(UIFont*)bodyFont
{
    if(_bodyFont)
        return _bodyFont;
    _bodyFont = [UIFont boldSystemFontThatFitsSize:[self labelConstraint] maxFontSize:22 minSize:20 text:self.bodyText];
    return _bodyFont;
}

-(CGSize)labelConstraint
{
    return CGSizeMake(self.contentRect.size.width - 40, self.contentRect.size.height - 100);
}

-(UIButton*)bodyLabelButton
{
    if(_bodyLabelButton)
        return _bodyLabelButton;
    
    CGSize size = [_bodyText sizeWithFont:self.bodyFont constrainedToSize:[self labelConstraint]];
    NSString *txt = [_bodyText stringByTruncatingToSize:size withFont:self.bodyFont addQuotes:NO];
    _bodyLabelButton = [[UIButton alloc] initWithFrame:CGRectMake(_contentRect.origin.x + _contentRect.size.width/2.0 - size.width/2.0, _contentRect.origin.y + _contentRect.size.height/2.0 - size.height/2.0 - 8 + _imageView.frame.size.height, size.width, size.height)];
    _bodyLabelButton.autoresizingMask = [self defaultAutoResizingMask];
    [_bodyLabelButton addTarget:self action:@selector(didSelectBodyLabel:) forControlEvents:UIControlEventTouchUpInside];
    [_bodyLabelButton setTitle:_bodyText forState:UIControlStateNormal];
    
    _bodyLabelButton.titleLabel.text = txt;
    _bodyLabelButton.titleLabel.font = self.bodyFont;
    _bodyLabelButton.titleLabel.numberOfLines = 0;
    _bodyLabelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_bodyLabelButton];
    return _bodyLabelButton;
}

-(UIImageView*)imageView
{
    if(_imageView)
        return _imageView;
    _imageView = [[UIImageView alloc] init];
    return _imageView;
}

-(void)layoutView
{
    if(_imageView)
    {
        [_imageView sizeToFit];
        CGRect rect = self.imageView.frame;
        rect.origin = CGPointMake(self.contentRect.origin.x + (self.contentRect.size.width/2.0 - rect.size.width/2.0), 0);
        _imageView.frame = rect;
        [self.view addSubview:self.imageView];
    }
        
    UIColor *titleColor = [UIColor whiteColor];
    [self.bodyLabelButton setTitleColor:titleColor forState:UIControlStateNormal];
    
    [_bodyLabelButton setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_bodyLabelButton];
    _buttons = [[NSMutableArray alloc] init];
    
    [self.items enumerateObjectsUsingBlock:^(MBAlertViewItem *item, NSUInteger index, BOOL *stop)
     {
         MBAlertViewButton *buttonLabel = [[MBAlertViewButton alloc] initWithTitle:item.title];
         [buttonLabel addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
         [buttonLabel addTarget:self action:@selector(didHighlightButton:) forControlEvents:UIControlEventTouchDown];
         [buttonLabel addTarget:self action:@selector(didRemoveHighlightFromButton:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchDragExit | UIControlEventTouchCancel];
         buttonLabel.tag = index;
         [_buttons addObject:buttonLabel];         
     }];
    
}

-(void)centerViews
{
    [_buttons enumerateObjectsUsingBlock:^(MBAlertViewButton *button, NSUInteger idx, BOOL *stop)
    {
        if(_imageView)
        {
            [_backgroundButton centerViewsVerticallyWithin:@[@{@"view" : _imageView, @"offset" : [NSNumber numberWithFloat:0]}, @{@"view" : self.bodyLabelButton, @"offset" : [NSNumber numberWithFloat:20]}, @{@"view" : button, @"offset" : [NSNumber numberWithFloat:20]}]];
        }
        else
        {
            [_backgroundButton centerViewsVerticallyWithin:@[@{@"view" : self.bodyLabelButton, @"offset" : [NSNumber numberWithFloat:0]}, @{@"view" : button, @"offset" : [NSNumber numberWithFloat:20]}]];
        }
    }];
}

// lays out button on rotation
-(void)layoutButtonsWrapper
{
    [UIView animateWithDuration:0.3 animations:^{
        [self performLayoutOfButtons];
    }];
    [self centerViews];
}

-(void)performLayoutOfButtons
{
    CGRect bounds = self.view.bounds;
    float totalWidth = 0;
    for(MBAlertViewButton *item in _buttons) {
        CGSize size = item.frame.size;
        totalWidth += size.width + kSpaceBetweenButtons;
    }
    
    totalWidth -= kSpaceBetweenButtons;
    
    float xOrigOfFirstItem = bounds.size.width/2.0 - totalWidth/2.0;
    __block float currentXOrigin = xOrigOfFirstItem;
    
    [self.items enumerateObjectsUsingBlock:^(MBAlertViewItem *item, NSUInteger index, BOOL *stop)
     {
         MBAlertViewButton *buttonLabel = [_buttons objectAtIndex:index];
         float origin = 0;
         if(index == 0)
             origin = currentXOrigin;
         else origin = currentXOrigin + kSpaceBetweenButtons;
         
         currentXOrigin = origin + buttonLabel.bounds.size.width;
         float yOrigin = _bodyLabelButton.frame.origin.y + _bodyLabelButton.frame.size.height ;

         CGRect rect = buttonLabel.frame;
         rect.origin = CGPointMake(origin, yOrigin);
         buttonLabel.frame = rect;
         buttonLabel.alertButtonType = item.type;
         
         if(!buttonLabel.superview)
             [self.view addSubview:buttonLabel];
     }];
}


#define kDismissDuration 0.25

-(void)hideWithFade
{
    self.view.alpha = 0.0;
    [self.view addFadingAnimationWithDuration:[self isMemberOfClass:[MBHUDView class]] ? 0.25 : 0.20];
    [self performSelector:@selector(removeAlertFromView) withObject:nil afterDelay:kDismissDuration];
}

-(void)didRemoveHighlightFromButton:(MBAlertViewButton*)button
{
    [button.layer removeAllAnimations];
}

-(void)addDismissAnimation
{
    NSArray *frameValues = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.15, 1.15, 1)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01, 0.01, 1.0)]];
    
    NSArray *frameTimes = @[@(0.0), @(0.1), @(0.5), @(1.0)];
    CAKeyframeAnimation *animation = [self animationWithValues:frameValues times:frameTimes duration:kDismissDuration];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [self.view.layer addAnimation:animation forKey:@"popup"];
    
    [self performSelector:@selector(hideWithFade) withObject:nil afterDelay:0.15];
}

-(void)addBounceAnimationToLayer:(CALayer*)layer
{
    NSArray *frameValues = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.35, 1.35, 1)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
    NSArray *frameTimes = @[@(0.0), @(0.5), @(0.9), @(1.0)];
    [layer addAnimation:[self animationWithValues:frameValues times:frameTimes duration:0.4] forKey:@"popup"];
}

-(void)didSelectBodyLabel:(UIButton*)bodyLabelButton
{
    NSArray *frameValues = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.08, 1.08, 1)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.02, 1.02, 1)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
    NSArray *frameTimes = @[@(0.0), @(0.1), @(0.7), @(0.9), @(1.0)];    
    [bodyLabelButton.layer addAnimation:[self animationWithValues:frameValues times:frameTimes duration:0.3] forKey:@"popup"];
}

-(void)didHighlightButton:(MBAlertViewButton*)button
{
    NSArray *frameValues = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.25, 1.25, 1.0)]];
    NSArray *frameTimes = @[@(0.0), @(0.5)];
    [button.layer addAnimation:[self animationWithValues:frameValues times:frameTimes duration:0.25] forKey:@"popup"];
}

-(CAKeyframeAnimation*)animationWithValues:(NSArray*)values times:(NSArray*)times duration:(CGFloat)duration
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = values;
    animation.keyTimes = times;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.removedOnCompletion = NO;
    animation.duration = duration;
    return animation;
}

- (void)setRotation:(NSNotification*)notification
{
    [self performSelector:@selector(layoutButtonsWrapper) withObject:nil afterDelay:0.01];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self layoutView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end