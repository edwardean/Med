//
//  NewRecord.h
//  masterDemo
//
//  Created by Edward on 13-3-6.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputNewRecord.h"
#import "SelectBQ.h"
@interface NewRecord : UIViewController <UIPopoverControllerDelegate,UITableViewDataSource,UITableViewDelegate>

{
    IBOutlet InputNewRecord *inputNewRecord;
    IBOutlet SelectBQ *selectBQ;
    NSMutableArray *data;
}
@property (retain, nonatomic) IBOutlet UINavigationBar *navBar;

@property (retain, nonatomic) IBOutlet UITextField *field;
@property (nonatomic, retain) InputNewRecord *inputNewRecord;
@property (nonatomic, retain) SelectBQ *selectBQ;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIButton *addBtn;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableArray *data;
-(IBAction)showPopover:(id)sender;
-(IBAction)hide:(id)sender;
- (IBAction)showBQ:(id)sender;
- (IBAction)saveBtnTapped:(id)sender;
- (void)deleteRow:(id)sender;
@end
