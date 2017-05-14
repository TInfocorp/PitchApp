//
//  ViewController.m
//  uPitch
//
//  Created by Puneet Rao on 04/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "LxReqRespManager.h"
#import "MainViewController.h"
#import "MainViewController_Client.h"
#import "SWRevealViewController.h"
#import "SideMenuViewController.h"
#import "PitchFeedJournalist_ViewController.h"
#import "LoginViewController.h"
#import "RegisterPage1.h"
#import "RegisterPage2.h"
#import "ForgotPasswordViewController.h"
#import "ProfileViewController.h"
#import "TandCViewController.h"
#import "constant.h"
#import "manageJournalistViewController.h"
#import "viewPitchesViewController_Journalists.h"

@interface ViewController ()
{
    NSString *strMsg;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginStatus"] isEqualToString:@"loggedin"])
    {
    [constant getIntialCountForUserId:[NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"userid"]] andDeviceId:[NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"deviceToken"]]];
        [self getLastMessageHistoryForUser:[USERDEFAULTS objectForKey:@"userid"] type:[USERDEFAULTS objectForKey:@"userTypeString"]];
    }
    [USERDEFAULTS setBool:NO forKey:@"FlagNot"];
    [USERDEFAULTS synchronize];
    
//    userType = @"1";
    [toolBar removeFromSuperview];
    emailTextField.inputAccessoryView = toolBar;
    passwordTextField.inputAccessoryView = toolBar;
    loginCreateAccountButton.layer.cornerRadius = 5;
    loginCreateAccountButton.layer.masksToBounds = YES;
    //23/01 highlight
    idArray            = [[NSMutableArray alloc]init];
    arrPitchId         = [[NSMutableArray alloc]init];
    chatDBId           = [[NSMutableArray alloc]init];
    
    emailImageView.layer.borderColor = [UIColor colorWithRed:63.0f/255.0f green:140.0f/255.0f blue:220.0f/255.0f alpha:1].CGColor;
    emailImageView.layer.borderWidth = 1;
    emailImageView.layer.cornerRadius = 5;
    emailImageView.layer.masksToBounds = YES;
    
    passwordImageView.layer.borderColor = [UIColor colorWithRed:63.0f/255.0f green:140.0f/255.0f blue:220.0f/255.0f alpha:1].CGColor;
    passwordImageView.layer.borderWidth = 1;
    passwordImageView.layer.cornerRadius = 5;
    passwordImageView.layer.masksToBounds = YES;
    [btnSignUp setTitleColor:[UIColor colorWithRed:45.0f/255.0f green:170.0f/255.0f blue:230.0f/255.0f alpha:1]forState: UIControlStateNormal];
    [btnLogin setTitleColor:[UIColor blackColor]forState: UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidChangeFrame:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidChangeShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [self setUpFrame];
    SWRevealViewController *revealController = [self revealViewController];
    revealController.panGestureRecognizer.enabled = NO;
    revealController.tapGestureRecognizer.enabled = NO;
    
    // _client = [CommonFunctions client];
    _client = [self client];
    appdelegateInstance = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [(AppDelegate*)appdelegateInstance setHUD:[[MBProgressHUD alloc] initWithView:[appdelegateInstance window]]];
    [[appdelegateInstance window] addSubview:[(AppDelegate*)appdelegateInstance HUD]];
    int xOfLogoImage = self.view.frame.size.width - self.view.frame.size.width/1.290;
    
    logoImageView.frame = CGRectMake(xOfLogoImage/2, logoImageView.frame.origin.y, self.view.frame.size.width/1.290, ((self.view.frame.size.width/1.290)/logoImageView.frame.size.width)*logoImageView.frame.size.height);
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginStatus"] isEqualToString:@"loggedin"]&&[[[NSUserDefaults standardUserDefaults]valueForKey:KEY_PROFILE_TAG]integerValue]==1)
    {
        //  [[NSUserDefaults standardUserDefaults]setObject:@"5" forKey:@"userid"];
        // userType=@"1";
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"userTypeString"] isEqualToString:@"2"])
        {
            if(([[NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"typeNot"]] isEqualToString:@"8"] || [[NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"typeNot"]] isEqualToString:@"12"])&& [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"isFromNotification"]])
            {
                [USERDEFAULTS removeObjectForKey:@"isFromNotification"];
                [USERDEFAULTS setBool:NO forKey:@"FlagNot"];
                [USERDEFAULTS removeObjectForKey:@"typeNot"];

                [USERDEFAULTS setObject:@"showChatScreen" forKey:@"directCall"];
                [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"userTypeString"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                viewPitchesViewController_Journalists*ctl;
                ctl=[self.storyboard instantiateViewControllerWithIdentifier:@"viewPitches"];
                //ctl.comeTag=@"Prof";
                ctl.matchesChatString = @"2";
                
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:ctl];
                [navController setViewControllers: @[ctl] animated: YES];
                SideMenuViewController *rearViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuList"];
                SWRevealViewController *mainRevealController =[self.storyboard instantiateViewControllerWithIdentifier:@"RevealController"];
                mainRevealController=[mainRevealController initWithRearViewController:rearViewController frontViewController:navController];
                [self.navigationController pushViewController:mainRevealController animated:NO];;
                
            }else
            {
                // journalist
                
                [USERDEFAULTS removeObjectForKey:@"typeNot"];
                [USERDEFAULTS setBool:NO forKey:@"FlagNot"];
                
                [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"userTypeString"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                
                PitchFeedJournalist_ViewController*ctl;
                ctl=[self.storyboard instantiateViewControllerWithIdentifier:@"pitchFeedtest"];
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:ctl];
                [navController setViewControllers: @[ctl] animated: YES];
                SideMenuViewController *rearViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuList"];
                SWRevealViewController *mainRevealController =[self.storyboard instantiateViewControllerWithIdentifier:@"RevealController"];
                mainRevealController=[mainRevealController initWithRearViewController:rearViewController frontViewController:navController];
                [self.navigationController pushViewController:mainRevealController animated:NO];
                
            }
            
        }
        else  if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"userTypeString"] isEqualToString:@"1"])
        {
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"userTypeString"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            
            if ([[NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"typeNot"] ] isEqualToString:@"2"] && [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"isFromNotification"]])
            {
                [USERDEFAULTS removeObjectForKey:@"isFromNotification"];
                [USERDEFAULTS removeObjectForKey:@"typeNot"];
                [USERDEFAULTS setBool:NO forKey:@"FlagNot"];
                [USERDEFAULTS synchronize];
                manageJournalistViewController*ctl;
                ctl=[self.storyboard instantiateViewControllerWithIdentifier:@"manageJournalists"];
                //ctl.comeTag=@"Prof";
                ctl.matchesChatString = @"1";
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:ctl];
                [navController setViewControllers: @[ctl] animated: YES];
                SideMenuViewController *rearViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuList"];
                SWRevealViewController *mainRevealController =[self.storyboard instantiateViewControllerWithIdentifier:@"RevealController"];
                mainRevealController=[mainRevealController initWithRearViewController:rearViewController frontViewController:navController];
                [self.navigationController pushViewController:mainRevealController animated:NO];;
            }else if(([[NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"typeNot"] ] isEqualToString:@"8"] ||[[NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"typeNot"] ] isEqualToString:@"12"] ) && [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"isFromNotification"]])
            {
                [USERDEFAULTS setObject:@"showChatScreen" forKey:@"directCall"];
                [USERDEFAULTS removeObjectForKey:@"isFromNotification"];
                [USERDEFAULTS setBool:NO forKey:@"FlagNot"];
                [USERDEFAULTS synchronize];
                manageJournalistViewController*ctl;
                ctl=[self.storyboard instantiateViewControllerWithIdentifier:@"manageJournalists"];
                //ctl.comeTag=@"Prof";
                ctl.matchesChatString = @"2";
                
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:ctl];
                [navController setViewControllers: @[ctl] animated: YES];
                SideMenuViewController *rearViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuList"];
                SWRevealViewController *mainRevealController =[self.storyboard instantiateViewControllerWithIdentifier:@"RevealController"];
                mainRevealController=[mainRevealController initWithRearViewController:rearViewController frontViewController:navController];
                [self.navigationController pushViewController:mainRevealController animated:NO];;
                
            }
            else
            {
                // client
                [USERDEFAULTS removeObjectForKey:@"typeNot"];
                [USERDEFAULTS setBool:NO forKey:@"FlagNot"];
                [USERDEFAULTS synchronize];
                
                SWRevealViewController*revealcontroller;
                revealcontroller=[self.storyboard instantiateViewControllerWithIdentifier:@"RevealController"];
                [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"userTypeString"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [self.navigationController pushViewController:revealcontroller animated:NO];
            }
            
            
        }
    }else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginStatus"] isEqualToString:@"loggedin"]&&[[[NSUserDefaults standardUserDefaults]valueForKey:KEY_PROFILE_TAG]integerValue]==0)
    {
        [USERDEFAULTS removeObjectForKey:@"typeNot"];
        [USERDEFAULTS setBool:NO forKey:@"FlagNot"];
        [USERDEFAULTS synchronize];
        
        ProfileViewController*ctl;
        ctl=[self.storyboard instantiateViewControllerWithIdentifier:@"profileController"];
        ctl.statusLogin=@"firstLogin";
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:ctl];
        [navController setViewControllers: @[ctl] animated: YES];
        SideMenuViewController *rearViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuList"];
        SWRevealViewController *mainRevealController =[self.storyboard instantiateViewControllerWithIdentifier:@"RevealController"];
        mainRevealController=[mainRevealController initWithRearViewController:rearViewController frontViewController:navController];
        [self.navigationController pushViewController:mainRevealController animated:YES];
    }
    
    self.navigationController.navigationBar.hidden=YES;
    // Disable iOS 7 back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    [USERDEFAULTS removeObjectForKey:@"typeNot"];
    [USERDEFAULTS synchronize];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)deleteLastMessageChat
{
   bool a = [[Database sharedObject] deleteData:@"delete from lastMessageMaster"];

}
-(void)deleteAllChat
{
    bool a = [[Database sharedObject] deleteData:@"delete from latestMessageMaster"];

}
-(void)showClientSetting
{
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"userTypeString"] isEqualToString:@"1"])
    {
        strWebService=[[NSString alloc]initWithFormat:@"%@show_client_setting",AppURL];
        
    }else
    {
        strWebService=[[NSString alloc]initWithFormat:@"%@showsetting",AppURL];
    }
    NSLog(@"%@",strWebService);
    NSDictionary *dictParams;
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",nil];
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSString *strMessageSwitch = [NSString stringWithFormat:@"%@",[[[response valueForKey:@"data"] valueForKey:@"Userlink"] valueForKey:@"message_notification"]];
             if ([strMessageSwitch isEqualToString:@"1"])
             {
                 [USERDEFAULTS setBool:NO forKey:@"messageNotificaitonOnOff"];
                 [USERDEFAULTS synchronize];
                 
             }
             else
             {
                 [USERDEFAULTS setBool:YES forKey:@"messageNotificaitonOnOff"];
                 [USERDEFAULTS synchronize];
             }
             
         }
     }];
}

