//
//  HirePublicistViewController.m
//  uPitch
//
//  Created by Puneet Rao on 14/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import "HirePublicistViewController.h"
#import "SWRevealViewController.h"
#import "LxReqRespManager.h"
#import <QuartzCore/QuartzCore.h>
#import "manageJournalistViewController.h"
#import "constant.h"
@interface HirePublicistViewController ()

@end

@implementation HirePublicistViewController
@synthesize payPalConfig,acceptCreditCards,payPalSuccessId;
- (void)viewDidLoad {
    messageTextView.text = @"";
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PubNubNotification:) name:@"pubnubnot" object:nil];
    
//    scrollVw.layer.borderColor=[UIColor redColor].CGColor;
//    scrollVw.layer.borderWidth=2;
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
}
- (IBAction)chatIconPressed:(id)sender {
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
#pragma mark PayPalProfileSharingDelegate methods

- (void)payPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController
             userDidLogInWithAuthorization:(NSDictionary *)profileSharingAuthorization {
    NSLog(@"PayPal Profile Sharing Authorization Success!");
    
    [self sendProfileSharingAuthorizationToServer:profileSharingAuthorization];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)sendProfileSharingAuthorizationToServer:(NSDictionary *)authorization {
    // TODO: Send authorization to server
    NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete profile sharing setup.", authorization);
}

- (void)userDidCancelPayPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController {
    NSLog(@"PayPal Profile Sharing Authorization Canceled");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Authorize Future Payments
- (IBAction)getUserAuthorizationForFuturePayments:(id)sender {
    
    PayPalFuturePaymentViewController *futurePaymentViewController = [[PayPalFuturePaymentViewController alloc] initWithConfiguration:self.payPalConfig delegate:self];
    [self presentViewController:futurePaymentViewController animated:YES completion:nil];
}
#pragma mark PayPalFuturePaymentDelegate methods

- (void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController
                didAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization {
    NSLog(@"PayPal Future Payment Authorization Success!");
    
    [self sendFuturePaymentAuthorizationToServer:futurePaymentAuthorization];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalFuturePaymentDidCancel:(PayPalFuturePaymentViewController *)futurePaymentViewController {
    NSLog(@"PayPal Future Payment Authorization Canceled");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendFuturePaymentAuthorizationToServer:(NSDictionary *)authorization {
    // TODO: Send authorization to server
    NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete future payment setup.", authorization);
}

- (void)setPayPalEnvironment:(NSString *)environment {
     self.environment = environment;
    [PayPalMobile preconnectWithEnvironment:environment];
}
- (void)pay {
    // Remove our last completed payment, just for demo purposes.
    
    // Note: For purposes of illustration, this example shows a payment that includes
    //       both payment details (subtotal, shipping, tax) and multiple items.
    //       You would only specify these if appropriate to your situation.
    //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
    //       and simply set payment.amount to your total charge.
    
    // Optional: include multiple items
    PayPalItem *item1 = [PayPalItem itemWithName:@"HIRE PUBLICIST"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"99"]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00037"];
      NSArray *items = @[item1];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"USD";
    payment.shortDescription = @"HIRE PUBLICIST";
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Update payPalConfig re accepting credit cards.
   // self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
    self.payPalConfig.acceptCreditCards = YES;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}
#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation
- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.  %@ %@", completedPayment.confirmation,[[completedPayment.confirmation class]description],[[completedPayment.confirmation valueForKey:@"response"] valueForKey:@"id"]);
    payPalSuccessId= [[completedPayment.confirmation valueForKey:@"response"] valueForKey:@"id"];
    [self submitApi];
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
    
   /* if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]integerValue]>0) {
        lblCount.hidden=NO;
        imgCount.hidden=NO;
        NSInteger show=[[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]integerValue]+[[[NSUserDefaults standardUserDefaults] valueForKey:@"MinusCount"] integerValue];
        lblCount.text=[NSString stringWithFormat:@"%ld",(long)show];
        //lblCount.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]];
    }
    else
    {
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"MinusCount"]integerValue]>0)
        {
            lblCount.hidden=NO;
            imgCount.hidden=NO;
            lblCount.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"MinusCount"]];
            
        }
        else
        {
            lblCount.hidden=YES;
            imgCount.hidden=YES;
        }
    }*/
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self getCount];
    self.navigationController.navigationBar.hidden=YES;
    // Set up payPalConfig
    payPalConfig = [[PayPalConfiguration alloc] init];
    payPalConfig.acceptCreditCards = YES;
    payPalConfig.merchantName = @"Awesome Shirts, Inc.";
    payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    // Setting the languageOrLocale property is optional.
    //
    // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
    // its user interface according to the device's current language setting.
    //
    // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
    // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
    // to use that language/locale.
    //
    // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
    
    payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    
    // Setting the payPalShippingAddressOption property is optional.
    //
    // See PayPalConfiguration.h for details.
    
    payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // use default environment, should be Production in real life
    
    NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
     self.environment = kPayPalEnvironment;
    [self setPayPalEnvironment:self.environment];
    
    
    appdelegateInstance = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    contactNameImageView.layer.borderColor = [UIColor colorWithRed:75.0f/255.0f green:190.0f/255.0f blue:255.0f/255.0f alpha:1.0].CGColor;
    contactNameImageView.layer.borderWidth=1.2f;
    contactNameImageView.layer.cornerRadius = 5;
    contactNameImageView.layer.masksToBounds = YES;
    
    contactNumberImageView.layer.borderColor = [UIColor colorWithRed:75.0f/255.0f green:190.0f/255.0f blue:255.0f/255.0f alpha:1.0].CGColor;
    contactNumberImageView.layer.borderWidth=1.2f;
    contactNumberImageView.layer.cornerRadius = 5;
    contactNumberImageView.layer.masksToBounds = YES;
    
    emailImageView.layer.borderColor = [UIColor colorWithRed:75.0f/255.0f green:190.0f/255.0f blue:255.0f/255.0f alpha:1.0].CGColor;
    emailImageView.layer.borderWidth=1.2f;
    emailImageView.layer.cornerRadius = 5;
    emailImageView.layer.masksToBounds = YES;
    
    messageImageView.layer.borderColor = [UIColor colorWithRed:75.0f/255.0f green:190.0f/255.0f blue:255.0f/255.0f alpha:1.0].CGColor;
    messageImageView.layer.borderWidth=1.2f;
    messageImageView.layer.cornerRadius = 5;
    messageImageView.layer.masksToBounds = YES;
    
    
    
    [toolBar removeFromSuperview];
    contactName.inputAccessoryView=toolBar;
    contactNumber.inputAccessoryView=toolBar;
    email.inputAccessoryView=toolBar;
    messageTextView.inputAccessoryView=toolBar;
    submitButton.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:145.0f/255.0f blue:25.0f/255.0f alpha:1.0];
    [[submitButton layer] setCornerRadius:5.0f];
    [[submitButton layer] setMasksToBounds:YES];
    scrollVw.contentSize = CGSizeMake(self.view.frame.size.width, 590);
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
         scrollVw.contentSize = CGSizeMake(768, 750);
     }
    
    pitchServiceQuoteString = @"1";
    
    scrollSubViewTop_Quote.hidden = YES;
    scrollSubViewTop_Hire.hidden = NO;

    [self leftSlider];
    [self setInitially];
    [super viewWillAppear:animated];
}


-(void)setInitially
{
    
        pitchServiceQuoteString =@"2";
        scrollSubViewTop_Quote.hidden = NO;
        scrollSubViewTop_Hire.hidden = YES;
        
        line_Pitch.hidden = YES;
        line_Quote.hidden = NO;
        
        scrollSubView_Common.frame = CGRectMake(0, scrollSubViewTop_Quote.frame.origin.y+scrollSubViewTop_Quote.frame.size.height, scrollSubView_Common.frame.size.width, scrollSubView_Common.frame.size.height);
        [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            messageBaseLabel.text = @"    Messages";
        }
        else{
            
            messageBaseLabel.text = @"Messages";
        }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        scrollVw.contentSize = CGSizeMake(768, scrollSubView_Common.frame.origin.y+scrollSubView_Common.frame.size.height+30);
    }
    else{
        scrollVw.contentSize = CGSizeMake(self.view.frame.size.width, scrollSubView_Common.frame.origin.y+scrollSubView_Common.frame.size.height);
    }
    NSLog(@"%@",[NSValue valueWithCGSize:scrollVw.contentSize]);
    //  scrollSubView_Common.layer.borderColor = [UIColor redColor].CGColor;
    //  scrollSubView_Common.layer.borderWidth = 3.0f;
    contactName.text =@"";
    contactNumber.text =@"";
    email.text =@"";
    messageTextView.text =@"";
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
  //  [button setBackgroundImage:[UIImage imageNamed:@"menu55.png"] forState:UIControlStateNormal];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        button.frame = CGRectMake(0, 0, 70, 70);
    }
    else{
        button.frame = CGRectMake(0, 0, 60, 60);
    }
    [self.view addSubview:button];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark TextView Delegate
