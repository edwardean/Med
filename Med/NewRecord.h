//
//  NewRecord.h
//  masterDemo
//
//  Created by Edward on 13-3-6.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SelectBQ.h"
@class InputNewRecord;
@protocol ClearCellMarkDelegate <NSObject>
@required
- (void)clearMark;

@end

@interface NewRecord : UIViewController <UIPopoverControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

{
    IBOutlet InputNewRecord *inputNewRecord;
    IBOutlet SelectBQ *selectBQ;
    NSMutableArray *data;
    id <ClearCellMarkDelegate> delegate;
}
@property (retain, nonatomic) IBOutlet UINavigationBar *navBar;

@property (retain, nonatomic) IBOutlet UITextField *field;
@property (nonatomic, retain) InputNewRecord *inputNewRecord;
@property (nonatomic, retain) SelectBQ *selectBQ;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIButton *addBtn;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, assign) id <ClearCellMarkDelegate> delegate;
-(IBAction)showPopover:(id)sender;
-(IBAction)hide:(id)sender;
- (IBAction)showBQ:(id)sender;
- (IBAction)saveBtnTapped:(id)sender;
- (void)deleteRow:(id)sender;
@end
