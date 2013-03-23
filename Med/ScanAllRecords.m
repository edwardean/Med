//
//  ScanAllRecords.m
//  Med
//
//  Created by Edward on 13-3-23.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "ScanAllRecords.h"
#import "Record.h"
@interface ScanAllRecords ()

@property (nonatomic, retain) NSArray *patientAndBQArray;
@property (nonatomic, retain) NSArray *searchArray;
@end

@implementation ScanAllRecords
@synthesize table = _table;
@synthesize search =_search;
@synthesize navBar = _navBar;
@synthesize patientAndBQArray = _patientAndBQArray;
@synthesize searchArray = _searchArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_navBar setBackImage];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.patientAndBQArray = [Record findAllRecordsInRecordTableToArray];
        NSLog(@"共有%d条记录",[self.patientAndBQArray count]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_table reloadData];
            });
    });
}

#pragma mark -
#pragma mark - UITableViewDelegete

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return [_searchArray count];
    } else {
        return [_patientAndBQArray count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"LiHang";
    UITableViewCell *cell = nil;
    
    NSDictionary *mainDic = [_patientAndBQArray objectAtIndex:[indexPath row]];
    NSDictionary *searchDic = [_searchArray objectAtIndex:[indexPath row]];
    cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellID] autorelease];
    }
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        cell.textLabel.text = [searchDic objectForKey:@"PatientName"];
        cell.detailTextLabel.text = [searchDic objectForKey:@"Office"];
    } else {
    cell.textLabel.text = [mainDic objectForKey:@"PatientName"];
    cell.detailTextLabel.text = [mainDic objectForKey:@"Office"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -
#pragma mark - UISearchBarDelegate
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"PatientName contains[cd]%@",searchText];
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"Office contains[cd]%@",searchText];
    NSPredicate *_predicate,*_predicate1;
    _predicate = [predicate predicateWithSubstitutionVariables:[self.patientAndBQArray dictionaryWithValuesForKeys:[NSArray arrayWithObject:@"PatientName"]]];
    _predicate1 = [predicate1 predicateWithSubstitutionVariables:[self.patientAndBQArray dictionaryWithValuesForKeys:[NSArray arrayWithObject:@"Office"]]];
    if([[self.patientAndBQArray filteredArrayUsingPredicate:_predicate] count]>0) {
        self.searchArray = [self.patientAndBQArray filteredArrayUsingPredicate:_predicate];
    } else {
        self.searchArray = [self.patientAndBQArray filteredArrayUsingPredicate:_predicate1];
    }
    debugLog(@"%@",_searchArray);
}
- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {

}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

}

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
    [super dealloc];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
