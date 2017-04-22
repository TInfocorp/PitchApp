//
//  ClientSettingViewController.m
//  uPitch
//
//  Created by Puneet Rao on 16/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import "ClientSettingViewController.h"
#import "SWRevealViewController.h"
#import "LxReqRespManager.h"
//#import "MainViewController_Client.h"
#import "constant.h"
#import "manageJournalistViewController.h"
#import "Utils.h"
#import "TandCViewController.h"
#import "AccountSettingViewController.h"
#import "FAQViewController.h"
@interface ClientSettingViewController ()

@end

@implementation ClientSettingViewController

- (void)viewDidLoad {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PubNubNotification:) name:@"pubnubnot" object:nil];
    [super viewDidLoad];
     // Do any additional setup after loading the view.
}
-(void)setClientView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if ([userTypeLabel.text isEqualToString:@"Basic"]) {
            userTypeView.frame = CGRectMake(userTypeView.frame.origin.x, userTypeView.frame.origin.y, self.view.frame.size.width, 180);
            upgradeButton.hidden = NO;
        }
        else{
            userTypeView.frame = CGRectMake(userTypeView.frame.origin.x, userTypeView.frame.origin.y, self.view.frame.size.width, 75);
            upgradeButton.hidden = YES;
        }
        
    }else
    {
        if ([userTypeLabel.text isEqualToString:@"Basic"]) {
            userTypeView.frame = CGRectMake(userTypeView.frame.origin.x, userTypeView.frame.origin.y, self.view.frame.size.width, 100+30);
            upgradeButton.hidden = NO;
        }
        else{
            userTypeView.frame = CGRectMake(userTypeView.frame.origin.x, userTypeView.frame.origin.y, self.view.frame.size.width, 51);
            upgradeButton.hidden = YES;
        }
    }
    notificationView.frame = CGRectMake(notificationView.frame.origin.x, userTypeView.frame.origin.y+userTypeView.frame.size.height, self.view.frame.size.width, notificationView.frame.size.height);
    contactView.frame = CGRectMake(contactView.frame.origin.x, notificationView.frame.origin.y+notificationView.frame.size.height, self.view.frame.size.width, contactView.frame.size.height);
    bottomView.frame = CGRectMake(bottomView.frame.origin.x, contactView.frame.origin.y+contactView.frame.size.height, self.view.frame.size.width, bottomView.frame.size.height);
    [self setScroll];
}
-(void)showClientSetting{
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
    
    strWebService=[[NSString alloc]initWithFormat:@"%@show_client_setting",AppURL];
    NSLog(@"%@",strWebService);
    NSDictionary *dictParams;
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",nil];
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
             [appdelegateInstance hideHUD];
             NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             if ([str isEqualToString:@"0"] )
             {
                 if ([[[[response valueForKey:@"data"] valueForKey:@"Userlink"] valueForKey:@"account_type"] isEqualToString:@"1"]) {
                      userTypeLabel.text = @"Basic";
                      upgradeButton.userInteractionEnabled = YES;
                 }
                 else  if ([[[[response valueForKey:@"data"] valueForKey:@"Userlink"] valueForKey:@"account_type"] isEqualToString:@"2"]){
                 //userTypeLabel.text = @"Pro";
                     userTypeLabel.text = @"PR Professional";
                      upgradeButton.userInteractionEnabled = YES;
                 }
                 else  if ([[[[response valueForKey:@"data"] valueForKey:@"Userlink"] valueForKey:@"account_type"] isEqualToString:@"3"]){
                     userTypeLabel.text = @"Basic";
                     upgradeButton.userInteractionEnabled = NO;
                     upgradeButton.backgroundColor = [UIColor lightGrayColor];
                     [upgradeButton setTitle:@"Request Pending" forState:UIControlStateNormal];
                 }
                 
                 [self setClientView];
                 
                 switchXpire=[[[response valueForKey:@"data"] valueForKey:@"Userlink"] valueForKey:@"notification_setting_expire"];
                 
                 if ([switchXpire isEqualToString:@"1"]) {
                     switchNotificationXpire.on = YES;
                 }
                 else{
                     switchNotificationXpire.on = NO;
                 }
                 
                 switchString = [[[response valueForKey:@"data"] valueForKey:@"Userlink"] valueForKey:@"message_notification"];
                 if ([switchString isEqualToString:@"1"]) {
                     [USERDEFAULTS setBool:NO forKey:@"messageNotificaitonOnOff"];
                     [USERDEFAULTS synchronize];
                     notifiactionSwitch.on = YES;
                 }
                 else{
                     notifiactionSwitch.on = NO;
                     [USERDEFAULTS setBool:YES forKey:@"messageNotificaitonOnOff"];
                     [USERDEFAULTS synchronize];
                 }
                 strOptionPush = [[[response valueForKey:@"data"] valueForKey:@"Userlink"] valueForKey:@"push_notification"];
                 if ([strOptionPush isEqualToString:@"1"]) {
                     switchPushNotification.on = YES;
                 }
                 else{
                     switchPushNotification.on = NO;
                 }

                 strOptionEmail = [[[response valueForKey:@"data"] valueForKey:@"Userlink"] valueForKey:@"email_notification"];
                 if ([strOptionEmail isEqualToString:@"1"]) {
                     switchEmailNotification.on = YES;
                 }
                 else{
                     switchEmailNotification.on = NO;
                 }

             }
             
             else if ([str isEqualToString:@"1"])
             {
//                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"Failure"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                 [alert show];
                 [constant alertViewWithMessage:[response valueForKey:@"Failure"]withView:self];
             }
             else if ([str isEqualToString:@"10"] )
             {
                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 alert.tag = 1234;
                 [alert show];
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
- (IBAction)chatIconPressed:(id)sender
{
//    [[NSUserDefaults standardUserDefaults]setObject:@"showChatScreen" forKey:@"directCall"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
    SWRevealViewController *revealController = self.revealViewController;
    manageJournalistViewController*obj;
    obj=[self.storyboard instantiateViewControllerWithIdentifier:@"manageJournalists"];
    obj.matchesChatString = @"1";
    
    long chat = [[USERDEFAULTS valueForKey:@"chatcount"]integerValue];
    long match = [[USERDEFAULTS valueForKey:@"matchcount"] integerValue];
    
    if (chat > 0  && match == 0)
    {
        obj.matchesChatString = @"2";
        
    }
    else if (chat == 0  && match > 0)
    {
        obj.matchesChatString = @"1";
        
    }
    else if (chat > 0 && match > 0)
    {
        obj.matchesChatString = @"1";
        
    }
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:obj];
    [revealController pushFrontViewController:navigationController animated:YES];
}


-(void)PubNubNotification:(NSNotification *) notification
{
    [self getCount];
}
-(void)getCount
{
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"totalcount"]integerValue]>0 || [[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]integerValue]>0)
    {
        lblCount.hidden=NO;
        imgCount.hidden=NO;
        NSInteger show=[[[NSUserDefaults standardUserDefaults]valueForKey:@"chatcount"]integerValue]+[[[NSUserDefaults standardUserDefaults] valueForKey:@"matchcount"] integerValue]+[[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]integerValue]+[[[NSUserDefaults standardUserDefaults] valueForKey:@"MinusCount"] integerValue];
        lblCount.text=[NSString stringWithFormat:@"%ld",(long)show];
        
        //lblCount.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]];
    }
    else
    {
        lblCount.hidden=YES;
        imgCount.hidden=YES;
    }
    
