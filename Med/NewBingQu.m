//
//  NewBingQu.m
//  masterDemo
//
//  Created by Edward on 13-3-6.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "NewBingQu.h"
#import "BingQu.h"
@interface NewBingQu ()

@end

@implementation NewBingQu
@synthesize inputTextField;
@synthesize navBar = _navBar;
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
    inputTextField.autocorrectionType = UITextAutocapitalizationTypeNone;
    inputTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    inputTextField.returnKeyType = UIReturnKeyDone;
    inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    inputTextField.keyboardType = UIKeyboardTypeDefault;
    inputTextField.delegate = self;
    [_navBar setBackImage];
}
- (IBAction)hide:(id)sender {
    debugMethod();
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)Save:(id)sender {
    
    debugMethod();
    if ([inputTextField.text isEqualToString:@""]) {
        return;
    } else {
        if ([BingQu findTheSameBingQu:[inputTextField.text uppercaseString]]) {
            NSString *str = [NSString stringWithFormat:@"%@已经录入过了",[inputTextField.text uppercaseString]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:str delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        } else {
            
            if ([BingQu createNewBingQu:[inputTextField.text uppercaseString]]) {
                NSString *str = [NSString stringWithFormat:@"病区:%@创建成功",[inputTextField.text uppercaseString]];
                [Help ShowGCDMessage:str andView:self.view andDelayTime:1.0f];
                [self.inputTextField setText:@""];
            } else {
                NSString *str = [NSString stringWithFormat:@"%@创建失败",inputTextField.text];
                [Help ShowGCDMessage:str andView:self.view andDelayTime:1.0f];
            }
        }
    }
}
#pragma mark UITextField DelegateMethods
- (BOOL)textFieldShouldReturn:(UITextField *)_textField {
    
    [_textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSCharacterSet *cs = nil;
//    if ([textField isEqual:inputTextField]) {
//        cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM]invertedSet];
//    }
//    else
//        return YES;
//    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//	BOOL basicTest = [string isEqualToString:filtered];
//	
//	
//	return basicTest;
    return YES;
}
#pragma mark -
- (void) viewDidUnload {
    
    [self setNavBar:nil];
    [self setInputTextField:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    
    [_navBar release];
    [inputTextField release];
    [super dealloc];
}
@end
