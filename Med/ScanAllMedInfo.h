//
//  ScanAllMedInfo.h
//  Med
//
//  Created by Edward on 13-3-21.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanAllMedInfo : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate> {
    IBOutlet UITableView *_table;
}
@property (strong, nonatomic) IBOutlet UISearchBar *search;

@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (nonatomic, strong) UITableView *table;
- (IBAction)deleteRow:(id)sender;
//@property (retain, nonatomic) IBOutlet UIBarButtonItem *deleteBtn;
- (IBAction)exportMedTable:(id)sender;
@end