- (void)textViewDidEndEditing:(UITextView *)theTextView
{
    if (![messageTextView hasText]) {
        messageBaseLabel.hidden = NO;
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationLandscapeLeft ||
            orientation == UIInterfaceOrientationLandscapeRight)
        {
            scrollVw.contentSize = CGSizeMake(768, 1000);
             if ([pitchServiceQuoteString isEqualToString:@"1"]) {
             }
             else{
             }
           
             scrollVw.scrollEnabled = YES;
        }
        else{
            scrollVw.scrollEnabled = NO;
        }
    }
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        if (scrollSubViewTop_Hire.hidden){
            scrollVw.contentSize = CGSizeMake(self.view.frame.size.width, scrollSubView_Common.frame.origin.y+scrollSubView_Common.frame.size.height);
        }
    }
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationLandscapeLeft ||
            orientation == UIInterfaceOrientationLandscapeRight)
        {
            if ([pitchServiceQuoteString isEqualToString:@"1"]) {
                scrollVw.contentOffset = CGPointMake(0, 365);
                contentOffsetY = scrollVw.contentOffset.y;
            }
            else{
                scrollVw.contentOffset = CGPointMake(0, 365);
                contentOffsetY = scrollVw.contentOffset.y;
            }
            scrollVw.contentSize = CGSizeMake(768, 1100);
        }else{
           
            if (scrollSubViewTop_Hire.hidden && textView==messageTextView) {
                scrollVw.scrollEnabled = YES;
                scrollVw.contentSize = CGSizeMake(self.view.frame.size.width,1000);
            }
        }
    }
    else{
        
        if (scrollSubViewTop_Hire.hidden){
        scrollVw.contentSize = CGSizeMake(self.view.frame.size.width, 775+80);
        }else{
            scrollVw.contentSize = CGSizeMake(self.view.frame.size.width, 732);
        }
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationLandscapeLeft ||
            orientation == UIInterfaceOrientationLandscapeRight)
        {
            scrollVw.contentSize = CGSizeMake(768, 1000);
            if ([pitchServiceQuoteString isEqualToString:@"1"]) {
            }
            else{
            }
            
            scrollVw.scrollEnabled = YES;
        }
        else{
            scrollVw.scrollEnabled = NO;
        }
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){}
    else{
        scrollVw.contentOffset = CGPointMake(0, scrollSubView_Common.frame.origin.y+email.frame.origin.y);
        
    }
    
    
    return YES;
}

