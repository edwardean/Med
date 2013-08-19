//
//  ScanAllMedInfo.m
//  Med
//
//  Created by Edward on 13-3-21.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "ScanAllMedInfo.h"
#import "Medicine.h"
#import "CHCSVWriter.h"
#define markMedNameLabelTag 1
#define markPymLabelTag 3
#define markSpeciLabelTag 4
@interface ScanAllMedInfo ()
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *searchResultArray;
@end

@implementation ScanAllMedInfo
@synthesize navBar;
@synthesize table = _table;
@synthesize dataArray = _dataArray;
@synthesize search = _search;
@synthesize searchResultArray = _searchResultArray;
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
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    self.dataArray = [Medicine findAllMedicineToArray];
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.table setContentSize:CGSizeMake(self.view.frame.size.width, [_dataArray count]*60*2)];
      [_table reloadData];
    });
  });
  
  [self.table setContentSize:CGSizeMake(self.view.frame.size.width, [_dataArray count]*60*2)];
  [_table reloadData];
  [super viewDidAppear:animated];
}
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view custom:navBar];
  self.searchResultArray = nil;
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
  UIFont *font = [UIFont fontWithName:@"Arial" size:13.0f];
  UIFont *nameLabelFont = [UIFont fontWithName:@"Arial" size:17.0f];
  static NSString *CellID =@"LIHANG";
  UITableViewCell *cell = nil;
  
  cell = [tableView dequeueReusableCellWithIdentifier:CellID];
  
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    //药名
    UILabel *medNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 16, 150, 40)];
    medNameLabel.tag = markMedNameLabelTag;
    [cell.contentView addSubview:medNameLabel];
    
    
    //拼音码
    UILabel *pymlabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 17, 150, 20)];
    pymlabel.tag = markPymLabelTag;
    [cell.contentView addSubview:pymlabel];
    
    //含量
    UILabel *specilabel = [[UILabel alloc] initWithFrame:CGRectMake(300, 17, 150, 20)];
    specilabel.tag = markSpeciLabelTag;
    [cell.contentView addSubview:specilabel];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
  if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
    NSDictionary *searchDic = [_searchResultArray objectAtIndex:[indexPath row]];
    UILabel *_medNameLabel = (UILabel *)[cell.contentView viewWithTag:markMedNameLabelTag];
    UILabel *_pymLabel = (UILabel *)[cell.contentView viewWithTag:markPymLabelTag];
    UILabel *_speciLabel = (UILabel *)[cell.contentView viewWithTag:markSpeciLabelTag];
    [_medNameLabel setFont:nameLabelFont];
    [_pymLabel setFont:font];
    [_speciLabel setFont:font];
    [_medNameLabel setBackgroundColor:[UIColor clearColor]];
    [_pymLabel setBackgroundColor:[UIColor clearColor]];
    [_speciLabel setBackgroundColor:[UIColor clearColor]];
    [_medNameLabel setText:[NSString stringWithFormat:@"%@",[searchDic objectForKey:@"Name"]]];
    [_pymLabel setText:[NSString stringWithFormat:@"拼音码:%@",[searchDic objectForKey:@"PYM"]]];
    [_speciLabel setText:[NSString stringWithFormat:@"含量:%@%@",[searchDic objectForKey:@"Specifi"],[medDic objectForKey:@"Unit"]]];
  } else {
    UILabel *_medNameLabel = (UILabel *)[cell.contentView viewWithTag:markMedNameLabelTag];
    UILabel *_pymLabel = (UILabel *)[cell.contentView viewWithTag:markPymLabelTag];
    UILabel *_speciLabel = (UILabel *)[cell.contentView viewWithTag:markSpeciLabelTag];
    [_medNameLabel setFont:nameLabelFont];
    [_pymLabel setFont:font];
    [_speciLabel setFont:font];
    [_medNameLabel setBackgroundColor:[UIColor clearColor]];
    [_pymLabel setBackgroundColor:[UIColor clearColor]];
    [_speciLabel setBackgroundColor:[UIColor clearColor]];
    [_medNameLabel setText:[NSString stringWithFormat:@"%@",[medDic objectForKey:@"Name"]]];
    [_pymLabel setText:[NSString stringWithFormat:@"拼音码:%@",[medDic objectForKey:@"PYM"]]];
    [_speciLabel setText:[NSString stringWithFormat:@"含量:%@%@",[medDic objectForKey:@"Specifi"],[medDic objectForKey:@"Unit"]]];
  }
  return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
  if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
    //debugLog(@"search:%@",[_MedPYMArray objectAtIndex:indexPath.row]);
  } else {
    //debugLog(@"Not Search:%@",[_dataArray objectAtIndex:[indexPath row]]);
  }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
  return @"删除";
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}
//禁用手势删除，只支持编辑状态下删除
- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (!tableView.editing)
    return UITableViewCellEditingStyleNone;
  else {
    return UITableViewCellEditingStyleDelete;
  }
  
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *_pymLabel = (UILabel *)[cell.contentView viewWithTag:markPymLabelTag];
    NSString *pym = [[_pymLabel text] substringFromIndex:4];
    debugLog(@"pym:%@",pym);
    if ([Medicine deleteSomeMedicine:pym]) {
      NSString *msg = [NSString stringWithFormat:@"%@已删除",pym];
      [Help ShowGCDMessage:msg andView:self.view andDelayTime:1.0f];
      [self viewDidAppear:YES];
    }
    NSMutableArray *tempArray = [self.searchResultArray mutableCopy];
    [tempArray removeObjectAtIndex:[indexPath row]];
    self.searchResultArray = tempArray;
    [self.searchDisplayController.searchResultsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    self.dataArray = [Medicine findAllMedicineToArray];
    [self.table reloadData];
  } else {
    NSDictionary *dic = [self.dataArray objectAtIndex:[indexPath row]];
    NSString *pym = [dic objectForKey:@"PYM"];
    if ([Medicine deleteSomeMedicine:pym]) {
      NSString *msg = [NSString stringWithFormat:@"%@已删除",pym];
      [Help ShowGCDMessage:msg andView:self.view andDelayTime:1.0f];
    }
    NSMutableArray *tempArray = [self.dataArray mutableCopy];
    [tempArray removeObjectAtIndex:[indexPath row]];
    self.dataArray = tempArray;
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
  _predicate = [predicate predicateWithSubstitutionVariables:[self.dataArray dictionaryWithValuesForKeys:@[@"Name"]/*[NSArray arrayWithObject:@"Name"]*/]];
  _predicate1 = [predicate1 predicateWithSubstitutionVariables:[self.dataArray dictionaryWithValuesForKeys:@[@"PYM"]/*[NSArray arrayWithObject:@"PYM"]*/]];
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

- (void)viewDidUnload {
  [super viewDidUnload];
  [self setNavBar:nil];
  self.table = nil;
  self.search = nil;
  
  debugMethod();
}
- (IBAction)deleteRow:(id)sender {
  UIBarButtonItem *_deleteBtn = (UIBarButtonItem *)sender;
  [self.searchDisplayController.searchResultsTableView setEditing:!self.searchDisplayController.searchResultsTableView.isEditing animated:YES];
  
  [self.table setEditing:!self.table.isEditing animated:YES];
  if (_table.isEditing) {
    [_deleteBtn setTintColor:OKColor];
    [_deleteBtn setTitle:@"完成"];
  } else {
    [_deleteBtn setTintColor:ModifyColor];
    [_deleteBtn setTitle:@"编辑"];
  }
}
- (IBAction)exportMedTable:(id)sender {
  CHCSVWriter *csvWriter = [[CHCSVWriter alloc] initWithCSVFile:[[(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)) lastObject]stringByAppendingPathComponent:@"药品.csv"] atomic:YES];
  [_dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSDictionary *medDic = [_dataArray objectAtIndex:idx];
    NSLog(@"Med:%@",medDic);
    [csvWriter writeField:[medDic objectForKey:@"Name"]];
    NSString *spe = [NSString stringWithFormat:@"%@%@",[medDic objectForKey:@"Specifi"],[medDic objectForKey:@"Unit"]];
    [csvWriter writeField:spe];
    [csvWriter writeField:[medDic objectForKey:@"PYM"]];
    [csvWriter writeField:[medDic objectForKey:@"Content"]];
    [csvWriter writeField:nil];
    if ((idx+1) % 3==0) {
      [csvWriter writeLine];
    }
    
  }];
  [csvWriter closeFile];
  NSString *msg  = @"亲,全部药品已导入到'药品.csv'文件中了^_^";
  [Help ShowGCDMessage:msg andView:self.view andDelayTime:2.2f];
}
@end