-(void)setUpFrame
{
    
    if (IS_IPHONE_6 || IS_IPHONE_6_PLUS)
    {
        clientCheckImageView.frame=CGRectMake(clientCheckImageView.frame.origin.x-2, clientCheckImageView.frame.origin.y-2, clientCheckImageView.frame.size.width+4, clientCheckImageView.frame.size.height+4);
        
        journalistCheckImageView.frame=CGRectMake(journalistCheckImageView.frame.origin.x-2, journalistCheckImageView.frame.origin.y-2, journalistCheckImageView.frame.size.width+4,journalistCheckImageView.frame.size.height+4);
        [lblClient setFont:[UIFont systemFontOfSize:15]];
        [lblJournalist setFont:[UIFont systemFontOfSize:15]];
    }
    
    
    
}
-(BOOL)validateEmailWithString:(NSString*)email1
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email1];
}

#pragma mark View delegate
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    emailTextField.text =@"";
    passwordTextField.text =@"";
    [showHideButton setTitle:@"Show" forState:UIControlStateNormal];
    showPassowrdBool = NO;
    passwordTextField.enabled = YES;
    passwordTextField.secureTextEntry = YES;
    passwordTextField.enabled = YES;
    [super viewWillDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    //     self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    //    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    
    
    if ([loginCreateAccountButton.titleLabel.text isEqualToString:@"CREATE ACCOUNT"]) {
        [loginCreateAccountButton setBackgroundColor:[UIColor colorWithRed:45.0f/255.0f green:170.0f/255.0f blue:230.0f/255.0f alpha:1]];
    }else{
        [loginCreateAccountButton setBackgroundColor:[UIColor colorWithRed:243.0f/255.0f green:203.0f/255.0f blue:52.0f/255.0f alpha:1]];
    }
    [super viewWillAppear:animated];
    SWRevealViewController *revealController = [self revealViewController];
    revealController.panGestureRecognizer.enabled = NO;
    revealController.tapGestureRecognizer.enabled = NO;
    [journalistCheckImageView setImage:[UIImage imageNamed:@"un_selected"]];
    [clientCheckImageView setImage:[UIImage imageNamed:@"un_selected"]];
    userType = @"";
    
    
}
- (IBAction)loginToExistingAccount:(id)sender
{
    LoginViewController*obj;
    obj=[self.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
    [self.navigationController pushViewController:obj animated:YES];
    
}

- (IBAction)newUserAction:(id)sender {
    RegisterPage1*obj;
    obj=[self.storyboard instantiateViewControllerWithIdentifier:@"signUp1"];
    [self.navigationController pushViewController:obj animated:YES];
}

#pragma mark TextField Delegate

-(void)keyboardDidChangeShow:(NSNotification *)notification
{
    //toolBar.hidden=NO;
}


- (void)keyboardDidChangeFrame:(NSNotification *)notification
{
    
    
    [self doneToolBar:nil];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    // code password validation
    //    BOOL lowerCaseLetter=NO,upperCaseLetter=NO,digit=NO,specialCharacter = 0;
    //    if([textField.text length] >= 6)
    //    {
    //        for (int i = 0; i < [passwordTextField.text length]; i++)
    //        {
    //            unichar c = [passwordTextField.text characterAtIndex:i];
    //            if(!lowerCaseLetter)
    //            {
    //                lowerCaseLetter = [[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:c];
    //            }
    //            if(!upperCaseLetter)
    //            {
    //                upperCaseLetter = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:c];
    //            }
    //            if(!digit)
    //            {
    //                digit = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c];
    //            }
    //            if(!specialCharacter)
    //            {
    //                specialCharacter = [[NSCharacterSet symbolCharacterSet] characterIsMember:c];
    //            }
    //        }
    //
    //        if(specialCharacter && digit && lowerCaseLetter && upperCaseLetter)
    //        {
    //            //do what u want
    //        }
    //        else
    //        {
    //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
    //                                                            message:@"Please Ensure that you have at least one lower case letter, one upper case letter, one digit and one special character"
    //                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //            [alert show];
    //        }
    //
    //    }
    //    else
    //    {
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
    //                                                        message:@"Please Enter at least 6 password"
    //                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //        [alert show];
    //    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField==passwordTextField)
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
            //            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"upitch" message:@"Password maximum limit 20 characters."delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            //            [alert show];
            [constant alertViewWithMessage:@"Password maximum limit 20 characters." withView:self];
            return NO;
        }
        
    }
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resignKeyBoard];
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+200);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        //        scrollView.contentSize = CGSizeMake(768, 750);
        scrollView.contentOffset = CGPointMake(0, textField.tag*50+45);
    }
    else{
        scrollView.contentOffset = CGPointMake(0, textField.tag*40+45);
    }
    
    return YES;
}
- (IBAction)linkedInButtonPressed:(id)sender {
    
    // [appdelegateInstance showHUD:@""];
    UIButton *btn = (UIButton*)sender;
    if (btn.tag ==1) {
        //client
        userType = @"1";
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"userTypeString"];
    }
    else{
        // journalist
        userType = @"2";
        [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"userTypeString"];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [_client getAuthorizationCode:^(NSString *code) {
        
        [_client getAccessToken:code success:^(NSDictionary *accessTokenData)
         {
             NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
             NSLog(@"%@",accessToken);
             [appdelegateInstance showHUD:@""];
             [self requestMeWithToken:accessToken];
         }                   failure:^(NSError *error) {
             [appdelegateInstance hideHUD];
             NSLog(@"Quering accessToken failed %@", error);
         }];
    }                      cancel:^{
        NSLog(@"Authorization was cancelled by user");
        //        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Authorization was cancelled by user" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //        [alert show];
        [constant alertViewWithMessage:@"Authorization was cancelled by user."withView:self];
        [appdelegateInstance hideHUD];
    }                     failure:^(NSError *error) {
        [appdelegateInstance hideHUD];
        NSLog(@"Authorization failed %@", error);
        //        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Authorization failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //        [alert show];
        [constant alertViewWithMessage:@"Authorization failed."withView:self];
    }];
}
#pragma mark Create account

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        NSLog(@"Pitch Creator");
        RegisterPage1*obj;
        obj=[self.storyboard instantiateViewControllerWithIdentifier:@"signUp1"];
        obj.userTypeString = @"1";
        [self.navigationController pushViewController:obj animated:YES];
    }
    else if (buttonIndex==1) {
        NSLog(@"Journalist");
        RegisterPage1*obj;
        obj=[self.storyboard instantiateViewControllerWithIdentifier:@"signUp1"];
        obj.userTypeString = @"2";
        [self.navigationController pushViewController:obj animated:YES];
    }
    else if (buttonIndex==2) {
        NSLog(@"cancel");
    }
}
- (LIALinkedInHttpClient *)client {
    LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:@"https://localhost"
                                                                                    clientId:LINKED_ID_API_KEY
                                                                                clientSecret:LINKED_ID_SECURE_KEY
                                                                                       state:@"DCEEFWF45453sdffef424"
                                                                               grantedAccess:@[@"r_emailaddress",@"r_basicprofile"]];
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
}
- (void)requestMeWithToken:(NSString *)accessToken
{
    [appdelegateInstance showHUD:@""];
    NSLog(@"%@",[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,firstName,lastName,email-address,phone-numbers,num-connections,pictureUrl,threeCurrentPositions,Positions,industry,headline,educations:(school-name,field-of-study,start-date,end-date,degree,activities))?oauth2_access_token=%@&format=json",accessToken]);
    [_client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,firstName,lastName,email-address,phone-numbers,connections,pictureUrl,threeCurrentPositions,Positions,industry,headline,educations:(school-name,field-of-study,start-date,end-date,degree,activities))?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result)
     {
         NSLog(@"current user %@", result);
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSString *jsonString ;
             NSError *error;
             NSData *jsonData = [NSJSONSerialization dataWithJSONObject:result
                                                                options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                  error:&error];
             if (! jsonData) {
                 NSLog(@"Got an error: %@", error);
             } else {
                 jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                 // NSLog(@"%@",jsonString);
             }
             [self RunAPI:[NSString stringWithFormat:@"%@ %@",[result valueForKey:@"firstName"],[result valueForKey:@"lastName"]] :[result valueForKey:@"id"] :[[[[[result valueForKey:@"positions"] valueForKey:@"values"] objectAtIndex:0] valueForKey:@"company"] valueForKey:@"name"] :[result valueForKey:@"headline"] :[result valueForKey:@"pictureUrl"] : jsonString];
         }
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"failed to fetch current user %@", error);
             [appdelegateInstance hideHUD];
         }];
}
#pragma mark Login action
- (IBAction)userTypeButtonPressed:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if (btn.tag==1) {
        [clientCheckImageView setImage:[UIImage imageNamed:@"selected.png"]];
        [journalistCheckImageView setImage:[UIImage imageNamed:@"un_selected"]];
        userType = @"1";
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"userTypeString"];
    }
    else{
        [clientCheckImageView setImage:[UIImage imageNamed:@"un_selected"]];
        [journalistCheckImageView setImage:[UIImage imageNamed:@"selected.png"]];
        userType = @"2";
        [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"userTypeString"];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (IBAction)loginButtonPressed:(id)sender
{
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
    else if (passwordTextField.text.length<6 &&![loginCreateAccountButton.titleLabel.text isEqualToString:@"LOG IN"])
    {
        //        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter atleast 6 characters." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //        [alert show];
        [constant alertViewWithMessage:@"Please enter at least 6 characters for your PASSWORD."withView:self];
    }else if([userType isEqualToString:@""])
    {
        [constant alertViewWithMessage:@"Please select account type."withView:self];
        
    }    else
    {
        [self loginAPI];
    }
}
-(void)loginAPI
{
    [self resignKeyBoard];
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
    NSDictionary *dictParams;
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"] length]<10) {
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"deviceToken"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    if ([loginCreateAccountButton.titleLabel.text isEqualToString:@"LOG IN"]) {
        strWebService=[[NSString alloc]initWithFormat:@"%@login",AppURL];
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:emailTextField.text,@"email",passwordTextField.text,@"password",
                    userType,@"type",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"]],@"device_id",
                    nil];
    }
    else{
        strWebService=[[NSString alloc]initWithFormat:@"%@registration",AppURL];
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:emailTextField.text,@"email",passwordTextField.text,@"password",userType,@"type",[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"],@"device_id",nil];
    }
    [[NSUserDefaults standardUserDefaults]setObject:emailTextField.text forKey:KEY_Email];
    [[NSUserDefaults standardUserDefaults]setObject:passwordTextField.text forKey:KEY_Password];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    NSLog(@"%@",strWebService);
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
           [self getMessageHistoryForUser:[NSString stringWithFormat:@"%@",[response objectForKey:@"user_id"]] type:userType];
             [appdelegateInstance hideHUD];
             [[NSUserDefaults standardUserDefaults]setObject:@"loggedin" forKey:@"LoginStatus"];
             
             [USERDEFAULTS setBool:YES forKey:@"isUserFirstTime"];
             [USERDEFAULTS setBool:YES forKey:ISFIRSTTIMERIGHTJOURNALIST];
             [USERDEFAULTS setBool:YES forKey:ISFIRSTTIMELEFTJOURALIST];
             [USERDEFAULTS synchronize];
             if ([[NSString stringWithFormat:@"%@",[response objectForKey:@"user_id"]] isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]]]) {
                 
             }else
             {
                 [[NSUserDefaults standardUserDefaults]setObject:[response valueForKey:@"user_id"] forKey:@"userid"];
                 [self deleteDbData];
                 
             }
             NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             if ([str isEqualToString:@"0"])
             {
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:LINKEDIN_TOKEN_KEY];
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:LINKEDIN_EXPIRATION_KEY];
                 
                 NSString*str1=[NSString stringWithFormat:@"%@",[response valueForKey:@"profile_tag"]];
                 [[NSUserDefaults standardUserDefaults]setObject:str1 forKey:KEY_PROFILE_TAG];
                 [[NSUserDefaults standardUserDefaults]setObject:@"onsignup" forKey:@"first"];
                 [[NSUserDefaults standardUserDefaults]setObject:[response valueForKey:@"user_id"] forKey:@"userid"];
                 if ([loginCreateAccountButton.titleLabel.text isEqualToString:@"LOG IN"])
                 {
                     
                     [USERDEFAULTS setObject:[NSString stringWithFormat:@"%@",[response valueForKey:@"first_name"]] forKey:@"username"];
                     [USERDEFAULTS setObject:[NSString stringWithFormat:@"%@ %@",[response valueForKey:@"first_name"],[response valueForKey:@"last_name"]] forKey:@"fullName"];
                     [USERDEFAULTS setObject:@"loggedin" forKey:@"LoginStatus"];
                     [USERDEFAULTS setObject:@"NotOnSignup" forKey:@"first"];
                     [USERDEFAULTS setObject:@"2" forKey:@"userTypeString"];
                     
                     
                     [USERDEFAULTS synchronize];
                     if ([userType isEqualToString:@"2"])
                     {
                         // journalist
                         [USERDEFAULTS setObject:@"2" forKey:@"userTypeString"];
                         [USERDEFAULTS synchronize];



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
                 else
                 {
                     NSString*str1=[NSString stringWithFormat:@"%@",[response valueForKey:@"profile_tag"]];
                     if ([str1 isEqualToString:@"0"])
                     {
                         [USERDEFAULTS setObject:@"View" forKey:@"view"];
                     }
                     
                     [USERDEFAULTS setObject:[response valueForKey:@"user_id"] forKey:@"userid"];
                     
                     [USERDEFAULTS synchronize];
                     [USERDEFAULTS setObject:userType forKey:@"userTypeString"];
                     [USERDEFAULTS synchronize];
                     
                     if ([str1 isEqualToString:@"1"])
                     {
                         
                         [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[response valueForKey:@"first_name"]] forKey:@"username"];
                         NSLog(@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"username"]);
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
                     else{
                         ProfileViewController*ctl;
                         ctl=[self.storyboard instantiateViewControllerWithIdentifier:@"profileController"];
                         ctl.comeTag=@"Prof";
                         UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:ctl];
                         [navController setViewControllers: @[ctl] animated: YES];
                         SideMenuViewController *rearViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuList"];
                         SWRevealViewController *mainRevealController =[self.storyboard instantiateViewControllerWithIdentifier:@"RevealController"];
                         mainRevealController=[mainRevealController initWithRearViewController:rearViewController frontViewController:navController];
                         [self.navigationController pushViewController:mainRevealController animated:YES];
                     }
                     //                      RegisterPage2*obj;
                     //                      obj=[self.storyboard instantiateViewControllerWithIdentifier:@"signUp2"];
                     //                      [self.navigationController pushViewController:obj animated:YES];
                 }
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 [self showClientSetting];
             }
             else  if ([str isEqualToString:@"2"])
             {
                 if ([loginCreateAccountButton.titleLabel.text isEqualToString:@"LOG IN"])
                 {
                     
                     [[NSUserDefaults standardUserDefaults]setObject:[response valueForKey:@"user_id"] forKey:@"userid"];
                     [[NSUserDefaults standardUserDefaults]setObject:@"0"forKey:KEY_PROFILE_TAG];
                     //                      [[NSUserDefaults standardUserDefaults]synchronize];
                     //                      UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     //                      alert.tag = 100;
                     //                      [alert show];
                     [[NSUserDefaults standardUserDefaults]setObject:userType forKey:@"userTypeString"];
                     [[NSUserDefaults standardUserDefaults]synchronize];
                     ProfileViewController*ctl;
                     ctl=[self.storyboard instantiateViewControllerWithIdentifier:@"profileController"];
                     //ctl.comeTag=@"Prof";
                     
                     UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:ctl];
                     [navController setViewControllers: @[ctl] animated: YES];
                     SideMenuViewController *rearViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuList"];
                     SWRevealViewController *mainRevealController =[self.storyboard instantiateViewControllerWithIdentifier:@"RevealController"];
                     mainRevealController=[mainRevealController initWithRearViewController:rearViewController frontViewController:navController];
                     [self.navigationController pushViewController:mainRevealController animated:YES];
                     
                 }
                 else{
                     //                      UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     //                      [alert show];
                     [constant alertViewWithMessage:[response valueForKey:@"message"]withView:self];
                 }
                 [self showClientSetting];
             }
             else
             {
                 
                 if (response == nil||response == (id)[NSNull null])
                 {
                     //                     UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"upitch" message:@"An unknown error has occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     //                     [alert show];
                     [constant alertViewWithMessage:@"An unknown error has occurred."withView:self];
                 }
                 else
                 {
                     //                     UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     //                     [alert show];
                     [constant alertViewWithMessage:[response valueForKey:@"message"]withView:self];
                 }
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
// changes for highlight 25/01
-(void)deleteDbData
{
}
-(void)fillMessageToDB:(NSMutableArray*)arrMessage
{
    for(int i = 0;i<arrMessage.count;i++)
    {
        NSDictionary *dictData = [arrMessage objectAtIndex:i] ;
        
        NSString*time = @"";
        NSString*messageStr = @"";
        NSString*to = @"";
        NSString*from = @"";
        NSString *type = @"";
        NSString*strFinalOpponentName = @"";
        from = [[[dictData objectForKey:@"fromJID"] componentsSeparatedByString:@"@"] objectAtIndex:0];
        to = [[[dictData objectForKey:@"toJID"] componentsSeparatedByString:@"@"] objectAtIndex:0];
        time = [dictData objectForKey:@"sentDate"];
        time = [self timestamp2date:time];
        
        //        from = [[[userInfo objectForKey:@"from"] componentsSeparatedByString:@"@"] objectAtIndex:0];
        //        to = [[[userInfo objectForKey:@"to"] componentsSeparatedByString:@"@"] objectAtIndex:0];
        //        time = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"time"]];
        //        time = [APPDELEGATE timestamp2date:time];
        //        messageStr = [userInfo objectForKey:@"message"];
        NSString*messageThreadID = @"";
        type = [dictData objectForKey:@"type"];
        messageStr = [dictData objectForKey:@"body"];
        NSString *strIsRead ;
        if ([type integerValue]==2)
        {
            strIsRead =  @"0";
            
        }else
        {
            strIsRead =  @"1";
            
        }
        NSDictionary *dicTemp;
        dicTemp = [NSDictionary dictionaryWithObjectsAndKeys:messageStr, @"lastMessage",
                   from.uppercaseString, @"lastMessageFromUser",
                   time, @"messageTime",
                   to.uppercaseString, @"opponentXMPPID",
                   strFinalOpponentName,@"opponentDisplayName",
                   strIsRead,@"isRead",type,@"userType",
                   nil];
        //                    Database *database = [Database sharedObject];
        
        //        int tID = (int)[database insertToTable:@"latestMessageMaster" withValues:dicTemp];
        int tID = [APPDELEGATE insertMessage:dicTemp];
    }
//    NSString*time = [[arrMessage lastObject] objectForKey:@"sentDate"];
//    NSString*messageStr = [[arrMessage lastObject] objectForKey:@"body"];
//    NSString*to = @"";
//    NSString*from =[[[[arrMessage lastObject] objectForKey:@"fromJID"] componentsSeparatedByString:@"@"] objectAtIndex:0];
//    NSString *type = [[arrMessage lastObject] objectForKey:@"type"];
//    NSString *strIsRead ;
//    
//    if ([type integerValue]==2)
//    {
//        strIsRead =  @"0";
//        
//    }else
//    {
//        strIsRead =  @"1";
//        
//    }
//    NSString*strFinalOpponentName = @"";
//    NSDictionary *dicTemp;
//    dicTemp = [NSDictionary dictionaryWithObjectsAndKeys:messageStr, @"lastMessage",
//               from.uppercaseString, @"lastMessageFromUser",
//               time, @"messageTime",
//               to.uppercaseString, @"opponentXMPPID",
//               strFinalOpponentName,@"opponentDisplayName",
//               strIsRead,@"isRead",@"2",@"userType",
//               nil];
//    Database *database = [Database sharedObject];
//    
//    int tID1 = (int)[database insertToTable:@"lastMessageMaster" withValues:dicTemp];
//    NSLog(@"%d",tID1);
    
    [self getLastMessageHistoryForUser:[USERDEFAULTS objectForKey:@"userid"] type:[USERDEFAULTS objectForKey:@"userTypeString"]];

}

-(void)lastMessagefillMessageToDB:(NSMutableArray*)arrMessage
{
//    NSSortDescriptor *sortDescriptor;
//    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastmessagetime"
//                                                 ascending:YES];
//    NSMutableArray *sortDescriptors = [NSMutableArray arrayWithObject:sortDescriptor];
//    NSMutableArray *sortedArray = [arrMessage sortedArrayUsingDescriptors:sortDescriptors];
//    arrMessage = sortedArray;
    for(int i = 0;i<arrMessage.count;i++)
    {
        NSDictionary *dictData = [arrMessage objectAtIndex:i] ;
        
        NSString*time = @"";
        NSString*messageStr = @"";
        NSString*to = @"";
        NSString*from = @"";
        NSString *type = @"";
        NSString*strFinalOpponentName = @"";
        from = [[[dictData objectForKey:@"fromJID"] componentsSeparatedByString:@"@"] objectAtIndex:0];
        to = [[[dictData objectForKey:@"toJID"] componentsSeparatedByString:@"@"] objectAtIndex:0];
        time = [dictData objectForKey:@"sentDate"];
        time = [self timestamp2date:time];

//        from = [[[userInfo objectForKey:@"from"] componentsSeparatedByString:@"@"] objectAtIndex:0];
//        to = [[[userInfo objectForKey:@"to"] componentsSeparatedByString:@"@"] objectAtIndex:0];
//        time = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"time"]];
//        time = [APPDELEGATE timestamp2date:time];
//        messageStr = [userInfo objectForKey:@"message"];
        type = [dictData objectForKey:@"type"];
        messageStr = [dictData objectForKey:@"body"];
        NSString *strIsRead ;
        if ([type integerValue]==2)
        {
            strIsRead =  @"0";

        }else
        {
            strIsRead =  @"1";

        }
            NSDictionary *dicTemp;
            dicTemp = [NSDictionary dictionaryWithObjectsAndKeys:messageStr, @"lastMessage",
                       from.uppercaseString, @"lastMessageFromUser",
                       time, @"messageTime",
                       to.uppercaseString, @"opponentXMPPID",
                       strFinalOpponentName,@"opponentDisplayName",
                       strIsRead,@"isRead",type,@"userType",
                       nil];
        
                    int Flag = (int)[ [Database sharedObject] insertToTable:@"lastMessageMaster" withValues:dicTemp];
                    NSLog(@"%d",Flag);
    }
//    NSString*time = [[arrMessage lastObject] objectForKey:@"sentDate"];
//    NSString*messageStr = [[arrMessage lastObject] objectForKey:@"body"];
//    NSString*to = @"";
//    NSString*from =[[[[arrMessage lastObject] objectForKey:@"fromJID"] componentsSeparatedByString:@"@"] objectAtIndex:0];
//    NSString *type = [[arrMessage lastObject] objectForKey:@"type"];
//    NSString *strIsRead ;
//
//    if ([type integerValue]==2)
//    {
//        strIsRead =  @"0";
//        
//    }else
//    {
//        strIsRead =  @"1";
//        
//    }
//    NSString*strFinalOpponentName = @"";
//    NSDictionary *dicTemp;
//    dicTemp = [NSDictionary dictionaryWithObjectsAndKeys:messageStr, @"lastMessage",
//               from.uppercaseString, @"lastMessageFromUser",
//               time, @"messageTime",
//               to.uppercaseString, @"opponentXMPPID",
//               strFinalOpponentName,@"opponentDisplayName",
//               strIsRead,@"isRead",@"2",@"userType",
//               nil];
//    Database *database = [Database sharedObject];
//    
//    int tID1 = (int)[database insertToTable:@"lastMessageMaster" withValues:dicTemp];
//    NSLog(@"%d",tID1);

    
}
-(NSString*)timestamp2date:(NSString*)timestamp
{
    //[timeStampString stringByAppendingString:@"000"];   //convert to ms
    double time = [timestamp doubleValue]/1000;
    
    NSTimeInterval _interval=time;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setTimeZone:[NSTimeZone localTimeZone]];
    [_formatter setDateFormat:@"dd/MM/yy HH:mm:ss.SSS"];
    return [_formatter stringFromDate:date];
}
-(void)getLastMessageHistoryForUser:(NSString*)userID type:(NSString*)usertype;
{
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
    NSDictionary *dictParams;
    if ([usertype isEqualToString:@"1"])
    {
        strWebService=[[NSString alloc]initWithFormat:XmppHistoryPitcher];
    }else
    {
        strWebService=[[NSString alloc]initWithFormat:XmppHistoryJournalist];
    }
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:userID,@"user_id",usertype,@"type",
                nil];
    NSLog(@"%@",strWebService);
    NSLog(@"%@",dictParams);
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSMutableArray *messageArr = [[NSMutableArray alloc] init];
             messageArr = [response objectForKey:@"data"];
             NSLog(@"response of get request:%@",response);
             [self deleteLastMessageChat];
             [self lastMessagefillMessageToDB:messageArr];
             
         }
     }
     ];
}

