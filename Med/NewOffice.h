//
//  NewOffice.h
//  masterDemo
//
//  Created by Edward on 13-3-5.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Office.h"
@interface NewOffice : UIViewController <UITextFieldDelegate> {
    IBOutlet UITextField *textField;
}

@property (nonatomic, retain) UITextField *textField;

- (IBAction)hide:(id)sender;
- (IBAction)Save:(id)sender;

@end

