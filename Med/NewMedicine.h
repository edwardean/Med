//
//  NewMedicine.h
//  masterDemo
//
//  Created by Edward on 13-3-5.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDiscreetNotificationView.h"
@interface NewMedicine : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    IBOutlet UITableView *specifiTable;
    IBOutlet UITextField *nameTextField;
    IBOutlet UITextField *specifiTextField;
    IBOutlet UITextField *countTextField;
    IBOutlet UITextField *pymTextField;
    IBOutlet UINavigationBar *navBar;
}

@property (nonatomic, retain) UITableView *specifiTable;
@property (nonatomic, retain) UITextField *nameTextField;
@property (nonatomic, retain) UITextField *specifiTextField;
@property (nonatomic, retain) UITextField *countTextField;
@property (nonatomic, retain) UITextField *pymTextField;
- (IBAction)hide:(id)sender;
- (IBAction)Save:(id)sender;
@end