-(void)getMessageHistoryForUser:(NSString*)userID type:(NSString*)usertype;
{
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
    NSDictionary *dictParams;
    if ([usertype isEqualToString:@"1"])
    {
        strWebService=[[NSString alloc]initWithFormat:XmppHistoryPitcher];
    }else
    {
        strWebService=[[NSString alloc]initWithFormat:XmppHistoryJournalist];
    }
    
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:userID,@"user_id",usertype,@"type",
                nil];
    
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSMutableArray *messageArr = [[NSMutableArray alloc] init];
             messageArr = [response objectForKey:@"data"];
             NSLog(@"response of get request:%@",response);
             [self deleteAllChat];
             [self fillMessageToDB:messageArr];

         }
     }
     ];
}
//-(void)getIDArray
//{
//    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
//    
//    NSString*strWebService;
//    NSDictionary *dictParams;
//    chatDBId = [[NSMutableArray alloc] init];
//    strWebService=[[NSString alloc]initWithFormat:@"%@show_chat",AppURL];
//    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",
//                nil];
//    NSLog(@"%@",strWebService);
//    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
//     {
//         if (!error)
//         {
//             NSLog(@"response of get request:%@",response);
//             NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
//             if ([str isEqualToString:@"0"] )
//             {
//                 idArray=[[NSMutableArray alloc]init];
//                 arrPitchId=[[NSMutableArray alloc]init];
//                 for (int k=0; k<[[response valueForKey:@"data"] count]; k++) {
//                     [idArray addObject:[[[[response valueForKey:@"data"] valueForKey:@"b"] valueForKey:@"user_id"] objectAtIndex:k]];
//                     [arrPitchId addObject:[[[[response valueForKey:@"data"] valueForKey:@"0"] valueForKey:@"pitch_id"] objectAtIndex:k]];
//                     NSString *strChatID;
//                     
//                     strChatID = [NSString stringWithFormat:@"%@_%@_%@",[[[[response valueForKey:@"data"] valueForKey:@"b"] valueForKey:@"user_id"] objectAtIndex:k],[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],[[[[response valueForKey:@"data"] valueForKey:@"0"] valueForKey:@"pitch_id"] objectAtIndex:k]];
//                     ;
//                     
//                     
//                     [chatDBId addObject:strChatID];
//                     
//                     
//                 }
//             }
//             [self saveSetData:chatDBId];
//             
//         }
//     }];
//}
//-(void)saveSetData:(NSMutableArray*)chatId
//{
//    
//    for (int i = 0; i< chatDBId.count; i++) {
//        sqlite3_stmt    *statement;
//        const char *dbpath = [databasePath UTF8String];
//        
//        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
//        {
//            NSString *insertSQL = [NSString stringWithFormat:
//                                   @"INSERT INTO uPitchChat (channelName, status,message) VALUES (\"%@\", \"%d\", \"%@\")",
//                                   [chatId objectAtIndex:i],0,@"test"];
//            NSLog(@"insert query %@",insertSQL);
//            
//            const char *insert_stmt = [insertSQL UTF8String];
//            sqlite3_prepare_v2(contactDB, insert_stmt,
//                               -1, &statement, NULL);
//            if (sqlite3_step(statement) == SQLITE_DONE)
//            {
//                
//                NSLog(@"Contact added");
//                
//                
//            } else {
//                NSLog(@"Failed to add contact");
//            }
//            sqlite3_finalize(statement);
//            sqlite3_close(contactDB);
//        }
//        
//        
//    }
//    
//}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        [[NSUserDefaults standardUserDefaults]setObject:userType forKey:@"userTypeString"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        ProfileViewController*ctl;
        ctl=[self.storyboard instantiateViewControllerWithIdentifier:@"profileController"];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:ctl];
        [navController setViewControllers: @[ctl] animated: YES];
        SideMenuViewController *rearViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuList"];
        SWRevealViewController *mainRevealController =[self.storyboard instantiateViewControllerWithIdentifier:@"RevealController"];
        mainRevealController=[mainRevealController initWithRearViewController:rearViewController frontViewController:navController];
        [self.navigationController pushViewController:mainRevealController animated:YES];
    }
    if (alertView.tag==1000) {
        ForgotPasswordViewController*obj;
        obj=[self.storyboard instantiateViewControllerWithIdentifier:@"forgotPassword"];
        obj.strMessage=strMsg;
        obj.strClientJournalist=[NSString stringWithFormat:@"%@",userType];
        [self.navigationController pushViewController:obj animated:YES];
        
    }
}
-(void)resignKeyBoard{
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        scrollView.contentSize = CGSizeMake(768, 750);
    }
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
#pragma mark Forgot Password
- (IBAction)forgotPasswordClicked:(id)sender
{
    //    ForgotPasswordViewController*obj;
    //    obj=[self.storyboard instantiateViewControllerWithIdentifier:@"forgotPassword"];
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
    }else if([userType isEqualToString:@""])
    {
        [constant alertViewWithMessage:@"Please select account type."withView:self];
        
    }
    else{
        [self.view endEditing:YES];
        [self sendMailApi];
    }
    
}


