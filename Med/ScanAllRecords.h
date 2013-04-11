//
//  ScanAllRecords.h
//  Med
//
//  Created by Edward on 13-3-23.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackScrollViewController.h"
#import "ExportTable.h"
@interface ScanAllRecords : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate> {
    IBOutlet UITableView *_table;
}

@property (nonatomic, retain) UITableView *table;
@property (retain, nonatomic) UISearchBar *search;
@property (retain, nonatomic) IBOutlet UINavigationBar *navBar;
- (IBAction)exportPressed:(id)sender;
- (IBAction)deleteRow:(id)sender;
@end
