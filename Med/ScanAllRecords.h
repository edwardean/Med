//
//  ScanAllRecords.h
//  Med
//
//  Created by Edward on 13-3-23.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanAllRecords : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate> {
    IBOutlet UITableView *_table;
}

@property (nonatomic, retain) UITableView *table;
@property (retain, nonatomic) IBOutlet UISearchBar *search;
@property (retain, nonatomic) IBOutlet UINavigationBar *navBar;
@end