-(void)sendMailApi
{
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
    NSDictionary *dictParams;
    
    // forgot password
    strWebService=[[NSString alloc]initWithFormat:@"%@forgot_password",AppURL];
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:
                emailTextField.text,@"email",
                userType,@"type"
                ,
                nil];
    [[NSUserDefaults standardUserDefaults]setObject:emailTextField.text forKey:KEY_Email];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"%@",dictParams);
    NSLog(@"%@",strWebService);
    
    
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
             [appdelegateInstance hideHUD];
             NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             
             strMsg=[response valueForKey:@"message"];
             if ([str isEqualToString:@"0"])
             {
                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 alert.tag = 1000;
                 [alert show];
             }
             else  if ([str isEqualToString:@"1"])
             {
                 //                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 //                 [alert show];
                 [constant alertViewWithMessage:[response valueForKey:@"message"]withView:self];
             }else
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

- (IBAction)loginSignUpPressed:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    if (btn.tag==2)
    {
        
        [btnLogin setTitleColor:[UIColor colorWithRed:45.0f/255.0f green:170.0f/255.0f blue:230.0f/255.0f alpha:1]forState: UIControlStateNormal];
        [btnSignUp setTitleColor:[UIColor blackColor]forState: UIControlStateNormal];
        
        [loginCreateAccountButton setBackgroundColor:[UIColor colorWithRed:243.0f/255.0f green:203.0f/255.0f blue:52.0f/255.0f alpha:1]];
        [loginCreateAccountButton setTitle:@"LOG IN" forState:UIControlStateNormal];
        forgotPassView.hidden = NO;
        tandCView.hidden = YES;
        arrowImageViewSignUp.hidden = YES;
        arrowImageViewLogin.hidden = NO;
    }
    else
    {
        [btnSignUp setTitleColor:[UIColor colorWithRed:45.0f/255.0f green:170.0f/255.0f blue:230.0f/255.0f alpha:1]forState: UIControlStateNormal];
        [btnLogin setTitleColor:[UIColor blackColor]forState: UIControlStateNormal];
        [loginCreateAccountButton setBackgroundColor:[UIColor colorWithRed:45.0f/255.0f green:170.0f/255.0f blue:230.0f/255.0f alpha:1]];
        [loginCreateAccountButton setTitle:@"CREATE ACCOUNT" forState:UIControlStateNormal];
        forgotPassView.hidden = YES;
        tandCView.hidden = NO;
        arrowImageViewSignUp.hidden = NO;
        arrowImageViewLogin.hidden = YES;
        
    }
    [journalistCheckImageView setImage:[UIImage imageNamed:@"un_selected"]];
    [clientCheckImageView setImage:[UIImage imageNamed:@"un_selected"]];
    userType = @"";
    emailTextField.text =@"";
    passwordTextField.text =@"";
}

