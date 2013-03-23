//
//  SelectBQ.h
//  masterDemo
//
//  Created by Edward on 13-3-14.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectBQ : UIViewController <UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDelegate,UITableViewDataSource> {
    
    IBOutlet UITableView *table;
    NSString *BQStr;
}
@property (nonatomic, copy) NSString *BQStr;
@property (nonatomic, retain) UITableView *table;
@end
