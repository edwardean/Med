//
//  NewRecord.h
//  masterDemo
//
//  Created by Edward on 13-3-6.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SelectBQ.h"
//#import "QBFlatButton.h"
@class InputNewRecord;
@class QBFlatButton;
@interface NewRecord : UIViewController <UIPopoverControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,PassSelectedBQDelegete>

{
    IBOutlet InputNewRecord *inputNewRecord;
    IBOutlet SelectBQ *selectBQ;
    NSMutableArray *data;
}
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;

@property (strong, nonatomic) IBOutlet UITextField *field;
@property (nonatomic, strong) InputNewRecord *inputNewRecord;
@property (nonatomic, strong) SelectBQ *selectBQ;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (strong, nonatomic) IBOutlet UILabel *selectedBQLabel;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) NSMutableArray *data;
-(IBAction)showPopover:(id)sender;
-(IBAction)Hide:(id)sender;
- (IBAction)showBQ:(id)sender;
- (IBAction)saveBtnTapped:(id)sender;
- (void)deleteRow:(id)sender;
@end
