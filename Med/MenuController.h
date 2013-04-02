//
//  MenuController.h
//  StackScrollView
//
//  Created by Edward on 13-3-21.
//
//

#import <UIKit/UIKit.h>
@class NewMedicine;
@class NewBingQu;
@class NewRecord;
@class ScanAllMedInfo;
@class ScanAllRecords;
@class ExportTable;
@interface MenuController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate> {
    UITableView *_table;
    NSMutableArray *_dataList;
}
@property (nonatomic, retain) UITableView *table;
- (id) initWithFrame:(CGRect)frame;
@end
