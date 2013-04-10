//
//  InputNewRecord.h
//  masterDemo
//
//  Created by Edward on 13-3-6.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewRecord.h"
@interface InputNewRecord : UIViewController <UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate> {
    UITableView *table;
}

@property (nonatomic, retain) UISearchBar *search;
@property (nonatomic, retain) UITableView *table;
@property (nonatomic, retain) UITextField *field;
@property (nonatomic, retain) NSMutableArray *contentArray;//存放所选药量和index
@end
