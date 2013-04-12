//
//  SelectBQ.m
//  masterDemo
//
//  Created by Edward on 13-3-14.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "SelectBQ.h"
#import "BingQu.h"
@interface SelectBQ ()

@property (nonatomic, retain) NSArray *array;
@property (nonatomic, retain) NSArray *searchArray;
@property (nonatomic, retain) NSIndexPath *lastPath;
@end

@implementation SelectBQ

@synthesize table,BQStr;
@synthesize array;
@synthesize search = _search;
@synthesize searchArray = _searchArray;
@synthesize delegate;
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
    self.array = [NSArray array];
    self.lastPath = nil;
    self.BQStr = @"NULL";
    self.contentSizeForViewInPopover = CGSizeMake(375, 530);
    self.table.contentSize = CGSizeMake(375, [self.table numberOfRowsInSection:0]*44*1.5);
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.array = [BingQu findAllBingQuIntoArray];
        if ([array count] == [BingQu countAllBingQu]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.table reloadData];
            });
        }
        
    });
    
}

#pragma mark UITableViewDelegete 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        rows = [self.searchArray count];
    } else {
        rows = [self.array count];
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

   static NSString *CellID = @"Cell";
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID]autorelease];
    }
    
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        cell.textLabel.text = [_searchArray objectAtIndex:[indexPath row]];
        
        } else {
            cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
    }
    
    if ([self.lastPath isEqual:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if ([cell.textLabel.text isEqualToString:[US objectForKey:@"BQ"]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        
        BOOL isMarked = [[self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:self.lastPath] accessoryType] == UITableViewCellAccessoryCheckmark ? YES : NO;
        if (![indexPath isEqual:self.lastPath]) {
            
            UITableViewCell *newCell = [self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:indexPath];
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            NSString *str = [_searchArray objectAtIndex:indexPath.row];
            [US setObject:str forKey:@"BQ"];
            
            UITableViewCell *oldCell = [self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:self.lastPath];
            oldCell.accessoryType = UITableViewCellAccessoryNone;
            self.lastPath = indexPath;
            self.BQStr = [_searchArray objectAtIndex:indexPath.row];
            
        } else {
            UITableViewCell *newCell = [self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:indexPath];
            if (isMarked) {
                self.BQStr = @"NULL";
                [US removeObjectForKey:@"BQ"];
                newCell.accessoryType = UITableViewCellAccessoryNone;
            } else {
                newCell.accessoryType = UITableViewCellAccessoryCheckmark;
                self.BQStr = [_searchArray objectAtIndex:indexPath.row];
                NSString *str = [_searchArray objectAtIndex:indexPath.row];
                [US setObject:str forKey:@"BQ"];
            }
            
        }
    } else {
    
    BOOL isMarked = [[table cellForRowAtIndexPath:self.lastPath] accessoryType] == UITableViewCellAccessoryCheckmark ? YES : NO;
    if (![indexPath isEqual:self.lastPath]) {

        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        NSString *str = [self.array objectAtIndex:indexPath.row];
        [US setObject:str forKey:@"BQ"];
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.lastPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        self.lastPath = indexPath;
        self.BQStr = [array objectAtIndex:indexPath.row];
        
    } else {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        if (isMarked) {
        self.BQStr = @"NULL";
            [US removeObjectForKey:@"BQ"];
        newCell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.BQStr = [array objectAtIndex:indexPath.row];
            NSString *str = [self.array objectAtIndex:indexPath.row];
            [US setObject:str forKey:@"BQ"];
        }
        
    }
    }
    [tableView reloadData];
    debugLog(@"点击:%@   USerDefault:%@",self.BQStr,[US objectForKey:@"BQ"]);
    [delegate passSelectedBQ:[US objectForKey:@"BQ"]];
    [US synchronize];

}

#pragma mark -
#pragma mark - UISearchBarDelegate
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    self.searchArray = [self.array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF contains[cd]%@",searchText]];
    debugLog(@"%@",_searchArray);
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
   // [self filterContentForSearchText:searchText scope:[[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [table reloadData];
}
/**
 Asks the delegate if the table view should be reloaded for a given search string.
 **/
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}
#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload {
    [super viewDidUnload];
    [self setSearch:nil];
    self.table = nil;
    self.BQStr = nil;
    self.searchArray = nil;
    self.lastPath = nil;
}

- (void) dealloc {
    [table release];
    [BQStr release];
    [array release];
    [_searchArray release];
    [_lastPath release];
    [super dealloc];
}
@end
