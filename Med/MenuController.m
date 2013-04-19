//
//  MenuController.m
//  StackScrollView
//
//  Created by Edward on 13-3-21.
//
//

#import "MenuController.h"
#import "DataViewController.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "StackScrollViewController.h"
#import "Cell1.h"
#import "Cell2.h"
#import "NewMedicine.h"
#import "NewBingQu.h"
#import "NewRecord.h"
#import "ScanAllMedInfo.h"
#import "ScanAllRecords.h"
#import "ExportTable.h"
#import "FMDatabase.h"
#import "dataBaseManager.h"
#import "CMActionSheet.h"
#import "WCAlertView.h"
#import "MNMToast.h"
@interface MenuController ()
@property (assign) BOOL isOpen;
@property (nonatomic, retain) NSIndexPath *selectIndex;
@property (nonatomic, retain) NewMedicine *newMed;
@property (nonatomic, retain) NewBingQu *newBQ;
@property (nonatomic, retain) NewRecord *newRecord;
@property (nonatomic, retain) ScanAllMedInfo *scanAllMed;
@property (nonatomic, retain) ScanAllRecords *scanAllRecord;
@property (nonatomic, retain) ExportTable *exp;
@property (nonatomic, retain) NSArray *menuIconList;
@end
@implementation MenuController
@synthesize table = _table;
@synthesize isOpen,selectIndex;
- (id)initWithFrame:(CGRect)frame {
    if (self = [super init]) {
		[self.view setFrame:frame];
		_table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
		[_table setDelegate:self];
		[_table setDataSource:self];
		[_table setBackgroundColor:[UIColor clearColor]];
                
        UIView* footerView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
		_table.tableFooterView = footerView;
        [_table setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_tab_cell_separator"]]];
        [footerView release];
        _table.scrollEnabled = NO;
		[self.view addSubview:_table];
		
		UIView* verticalLineView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, -5, 1, self.view.frame.size.height)];
		[verticalLineView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [verticalLineView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_tab_cell_separator_vertical"]]];
		[self.view addSubview:verticalLineView];
		[self.view bringSubviewToFront:verticalLineView];
        [verticalLineView release];
		
	}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSString *path  = [[NSBundle mainBundle] pathForResource:@"menu" ofType:@"plist"];
    _dataList = [[NSMutableArray alloc] initWithContentsOfFile:path];
    _menuIconList = @[@"add",@"scan",@"setting"];//[NSArray arrayWithObjects:@"add",@"scan",@"setting",nil];
    self.table.sectionFooterHeight = 0;
    self.table.sectionHeaderHeight = 0;
    self.isOpen = NO;
    self.newMed = [[NewMedicine alloc] initWithNibName:@"NewMedicine" bundle:nil];
    _newBQ = [[NewBingQu alloc] initWithNibName:@"NewBingQu" bundle:nil];
    _newRecord = [[NewRecord alloc] initWithNibName:@"NewRecord" bundle:nil];
    _scanAllMed = [[ScanAllMedInfo alloc] initWithNibName:@"ScanAllMedInfo" bundle:nil];
    _scanAllRecord = [[ScanAllRecords alloc] initWithNibName:@"ScanAllRecords" bundle:nil];
    _exp = [[ExportTable alloc] initWithNibName:@"ExportTable" bundle:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataList count];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isOpen) {
        if (self.selectIndex.section == section) {
            return [[[_dataList objectAtIndex:section] objectForKey:@"list"] count]+1;;
        }
    }
    return 1;
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0) {
        static NSString *CellIdentifier = @"Cell2";
        Cell2 *cell = (Cell2*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        NSArray *list = [[_dataList objectAtIndex:self.selectIndex.section] objectForKey:@"list"];
        cell.titleLabel.text = [list objectAtIndex:indexPath.row-1];
        cell.titleLabel.font = MyFont(16.0f);
        return cell;
    }else
    {
        static NSString *CellIdentifier = @"Cell1";
        Cell1 *cell = (Cell1*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        NSString *name = [[_dataList objectAtIndex:indexPath.section] objectForKey:@"name"];
        //cell.titleLabel.text = name;
        cell.textLabel.text = name;
        cell.textLabel.font = MyFont(19.5f);
        cell.imageView.image = [UIImage imageNamed:[_menuIconList objectAtIndex:[indexPath section]]];
        [cell changeArrowWithUp:([self.selectIndex isEqual:indexPath]?YES:NO)];
        return cell;
    }
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([indexPath isEqual:self.selectIndex]) {
            self.isOpen = NO;
            [self didSelectCellRowFirstDo:NO nextDo:NO];
            self.selectIndex = nil;
            
        }else
        {
            if (!self.selectIndex) {
                self.selectIndex = indexPath;
                [self didSelectCellRowFirstDo:YES nextDo:NO];
                
            }else
            {
                
                [self didSelectCellRowFirstDo:NO nextDo:YES];
            }
        }
        
    }else
    {
        NSDictionary *dic = [_dataList objectAtIndex:indexPath.section];
        NSArray *list = [dic objectForKey:@"list"];
        NSString *item = [list objectAtIndex:indexPath.row-1];
        if ([item isEqualToString:@"新增药品"]) {
            [[StackScrollViewAppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:_newMed invokeByController:self isStackStartView:TRUE];
        } else if ([item isEqualToString:@"新增病区"]) {
            [[StackScrollViewAppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:_newBQ invokeByController:self isStackStartView:TRUE];
        } else if ([item isEqualToString:@"新增用药记录"]) {
            [[StackScrollViewAppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:_newRecord invokeByController:self isStackStartView:TRUE];
        } else if ([item isEqualToString:@"查看所有药品信息"])
        {
            [[StackScrollViewAppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:_scanAllMed invokeByController:self isStackStartView:TRUE];
        } else if ([item isEqualToString:@"查看各病区用药记录"]) {
            [[StackScrollViewAppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:_scanAllRecord invokeByController:self isStackStartView:TRUE];
        } else if ([item isEqualToString:@"导出数据"]) {
            [[StackScrollViewAppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:_exp invokeByController:self isStackStartView:TRUE];
        } else if ([item isEqualToString:@"清空所有"]) {
//            [WCAlertView showAlertWithTitle:@"确认信息" message:@"真的要清除所有记录吗??" customizationBlock:^(WCAlertView *alertView) {
//                alertView.style = WCAlertViewStyleVioletHatched;
//            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
//                if (buttonIndex == 1) {
//                    BOOL isOK = NO;
//                    FMDatabase *dataBase = [dataBaseManager createDataBase];
//                    if ([dataBase open]) {
//                        NSString *sql3 = @"DELETE FROM Record";
//                        NSString *sql4 = @"DELETE FROM Detail";
//                        isOK = [dataBase executeUpdate:sql3]&&[dataBase executeUpdate:sql4];
//                        [dataBase close];
//                    }
//                    NSString *msg = isOK ? @"已删除所有记录" : @"出现错误";
//                    [Help ShowGCDMessage:msg andView:self.view andDelayTime:1.0];
//                } else {
//                    debugLog(@"取消");
//                }
//            } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            MBAlertView *alert = [MBAlertView alertWithBody:@"清空所有记录,但会保留药品和病区信息" cancelTitle:@"取消" cancelBlock:nil];
            [alert addButtonWithText:@"确定" type:MBAlertViewItemTypePositive block:^{
                BOOL isOK = NO;
                FMDatabase *dataBase = [dataBaseManager createDataBase];
                if ([dataBase open]) {
                    NSString *sql3 = @"DELETE FROM Record";
                    NSString *sql4 = @"DELETE FROM Detail";
                    isOK = [dataBase executeUpdate:sql3]&&[dataBase executeUpdate:sql4];
                    [dataBase close];
                }
                if (isOK) {
                    [Help doSomething:^{
                        [MNMToast showWithText:@"记录已清除" autoHidding:YES priority:MNMToastPriorityNormal completionHandler:^(MNMToastValue *toast) {
                            
                        } tapHandler:nil];
                    } afterDelay:0.0f];
                } else {
                    [Help doSomething:^{
                        [MNMToast showWithText:@"不好意思，出错了!" autoHidding:YES priority:MNMToastPriorityNormal completionHandler:^(MNMToastValue *toast) {
                            
                        } tapHandler:nil];
                    } afterDelay:0.0f];
                }
            }];
            [alert addToDisplayQueue];
            
        } else if ([item isEqualToString:@"删除所有已导出文件"]){
            CMActionSheet *sheet = [[[CMActionSheet alloc] init]autorelease];
            [sheet addButtonWithTitle:@"真的要删除吗?这会清除所有的csv文件,请确认已将文件安全地导出" type:CMActionSheetButtonTypeRed block:^{
                NSString *extension = @"csv";
                NSFileManager *manager = [NSFileManager defaultManager];
                NSString *path = DOCUMENT;
                NSString *dir = [DOCUMENT stringByAppendingPathComponent:DirectoryName];
                NSArray *contents = [manager contentsOfDirectoryAtPath:path error:NULL];
                NSEnumerator *e = [contents objectEnumerator] ;
                NSString *fileName;
                while ((fileName = [e nextObject])) {
                    if ([[fileName pathExtension] isEqualToString:extension]) {
                           [manager removeItemAtPath:[path stringByAppendingPathComponent:fileName] error:NULL]; 
                    }
                }
                BOOL isDir = YES;
             if ([manager fileExistsAtPath:dir isDirectory:&isDir]){
                 [manager removeItemAtPath:dir error:nil];
             }
            }];
            [sheet addButtonWithTitle:@"好吧,我反悔了" type:CMActionSheetButtonTypeWhite block:^{
                
            }];
            [sheet present];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
    
    Cell1 *cell = (Cell1 *)[self.table cellForRowAtIndexPath:self.selectIndex];
    [cell changeArrowWithUp:firstDoInsert];
    
    [self.table beginUpdates];
    
    int section = self.selectIndex.section;
    int contentCount = [[[_dataList objectAtIndex:section] objectForKey:@"list"] count];
	NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
	for (NSUInteger i = 1; i < contentCount + 1; i++) {
		NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
		[rowToInsert addObject:indexPathToInsert];
	}
	
	if (firstDoInsert)
    {   [self.table insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
	else
    {
        [self.table deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    
	[rowToInsert release];
	
	[self.table endUpdates];
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [self.table indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    if (self.isOpen) [self.table scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
- (void)viewDidUnload {
    [super viewDidUnload];
    _dataList = nil;
    [self setTable:nil];
    [self setSelectIndex:nil];
}

- (void) dealloc {
    [_dataList release];
    _dataList = nil;
    [_table release];
    self.isOpen = NO;
    [selectIndex release];
    [_newMed release];
    [_newBQ release];
    [_newRecord release];
    [_scanAllMed release];
    [_scanAllRecord release];
    [_exp release];
    [super dealloc];
}
@end
