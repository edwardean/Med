//
//  NewMedicine.h
//  masterDemo
//
//  Created by Edward on 13-3-5.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NewMedicine : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    IBOutlet UITableView *specifiTable;
    IBOutlet UITextField *nameTextField;
    IBOutlet UITextField *specifiTextField;
    IBOutlet UITextField *countTextField;
    IBOutlet UITextField *pymTextField;
    IBOutlet UINavigationBar *navBar;
}

@property (nonatomic, strong) UITableView *specifiTable;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *specifiTextField;
@property (nonatomic, strong) UITextField *countTextField;
@property (nonatomic, strong) UITextField *pymTextField;
- (IBAction)Hide:(id)sender;
- (IBAction)Save:(id)sender;
@end
