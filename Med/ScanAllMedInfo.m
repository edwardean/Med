//
//  ScanAllMedInfo.m
//  Med
//
//  Created by Edward on 13-3-21.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "ScanAllMedInfo.h"
#import "UINavigationBar+CustomImage.h"
#import "Medicine.h"
#import "GCDiscreetNotificationView.h"
#define markMedNameLabelTag 1
#define markPymLabelTag 3
@interface ScanAllMedInfo ()
@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, retain) NSArray *MedNameArray;
@property (nonatomic, retain) NSArray *MedPYMArray;
@property (nonatomic, retain) NSArray *searchResultArray;
@property (assign) BOOL isChinese;
@end

@implementation ScanAllMedInfo
@synthesize navBar;
@synthesize table = _table;
@synthesize dataArray = _dataArray;
@synthesize search = _search;
@synthesize searchResultArray = _searchResultArray;
@synthesize deleteBtn = _deleteBtn;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    debugMethod();
    [super viewDidAppear:animated];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.dataArray = [Medicine findAllMedicineToArray];
        if ([_dataArray count]==[Medicine countAllMedicine]) {
            NSMutableArray *_medArray,*_pymArray;
            _medArray = [NSMutableArray arrayWithCapacity:0];
            _pymArray = [NSMutableArray arrayWithCapacity:0];
            for (int i=0; i<[_dataArray count]; i++) {
                NSDictionary *_dic = [_dataArray objectAtIndex:i];
                [_medArray addObject:[_dic objectForKey:@"Name"]];
                [_pymArray addObject:[_dic objectForKey:@"PYM"]];
            }
            _MedNameArray = [_medArray copy];
            _MedPYMArray = [_pymArray copy];
            //debugLog(@"药品获取完毕");
            debugLog(@"Name:%@  PYM:%@",_MedNameArray,_MedPYMArray);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_table reloadData];
            });
        }
    });

}
- (void)viewDidLoad
{
    [super viewDidLoad];


    [navBar setBackImage];
    self.searchResultArray = nil;
    self.isChinese = NO;
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

    NSInteger rows = 0;
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        rows = [self.searchResultArray count];
    } else {
        rows = [self.dataArray count];
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *medDic = [_dataArray objectAtIndex:[indexPath row]];
    NSDictionary *searchDic = [_searchResultArray objectAtIndex:[indexPath row]];
    UIFont *font = [UIFont fontWithName:@"Arial" size:13.0f];
    UIFont *nameLabelFont = [UIFont fontWithName:@"Arial" size:17.0f];
    static NSString *CellID =@"LIHANG";
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID] autorelease];        
        //药名
        UILabel *medNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 150, 40)];
        medNameLabel.tag = markMedNameLabelTag;
        [cell.contentView addSubview:medNameLabel];
        [medNameLabel release];
        
        
        //拼音码
        UILabel *pymlabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 17, 150, 20)];
        pymlabel.tag = markPymLabelTag;
        [cell.contentView addSubview:pymlabel];
        [pymlabel release];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {

                    UILabel *_medNameLabel = (UILabel *)[cell.contentView viewWithTag:markMedNameLabelTag];
                    UILabel *_pymLabel = (UILabel *)[cell.contentView viewWithTag:markPymLabelTag];
                    [_medNameLabel setFont:nameLabelFont];
                    [_pymLabel setFont:font];
                    [_medNameLabel setBackgroundColor:[UIColor clearColor]];
                    [_pymLabel setBackgroundColor:[UIColor clearColor]];
                    [_medNameLabel setText:[NSString stringWithFormat:@"%@",[searchDic objectForKey:@"Name"]]];
                    [_pymLabel setText:[NSString stringWithFormat:@"拼音码:%@",[searchDic objectForKey:@"PYM"]]];
    } else {
        UILabel *_medNameLabel = (UILabel *)[cell.contentView viewWithTag:markMedNameLabelTag];
        UILabel *_pymLabel = (UILabel *)[cell.contentView viewWithTag:markPymLabelTag];
        [_medNameLabel setFont:nameLabelFont];
        [_pymLabel setFont:font];
        [_medNameLabel setBackgroundColor:[UIColor clearColor]];
        [_pymLabel setBackgroundColor:[UIColor clearColor]];
        [_medNameLabel setText:[NSString stringWithFormat:@"%@",[medDic objectForKey:@"Name"]]];
        [_pymLabel setText:[NSString stringWithFormat:@"拼音码:%@",[medDic objectForKey:@"PYM"]]];
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        debugLog(@"search:%@",[_MedPYMArray objectAtIndex:indexPath.row]);
    } else {
        debugLog(@"Not Search:%@",[_dataArray objectAtIndex:[indexPath row]]);
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    GCDiscreetNotificationView *gcd = [[GCDiscreetNotificationView alloc] initWithText:@"" showActivity:NO inPresentationMode:GCDiscreetNotificationViewPresentationModeTop inView:self.view];
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UILabel *_pymLabel = (UILabel *)[cell.contentView viewWithTag:markPymLabelTag];
        NSString *pym = [[_pymLabel text] substringFromIndex:4];
        debugLog(@"pym:%@",pym);
        if ([Medicine deleteSomeMedicine:pym]) {
            [gcd setTextLabel:[NSString stringWithFormat:@"%@已删除",pym]];
            [gcd show:YES];
            [gcd hideAnimatedAfter:1.0f];
            [gcd release];
            [self viewDidAppear:YES];
        }
        NSMutableArray *tempArray = [self.searchResultArray mutableCopy];
        [tempArray removeObjectAtIndex:[indexPath row]];
        self.searchResultArray = [tempArray copy];
        [tempArray release];
        [self.searchDisplayController.searchResultsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        NSDictionary *dic = [self.dataArray objectAtIndex:[indexPath row]];
        NSString *pym = [dic objectForKey:@"PYM"];
        if ([Medicine deleteSomeMedicine:pym]) {
            [gcd setTextLabel:[NSString stringWithFormat:@"%@已删除",pym]];
            [gcd show:YES];
            [gcd hideAnimatedAfter:1.0f];
            [gcd release];
        }
        NSMutableArray *tempArray = [self.dataArray mutableCopy];
        [tempArray removeObjectAtIndex:[indexPath row]];
        self.dataArray = [tempArray copy];
        [tempArray release];
        [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
#pragma mark -

#pragma mark - UISearchBarDelegate

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    debugMethod();
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name contains[cd]%@",searchText];
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"PYM contains[cd]%@",searchText];
    NSPredicate *_predicate;
    NSPredicate *_predicate1;
    _predicate = [predicate predicateWithSubstitutionVariables:[self.dataArray dictionaryWithValuesForKeys:[NSArray arrayWithObject:@"Name"]]];
    _predicate1 = [predicate1 predicateWithSubstitutionVariables:[self.dataArray dictionaryWithValuesForKeys:[NSArray arrayWithObject:@"PYM"]]];
    if ([[self.dataArray filteredArrayUsingPredicate:_predicate] count]>0) {
        self.searchResultArray = [self.dataArray filteredArrayUsingPredicate:_predicate];
    } else {
        self.searchResultArray = [self.dataArray filteredArrayUsingPredicate:_predicate1];
    }
}
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    debugMethod();
    [self filterContentForSearchText:searchText scope:[[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {

}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {

}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [navBar release];
    [UISearchBar release];
    [_deleteBtn release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setNavBar:nil];
    [self setDeleteBtn:nil];
    [super viewDidUnload];
}
- (IBAction)deleteRow:(id)sender {
   
    [self.searchDisplayController.searchResultsTableView setEditing:!self.searchDisplayController.searchResultsTableView.isEditing animated:YES];

    [self.table setEditing:!self.table.isEditing animated:YES];
    if (_table.isEditing) {
        [_deleteBtn setTintColor:[UIColor redColor]];
        [_deleteBtn setTitle:@"完成"];
    } else {
        [_deleteBtn setTintColor:[UIColor darkGrayColor]];
        [_deleteBtn setTitle:@"删除"];
    }
}
@end
