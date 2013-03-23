//
//  MenuController.h
//  StackScrollView
//
//  Created by Edward on 13-3-21.
//
//

#import <UIKit/UIKit.h>

@interface MenuController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    UITableView *_table;
    NSMutableArray *_dataList;
}
@property (nonatomic, retain) UITableView *table;
- (id) initWithFrame:(CGRect)frame;
@end