- (void) textViewDidChange:(UITextView *)textView
{
    if(![messageTextView hasText]) {
        messageBaseLabel.hidden = NO;
    }
    else{
        messageBaseLabel.hidden = YES;
    }
}
#pragma mark TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){

        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationLandscapeLeft ||
            orientation == UIInterfaceOrientationLandscapeRight)
        {
            scrollVw.contentSize = CGSizeMake(768, 1000);
            if ([pitchServiceQuoteString isEqualToString:@"1"]) {
                scrollVw.contentOffset = CGPointMake(0, textField.frame.origin.y+30);
                 //scrollVw.contentOffset = CGPointMake(0, 300);
                contentOffsetY = scrollVw.contentOffset.y;
                 NSLog(@"landscape %d",contentOffsetY);
            }
            else{
                scrollVw.contentOffset = CGPointMake(0, textField.frame.origin.y+60);
                //scrollVw.contentOffset = CGPointMake(0, 220);
                contentOffsetY = scrollVw.contentOffset.y;
                NSLog(@"portrait %d",contentOffsetY);

            }
               }
    }
    else{
    scrollVw.contentOffset = CGPointMake(0, scrollSubView_Common.frame.origin.y+10);
         scrollVw.contentSize = CGSizeMake(self.view.frame.size.width, 690);
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self.view setFrame:CGRectMake(0, 0 ,self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
    return YES;
}
#pragma mark ToolBar method
-(IBAction)cancelToolBar:(id)sender
{
    scrollVw.scrollEnabled=YES;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        scrollVw.contentSize = CGSizeMake(768, scrollSubView_Common.frame.size.height+scrollSubView_Common.frame.origin.y+20);
    }
    else
    {
        scrollVw.contentSize = CGSizeMake(self.view.frame.size.width, scrollSubView_Common.frame.size.height+scrollSubView_Common.frame.origin.y+20);
        NSLog(@"%@",[NSValue valueWithCGSize:scrollVw.contentSize]);
    }

    contentOffsetY=0;
    [contactName resignFirstResponder];
    [contactNumber resignFirstResponder];
    [email resignFirstResponder];
    [messageTextView resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self.view setFrame:CGRectMake(0, 0 ,self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}
-(IBAction)Done
{
    scrollVw.scrollEnabled=YES;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
     scrollVw.contentSize = CGSizeMake(768, scrollSubView_Common.frame.size.height+scrollSubView_Common.frame.origin.y+20);
    }
    else
    {
    scrollVw.contentSize = CGSizeMake(self.view.frame.size.width, scrollSubView_Common.frame.size.height+scrollSubView_Common.frame.origin.y+20);
    }
     contentOffsetY=0;
    [contactName resignFirstResponder];
    [contactNumber resignFirstResponder];
    [email resignFirstResponder];
    [messageTextView resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self.view setFrame:CGRectMake(0, 0 ,self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}
-(void)submitApi
{
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService=[[NSString alloc]initWithFormat:@"%@saveservice",AppURL];
   
    NSDictionary *dictParams;
    
    if ([pitchServiceQuoteString isEqualToString:@"1"]) {
//        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:contactName.text,@"contact",contactNumber.text,@"phone",email.text,@"email",messageTextView.text,@"message",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",pitchServiceQuoteString,@"record_type",@"99",@"amount",payPalSuccessId,@"trans_id",
//                    nil];
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:contactName.text,@"contact",contactNumber.text,@"phone",email.text,@"email",messageTextView.text,@"message",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",pitchServiceQuoteString,@"record_type",
                    nil];
    }
    else{
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:contactName.text,@"contact",contactNumber.text,@"phone",email.text,@"email",messageTextView.text,@"message",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",pitchServiceQuoteString,@"record_type",
                    nil];
    }
    
     NSLog(@"%@",strWebService);
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
//                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Request submitted successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                 [alert show];
                 [constant alertViewWithMessage:@"Request submitted successfully."withView:self];
                contactName.text =@"";
                 contactNumber.text =@"";
                 email.text =@"";
                 messageTextView.text =@"";
                 messageBaseLabel.hidden = NO;
             }
            else if ([str isEqualToString:@"0"] )
             {
//                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                 [alert show];
                 [constant alertViewWithMessage:[response valueForKey:@"message"]withView:self];
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
             [constant alertViewWithMessage:@"Connectivity levels low. Please try again."withView:self];
             NSLog(@"Error returned:%@",[error localizedDescription]);
         }
     }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1234) {
        AppDelegate *appd= (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appd LogoutFromApp:self];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)bottomButtonAction:(UIButton*)sender {
    if ([sender tag]==1)
    {
        pitchServiceQuoteString =@"1";
        scrollSubViewTop_Quote.hidden = YES;
        scrollSubViewTop_Hire.hidden = NO;
        
        line_Pitch.hidden = NO;
        line_Quote.hidden = YES;
        
        scrollSubView_Common.frame = CGRectMake(0, scrollSubViewTop_Hire.frame.origin.x+scrollSubViewTop_Hire.frame.size.height, scrollSubView_Common.frame.size.width, scrollSubView_Common.frame.size.height);
       
        [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
             messageBaseLabel.text = @"    What are you pitching";
        }
        else{
            messageBaseLabel.text = @"What are you pitching";
        }
    }
    else  if ([sender tag]==2)
    {
        pitchServiceQuoteString =@"2";
        scrollSubViewTop_Quote.hidden = NO;
        scrollSubViewTop_Hire.hidden = YES;
        
        line_Pitch.hidden = YES;
        line_Quote.hidden = NO;
        
        scrollSubView_Common.frame = CGRectMake(0, scrollSubViewTop_Quote.frame.origin.y+scrollSubViewTop_Quote.frame.size.height, scrollSubView_Common.frame.size.width, scrollSubView_Common.frame.size.height);
         [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            messageBaseLabel.text = @"    Messages";
        }
        else{

        messageBaseLabel.text = @"Messages";
        }
    }
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
         
    scrollVw.contentSize = CGSizeMake(768, scrollSubView_Common.frame.origin.y+scrollSubView_Common.frame.size.height+30);
     }
     else{
         scrollVw.contentSize = CGSizeMake(self.view.frame.size.width, scrollSubView_Common.frame.origin.y+scrollSubView_Common.frame.size.height);
     }
    NSLog(@"%@",[NSValue valueWithCGSize:scrollVw.contentSize]);
  //  scrollSubView_Common.layer.borderColor = [UIColor redColor].CGColor;
  //  scrollSubView_Common.layer.borderWidth = 3.0f;
    contactName.text =@"";
    contactNumber.text =@"";
    email.text =@"";
    messageTextView.text =@"";
}

