//
//  ForgotPasswordViewController.m
//  uPitch
//
//  Created by Puneet Rao on 19/05/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "LxReqRespManager.h"
#import "constant.h"
@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    
    appdelegateInstance = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [toolBar removeFromSuperview];
    email.inputAccessoryView = toolBar;
    
    borderImageView.layer.borderColor = [UIColor colorWithRed:63.0f/255.0f green:140.0f/255.0f blue:220.0f/255.0f alpha:1].CGColor;
    borderImageView.layer.borderWidth = 1;
    borderImageView.layer.cornerRadius = 5;
    borderImageView.layer.masksToBounds = YES;
    // 1 for email and 2 for reset password
    stateString = @"2";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
    }else{
    submitButton.frame = CGRectMake(submitButton.frame.origin.x, emailView.frame.origin.y+emailView.frame.size.height+30, submitButton.frame.size.width, submitButton.frame.size.height);
    }
    
    
    
    // for Hiding views
    emailView.hidden = YES;
    resetView.hidden = NO;
    
    //lblMsg.text=[NSString stringWithFormat:@"%@",self.strMessage];
    
    lblMsg.text=@"Please enter confirmation code sent on your email";
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
    }else{
        submitButton.frame = CGRectMake(submitButton.frame.origin.x, resetView.frame.origin.y+resetView.frame.size.height+30, submitButton.frame.size.width, submitButton.frame.size.height);
    }
    submitButton.layer.cornerRadius = 5;
    submitButton.layer.masksToBounds = YES;
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
    [self resignAllKeys];
}

- (IBAction)cancelToolBar:(id)sender {
    [self resignAllKeys];
}
-(void)resignAllKeys{
    [email resignFirstResponder];
    [confirmationCode resignFirstResponder];
    [password resignFirstResponder];
    [confirmationCode resignFirstResponder];
}


- (IBAction)submitButtonPressed:(id)sender
{
    [self.view endEditing:YES];
 
    if ([stateString isEqualToString:@"1"]) {
        email.text = [email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([email.text isEqualToString:@""] || email.text.length<=0 ) {
//            UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
            [constant alertViewWithMessage:@"Please enter email address."withView:self];
        }
        else if (![self validateEmailWithString:email.text])
        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Email format is invalid. It should be in (abc@example.com)format." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
            [constant alertViewWithMessage:@"Email format is invalid. It should be in (abc@example.com)format."withView:self];
        }
        else{
            [self resignAllKeys];
            [self sendMailApi];
        }
    }
    else{
        confirmationCode.text = [confirmationCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if ([confirmationCode.text isEqualToString:@""] || confirmationCode.text.length<=0 ) {
//            UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter confirmation code." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
            [constant alertViewWithMessage:@"Please enter confirmation code."withView:self];
        }
       else if ([password.text isEqualToString:@""] || password.text.length<=0 ) {
//            UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
           [constant alertViewWithMessage:@"Please enter password."withView:self];
       } else if (password.text.length<6) {
//                   UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter atleast 6 characters." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                   [alert show];
           [constant alertViewWithMessage:@"Please enter at least 6 characters for your PASSWORD."withView:self];
       }
       else if ([conPassword.text isEqualToString:@""] || conPassword.text.length<=0 ) {
//           UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter confirm password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//           [alert show];
           [constant alertViewWithMessage:@"Please enter confirm password."withView:self];
       }
       else if (![password.text isEqualToString:conPassword.text]  ) {
//           UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Password and confirm password does not match." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//           [alert show];
           [constant alertViewWithMessage:@"Password and confirm password does not match."withView:self];
       }
       else{
           [self resignAllKeys];
           [self sendMailApi];
       }
    }
}

-(void)sendMailApi
{
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
     NSDictionary *dictParams;
    if ([stateString isEqualToString:@"1"]) {
        // forgot password
        strWebService=[[NSString alloc]initWithFormat:@"%@forgot_password",AppURL];
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:
                    email.text,@"email",
                    nil];
    }
    else{
        // reset password
        strWebService=[[NSString alloc]initWithFormat:@"%@reset_password",AppURL];
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:confirmationCode.text,@"reset_code",password.text,@"password",
                    email.text,@"email",
                    self.strClientJournalist,@"type",
                    nil];
    }
    NSLog(@"%@",dictParams);
    NSLog(@"%@",strWebService);
   
    [[NSUserDefaults standardUserDefaults]setObject:password.text forKey:KEY_Password];
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
             [appdelegateInstance hideHUD];
             NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             if ([str isEqualToString:@"0"])
             {
                 if ([stateString isEqualToString:@"1"]) {
                     UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     alert.tag = 100;
                     [alert show];
                 }
                 else{
                     UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     alert.tag = 200;
                     [alert show];
                 }
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        emailView.hidden = YES;
        resetView.hidden = NO;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            
        }else{
        submitButton.frame = CGRectMake(submitButton.frame.origin.x, resetView.frame.origin.y+resetView.frame.size.height+30, submitButton.frame.size.width, submitButton.frame.size.height);
        }
           stateString =@"2";
        //[self.navigationController popViewControllerAnimated:YES];
    }
    else if (alertView.tag == 200)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 100 *      NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
            [[self navigationController] popViewControllerAnimated:YES];
        });
    }
}
- (IBAction)popView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
