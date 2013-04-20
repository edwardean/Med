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

@property (atomic, strong) NSArray *patientAndBQArray;
@property (nonatomic, strong) NSArray *searchArray;
@property (nonatomic, strong) NSArray *medArray;
@property (assign) BOOL isOpen;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (assign) NSInteger segmentIndex;
@property (nonatomic,copy) NSString *searchBarPlaceholder;
@property (nonatomic,copy) NSString *searchName;
@end

@implementation ScanAllRecords
@synthesize table = _table;
@synthesize navBar = _navBar;
@synthesize patientAndBQArray = _patientAndBQArray;
@synthesize searchArray = _searchArray;
@synthesize medArray = _medArray;
@synthesize isOpen;
@synthesize segmentIndex;
@synthesize searchController = _searchController;

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
    self.isOpen = NO;
    self.search = [[UISearchBar alloc] initWithFrame:CGRectZero];
    self.search.placeholder = @"搜索";
    self.search.delegate = self;
    [self.search sizeToFit];
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.search contentsController:self];
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.delegate = self;
    [self.searchController.searchBar setScopeButtonTitles:@[@"按药品拼音码检索",@"按病区或病人检索"]];
    self.search.showsScopeBar = YES;
    self.table.tableHeaderView = self.searchDisplayController.searchBar;
    self.table.contentOffset = CGPointMake(0, CGRectGetHeight(self.search.bounds));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        self.patientAndBQArray = [Record findAllRecordsInRecordTableToArray];
