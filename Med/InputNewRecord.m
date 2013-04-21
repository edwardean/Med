//
//  InputNewRecord.m
//  masterDemo
//
//  Created by Edward on 13-3-6.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "InputNewRecord.h"
#import "dataBaseManager.h"
#import "Medicine.h"
#import "BingQu.h"
#import "Record.h"
#import "MedInfoCell.h"
#import <QuartzCore/QuartzCore.h>
#define markMedNameLabelTag 1
#define markCountLabelTag 2
#define markPymLabelTag 3
#define markUnitLabelTag 4
#define markCountField 5
#define markDanweiLabel 6
#define markOKBtnTag 7
#define markCancelBtnTag 8
#define MedNameLabelTag 11
#define CountLabelTag 12
#define PymLabelTag 13
#define UnitLabelTag 14



#define semarkMedNameLabelTag 15
#define semarkCountLabelTag 16
#define semarkPymLabelTag 17
#define semarkUnitLabelTag 18
#define semarkCountField 19
#define semarkDanweiLabel 20
#define semarkOKBtnTag 21
#define semarkCancelBtnTag 26
#define seMedNameLabelTag 22
#define seCountLabelTag 23
#define sePymLabelTag 24
#define seUnitLabelTag 25
@interface InputNewRecord ()

@property (nonatomic, strong) NSArray *medArray;//主数据源，所有药品信息
@property (nonatomic, strong) NSArray *searchArray;//搜索结果，searchDisplayResultTableView的数据源
@property(strong, nonatomic) NSIndexPath *selectIndex;///////
@property (strong,nonatomic) NSIndexPath *searchSelectIndex;////////
@property (nonatomic, strong) NSMutableArray *indexArray;//保存已经选择过的indexPath
@property (nonatomic, strong) NSMutableArray *searchIndexArray;/////////

@property (nonatomic, strong) NSArray *sections;//索引节
@end

