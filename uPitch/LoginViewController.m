//
//  LoginViewController.m
//  uPitch
//
//  Created by Puneet Rao on 19/05/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import "LoginViewController.h"
#import "LxReqRespManager.h"
#import "SWRevealViewController.h"
#import "SideMenuViewController.h"
#import "PitchFeedJournalist_ViewController.h"
#import "RegisterPage2.h"
#import "constant.h"
#import "ForgotPasswordViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize clientJournalsitsString;
- (void)viewDidLoad {
    
    appdelegateInstance = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [toolBar removeFromSuperview];
    emailTextField.inputAccessoryView = toolBar;
    passwordTextField.inputAccessoryView = toolBar;
    
    // set color of user type button
    if ([clientJournalsitsString isEqualToString:@"2"]) {
        [self setJournalistsButton];
    }
    else{
      [self setClientButton];
    }
       textFieldView.layer.borderColor = [UIColor colorWithRed:225.0f/255.0f green:225.0f/255.0f blue:225.0f/255.0f alpha:1].CGColor;
    textFieldView.layer.borderWidth = 1.6f;
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
-(void)setClientButton{
    
    pitchCreator.backgroundColor = [UIColor colorWithRed:58.0f/255.0f green:186.0f/255.0f blue:76.0f/255.0f alpha:1 ];
    pitchCreator.layer.cornerRadius = 2;
    [[pitchCreator layer] setMasksToBounds:YES];
    [pitchCreator setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    journalists.backgroundColor = [UIColor clearColor ];
    journalists.layer.cornerRadius = 0.1f;
    [[journalists layer] setMasksToBounds:YES];
    
    journalists.layer.borderColor = [UIColor colorWithRed:58.0f/255.0f green:186.0f/255.0f blue:76.0f/255.0f alpha:1 ].CGColor;
    journalists.layer.borderWidth = 1.0f;
    
    [journalists setTitleColor:[UIColor colorWithRed:58.0f/255.0f green:186.0f/255.0f blue:76.0f/255.0f alpha:1 ] forState:UIControlStateNormal];
}
-(void)setJournalistsButton{
    journalists.backgroundColor = [UIColor colorWithRed:58.0f/255.0f green:186.0f/255.0f blue:76.0f/255.0f alpha:1 ];
    journalists.layer.cornerRadius = 2;
    [[journalists layer] setMasksToBounds:YES];
    [journalists setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    pitchCreator.backgroundColor = [UIColor clearColor ];
    pitchCreator.layer.cornerRadius = 0.1f;
    [[pitchCreator layer] setMasksToBounds:YES];
    
    pitchCreator.layer.borderColor = [UIColor colorWithRed:58.0f/255.0f green:186.0f/255.0f blue:76.0f/255.0f alpha:1 ].CGColor;
    pitchCreator.layer.borderWidth = 1.0f;
    
    [pitchCreator setTitleColor:[UIColor colorWithRed:58.0f/255.0f green:186.0f/255.0f blue:76.0f/255.0f alpha:1 ] forState:UIControlStateNormal];
    
}
- (IBAction)userTypeButtonPressed:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if (btn.tag==1)
    {
         userType = @"1";
         [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"userTypeString"];
        [self setClientButton];
    }
    else{
         userType = @"2";
         [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"userTypeString"];
        [self setJournalistsButton];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (IBAction)loginButtonPressed:(id)sender {
    
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
    else{
        [self loginAPI];
    }
}

- (IBAction)forgotPasswordClicked:(id)sender {
    ForgotPasswordViewController*obj;
    obj=[self.storyboard instantiateViewControllerWithIdentifier:@"forgotPassword"];
    [self.navigationController pushViewController:obj animated:YES];
}
-(void)loginAPI
{
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService=[[NSString alloc]initWithFormat:@"%@showcategory",AppURL];
    NSLog(@"%@",strWebService);
    NSDictionary *dictParams;
    
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"Token"]],@"Token",
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
                 [[NSUserDefaults standardUserDefaults]setObject:[response valueForKey:@"user_id"] forKey:@"userid"];
                 [[NSUserDefaults standardUserDefaults]setObject:@"loggedin" forKey:@"LoginStatus"];
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 
                 if ([userType isEqualToString:@"2"])
                 {
                     // journalist
                     [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"userTypeString"];
                     [[NSUserDefaults standardUserDefaults]synchronize];
                    PitchFeedJournalist_ViewController*ctl;
                     ctl=[self.storyboard instantiateViewControllerWithIdentifier:@"pitchFeedtest"];
                     
                     UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:ctl];
                     [navController setViewControllers: @[ctl] animated: YES];
                     SideMenuViewController *rearViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuList"];
                     SWRevealViewController *mainRevealController =[self.storyboard instantiateViewControllerWithIdentifier:@"RevealController"];
                     mainRevealController=[mainRevealController initWithRearViewController:rearViewController frontViewController:navController];
                     [self.navigationController pushViewController:mainRevealController animated:YES];
                 }
                 else{
                     // client
                     SWRevealViewController*revealcontroller;
                     revealcontroller=[self.storyboard instantiateViewControllerWithIdentifier:@"RevealController"];
                     [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"userTypeString"];
                     [[NSUserDefaults standardUserDefaults]synchronize];
                     [self.navigationController pushViewController:revealcontroller animated:YES];
                 }
            }
             else  if ([str isEqualToString:@"1"])
             {
                 if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"createAccount"] isEqualToString:@"signup1"]) {
                     RegisterPage2*obj;
                     obj=[self.storyboard instantiateViewControllerWithIdentifier:@"signUp2"];
                     [self.navigationController pushViewController:obj animated:YES];
                 }
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
             [constant alertViewWithMessage:@"Connectivity levels low. Please try again."withView:self];
             NSLog(@"Error returned:%@",[error localizedDescription]);
         }
     }];
}
-(void)resignKeyBoard{
    [emailTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}
#pragma mark ToolBar method
-(IBAction)cancelToolBar:(id)sender
{
    [self resignKeyBoard];
}
-(IBAction)doneToolBar:(id)sender
{
    [self resignKeyBoard];
}
- (IBAction)popview:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
