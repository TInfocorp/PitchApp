//
//  RegisterPage1.m
//  uPitch
//
//  Created by Puneet Rao on 19/05/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import "RegisterPage1.h"
#import "RegisterPage2.h"
#import "LxReqRespManager.h"
#import "SWRevealViewController.h"
#import "SideMenuViewController.h"
#import "PitchFeedJournalist_ViewController.h"
#import "Utils.h"
#import "constant.h"
@interface RegisterPage1 ()

@end

@implementation RegisterPage1
@synthesize userTypeString;
- (void)viewDidLoad {
    
    appdelegateInstance = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [toolBar removeFromSuperview];
    emailTextField.inputAccessoryView = toolBar;
    passwordTextField.inputAccessoryView = toolBar;
     confirmpasswordTextField.inputAccessoryView = toolBar;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(BOOL)validateEmailWithString:(NSString*)email1
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email1];
}
- (IBAction)doneToolBar:(id)sender {
    [self resignKeyBoard];
}

- (IBAction)cancelToolBar:(id)sender {
    [self resignKeyBoard];
}

- (IBAction)saveButtonPressed:(id)sender {
    
//    RegisterPage2*obj;
//    obj=[self.storyboard instantiateViewControllerWithIdentifier:@"signUp2"];
//    [self.navigationController pushViewController:obj animated:YES];
    emailTextField.text = [emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([emailTextField.text isEqualToString:@""] || emailTextField.text.length<=0 ) {
//        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [constant alertViewWithMessage:@"Please enter email address."withView:self];
    }
    else if (![self validateEmailWithString:emailTextField.text])
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Email format is invalid. It should be in (abc@example.com)format." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
        [constant alertViewWithMessage:@"Email format is invalid. It should be in (abc@example.com)format."withView:self];
    }
    else if ([passwordTextField.text isEqualToString:@""] || passwordTextField.text.length<=0 ) {
//        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [constant alertViewWithMessage:@"Please enter password."withView:self];
    }
    else if ([confirmpasswordTextField.text isEqualToString:@""] || confirmpasswordTextField.text.length<=0 ) {
//        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter confirm password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [constant alertViewWithMessage:@"Please enter confirm password."withView:self];
    }
    else if (![confirmpasswordTextField.text isEqualToString:passwordTextField.text]) {
//        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Password and confirm password does not match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [constant alertViewWithMessage:@"Password and confirm password does not match."withView:self];
    }
    else{
        [self resignKeyBoard];
        [self signUpAPI];
//        RegisterPage2*obj;
//        obj=[self.storyboard instantiateViewControllerWithIdentifier:@"signUp2"];
//        [self.navigationController pushViewController:obj animated:YES];
    }

}
-(void)signUpAPI
{
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService=[[NSString alloc]initWithFormat:@"%@registration",AppURL];
    NSLog(@"%@",strWebService);
    NSDictionary *dictParams;
    
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:emailTextField.text,@"email",passwordTextField.text,@"password",userTypeString,@"type",
                nil];
    
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
             [appdelegateInstance hideHUD];
             NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             if ([str isEqualToString:@"0"])
             {
                 [[NSUserDefaults standardUserDefaults]setObject:@"signup1" forKey:@"createAccount"];
                 [[NSUserDefaults standardUserDefaults]setObject:[response valueForKey:@"user_id"] forKey:@"userid"];
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:LINKEDIN_TOKEN_KEY];
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:LINKEDIN_EXPIRATION_KEY];
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 
                
                 
                 RegisterPage2*obj;
                 obj=[self.storyboard instantiateViewControllerWithIdentifier:@"signUp2"];
                 [self.navigationController pushViewController:obj animated:YES];
            }
             else  if ([str isEqualToString:@"1"])
             {
//                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                 [alert show];
                 [constant alertViewWithMessage:[response valueForKey:@"message"]withView:self];
             }
         }
         else
         {
             [appdelegateInstance hideHUD];
             [constant AlertMessageWithString:@"Connectivity levels low. Please try again." andWithView:self.view];
             NSLog(@"Error returned:%@",[error localizedDescription]);
         }
     }];
}
-(void)resignKeyBoard{
    [emailTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [confirmpasswordTextField resignFirstResponder];
}

- (IBAction)popview:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)popView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
