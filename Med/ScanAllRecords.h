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

@property (nonatomic, strong) UITableView *table;
@property (strong, nonatomic) UISearchBar *search;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
- (IBAction)exportPressed:(id)sender;
- (IBAction)deleteRow:(id)sender;
@end
