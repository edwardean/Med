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
    [navBar setBackImage];
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
    [self performSelector:@selector(Save:)];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    return YES;
}
#pragma mark -
- (void) viewDidUnload {
    
    [self setInputTextField:nil];
    navBar = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