- (IBAction)submitButtonPressed:(id)sender {
    
    contactName.text = [contactName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    contactNumber.text = [contactNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    email.text = [email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     messageTextView.text = [messageTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [contactName resignFirstResponder];
    [contactNumber resignFirstResponder];
    [email resignFirstResponder];
    [messageTextView resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self.view setFrame:CGRectMake(0, 0 ,self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];


    
    if ([contactName.text isEqualToString:@""] || contactName.text.length<=0 ) {
//        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter contact name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [constant alertViewWithMessage:@"Please enter contact name."withView:self];
    }
    else if ([contactNumber.text isEqualToString:@""] || contactNumber.text.length<=0 ) {
//        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter contact number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [constant alertViewWithMessage:@"Please enter contact number."withView:self];
    }
    else if ([email.text isEqualToString:@""] || email.text.length<=0 ) {
//        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [constant alertViewWithMessage:@"Please enter email address."withView:self];
    }
    else if (![self validateEmailWithString:email.text])
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Email format is invalid. It should be in (abc@example.com)format." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
        [constant alertViewWithMessage:@"Email format is invalid. It should be in (abc@example.com)format."withView:self];
    }
    else if ([messageTextView.text isEqualToString:@""] || messageTextView.text.length<=0 ) {
//        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter message" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [constant alertViewWithMessage:@"Please enter message."withView:self];
    }

    else{
         if ([pitchServiceQuoteString isEqualToString:@"1"]) {
       // [self pay];
             [self submitApi];
         }
         else{
        [self submitApi];
         }
    }
}
-(BOOL)validateEmailWithString:(NSString*)email1
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email1];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;

    if (textField==contactNumber)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"+0123456789."] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        if (newLength<=20) {
             return [string isEqualToString:filtered];
        }
        else
        {
//            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"upitch" message:@"Contact Number maximum limit 20 characters."delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
            [constant alertViewWithMessage:@"Contact Number maximum limit 20 characters."withView:self];
            return NO;
        }
    }
    
    if (textField==contactName)
    {
      
        if (newLength<= 100) {
            return newLength <= 100;
        }
        else
        {
//            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"upitch" message:@"Contact Name maximum limit 100 characters."delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
            [constant alertViewWithMessage:@"Contact Name maximum limit 100 characters."withView:self];
            return NO;
        }
        
    }
    if (textField==email)
    {
        
        if (newLength<= 100) {
            return newLength <= 100;
        }
        else
        {
//            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"upitch" message:@"Email Address maximum limit 100 characters."delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
            [constant alertViewWithMessage:@"Email Address maximum limit 100 characters."withView:self];
            return NO;
        }
        
    }

    return YES;
}
#pragma mark Orientation Method
- (BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
         if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortrait) {
             
             NSLog(@"portrait");
             if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
             {
                 scrollVw.contentOffset = CGPointMake(0, 0);
                 scrollVw.scrollEnabled = NO;
            }
             
         }
         else if (orientation == UIInterfaceOrientationLandscapeLeft ||
                  orientation == UIInterfaceOrientationLandscapeRight)
         {
             NSLog(@"landscape");
             if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
             {
                  scrollVw.contentOffset = CGPointMake(0, contentOffsetY);
                 scrollVw.scrollEnabled = YES;
//                 scrollVw.layer.borderColor = [UIColor redColor].CGColor;
//                 scrollVw.layer.borderWidth = 3.0f;
//                 scrollSubView_Common.layer.borderColor = [UIColor greenColor].CGColor;
//                 scrollSubView_Common.layer.borderWidth = 3.0f;
             }
             
         }
         
         // do whatever
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}
@end
