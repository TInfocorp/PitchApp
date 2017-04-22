//
//  AccountSettingViewController.m
//  UPitch
//
//  Created by Puneet Rao on 07/07/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import "AccountSettingViewController.h"
#import "SWRevealViewController.h"
#import "LxReqRespManager.h"
#import "constant.h"
@interface AccountSettingViewController ()

@end

@implementation AccountSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appdelegateInstance = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    SWRevealViewController *reveal = self.revealViewController;
    reveal.panGestureRecognizer.enabled = NO;
    [toolBar removeFromSuperview];
    txtEmail.inputAccessoryView = toolBar;
    txtNewEmail.inputAccessoryView = toolBar;
    txtOldPaswd.inputAccessoryView = toolBar;
    txtNewPaswd.inputAccessoryView = toolBar;
    txtConfrmNewPasw.inputAccessoryView = toolBar;
    [showHideButton setTitle:@"Show" forState:UIControlStateNormal];
    showPassowrdBool = NO;
    txtOldPaswd.secureTextEntry = YES;

    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignAllKeys)];
    [self.view addGestureRecognizer:tap];
    [self SetCornerradius:btnChangeEmail];
    [self SetCornerradius:btnChangePaswd];
    [self SetCornerradius:btnDelete];
    [self setScroll];
}

#pragma mark Required Actions
-(void)setScroll
{
    contentHeight=(scrlVw.frame.origin.y/2)+btnDelete.frame.origin.y+btnDelete.frame.size.height;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
    scrlVw.contentSize=CGSizeMake(self.view.frame.size.width,80+btnDelete.frame.origin.y+btnDelete.frame.size.height);
    }
    else
    {
    scrlVw.contentSize=CGSizeMake(self.view.frame.size.width,5+btnDelete.frame.origin.y+btnDelete.frame.size.height);
    }
}
-(void)SetCornerradius:(UIButton *)Btn
{
    Btn.layer.cornerRadius = 5;
    Btn.layer.masksToBounds = YES;
}

- (IBAction)doneToolBar:(id)sender {
    [self resignAllKeys];
}

- (IBAction)cancelToolBar:(id)sender {
    [self resignAllKeys];
}
-(void)resignAllKeys
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(BOOL)validateEmailWithString:(NSString*)email1
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email1];
}

#pragma mark Actions
- (IBAction)showPassword:(id)sender {
    if (showPassowrdBool) {
        [showHideButton setTitle:@"Show" forState:UIControlStateNormal];
        showPassowrdBool = NO;
        txtOldPaswd.secureTextEntry = YES;
        //[passwordTextField becomeFirstResponder];
    }
    else if (!showPassowrdBool){
        showPassowrdBool = YES;
        txtOldPaswd.secureTextEntry = NO;
        [showHideButton setTitle:@"Hide" forState:UIControlStateNormal];
    }
    [txtOldPaswd becomeFirstResponder];

    
}

- (IBAction)ChangeEmail:(id)sender {
    [self resignAllKeys];
    txtEmail.text = [txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    txtNewEmail.text = [txtNewEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([txtEmail.text isEqualToString:@""] || txtEmail.text.length<=0 ) {
//        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
      
        [constant alertViewWithMessage:@"Please enter email address."withView:self];
        
    }
    else if (![self validateEmailWithString:txtEmail.text])
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Email format is invalid. It should be in (abc@example.com)format." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
        [constant alertViewWithMessage:@"Email format is invalid. It should be in (abc@example.com)format."withView:self];
    }
    else if (![txtEmail.text isEqualToString:[USERDEFAULTS valueForKey:KEY_Email]])
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Email provided by you does not match with your current email." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
        [constant alertViewWithMessage:@"Email provided by you does not match with your current email."withView:self];
    }
    else if ([txtNewEmail.text isEqualToString:@""] || txtNewEmail.text.length<=0 ) {
//        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter new email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [constant alertViewWithMessage:@"Please enter new email."withView:self];
    } else if (![self validateEmailWithString:txtNewEmail.text])
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"New Email format is invalid. It should be in (abc@example.com)format." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
        [constant alertViewWithMessage:@"New Email format is invalid. It should be in (abc@example.com)format."withView:self];
    }
    else{
        [self RunAPIChangeEmail];
    }

}