@implementation InputNewRecord
@synthesize table;
@synthesize medArray;
@synthesize field;
@synthesize contentArray;
@synthesize search = _search;
@synthesize searchArray = _searchArray;
@synthesize searchIndexArray = _searchIndexArray;
@synthesize indexArray = _indexArray;
@synthesize selectIndex = _selectIndex;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad
{
    debugMethod();
    [super viewDidLoad];
    self.medArray = [NSArray array];
    self.indexArray = [NSMutableArray arrayWithCapacity:0];
    self.searchIndexArray = [NSMutableArray arrayWithCapacity:0];//////////
    self.selectIndex = nil;///判断是否
    self.searchSelectIndex = nil;////////////
    self.contentArray = [NSMutableArray arrayWithCapacity:0];
    self.contentSizeForViewInPopover = CGSizeMake(375, 650);
   
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, 380, 630) style:UITableViewStylePlain];
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 45)];
	footer.backgroundColor = [UIColor clearColor];
    self.table.tableFooterView = footer;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.medArray = [Medicine findAllMedicineToArray];///获取数据源
        if ([self.medArray count]==[Medicine countAllMedicine]) {
            //NSLog(@"所有药品:%@",self.medArray);
            dispatch_async(dispatch_get_main_queue(), ^{
                UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
                NSMutableArray *unsortedSections = [[NSMutableArray alloc] initWithCapacity:[[collation sectionTitles] count]];
                for (NSUInteger i=0; i < [[collation sectionTitles] count]; i++) {
                    [unsortedSections addObject:[NSMutableArray array]];
                }
                
                for (NSDictionary *dic in self.medArray) {
                    NSString *medPYM = [dic objectForKey:@"PYM"];
                    NSInteger index = [collation sectionForObject:medPYM collationStringSelector:@selector(description)];
                    [[unsortedSections objectAtIndex:index] addObject:dic];
                }
                
                NSMutableArray *sortedSections = [[NSMutableArray alloc] initWithCapacity:unsortedSections.count];
                
                for (NSMutableArray *section in unsortedSections) {
                    [sortedSections addObject:[collation sortedArrayFromArray:section collationStringSelector:@selector(description)]];
                }
                self.sections = sortedSections;
                NSLog(@"sortedSections:%@",sortedSections);
                if (animated) {
                    [self.table flashScrollIndicators];
                }
                [self.table reloadData];
            });
        }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - IndexedTableView
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if ([title isEqualToString:UITableViewIndexSearch]) {
        //[self scrollTableViewToSearchBarAnimated:NO];
        return NSNotFound;
    } else {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index]; //- 1; // -1 because we add the search symbol
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.table) {
        return self.sections.count;
    } else {
        return 1;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.table) {
        if ([[self.sections objectAtIndex:section] count]>0) {
            return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}
#pragma mark ClearCellMark Delegete
- (void)clearMark {
    [self.indexArray removeAllObjects];
    [self.table reloadData];
    debugMethod();
}
#pragma mark TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //因为cell有两种状态，选中时展开输入药量，未选中时关闭显示正常状态
    if (indexPath.row == self.selectIndex.row &&indexPath.section == self.selectIndex.section &&self.selectIndex != nil) {
        return 105;
    } else
    {
        return 60;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.table) {
        return [[self.sections objectAtIndex:section] count];
    } else {
        return self.medArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIFont *font = [UIFont fontWithName:@"Arial" size:13.0f];
    

    NSDictionary *dic = [NSDictionary dictionary];
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        dic = [_searchArray objectAtIndex:[indexPath row]];
    } else {
        dic = [[self.sections objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];//[medArray objectAtIndex:[indexPath row]];
    }
    if (indexPath.row == self.selectIndex.row &&indexPath.section == self.selectIndex.section&& self.selectIndex != nil) {
        static NSString *markCellID = @"MARKED";
        UITableViewCell *markCell = [tableView dequeueReusableCellWithIdentifier:markCellID];
        if (!markCell) {
            markCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:markCellID];
            //药名
            UILabel *medNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, -6, 150, 36)];
            medNameLabel.tag = markMedNameLabelTag;
            [markCell.contentView addSubview:medNameLabel];
            //产地
            UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 17, 150, 20)];
            countLabel.tag = markCountLabelTag;
            [markCell.contentView addSubview:countLabel];
            
            //拼音码
            UILabel *pymlabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 17, 150, 20)];
            pymlabel.tag = markPymLabelTag;
            [markCell.contentView addSubview:pymlabel];
            
            //规格
            UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 34, 150, 20)];
            unitLabel.tag = markUnitLabelTag;
            [markCell.contentView addSubview:unitLabel];
            
            //cell展开
            //背景
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 53, 392, 53)];
            [imgView setImage:[UIImage imageNamed:@"arraw"]];
            [markCell.contentView addSubview:imgView];
            
            //左边的删除按钮
            UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelBtn.frame = CGRectMake(10, 63, 34, 34);
            [cancelBtn setBackgroundImage:ImageNamed(@"deleteBtn_normal") forState:UIControlStateNormal];
            [cancelBtn setBackgroundImage:ImageNamed(@"deleteBtn") forState:UIControlStateHighlighted];
            [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [markCell.contentView addSubview:cancelBtn];
            
            //输入用药量textField
            UITextField *countField = [[UITextField alloc] initWithFrame:CGRectMake(60, 65, 180, 30)];
            countField.tag  = markCountField;
            [markCell.contentView addSubview:countField];
            
            //右边一点的药品单位mg/ml
            UILabel *danweiLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 65, 50, 30)];
            danweiLabel.tag = markDanweiLabel;
            [markCell.contentView addSubview:danweiLabel];
            
            //右侧的确认按钮
            UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            okBtn.frame = CGRectMake(310, 63, 34, 34);
            okBtn.tag = markOKBtnTag;
            [markCell.contentView addSubview:okBtn];
            
            markCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        //根据tag获取每个控件实例
        UILabel *_medNameLabel = (UILabel *)[markCell.contentView viewWithTag:markMedNameLabelTag];
        [_medNameLabel setFont:font];
        [_medNameLabel setBackgroundColor:[UIColor clearColor]];
        [_medNameLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"Name"]]];
        
        UILabel *_countLabel = (UILabel *)[markCell.contentView viewWithTag:markCountLabelTag];
        [_countLabel setFont:font];
        [_countLabel setText:[NSString stringWithFormat:@"产地:%@",[dic objectForKey:@"Content"]]];
        
        UILabel *_pymLabel = (UILabel *)[markCell.contentView viewWithTag:markPymLabelTag];
        [_pymLabel setFont:font];
        [_pymLabel setText:[NSString stringWithFormat:@"拼音码:%@",[dic objectForKey:@"PYM"]]];
        
        UILabel *_unitLabel = (UILabel *)[markCell.contentView viewWithTag:markUnitLabelTag];
        [_unitLabel setFont:font];
        [_unitLabel setText:[NSString stringWithFormat:@"规格:%@%@",[dic objectForKey:@"Specifi"],[dic objectForKey:@"Unit"]]];
        
        UITextField *tempField = (UITextField *)[markCell.contentView viewWithTag:markCountField];
        [tempField setBackgroundColor:[UIColor whiteColor]];
        tempField.layer.cornerRadius = 10.0f;
       self.field = tempField;
        self.field.placeholder = @"输入用药量";
        [self.field setText:@""];
        self.field.returnKeyType = UIReturnKeyDone;
        self.field.keyboardType = UIKeyboardTypeNumberPad;
        self.field.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.field addTarget:self action:@selector(textfiledDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
        self.field.delegate = self;
        
        UILabel *_danweiLabel = (UILabel *)[markCell.contentView viewWithTag:markDanweiLabel];
        [_danweiLabel setFont:font];
        [_danweiLabel setBackgroundColor:[UIColor clearColor]];
        [_danweiLabel setText:@"支/片"];
        
        UIButton *_okbtn = (UIButton *)[markCell.contentView viewWithTag:markOKBtnTag];
        NSString *Imgstr = [self.indexArray containsObject:indexPath] ? @"_refresh" : @"checkBtn_normal";
        [_okbtn setBackgroundImage:ImageNamed(Imgstr) forState:UIControlStateNormal];
        if (![self.indexArray containsObject:indexPath]) {
            [_okbtn setBackgroundImage:ImageNamed(@"checkBtn") forState:UIControlStateHighlighted];
        }
        [_okbtn addTarget:self action:@selector(okBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        return markCell;
        
    }
    else {
        static NSString *CellID = @"CELL";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
            
            //药名
            UILabel *medNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, -6, 150, 36)];
            medNameLabel.tag = MedNameLabelTag;
            [cell.contentView addSubview:medNameLabel];
            
            //产地
            UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 17, 150, 20)];
            countLabel.tag = CountLabelTag;
            [cell.contentView addSubview:countLabel];
            
            //拼音码
            UILabel *pymlabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 17, 150, 20)];
            pymlabel.tag = PymLabelTag;
            [cell.contentView addSubview:pymlabel];
            
            //规格
            UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 34, 150, 20)];
            unitLabel.tag = UnitLabelTag;
            [cell.contentView addSubview:unitLabel];
        }
        
        UILabel *_medNameLabel = (UILabel *)[cell.contentView viewWithTag:MedNameLabelTag];
        [_medNameLabel setFont:font];
        [_medNameLabel setBackgroundColor:[UIColor clearColor]];
        [_medNameLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"Name"]]];
        
        UILabel *_countLabel = (UILabel *)[cell.contentView viewWithTag:CountLabelTag];
        [_countLabel setFont:font];
        [_countLabel setText:[NSString stringWithFormat:@"产地:%@",[dic objectForKey:@"Content"]]];
        
        UILabel *_pymLabel = (UILabel *)[cell.contentView viewWithTag:PymLabelTag];
        [_pymLabel setFont:font];
        [_pymLabel setText:[NSString stringWithFormat:@"拼音码:%@",[dic objectForKey:@"PYM"]]];
        
        UILabel *_unitLabel = (UILabel *)[cell.contentView viewWithTag:UnitLabelTag];
        [_unitLabel setFont:font];
        [_unitLabel setText:[NSString stringWithFormat:@"规格:%@%@",[dic objectForKey:@"Specifi"],[dic objectForKey:@"Unit"]]];
        
        UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 34, 150, 20)];
        contentlabel.tag = 8;
        [cell.contentView addSubview:contentlabel];
        [contentlabel setFont:[UIFont fontWithName:@"Arial" size:13]];
        for (id obj in self.contentArray)
        {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *d = (NSDictionary *)obj;
                NSString *content = [d objectForKey:@"Content"];
                debugLog(@"%@ %@",[d objectForKey:@"Name"],[d objectForKey:@"PYM"]);
                if (indexPath.row == [[d objectForKey:@"IndexPath"] integerValue]) {
                    [contentlabel setText:[NSString stringWithFormat:@"已选:%@",content]];
                }
            }
        }
        
        if ([self.indexArray containsObject:indexPath]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //[self.table scrollToRowAtIndexPath:<#(NSIndexPath *)#> atScrollPosition:<#(UITableViewScrollPosition)#> animated:<#(BOOL)#>];
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        
    }
    debugLog(@"Index:%@ SecondIndex:%@",indexPath,self.selectIndex);
    if (!self.selectIndex) {
        self.selectIndex = indexPath;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.selectIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        BOOL selectTheSameRow = (indexPath.row == self.selectIndex.row)&&(indexPath.section == self.selectIndex.section) ? YES : NO;
        
        if (!selectTheSameRow) {//两次点的行不同
            NSIndexPath *tempIndexPath = [self.selectIndex copy];
            self.selectIndex = nil;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:tempIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];//合上上一次的行
            self.selectIndex = indexPath;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.selectIndex] withRowAnimation:UITableViewRowAnimationAutomatic];//展开新点击的行
        } else {
            self.selectIndex = nil;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];//直接合上点击的同一行
        }
        }
    
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)cancelBtnClicked:(UIButton *)button {/////点击左边删除按钮的方法
    debugMethod();
    /////////////////////////////////////////////////////////////////////////
    if ([button.superview.superview isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell *)button.superview.superview;
        NSIndexPath *indexPath = [table indexPathForCell:cell];
    
    NSMutableArray *tempAray = [NSMutableArray arrayWithCapacity:0];
    for (id obj in self.contentArray) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)obj;
            if (indexPath.row == [[dic objectForKey:@"IndexPath"] integerValue]) {
                [tempAray addObject:obj];
            }
        }
    }

    [self.contentArray removeObjectsInArray:tempAray];
    
    self.selectIndex = nil;
    [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    UITableViewCell *_cell = [table cellForRowAtIndexPath:indexPath];
    _cell.accessoryType = UITableViewCellAccessoryNone;
    
    if ([self.indexArray containsObject:indexPath]) {
        [self.indexArray removeObject:indexPath];
    }
}
    
}

