//
//  ScanAllRecords.m
//  Med
//
//  Created by Edward on 13-3-23.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "AppDelegate.h"
#import "ScanAllRecords.h"
#import "Record.h"
#import "StackScrollViewController.h"
#import "RootViewController.h"
#import "RecordDetail.h"
#import "Medicine.h"
@interface ScanAllRecords ()

@property (nonatomic, retain) NSArray *patientAndBQArray;
@property (nonatomic, retain) NSArray *searchArray;
@property (nonatomic, retain) NSArray *medArray;
@property (assign) BOOL isOpen;
@end

@implementation ScanAllRecords
@synthesize table = _table;
@synthesize search =_search;
@synthesize navBar = _navBar;
@synthesize patientAndBQArray = _patientAndBQArray;
@synthesize searchArray = _searchArray;
@synthesize medArray = _medArray;
@synthesize isOpen;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_navBar setBackImage];
    [super viewDidAppear:YES];
    self.patientAndBQArray = [Record findAllRecordsInRecordTableToArray];
    [_table reloadData];
    self.isOpen = NO;
    
}

- (void)viewDidAppear:(BOOL)animated {
//  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//      self.patientAndBQArray = [Record findAllRecordsInRecordTableToArray];
//      dispatch_async(dispatch_get_main_queue(), ^{
//          [_table reloadData];
//      });
//  });
    [super viewDidAppear:animated];
    
}
#pragma mark -
#pragma mark - UITableViewDataSource

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rows = 0;
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        rows = [_searchArray count];
    } else {
        rows = [_patientAndBQArray count];
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"LiHang";
    UITableViewCell *cell = nil;
    
    NSDictionary *mainDic = [_patientAndBQArray objectAtIndex:[indexPath row]];
    cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellID] autorelease];
    }
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        NSDictionary *searchDic = [_searchArray objectAtIndex:[indexPath row]];
        cell.textLabel.text = [searchDic objectForKey:@"PatientName"];
        cell.detailTextLabel.text = [searchDic objectForKey:@"Office"];
    } else {
    cell.textLabel.text = [mainDic objectForKey:@"PatientName"];
    cell.detailTextLabel.text = [mainDic objectForKey:@"Office"];
        //debugLog(@"%@",[mainDic objectForKey:@"Detail"]);
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark -
#pragma mark UITableViewdelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect rect = CGRectMake(0, 0, 447, self.view.frame.size.height);
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        NSDictionary *detailDic = [_searchArray objectAtIndex:[indexPath row]];
        NSArray *detailArray = [detailDic objectForKey:@"Detail"];
        NSString *patientName = [detailDic objectForKey:@"PatientName"];
        //debugLog(@"%@",detailArray);
        RecordDetail *detail = [[RecordDetail alloc] initWithFrame:rect andArray:detailArray andPatientName:patientName];
        [[StackScrollViewAppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:detail invokeByController:self isStackStartView:FALSE];
        [detail release];
        
    } else {
        
        NSDictionary *detailDic = [_patientAndBQArray objectAtIndex:[indexPath row]];
        NSArray *detailArray = [detailDic objectForKey:@"Detail"];
        NSString *patientname = [detailDic objectForKey:@"PatientName"];
        //debugLog(@"%@",detailArray);
        RecordDetail *detail = [[RecordDetail alloc] initWithFrame:rect andArray:detailArray andPatientName:patientname];
        [[StackScrollViewAppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:detail invokeByController:self isStackStartView:FALSE];
        [detail release];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!tableView.editing) {
        return UITableViewCellEditingStyleNone;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    UITableViewCell *cell = nil;
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        cell = [self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:indexPath];
    } else {
        cell = [tableView cellForRowAtIndexPath:indexPath];
        
    }
    NSString *patientname = cell.textLabel.text;
    NSString *office = cell.detailTextLabel.text;
    debugLog(@"要删除的patientName:%@   office:%@",patientname,office);
    BOOL isOK = NO;
    if ([Record deleteDetailByPatientID:[Record findDetailIDByPatientName:patientname Office:office]]) {
        isOK = [Record deleteSomeRecordByIDInTable:patientname andOffice:office];
    }
    NSString *result = isOK ? @"该记录删除完毕" : @"未能删除成功!";
    [Help ShowGCDMessage:result andView:self.view andDelayTime:1.7f];
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        NSMutableArray *temArray = [_searchArray mutableCopy];
        [temArray removeObjectAtIndex:[indexPath row]];
        self.searchArray = [temArray copy];
        [temArray release];
        [self.searchDisplayController.searchResultsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        self.patientAndBQArray = [Record findAllRecordsInRecordTableToArray];
        [self.table reloadData];
    } else {
        NSMutableArray *temyArray = [self.patientAndBQArray mutableCopy];
        [temyArray removeObjectAtIndex:[indexPath row]];
        self.patientAndBQArray = [temyArray copy];
        [temyArray release];
        [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
#pragma mark -
#pragma mark - UISearchBarDelegate
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
    [Record searchAllRecordsByPYM:searchText];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"PatientName contains[cd]%@",searchText];
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"Office contains[cd]%@",searchText];
    NSPredicate *_predicate,*_predicate1;
    _predicate = [predicate predicateWithSubstitutionVariables:[self.patientAndBQArray dictionaryWithValuesForKeys:[NSArray arrayWithObject:@"PatientName"]]];
    _predicate1 = [predicate1 predicateWithSubstitutionVariables:[self.patientAndBQArray dictionaryWithValuesForKeys:[NSArray arrayWithObject:@"Office"]]];
    if ([[Record findPatientIDInDetailTable:[searchText uppercaseString]] count]>0) {
        self.searchArray = [Record findPatientIDInDetailTable:[searchText uppercaseString]];
    } else {
    if([[self.patientAndBQArray filteredArrayUsingPredicate:_predicate] count]>0) {
        self.searchArray = [self.patientAndBQArray filteredArrayUsingPredicate:_predicate];
    } else {
        self.searchArray = [self.patientAndBQArray filteredArrayUsingPredicate:_predicate1];
    }
    }
    //debugLog(@"%@",_searchArray);
}
- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.isOpen = NO;
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {

}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterContentForSearchText:searchText scope:[[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    self.isOpen = YES;
    
}

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    //[self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;

}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
    [_table release];
    [_patientAndBQArray release];
    [_searchArray release];
    [_medArray release];
    [super dealloc];
}
- (void)viewDidUnload {
    self.table = nil;
    self.patientAndBQArray = nil;
    self.searchArray= nil;
    self.medArray = nil;
    [super viewDidUnload];
}
- (IBAction)export:(id)sender {
    if ([self.searchArray count]==0) {
        NSString *msg = @"亲,我只能导出筛选出的结果..";
        [Help ShowGCDMessage:msg andView:self.view andDelayTime:2.2f];
        return;
    }
    
    ExportTable *export = [[ExportTable alloc] init];
   BOOL isOK = [export exportSearchResult:_searchArray];
    [export release];
    NSString *resultStr = isOK ? @"检索结果已存至'搜索结果.csv'文件,请及时导出.":@"抱歉,导入出了点问题,请重试";
    [Help ShowGCDMessage:resultStr andView:self.view andDelayTime:2.2f];
    if (!self.isOpen) {
        self.searchArray = nil;
        [_searchArray release];
    }
}
- (IBAction)deleteRow:(id)sender {
    UIBarButtonItem *deleteBtn = (UIBarButtonItem *)sender;
    [self.searchDisplayController.searchResultsTableView setEditing:!self.searchDisplayController.searchResultsTableView.isEditing animated:YES];
    [self.table setEditing:!self.table.isEditing animated:YES];
    
    if ([_table isEditing]) {
        [deleteBtn setTintColor:OKColor];
        [deleteBtn setTitle:@"完成"];
    } else {
        [deleteBtn setTintColor:ModifyColor];
        [deleteBtn setTitle:@"编辑"];
    }
}
@end