//        dispatch_async(dispatch_get_main_queue(), ^{
//          [_table reloadData];  
//        });  
//    });
    
    
    NSArray *array = [Record findAllRecordsInRecordTableToArray];
    self.patientAndBQArray = array;
    debugLog(@"PatientAndBQArray is:%@",_patientAndBQArray);
    [_table reloadData];
    self.segmentIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
    switch (segmentIndex) {
        case 0:
            self.searchBarPlaceholder = @"键入药品拼音码";
            break;
        case 1:
            self.searchBarPlaceholder = @"键入病区或病人名";
            break;
        default:
            break;
    }
    self.searchDisplayController.searchBar.placeholder = _searchBarPlaceholder;
    [self.searchDisplayController.searchResultsTableView setRowHeight:60];
    UISegmentedControl *scopeBar = nil;
    for (id subView in self.searchDisplayController.searchBar.subviews){
        if ([subView isMemberOfClass:[UISegmentedControl class]]) {
            scopeBar = (UISegmentedControl *)subView;
            scopeBar.userInteractionEnabled = YES;
            scopeBar.tintColor = AbleBackgroundColor;
        }
    }
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
        if (_patientAndBQArray) {
            rows = [_patientAndBQArray count];
        } else {
            rows = 0;
        }
        
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"LiHang";
    UITableViewCell *cell = nil;
    
   
    cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellID];
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            if (segmentIndex==0) {
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 20, 150, 20)];
                nameLabel.tag = 1;
                [cell.contentView addSubview:nameLabel];
                
                UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(300, 20, 150, 20)];
                countLabel.tag = 2;
                [cell.contentView addSubview:countLabel];
            } else {
            
                UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(300, 38, 60, 20)];
                [dateLabel setAdjustsFontSizeToFitWidth:YES];
                [dateLabel setTextColor:[UIColor cyanColor]];
                [dateLabel setTag:4];
                [cell.contentView addSubview:dateLabel];
            }
        } else {
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(300, 38, 60, 20)];
        [dateLabel setAdjustsFontSizeToFitWidth:YES];
        [dateLabel setTextColor:[UIColor cyanColor]];
        [dateLabel setTag:3];
        [cell.contentView addSubview:dateLabel];
    }
    }
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        NSDictionary *searchDic = [_searchArray objectAtIndex:[indexPath row]];
        if (segmentIndex == 0) {
            cell.textLabel.text = [searchDic objectForKey:@"PatientName"];
            cell.textLabel.font = MyFont(19.0);
            cell.detailTextLabel.text = [searchDic objectForKey:@"Office"];
            cell.detailTextLabel.font = MyFont(14.0);
            
            UILabel *_nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
            [_nameLabel setBackgroundColor:[UIColor clearColor]];
            [_nameLabel setText:[searchDic objectForKey:@"Name"]];
            
            UILabel *_countLabel = (UILabel *)[cell.contentView viewWithTag:2];
            [_countLabel setBackgroundColor:[UIColor clearColor]];
            [_countLabel setText:[searchDic objectForKey:@"Count"]];
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.textLabel.text = [searchDic objectForKey:@"PatientName"];
            cell.textLabel.font = MyFont(19.0);
            cell.detailTextLabel.text = [searchDic objectForKey:@"Office"];
            cell.detailTextLabel.font = MyFont(14.0);
            UILabel *_dateLabel = (UILabel *)[cell.contentView viewWithTag:4];
            [_dateLabel setText:[searchDic objectForKey:@"Date"]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    } else {
        if (_patientAndBQArray) {
         NSDictionary *mainDic = [_patientAndBQArray objectAtIndex:[indexPath row]];
            UILabel *_dateLabel = (UILabel *)[cell.contentView viewWithTag:3];
            [_dateLabel setText:[mainDic objectForKey:@"Date"]];
        cell.textLabel.text = [mainDic objectForKey:@"PatientName"];
        cell.textLabel.font = MyFont(19.0);
        cell.detailTextLabel.text = [mainDic objectForKey:@"Office"];
        cell.detailTextLabel.font = MyFont(14.0);
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark -
#pragma mark UITableViewdelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect rect = CGRectMake(0, 0, 467, self.view.frame.size.height);
    NSString *patientName = nil;
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        debugLog(@"SearchResultTableView");
        if (segmentIndex==1) {
        NSDictionary *detailDic = [_searchArray objectAtIndex:[indexPath row]];
        NSArray *detailArray = [detailDic objectForKey:@"Detail"];
        patientName = [detailDic objectForKey:@"PatientName"];
        RecordDetail *detail = [[RecordDetail alloc] initWithFrame:rect andArray:detailArray andPatientName:patientName];
        [[StackScrollViewAppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:detail invokeByController:self isStackStartView:FALSE];
        }else {
            return;
        }
        
    } else {
        
        NSDictionary *detailDic = [_patientAndBQArray objectAtIndex:[indexPath row]];
        NSArray *detailArray = [detailDic objectForKey:@"Detail"];
        debugLog(@"NormalTableView  array is :%@",detailArray);
        patientName = [detailDic objectForKey:@"PatientName"];
        RecordDetail *detail = [[RecordDetail alloc] initWithFrame:rect andArray:detailArray andPatientName:patientName];
        [[StackScrollViewAppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:detail invokeByController:self isStackStartView:FALSE];
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
    UITableViewCell *cell = nil;
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        cell = [self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:indexPath];
        return;
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
        [self.searchDisplayController.searchResultsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        self.patientAndBQArray = [Record findAllRecordsInRecordTableToArray];
        [self.table reloadData];
    } else {
        NSMutableArray *temyArray = [self.patientAndBQArray mutableCopy];
        [temyArray removeObjectAtIndex:[indexPath row]];
        self.patientAndBQArray = [temyArray copy];
        [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
#pragma mark -
#pragma mark - UISearchBarDelegate
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    segmentIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
    if (segmentIndex == 0) {
        self.searchArray = [Record searchAllRecordsByPYM:searchText];
    } else {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"PatientName contains[cd]%@",searchText];
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"Office contains[cd]%@",searchText];
    NSPredicate *_predicate,*_predicate1;
    _predicate = [predicate predicateWithSubstitutionVariables:[self.patientAndBQArray dictionaryWithValuesForKeys:@[@"PatientName"]/*[NSArray arrayWithObject:@"PatientName"]*/]];
    _predicate1 = [predicate1 predicateWithSubstitutionVariables:[self.patientAndBQArray dictionaryWithValuesForKeys:@[@"Office"]/*[NSArray arrayWithObject:@"Office"]*/]];
    if ([[Record findPatientIDInDetailTable:[searchText uppercaseString]] count]>0) {
        self.searchArray = [Record findPatientIDInDetailTable:[searchText uppercaseString]];
    } else {
    if([[self.patientAndBQArray filteredArrayUsingPredicate:_predicate] count]>0) {
    self.searchArray = [self.patientAndBQArray filteredArrayUsingPredicate:_predicate];
    } else {
        self.searchArray = [self.patientAndBQArray filteredArrayUsingPredicate:_predicate1];
     }
    }
}
    debugLog(@"SearchArray:%@",_searchArray);
}
- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    if (OS_VERSION < 6.0) {
      searchBar.showsScopeBar = NO;  
    } else {
        self.isOpen = NO;
        UISegmentedControl *scopeBar = nil;
        for (id subView in self.searchDisplayController.searchBar.subviews){
            if ([subView isMemberOfClass:[UISegmentedControl class]]) {
                scopeBar = (UISegmentedControl *)subView;
                scopeBar.userInteractionEnabled = YES;
                scopeBar.hidden = NO;
                scopeBar.tintColor = AbleBackgroundColor;
            }
        }

    }
}
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    
    self.segmentIndex = selectedScope;
    debugLog(@"selectedIndex:%d",segmentIndex);
    switch (segmentIndex) {
        case 0:
            self.searchBarPlaceholder = @"键入药品拼音码";
            break;
        case 1:
            self.searchBarPlaceholder = @"键入病区或病人名";
            break;
        default:
            break;
    }
     self.searchDisplayController.searchBar.placeholder = _searchBarPlaceholder;
}
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    UISegmentedControl *scopeBar = nil;
    for (id subView in self.searchDisplayController.searchBar.subviews){
        if ([subView isMemberOfClass:[UISegmentedControl class]]) {
            scopeBar = (UISegmentedControl *)subView;
            }
    }
    if ([searchText length]>0) {
        if (OS_VERSION < 6.0) {
          searchBar.showsScopeBar = NO;  
        }
        else {
        scopeBar.userInteractionEnabled = NO;
        scopeBar.tintColor = EnableColor;
        }
        
    } else{
        if (OS_VERSION < 6.0) {
            searchBar.showsScopeBar = YES;
        } else {
       scopeBar.userInteractionEnabled = YES;
       scopeBar.tintColor = AbleBackgroundColor;
        }
        
    }
    self.isOpen = YES;
    
    self.searchName = searchText;
}

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {

    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;

}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    if (OS_VERSION < 6.0) {
       searchBar.showsScopeBar = YES; 
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.table = nil;
    self.search = nil;
    self.navBar = nil;
    self.searchController = nil;
    self.searchBarPlaceholder = nil;
    self.searchName = nil;
    
}
- (IBAction)exportPressed:(id)sender {
    if (!isOpen) {
        [Help ShowGCDMessage:@"亲,请检索后再导出.." andView:self.view andDelayTime:2.2f];
        return;
    }
    
    if ([self.searchArray count]==0) {
        [Help ShowGCDMessage:@"没有检索结果,就不给你导出" andView:self.view andDelayTime:2.0f];
        return;
    }
        
    BOOL isOK = NO;
    if ([_searchArray count]>0) {
    ExportTable *export = [[ExportTable alloc] init];
    if (segmentIndex == 1) {
    isOK = [export exportSearchResult:_searchArray andFileName:_searchName andseg:1 inMainDir:2];
    } else if(segmentIndex==0) {
        isOK = [export exportSearchResult:_searchArray andFileName:_searchName andseg:0 inMainDir:2];
    }
    NSString *_fileName = [_searchName stringByAppendingString:@".csv"];
    NSString *fileName = [NSString stringWithFormat:@"检索结果已存至'%@'文件中^_^",_fileName];
    NSString *resultStr = isOK ? fileName:@"抱歉,导入出了点问题,请重试";
    [Help ShowGCDMessage:resultStr andView:self.view andDelayTime:2.2f];
    if (!self.isOpen) {
        self.searchArray = nil;
    }
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