- (void)okBtnClicked:(UIButton *)button {//点击右边OK按钮的方法
    debugMethod();
    /////////////////////////////////////////////////////////////////////////
    if ([button.superview.superview isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell *)button.superview.superview;
        NSIndexPath *indexPath = [self.table indexPathForCell:cell];
        debugLog(@"OKIndexPath:%@",indexPath);
        NSDictionary *Meddic = [[self.sections objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        UITextField *textField = (UITextField *)[cell.contentView viewWithTag:markCountField];
        if (![Help isEmptyString:textField.text] && [textField.text intValue]>0) {
            [textField resignFirstResponder];
            
            if (![self.indexArray containsObject:indexPath]&&indexPath!=nil) {
                [self.indexArray addObject:indexPath];
            } else {
                debugLog(@"索引数组插入失败");
            }
            
            NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [NSString stringWithFormat:@"%@",[Meddic objectForKey:@"Name"]],@"Name",
                                 [NSString stringWithFormat:@"%@",[Meddic objectForKey:@"PYM"]],@"PYM",
                                 [NSNumber numberWithInteger:[indexPath row]],@"IndexPath",nil];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [NSString stringWithFormat:@"%@",[Meddic objectForKey:@"Name"]],@"Name",
                                 [NSString stringWithFormat:@"%@",[Meddic objectForKey:@"PYM"]],@"PYM",
                                 [NSString stringWithFormat:@"%@",textField.text],@"Content",
                                        [NSNumber numberWithInteger:[indexPath row]],@"IndexPath",nil];
                                // [NSString stringWithFormat:@"%@",[[self.medArray objectAtIndex:indexPath.row] objectForKey:@"Unit"]],@"Unit",nil];
            
            if (![contentArray containsObject:_dic]&&_dic!=nil) {
                NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
                for (NSMutableDictionary *objDic in self.contentArray) {
                    NSMutableDictionary *__objDic = [objDic mutableCopy];
                    //[__objDic removeObjectForKey:@"Unit"];
                    [__objDic removeObjectForKey:@"Content"];
                    if ([__objDic isEqualToDictionary:_dic]) {
                        [tempArray addObject:objDic];
                    }
                }
                
                [self.contentArray removeObjectsInArray:tempArray];
                [self.contentArray addObject:dic];
            } else {
                debugLog(@"插入数组错误");
            }
            self.selectIndex = nil;
            [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        }
    }
}

#pragma mark -



#pragma mark UITextField Delegate
#pragma mark 输入框的几个委托
- (IBAction)textFieldDoneEditing:(id)sender {
    debugMethod();
    self.field = (UITextField *)sender;
    [self.field resignFirstResponder];
    [sender resignFirstResponder];
    
}
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {

    debugMethod();
    [self.table scrollRectToVisible:textField.frame animated:YES];
    //[self.table setContentSize:CGSizeMake(380, [self.table numberOfRowsInSection:0]*60*2)];
    return YES;
}
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    debugMethod();
    //self.field = textField;
    if ([textField.superview.superview isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
       NSIndexPath * indexPath = [self.table indexPathForCell:cell];
        debugLog(@"indexPath = %@",indexPath);
        [self.table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        //[self.table setContentSize:CGSizeMake(380, [self.table numberOfRowsInSection:0]*60*2)];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    debugMethod();
   // NSIndexPath *indexPath = nil;
    if ([textField.superview.superview isKindOfClass:[UITableViewCell class]]) {
        //因为是加在cell的contentView上的所以有两个superView
        //UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
        //indexPath = [table indexPathForCell:cell];
       // UITextField *textfield = (UITextField *)[cell.contentView viewWithTag:markCountField];
        [textField resignFirstResponder];
        //[self.table setContentSize:CGSizeMake(380, [self.table numberOfRowsInSection:0]*60*2)];
    }
    return YES;
}

//限制只能输入数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSCharacterSet *cs = nil;
    if ([textField isEqual:field]) {
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERSPERIOD]invertedSet];
    } 
    else
        return YES;
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
	BOOL basicTest = [string isEqualToString:filtered];
	return basicTest;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    debugLog(@"Hidden:%@",userInfo);
    NSValue *value=[userInfo objectForKey:UIKeyboardBoundsUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
   // [self.table setContentSize:CGSizeMake(380, [self.table numberOfRowsInSection:0]*65*1.5)];
    //防止键盘弹出后遮盖TableView
    [UIView commitAnimations];
}


- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    debugLog(@"Show:%@",userInfo);
    NSValue *value=[userInfo objectForKey:UIKeyboardBoundsUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    // [self.table setContentSize:CGSizeMake(380, [self.table numberOfRowsInSection:0]*65*1.5)];
    //防止键盘弹出后遮盖TableView
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark - UISearchBarDelegate

///////利用谓词快速检索
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name contains[cd]%@",searchText];
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"PYM contains[cd]%@",searchText];
    NSPredicate *_predicate,*_predicate1;
    _predicate = [predicate predicateWithSubstitutionVariables:[self.medArray dictionaryWithValuesForKeys:@[@"Name"]/*[NSArray arrayWithObject:@"Name"]*/]];
    _predicate1 = [predicate1 predicateWithSubstitutionVariables:[self.medArray dictionaryWithValuesForKeys:@[@"PYM"]/*[NSArray arrayWithObject:@"PYM"]*/]];
    if ([[medArray filteredArrayUsingPredicate:_predicate] count] > 0) {
        self.searchArray = [medArray filteredArrayUsingPredicate:_predicate];
    } else {
        self.searchArray = [medArray filteredArrayUsingPredicate:_predicate1];
    }
    debugLog(@"%@",_searchArray);///充当检索结果的数据源
}

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}
#pragma mark -
- (void) viewDidUnload {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    self.contentArray = nil;
    [self setTable:nil];
    [self setSearch:nil];
    [self setField:nil];
    [self setSearchIndexArray:nil];
    [self setSearchArray:nil];
    [self setIndexArray:nil];
    [self setSelectIndex:nil];
    [super viewDidUnload];
}

- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
}
@end