//    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]integerValue]>0) {
//        lblCount.hidden=NO;
//        imgCount.hidden=NO;
//        NSInteger show=[[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]integerValue]+[[[NSUserDefaults standardUserDefaults] valueForKey:@"MinusCount"] integerValue];
//        lblCount.text=[NSString stringWithFormat:@"%ld",(long)show];
//        //lblCount.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]];
//    }
//    else
//    {
//        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"MinusCount"]integerValue]>0)
//        {
//            lblCount.hidden=NO;
//            imgCount.hidden=NO;
//            lblCount.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"MinusCount"]];
//            
//        }
//        else
//        {
//            lblCount.hidden=YES;
//            imgCount.hidden=YES;
//        }
//    }
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self getCount];
    [self setScroll];
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
//        if (orientation == UIInterfaceOrientationLandscapeLeft ||
//            orientation == UIInterfaceOrientationLandscapeRight)
//        {
//            scrollview.contentSize = CGSizeMake(self.view.frame.size.width, 900+50);
//        }else{
//            scrollview.contentSize = CGSizeMake(self.view.frame.size.width, 1050+50);
//        }
//
//    }
//    else
//    {
//        scrollview.contentSize = CGSizeMake(self.view.frame.size.width, 718+30+50+50);
//    }
        self.navigationController.navigationBar.hidden=YES;
    [toolBar removeFromSuperview];
    emailTextField.inputAccessoryView=toolBar;
    messageTextView.inputAccessoryView=toolBar;
    
    appdelegateInstance = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self showClientSetting];
    emailImageView.layer.borderColor = [UIColor colorWithRed:75.0f/255.0f green:190.0f/255.0f blue:255.0f/255.0f alpha:1.0].CGColor;
    emailImageView.layer.borderWidth=1.2f;
    emailImageView.layer.cornerRadius = 5;
    emailImageView.layer.masksToBounds = YES;
    
    textViewImageView.layer.borderColor = [UIColor colorWithRed:75.0f/255.0f green:190.0f/255.0f blue:255.0f/255.0f alpha:1.0].CGColor;
    textViewImageView.layer.borderWidth=1.2f;
    textViewImageView.layer.cornerRadius = 5;
    textViewImageView.layer.masksToBounds = YES;
    
    
    
    submitButton.layer.cornerRadius = 5;
    submitButton.layer.masksToBounds = YES;
    
    logoutButton.layer.cornerRadius = 5;
    logoutButton.layer.masksToBounds = YES;
    
    deleteButton.layer.cornerRadius = 5;
    deleteButton.layer.masksToBounds = YES;
    
    [self leftSlider];
    [super viewWillAppear:animated];
}
-(void)setScroll
{
    contentHeight=userTypeView.frame.size.height+notificationView.frame.size.height+contactView.frame.size.height+bottomView.frame.size.height+30;
    scrollview.contentSize = CGSizeMake(self.view.frame.size.width,userTypeView.frame.size.height+notificationView.frame.size.height+contactView.frame.size.height+bottomView.frame.size.height+30);
}
-(void)leftSlider
{

    SWRevealViewController *revealController = [self revealViewController];
    revealController.panGestureRecognizer.enabled = YES;
    revealController.tapGestureRecognizer.enabled = YES;
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
   // [button setBackgroundImage:[UIImage imageNamed:@"menu55.png"] forState:UIControlStateNormal];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        button.frame = CGRectMake(0, 0, 70, 70);
    }
    else{
        button.frame = CGRectMake(0, 0, 60, 60);
    }
    [self.view addSubview:button];
}

