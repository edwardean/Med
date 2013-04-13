//
//  RecordDetail.m
//  Med
//
//  Created by Edward on 13-3-24.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "RecordDetail.h"
#import "StackScrollViewController.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#define medNameLabelTag 1
#define medContLabelTag 2
@interface RecordDetail ()
@property (nonatomic, strong) NSArray *detailArray;
@property (nonatomic, strong) UINavigationBar *navbar;

@end

@implementation RecordDetail
@synthesize table = _table;
@synthesize detailArray = _detailArray;
@synthesize navbar = _navbar;
@synthesize patient;
- (id) initWithFrame:(CGRect)frame andArray:(NSArray *)array andPatientName:(NSString *)patientname {
    debugLog(@"array:%@",array);
    if (self = [super init]) {
        [self.view setFrame:frame];
        self.detailArray = array;
        self.table = [[UITableView alloc] initWithFrame:CGRectMake(0,40,frame.size.width, frame.size.height) style:UITableViewStylePlain];
        self.patient = patientname;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
	
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_table setDataSource:self];
    [_table setDelegate:self];
    //_table.contentSize = CGSizeMake(370, [_table numberOfRowsInSection:0]*44*1.5);
    UIView* footerView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    _table.tableFooterView = footerView;
    [_table setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    
    [self.view addSubview:_table];
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 468, 40)];
    [bar setBackImage];
    self.navbar = bar;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.text = patient;
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont fontWithName:@"Arial" size:20.0]];
    [titleLabel setCenter:_navbar.center];
    titleLabel.center = _navbar.center;
    [_navbar addSubview:titleLabel];
    [self.view addSubview:_navbar];
    
    UIButton *btn  =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(5, 3, 40, 40);
    [btn setBackgroundImage:[UIImage imageNamed:@"button_icon_close"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dismissSelfView) forControlEvents:UIControlEventTouchUpInside];
    [_navbar addSubview:btn];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)dismissSelfView {
    [self.view removeFromSuperview];
}
#pragma mark -
#pragma mark - UITableViewDelegete

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_detailArray count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellID = @"LiHang";
    UITableViewCell *cell = nil;
    UIFont *font = [UIFont fontWithName:@"Arial" size:15.0f];
    NSDictionary *medDic = [_detailArray objectAtIndex:[indexPath row]];
    cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        
        UILabel *medLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 150, 50)];
        medLabel.tag = medNameLabelTag;
        [cell.contentView addSubview:medLabel];
        
        UILabel *medContLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 6, 150, 50)];
        medContLabel.tag = medContLabelTag;
        [cell.contentView addSubview:medContLabel];
    }
    
    UILabel *_medNameLabel = (UILabel *)[cell.contentView viewWithTag:medNameLabelTag];
    [_medNameLabel setFont:font];
    [_medNameLabel setText:[NSString stringWithFormat:@"%@",[medDic objectForKey:@"Name"]]];
    [_medNameLabel setBackgroundColor:[UIColor clearColor]];
    
    UILabel *_medContLabel = (UILabel *)[cell.contentView viewWithTag:medContLabelTag];
    [_medContLabel setFont:font];
    [_medContLabel setBackgroundColor:[UIColor clearColor]];
    [_medContLabel setText:[NSString stringWithFormat:@"%@",[medDic objectForKey:@"Count"]]];;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void) viewDidUnload {

    self.table = nil;
    self.patient = nil;
    self.navbar = nil;
    [super viewDidUnload];
}

@end
