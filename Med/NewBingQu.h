//
//  NewBingQu.h
//  masterDemo
//
//  Created by Edward on 13-3-6.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dataBaseManager.h"
@interface NewBingQu : UIViewController <UITextFieldDelegate> {
    IBOutlet UITextField *inputTextField;
    IBOutlet UINavigationBar *navBar;
}
@property (nonatomic, strong) UITextField *inputTextField;
- (IBAction)hide:(id)sender;
- (IBAction)Save:(id)sender;
@end