#pragma mark TextView delegate
- (void)textViewDidEndEditing:(UITextView *)theTextView
{
    if (![messageTextView hasText]) 
    {
        messageLabel.hidden = NO;
    }
    
    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
//        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
//        if (orientation == UIInterfaceOrientationLandscapeLeft ||
//            orientation == UIInterfaceOrientationLandscapeRight)
//        {
//        scrollview.contentSize = CGSizeMake(self.view.frame.size.width, 900+50);
//        }else{
//        scrollview.contentSize = CGSizeMake(self.view.frame.size.width, 1050+50);
//        }
//    }
//    else{
//        scrollview.contentSize = CGSizeMake(self.view.frame.size.width, 718+30+50);
//    }

    [self setScroll];
    
    
}

- (void) textViewDidChange:(UITextView *)textView
{
    if(![messageTextView hasText]) {
        messageLabel.hidden = NO;
    }
    else{
        messageLabel.hidden = YES;
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationLandscapeLeft ||
            orientation == UIInterfaceOrientationLandscapeRight)
        {
            scrollview.contentOffset = CGPointMake(0, 320);
                contentOffsetY = scrollview.contentOffset.y;
            scrollview.contentSize = CGSizeMake(self.view.frame.size.width, scrollview.frame.size.height+350);
        }else{

        }
    }
    else
    {
        scrollview.contentOffset = CGPointMake(0, 280);
        contentOffsetY = scrollview.contentOffset.y;
        scrollview.contentSize = CGSizeMake(self.view.frame.size.width, contentHeight+200);
    }
    
    
}
-(BOOL)validateEmailWithString:(NSString*)email1
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email1];
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
#pragma mark Upgrade user
-(void)upgradeTheUser{
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
    strWebService=[[NSString alloc]initWithFormat:@"%@save_client_account",AppURL];
    NSLog(@"%@",strWebService);
    NSDictionary *dictParams;
    
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",
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
                 //userTypeLabel.text = @"Pro";
                 //[self setClientView];
                 userTypeLabel.text = @"Basic";
                 upgradeButton.userInteractionEnabled = NO;
                 upgradeButton.backgroundColor = [UIColor lightGrayColor];
                 [upgradeButton setTitle:@"Request Pending" forState:UIControlStateNormal];
                 
//                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                 [alert show];
             }
             else if ([str isEqualToString:@"1"] )
             {
//                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"Failure"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                 [alert show];
                 [constant alertViewWithMessage:[response valueForKey:@"Failure"]withView:self];
             }
             else if ([str isEqualToString:@"10"] )
             {
                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 alert.tag = 1234;
                 [alert show];
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
#pragma mark Others Methods
- (IBAction)AccountSettingPressed:(id)sender {
    
    AccountSettingViewController *obj;
    obj=[self.storyboard instantiateViewControllerWithIdentifier:@"AccountSetting"];
    [self.navigationController pushViewController:obj animated:YES];

}

- (IBAction)requestFreeUpgrade:(id)sender {
   
    
   // UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Do you want to upgrade the user type ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    
     UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"I confirm I am a PR professional." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alert.tag = 200;
    [alert show];
}

- (IBAction)FAQAction:(id)sender {
//    NSURL * url=[NSURL URLWithString:[NSString stringWithFormat:@"http://www.apple.com"]];
//    [[UIApplication sharedApplication] openURL:url];
    
    
    
    FAQViewController *ctl;
    ctl=[self.storyboard instantiateViewControllerWithIdentifier:@"faqController"];
    [self.navigationController pushViewController:ctl animated:YES];
    

}

-(IBAction)gotoFaqPage:(id)sender
{
    
}


- (IBAction)privacyTerms:(id)sender {
    
    //Privacy 2
    TandCViewController*obj;
    obj=[self.storyboard instantiateViewControllerWithIdentifier:@"TandC"];
    obj.strComeFrom=@"2";
    [self.navigationController pushViewController:obj animated:YES];
   

    
//    NSURL * url=[NSURL URLWithString:[NSString stringWithFormat:@"http://www.apple.com"]];
//    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)rateUs:(id)sender
{
    NSURL * url=[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/upitch-public-relations-journalist/id1028833243?ls=1&mt=8"]];
    [[UIApplication sharedApplication] openURL:url];
}
#pragma mark notifiaction Setting
//- (IBAction)setState:(id)sender
//{
//   
//}

- (IBAction)SetExpireState:(id)sender {
    BOOL state = [sender isOn];
    NSString *rez = state == YES ? @"YES" : @"NO";
    NSLog(@"%@",rez);
    if ([rez isEqualToString:@"YES"])
    {
        switchXpire = @"1";
    }
    else
    {
        switchXpire = @"0";
    }
    [self changeState];
}




-(void)changeState
{
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
    NSString *strOn = @"1";
    strWebService=[[NSString alloc]initWithFormat:@"%@save_client_notification",AppURL];
    NSLog(@"%@",strWebService);
    NSDictionary *dictParams;
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:
                    [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],
                    @"user_id",
                    strOn,@"notification_setting",switchXpire,@"notification_setting_expire",
                    nil];
    NSLog(@"%@",dictParams);
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
             [appdelegateInstance hideHUD];
             NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             if ([str isEqualToString:@"0"] )
             {
                 
            }
             else if ([str isEqualToString:@"1"])
             {
//                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"Failure"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                 [alert show];
                 [constant alertViewWithMessage:[response valueForKey:@"Failure"]withView:self];
             }
             else if ([str isEqualToString:@"10"] )
             {
                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 alert.tag = 1234;
                 [alert show];
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
-(void)setNotificationOption
{
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
    
    strWebService=[[NSString alloc]initWithFormat:@"%@save_push_email_notification",AppURL];
    NSLog(@"%@",strWebService);
    NSDictionary *dictParams;
  
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:
                [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],
                @"user_id",switchString,@"message_notification",
                strOptionPush,@"push_notification",
                strOptionEmail,@"email_notification",
                nil];
    
    NSLog(@"%@",dictParams);
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
             [appdelegateInstance hideHUD];
             NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             if ([str isEqualToString:@"0"] )
             {
                 
             }
             else if ([str isEqualToString:@"1"])
             {
                 //                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"Failure"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 //                 [alert show];
                 [constant alertViewWithMessage:[response valueForKey:@"Failure"]withView:self];
             }
             else if ([str isEqualToString:@"10"] )
             {
                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 alert.tag = 1234;
                 [alert show];
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
#pragma mark Delete and logout action
- (IBAction)logoutAction:(id)sender {
    AppDelegate *appd= (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appd LogoutFromApp:self];
}

- (IBAction)deleteAccountPressed:(id)sender {
    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Are you sure, you want to delete your account ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alert.tag = 100;
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    AppDelegate *appd= (AppDelegate *)[UIApplication sharedApplication].delegate;

    
    if (alertView.tag==100)
    {
        if (buttonIndex==0) {
            NSLog(@"Cancel");
        }
        else if (buttonIndex==1) {
            NSLog(@"OK");
            MaintainApiBool = YES;
            [self runApi];
        }
    }
    else if (alertView.tag==200)
    {
        if (buttonIndex==0) {
            NSLog(@"Cancel");
        }
        else if (buttonIndex==1) {
            NSLog(@"OK");
            [self upgradeTheUser];
        }
    }
    if (alertView.tag == 7005)
    {
        [appd deleteAccount:self];
        [appd deleteAccount:self];
        
    }

    
    if (alertView.tag==1234) {
        [appd LogoutFromApp:self];
    }
    
}
- (IBAction)submitAction:(id)sender {
    
     messageTextView.text = [messageTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
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
    else if ([messageTextView.text isEqualToString:@""] || messageTextView.text.length<=0 ) {
//        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter message." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [constant alertViewWithMessage:@"Please enter message."withView:self];
    }
    else{
        [messageTextView resignFirstResponder];
        [emailTextField resignFirstResponder];
        MaintainApiBool =NO;
        [self runApi];
    }
    
}

- (IBAction)setEmailNotification:(id)sender {
    BOOL state = [sender isOn];
    NSString *rez = state == YES ? @"YES" : @"NO";
    NSLog(@"%@",rez);
    if ([rez isEqualToString:@"YES"])
    {
        strOptionEmail = @"1";
    }
    else
    {
        strOptionEmail = @"0";
    }
    [self setNotificationOption];
    
}

- (IBAction)setState:(id)sender
{
    BOOL state = [sender isOn];
    NSString *rez = state == YES ? @"YES" : @"NO";
    NSLog(@"%@",rez);
    if ([rez isEqualToString:@"YES"])
    {
        switchString = @"1";
        [USERDEFAULTS setBool:NO forKey:@"messageNotificaitonOnOff"];
        [USERDEFAULTS synchronize];    }
    else
    {
        [USERDEFAULTS setBool:YES forKey:@"messageNotificaitonOnOff"];
        [USERDEFAULTS synchronize];
        switchString = @"0";
    }
    [self setNotificationOption];
}

- (IBAction)setPushNotification:(id)sender {
    BOOL state = [sender isOn];
    NSString *rez = state == YES ? @"YES" : @"NO";
    NSLog(@"%@",rez);
    if ([rez isEqualToString:@"YES"])
    {
        strOptionPush = @"1";
    }
    else
    {
        strOptionPush = @"0";
    }
    [self setNotificationOption];
}
-(void)runApi
{
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
    if (MaintainApiBool==YES) {
        // delete account
        strWebService=[[NSString alloc]initWithFormat:@"%@deleteaccount",AppURL];
    }
    else{
        // submit Query Api
        strWebService=[[NSString alloc]initWithFormat:@"%@saveservice",AppURL];
    }
    NSLog(@"%@",strWebService);
    NSDictionary *dictParams;
    if (MaintainApiBool) {
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",
                    nil];
    }
    else{
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:
                emailTextField.text,@"email",
                messageTextView.text,@"message",
                @"3",@"record_type",
                [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",
                nil];
    }
    
     [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
             [appdelegateInstance hideHUD];
             NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             if ([str isEqualToString:@"0"] )
             {
                 if (MaintainApiBool==YES) {
                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Account deleted successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     alert.tag = 7005;
                 [alert show];
//                     [constant alertViewWithMessage:@"Account deleted successfully."withView:self];
                     [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userid"];
                     [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userTypeString"];
                     [[NSUserDefaults standardUserDefaults]synchronize];
                     UINavigationController *frontNavigationController = (id)self.revealViewController.frontViewController;
                     [frontNavigationController.navigationController popToRootViewControllerAnimated:YES];
                 }
                 else{
//                     UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Request submitted successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                     [alert show];
                     [constant alertViewWithMessage:@"Request submitted successfully."withView:self];
                     emailTextField.text =@"";
                     messageTextView.text =@"";
                     
                     messageLabel.hidden=NO;
                     
                 }
                 
                                

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
             [constant AlertMessageWithString:@"Connectivity levels low. Please try again." andWithView:self.view];
             NSLog(@"Error returned:%@",[error localizedDescription]);
         }
     }];
}
#pragma mark ToolBar method
-(IBAction)cancelToolBar:(id)sender
{
    [emailTextField resignFirstResponder];
    [messageTextView resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self.view setFrame:CGRectMake(0, 0 ,self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}
-(IBAction)Done
{
    [emailTextField resignFirstResponder];
    [messageTextView resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self.view setFrame:CGRectMake(0, 0 ,self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}
@end