- (IBAction)ChangePassword:(id)sender {
   [self resignAllKeys];
    txtOldPaswd.text = [txtOldPaswd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    txtNewPaswd.text = [txtNewPaswd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    txtConfrmNewPasw.text = [txtConfrmNewPasw.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([txtOldPaswd.text isEqualToString:@""] || txtOldPaswd.text.length<=0 ) {
//        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter your password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [constant alertViewWithMessage:@"Please enter your password."withView:self];
    }
    else if ([txtNewPaswd.text isEqualToString:@""] || txtNewPaswd.text.length<=0 ) {
//        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter new password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [constant alertViewWithMessage:@"Please enter new password."withView:self];
    }
    else if (txtNewPaswd.text.length<6)
    {
//        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter atleast 6 characters." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [constant alertViewWithMessage:@"Please enter at least 6 characters for your PASSWORD."withView:self];
    }
    else if (![txtOldPaswd.text isEqualToString:[USERDEFAULTS valueForKey:KEY_Password]])
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Password provided by you does not match with your current password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
        [constant alertViewWithMessage:@"Password provided by you does not match with your current password."withView:self];
    }
    else if ([txtConfrmNewPasw.text isEqualToString:@""] || txtConfrmNewPasw.text.length<=0 ) {
//        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please re-enter new password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [constant alertViewWithMessage:@"Please re-enter new password."withView:self];
    }
    else if (txtConfrmNewPasw.text.length<6)
    {
//        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter atleast 6 characters." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
          [constant alertViewWithMessage:@"Please enter at least 6 characters for your PASSWORD." withView:self];
    }else if (![txtNewPaswd.text isEqualToString:txtConfrmNewPasw.text])
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"New password and confirm new password does not match." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
        [constant alertViewWithMessage:@"New password and confirm new password does not match."withView:self];
    }
    else{
        [self RunAPIChangePassword];
    }
    

}

- (IBAction)DeleteAccount:(id)sender {
    [self resignAllKeys];
    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Are you sure, you want to delete your account?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alert.tag = 100;
    [alert show];
}

- (IBAction)Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark TEXTFEILD
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField==txtNewPaswd)
    {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        if (newLength<= 20) {
            return newLength <= 20;
        }
        else
        {
//            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"upitch" message:@"New Password maximum limit 20 characters."delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
            [constant alertViewWithMessage:@"New Password maximum limit 20 characters."withView:self];
            return NO;
        }
        
    }
    
    if (textField==txtConfrmNewPasw)
    {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        if (newLength<= 20) {
            return newLength <= 20;
        }
        else
        {
//            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"upitch" message:@"Confirm New Password maximum limit 20 characters."delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
           
            [constant alertViewWithMessage:@"New Password maximum limit 20 characters."withView:self];
            return NO;
        }
        
    }

    
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self setScroll];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resignAllKeys];
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
   
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationLandscapeLeft ||
            orientation == UIInterfaceOrientationLandscapeRight)
        {
           scrlVw.contentOffset = CGPointMake(0,220);
           scrlVw.contentSize = CGSizeMake(self.view.frame.size.width, scrlVw.frame.size.height+450);
        }else
        {
            
        }

    }
    else
    {

    if (textField==txtConfrmNewPasw||textField==txtNewPaswd||textField==txtOldPaswd)
    {
        
        if (IS_IPHONE_6||IS_IPHONE_6_PLUS) {
            scrlVw.contentOffset = CGPointMake(0,50);
        }
        else if (IS_IPHONE_5) {
            scrlVw.contentOffset = CGPointMake(0,150);
        }
        else
        {
        scrlVw.contentOffset = CGPointMake(0,220);
        }
    }
       scrlVw.contentSize = CGSizeMake(self.view.frame.size.width, contentHeight+250);
    }
   
   
    

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    
    if (alertView.tag==100)
    {
        if (buttonIndex==0) {
            NSLog(@"Cancel");
        }
        else if (buttonIndex==1) {
            NSLog(@"OK");
            [self runApiDeleteAccount];
        }
    }
    
    if (alertView.tag==1234) {
        AppDelegate *appd= (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appd LogoutFromApp:self];
    }
    
}
#pragma mark API
-(void)RunAPIChangeEmail
{
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
    NSDictionary *dictParams;
    strWebService=[[NSString alloc]initWithFormat:@"%@update_user_email",AppURL];
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:
                [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"userid"]],@"user_id",
                txtNewEmail.text,@"email",
                nil];
    NSLog(@"%@",dictParams);
    NSLog(@"%@",strWebService);
    
    
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
             [appdelegateInstance hideHUD];
             NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             if ([str isEqualToString:@"0"])
             {
                [USERDEFAULTS setObject:txtNewEmail.text forKey:KEY_Email];
                 txtEmail.text=@"";
                 txtNewEmail.text=@"";
//                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                 [alert show];
                 [constant alertViewWithMessage:[response valueForKey:@"message"]withView:self];
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
//             [constant alertViewWithMessage:@"Connectivity levels low. Please try again."withView:self];
             NSLog(@"Error returned:%@",[error localizedDescription]);
         }
     }];
}


