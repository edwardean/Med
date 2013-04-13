//
//  AppDelegate.h
//  Med
//
//  Created by Edward on 13-3-21.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RootViewController;

@interface StackScrollViewAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	RootViewController *rootViewController;
}

+ (StackScrollViewAppDelegate *) instance;

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) RootViewController *rootViewController;


@end