- (IBAction)TandCpressed:(id)sender {
    TandCViewController*obj;
    obj=[self.storyboard instantiateViewControllerWithIdentifier:@"TandC"];
    obj.strComeFrom=@"1";
    [self.navigationController pushViewController:obj animated:YES];
}

- (IBAction)showPassword:(id)sender {
    
    if (showPassowrdBool) {
        [showHideButton setTitle:@"Show" forState:UIControlStateNormal];
        showPassowrdBool = NO;
        passwordTextField.enabled = YES;
        passwordTextField.secureTextEntry = YES;
        passwordTextField.enabled = YES;
        //[passwordTextField becomeFirstResponder];
    }
    else if (!showPassowrdBool){
        showPassowrdBool = YES;
        passwordTextField.enabled = YES;
        passwordTextField.secureTextEntry = NO;
        passwordTextField.enabled = YES;
        //[passwordTextField becomeFirstResponder];
        [showHideButton setTitle:@"Hide" forState:UIControlStateNormal];
    }
    [passwordTextField becomeFirstResponder];
}
-(void)RunAPI :(NSString*)Name :(NSString*)idOfUser :(NSString*)Company :(NSString*)position :(NSString*)ImageUrl :(NSString*)Response{
    // NSLog(@"%@ ",Name);
    
    
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService=[[NSString alloc]initWithFormat:@"%@saveuser",AppURL];
    //  NSLog(@"%@",strWebService);
    NSDictionary *dictParams;
    [[NSUserDefaults standardUserDefaults]setObject:emailTextField.text forKey:KEY_Email];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:Name,@"name",
    //                idOfUser,@"linkedin_id",Company,@"company",position,@"designation",ImageUrl,@"file1",userType,@"type",@"testuser",@"chat_username",
    //                nil];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"] length]>10) {
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:userType,@"type",Response,@"linkedin_array",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"]],@"device_id",
                    nil];
    }
    else{
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:userType,@"type",Response,@"linkedin_array",@"",@"device_id",
                    nil];
    }
    //NSLog(@"%@",dictParams);
    
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
             [appdelegateInstance hideHUD];
             NSString*str = [NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
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
                     
                     //                     MainViewController*ctl;
                     //                     ctl=[self.storyboard instantiateViewControllerWithIdentifier:@"maincontroller"];
                     
                     PitchFeedJournalist_ViewController*ctl;
                     ctl=[self.storyboard instantiateViewControllerWithIdentifier:@"pitchFeedtest"];
                     
                     UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:ctl];
                     [navController setViewControllers: @[ctl] animated: YES];
                     SideMenuViewController *rearViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuList"];
                     SWRevealViewController *mainRevealController =[self.storyboard instantiateViewControllerWithIdentifier:@"RevealController"];
                     mainRevealController=[mainRevealController initWithRearViewController:rearViewController frontViewController:navController];
                     [self.navigationController pushViewController:mainRevealController animated:YES];
                     //[self.navigationController pushViewController:obj animated:YES];
                 }
                 else{
                     
                     SWRevealViewController*revealcontroller;
                     revealcontroller=[self.storyboard instantiateViewControllerWithIdentifier:@"RevealController"];
                     
                     // MainViewController_Client*obj;
                     // obj=[self.storyboard instantiateViewControllerWithIdentifier:@"maincontroller_client"];
                     [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"userTypeString"];
                     [[NSUserDefaults standardUserDefaults]synchronize];
                     [self.navigationController pushViewController:revealcontroller animated:YES];
                 }
                 
                 
             }
             else  if ([str isEqualToString:@"1"])
             {
                 //                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 //                 [alert show];
                 [constant alertViewWithMessage:[response valueForKey:@"message"]withView:self];
             }
             else if ([response valueForKey:@"Failure"] )
             {
                 
                 
             }
         }
         else
         {
             [appdelegateInstance hideHUD];
             NSLog(@"Error returned:%@",[error localizedDescription]);
         }
     }];
}
@end
