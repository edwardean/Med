//
//  NewMedicine.m
//  masterDemo
//
//  Created by Edward on 13-3-5.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "NewMedicine.h"
#import "QuartzCore/QuartzCore.h"
#import "dataBaseManager.h"
#import "Medicine.h"
@interface NewMedicine ()
@property (nonatomic, retain) NSIndexPath *lastIndex;
@property (nonatomic, copy) NSString *specifiStr;
@property (nonatomic, copy) NSString *unitStr;
@property (nonatomic, retain) UIAlertView *alert;
@property (nonatomic, retain) UIAlertView *alert5;
@end

@implementation NewMedicine

@synthesize specifiTable,nameTextField,specifiTextField,countTextField,pymTextField;
@synthesize lastIndex,specifiStr,unitStr,alert,alert5;
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
    [navBar setBackImage];
    self.specifiStr = @"";
    self.unitStr = @"";
    self.specifiTable.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.specifiTable selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    nameTextField.autocorrectionType = UITextAutocapitalizationTypeNone;
    nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    nameTextField.returnKeyType = UIReturnKeyNext;
    nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTextField.keyboardType = UIKeyboardTypeDefault;
    nameTextField.delegate = self;
    specifiTextField.autocorrectionType = UITextAutocapitalizationTypeNone;
    specifiTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    specifiTextField.returnKeyType = UIReturnKeyNext;
    specifiTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    specifiTextField.keyboardType = UIKeyboardTypeNumberPad;
    specifiTextField.delegate = self;
    pymTextField.autocorrectionType = UITextAutocapitalizationTypeNone;
    pymTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    pymTextField.returnKeyType = UIReturnKeyNext;
    pymTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    pymTextField.keyboardType = UIKeyboardTypeDefault;
    pymTextField.delegate = self;
    countTextField.autocorrectionType = UITextAutocapitalizationTypeNone;
    countTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    countTextField.returnKeyType = UIReturnKeyDone;
    countTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    countTextField.keyboardType = UIKeyboardTypeDefault;
    countTextField.delegate = self;
    
    
}
#pragma mark UITextField委托
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    if (textField==nameTextField) {
        [pymTextField becomeFirstResponder];
    } else if (textField == pymTextField) {
        [specifiTextField becomeFirstResponder];
    } else if (textField == specifiTextField) {
        [countTextField becomeFirstResponder];
    } else if (textField == countTextField) {
        [countTextField resignFirstResponder];
        [self performSelector:@selector(Save:)];
    }
    return YES;
}

//有些输入内容限制为某种格式，比如纯数字，纯字母等等
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSCharacterSet *cs = nil;
    if ([textField isEqual:specifiTextField]) {
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERSPERIOD]invertedSet];
    } else if ([textField isEqual:pymTextField]){
        cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM]invertedSet];
    } else
        return YES;
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
	BOOL basicTest = [string isEqualToString:filtered];
	
	
	return basicTest;

}
#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)hide:(id)sender {
    debugMethod();
    self.specifiTextField.text = @"";
    self.nameTextField.text = @"";
    self.countTextField.text = @"";
    self.pymTextField.text = @"";
    [self.nameTextField becomeFirstResponder];
}

- (IBAction)Save:(id)sender {
    debugMethod();
    if ([nameTextField.text length]==0 || [specifiTextField.text length] == 0 || [countTextField.text length]==0 || [pymTextField.text length] == 0) {
        UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"警告" message:@"信息不完整" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert1 show];
        [alert1 release];

    } else {
        if ([self.unitStr isEqualToString:@""]) {
            UIAlertView *alert2 = [[UIAlertView alloc]initWithTitle:@"啊噢!" message:@"主人你忘记选药品规格了" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alert2 show];
            [alert2 release];
        } else {
            NSString *str  =[self.specifiTextField.text stringByAppendingString:self.unitStr];
            NSString *message = [NSString stringWithFormat:@"药品名称:%@\n拼音码:%@\n规格:%@\n产地:%@",nameTextField.text,[pymTextField.text uppercaseString],str,countTextField.text];
            self.alert = [[UIAlertView alloc]initWithTitle:@"确认信息" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alert show];
        }
    }
}
- (void) dismiss {
    [self dismissModalViewControllerAnimated:YES];
}
- (void) saveDataIntoTable {
    debugMethod();
    if ([Medicine createNewMedicine:nameTextField.text andSpecifi:specifiTextField.text andUnit:self.unitStr andContent:countTextField.text PYM:[pymTextField.text uppercaseString]]) {
        NSString *str = [NSString stringWithFormat:@"药品%@创建完毕",nameTextField.text];
        [Help ShowGCDMessage:str andView:self.view andDelayTime:1.0f];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:2.0f];
        [self performSelector:@selector(hide:)];
    }  else {
          NSString *str = @"创建失败";
          [Help ShowGCDMessage:str andView:self.view andDelayTime:1.0f];
    }
}
- (void)checkDataInTable {
    debugMethod();
    Medicine *med = [[Medicine alloc] init];
    if ([med findIDByMedicinePYM:[self.pymTextField.text uppercaseString]]) {
        
        self.alert5 = [[UIAlertView alloc] initWithTitle:@"有重复" message:@"已经有相同的拼音码了" delegate:self cancelButtonTitle:@"返回继续操作" otherButtonTitles:nil];
        [alert5 show];
    } else if([med findIfExitsSameName:self.nameTextField.text]) {
        
        self.alert5 = [[UIAlertView alloc] initWithTitle:@"有重复" message:@"已经有相同名称但拼音码不同的药品记录了" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续保存",nil];
        [alert5 show];
    } else
        [self saveDataIntoTable];
    [med release];
}
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView isEqual:alert]) {
        if (buttonIndex == 1) {
            [self checkDataInTable];
        }
    }
    
    if ([alertView isEqual:alert5]) {
        if (buttonIndex == 1) {
            [self saveDataIntoTable];
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    NSString *cellText = nil;
    if ([indexPath row] == 0) {
        cellText = @"ml";
    } else if ([indexPath row] == 1) {
     cellText =@"mg";
    }
    cell.textLabel.text = cellText;
    
    
    if ([self.lastIndex isEqual:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[tableView cellForRowAtIndexPath:indexPath] isSelected]) {

        self.unitStr = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![indexPath isEqual:self.lastIndex]) {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.lastIndex];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
       
        self.lastIndex = indexPath;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0f;
}

- (void)viewDidUnload {
    navBar = nil;
    [super viewDidUnload];
    self.alert = nil;
    self.alert5 = nil;
    self.specifiTable  = nil;
    self.nameTextField = nil;
    self.specifiTextField = nil;
    self.countTextField = nil;
    self.pymTextField = nil;
    self.specifiStr = nil;
    self.unitStr = nil;
    self.lastIndex = nil;
}
- (void) dealloc {
    [navBar release];
    [alert release];
    [alert5 release];
    [specifiTable release];
    [nameTextField release];
    [specifiTextField release];
    [countTextField release];
    [pymTextField release];
    [navBar release];
    [specifiStr release];
    [unitStr release];
    [lastIndex release];
    [super dealloc];
}
@end
