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
#import "NewOffice.h"
#import "NewBingQu.h"
#import "NewRecord.h"
#import "ScanAllMedInfo.h"
#import "ScanAllRecords.h"
@interface MenuController ()
@property (assign) BOOL isOpen;
@property (nonatomic, retain) NSIndexPath *selectIndex;
@end
@implementation MenuController
@synthesize table = _table;
@synthesize isOpen,selectIndex;
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        
//    }
//    return self;
//}
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
    //NSLog(@"%@",path);
    
    self.table.sectionFooterHeight = 0;
    self.table.sectionHeaderHeight = 0;
    self.isOpen = NO;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //NSLog(@"_dataListCount:%d",[_dataList count]);
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
        return cell;
    }else
    {
        static NSString *CellIdentifier = @"Cell1";
        Cell1 *cell = (Cell1*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        NSString *name = [[_dataList objectAtIndex:indexPath.section] objectForKey:@"name"];
        cell.titleLabel.text = name;
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
        UIViewController *controller = [[[UIViewController alloc] init] autorelease];
        NewMedicine *newMedicine = [[[NewMedicine alloc] initWithNibName:@"NewMedicine" bundle:nil] autorelease];
        
        //NewOffice *newOffice = [[NewOffice alloc] initWithNibName:@"NewOffice" bundle:nil];
        NewBingQu *newBQ = [[[NewBingQu alloc] initWithNibName:@"NewBingQu" bundle:nil] autorelease];
        
        NewRecord *newRecord = [[[NewRecord alloc] initWithNibName:@"NewRecord" bundle:nil] autorelease];
        ScanAllMedInfo *scanMedInfo = [[[ScanAllMedInfo alloc] initWithNibName:@"ScanAllMedInfo" bundle:nil] autorelease];
        ScanAllRecords *scanAllRecord = [[[ScanAllRecords alloc] initWithNibName:@"ScanAllRecords" bundle:nil] autorelease];
        
        NSDictionary *dic = [_dataList objectAtIndex:indexPath.section];
        NSArray *list = [dic objectForKey:@"list"];
        NSString *item = [list objectAtIndex:indexPath.row-1];
        if ([item isEqualToString:@"新增药品"]) {
            controller = [newMedicine retain];
        } else if ([item isEqualToString:@"新增病区"]) {
            controller = [newBQ retain];
        } else if ([item isEqualToString:@"新增用药记录"]) {
            controller = [newRecord retain];
        } else if ([item isEqualToString:@"查看所有药品信息"])
        {
            controller = [scanMedInfo retain];
        } else if ([item isEqualToString:@"查看各病区用药记录"]) {
            controller = [scanAllRecord retain];
        }
//        controller.modalPresentationStyle = UIModalPresentationFormSheet;
//        [self presentModalViewController:controller animated:YES];
        [[StackScrollViewAppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:controller invokeByController:self isStackStartView:TRUE];        
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
- (void) dealloc {
    [_dataList release];
    _dataList = nil;
    self.table = nil;
    self.isOpen = NO;
    self.selectIndex = nil;
    [super dealloc];
}
@end
