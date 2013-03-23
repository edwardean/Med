//
//  NewOffice.m
//  masterDemo
//
//  Created by Edward on 13-3-5.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "NewOffice.h"
#import "Office.h"
#import "GCDiscreetNotificationView.h"
@interface NewOffice ()

@end

@implementation NewOffice
@synthesize textField;
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
    
    textField.autocorrectionType = UITextAutocapitalizationTypeNone;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.delegate = self;
}
- (IBAction)hide:(id)sender {
    debugMethod();
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)Save:(id)sender {
    debugMethod();
    GCDiscreetNotificationView *gcd = [[[GCDiscreetNotificationView alloc] initWithText:@"" showActivity:NO inPresentationMode:GCDiscreetNotificationViewPresentationModeTop inView:self.view] autorelease];
    if ([textField.text isEqualToString:@""]) {
        return;
    } else {
        if ([Office findTheSameOffcie:textField.text]) {
            NSString *str = [NSString stringWithFormat:@"%@已经录入过了",textField.text];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:str delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        } else {
            
            if([Office createNewOffcie:textField.text]){
            NSString *str = [NSString stringWithFormat:@"科室:%@创建成功",textField.text];
            [gcd setTextLabel:str];
            [gcd show:YES];
            [gcd hideAnimatedAfter:1.0f];
            [self.textField setText:@""];
            } else {
                NSString *str = [NSString stringWithFormat:@"%@创建失败",textField.text];
                [gcd setTextLabel:str];
                [gcd show:YES];
                [gcd hideAnimatedAfter:1.0f];
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
#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    textField = nil;
}

- (void)dealloc {
    [textField release];
    [super dealloc];
}

@end