-(void)RunAPIChangePassword
{
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
    NSDictionary *dictParams;
    strWebService=[[NSString alloc]initWithFormat:@"%@update_user_password",AppURL];
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:
                [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"userid"]],@"user_id",
                
                txtConfrmNewPasw.text,@"password",
                nil];
    NSLog(@"%@",dictParams);
    NSLog(@"%@",strWebService);
    
    
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
             [appdelegateInstance hideHUD];
             NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             if ([str isEqualToString:@"0"])
             {
                [USERDEFAULTS setObject:txtConfrmNewPasw.text forKey:KEY_Password];
                     txtOldPaswd.text=@"";
                     txtNewPaswd.text=@"";
                txtConfrmNewPasw.text=@"";
//                     UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                     [alert show];
                 [constant alertViewWithMessage:[response valueForKey:@"message"]withView:self];
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
//             UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Connectivity levels low. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//             [alert show];
             [constant AlertMessageWithString:@"Connectivity levels low. Please try again." andWithView:self.view];

//             [constant alertViewWithMessage:@"Connectivity levels low. Please try again."withView:self];
             NSLog(@"Error returned:%@",[error localizedDescription]);
         }
     }];
}


-(void)runApiDeleteAccount
{
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
        // delete account
        strWebService=[[NSString alloc]initWithFormat:@"%@deleteaccount",AppURL];
   
    NSLog(@"%@",strWebService);
    NSDictionary *dictParams;
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"userid"]],@"user_id",
                    nil];
       [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
             [appdelegateInstance hideHUD];
             NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             if ([str isEqualToString:@"0"] )
             {
//                     UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Account deleted successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                     [alert show];
                 [constant alertViewWithMessage:@"Account deleted successfully."withView:self];
                     AppDelegate *appd= (AppDelegate *)[UIApplication sharedApplication].delegate;
                     [appd LogoutFromApp:self];
             }
             else if ([str isEqualToString:@"10"] )
             {
                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 alert.tag = 1234;
                 [alert show];
             }
             else if ([response valueForKey:@"Failure"] )
             {
//                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"Failure"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                 [alert show];
                 [constant alertViewWithMessage:[response valueForKey:@"Failure"]withView:self];
             }
         }
         else
         {
             
             [appdelegateInstance hideHUD];
//             UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Connectivity levels low. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//             [alert show];
             [constant AlertMessageWithString:@"Connectivity levels low. Please try again." andWithView:self.view];

//             [constant alertViewWithMessage:@"Connectivity levels low. Please try again."withView:self];
             NSLog(@"Error returned:%@",[error localizedDescription]);
         }
     }];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
         if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortrait) {
             
             [self setScroll];
             
         }
         
         else if (orientation == UIInterfaceOrientationLandscapeLeft ||
                  orientation == UIInterfaceOrientationLandscapeRight)
         {
             [self setScroll];
         }
         
         // do whatever
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

@end
