//
//  ExpiryTimeViewController.m
//  uPitch
//
//  Created by Puneet Rao on 03/04/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import "ExpiryTimeViewController.h"
#import "UIImageView+WebCache.h"
#import "LxReqRespManager.h"
#import "ProfileViewController.h"
#import "SWRevealViewController.h"
#import "constant.h"
@interface ExpiryTimeViewController ()

@end

@implementation ExpiryTimeViewController
@synthesize pitchImageView,urlString,summary,titleString,compantNameString,positionString,pitchJournalistsString,pitchIdString,userIdString,pitchSelectorIdString,pitchIdForSetTimer;
- (void)myNotificationMethod:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect  keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
   
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
         bottomView.frame=CGRectMake(bottomView.frame.origin.x,([[UIScreen mainScreen] bounds].size.height-keyboardFrameBeginRect.size.height)-80, bottomView.frame.size.width, bottomView.frame.size.height);
         scrollvw.contentSize = CGSizeMake(self.view.frame.size.width, contentSizeHeight+350);
    }
    else{
         bottomView.frame=CGRectMake(bottomView.frame.origin.x,([[UIScreen mainScreen] bounds].size.height-keyboardFrameBeginRect.size.height)-60, bottomView.frame.size.width, bottomView.frame.size.height);
       scrollvw.contentSize = CGSizeMake(self.view.frame.size.width, contentSizeHeight+250);
    }
    customButton.hidden = NO;
   
}
-(void)commonCode{
    sendButton.userInteractionEnabled = NO;
    [sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myNotificationMethod:) name:UIKeyboardWillShowNotification object:nil];
    
    NSLog(@"%@ %@ %@",userIdString,pitchSelectorIdString,pitchIdString);
    // PNConfiguration *myConfig = [PNConfiguration configurationForOrigin:@"pubsub.pubnub.com"  publishKey:pubnub_publishKey subscribeKey:pubnub_secretKey secretKey:pubnub_subscribeKey];
      
    
    

    // pitchJournalistsString =1 for pitch 2 for journalists
    
    borderImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    borderImageView.layer.borderWidth = 1.0f;
    borderImageView.layer.cornerRadius = 8;
    borderImageView.layer.masksToBounds = YES;
    borderImageView.backgroundColor = [UIColor whiteColor];
    
    pitchSubView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    pitchSubView.layer.borderWidth = 1.0f;
    
    if ([pitchJournalistsString isEqualToString:@"1"]) {
        headerLabel.text =@"MATCHED PITCH";
        journalistView.hidden = YES;
        pitchView.hidden = NO;
        NSURL*Url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]];
        NSLog(@"%@",Url1);
        [pitchImageView setImageWithURL:Url1 placeholderImage:[UIImage imageNamed:@"userDefault.jpg"] imagesize:CGSizeMake(400, 400)];
        summaryLabel.text = summary;
        titleLabel.text = titleString;
        
        int labelfontSize;
        int maxHeight;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            labelfontSize =23;
            maxHeight =100;
        }
        else{
            labelfontSize =13;
            maxHeight =80;
        }
        CGSize constraintSize;
        constraintSize.height = MAXFLOAT;
        constraintSize.width = summaryLabel.frame.size.width;
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIFont fontWithName:@"HelveticaNeue-Light" size:labelfontSize], NSFontAttributeName,
                                              nil];
        
        CGRect frame = [summaryLabel.text boundingRectWithSize:constraintSize
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:attributesDictionary
                                                       context:nil];
        
        CGSize stringSize = frame.size;
        //        if (stringSize.height>maxHeight) {
        //            stringSize.height = maxHeight;
        //        }
        summaryLabel.frame = CGRectMake(summaryLabel.frame.origin.x, summaryLabel.frame.origin.y, summaryLabel.frame.size.width, stringSize.height);
        
        pitchSubView.frame = CGRectMake(pitchSubView.frame.origin.x, pitchSubView.frame.origin.y, pitchSubView.frame.size.width, summaryLabel.frame.origin.y+summaryLabel.frame.size.height+10);
        
        pitchView.frame = CGRectMake(pitchView.frame.origin.x, pitchView.frame.origin.y, pitchView.frame.size.width, summaryLabel.frame.origin.y+summaryLabel.frame.size.height+10);
        expiryView.frame = CGRectMake(expiryView.frame.origin.x, pitchView.frame.origin.y+pitchView.frame.size.height+20, expiryView.frame.size.width, expiryView.frame.size.height);
        scrollvw.contentSize = CGSizeMake(self.view.frame.size.width, expiryView.frame.origin.y+expiryView.frame.size.height+20);
    }
    else if ([pitchJournalistsString isEqualToString:@"2"])
    {
        headerLabel.text =@"JOURNALIST";
        journalistView.hidden = NO;
        pitchView.hidden = YES;
        expiryView.frame = CGRectMake(expiryView.frame.origin.x, journalistView.frame.origin.y+journalistView.frame.size.height+20, expiryView.frame.size.width, expiryView.frame.size.height);
        scrollvw.contentSize = CGSizeMake(self.view.frame.size.width, expiryView.frame.origin.y+expiryView.frame.size.height+20);
        
        companyName.text = compantNameString;
        position.text = positionString;
        NSURL*Url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]];
        NSLog(@"%@",Url1);
        [userImageView setImageWithURL:Url1 placeholderImage:[UIImage imageNamed:@"userDefault.jpg"] imagesize:CGSizeMake(400, 400)];
        userImageView.layer.cornerRadius = userImageView.frame.size.height/2;
        userImageView.layer.masksToBounds = YES;
        
    }
    contentSizeHeight = scrollvw.contentSize.height;
}
- (void)viewDidLoad
{
    
    appdelegateInstance = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [super viewDidLoad];
 
   
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    [appdelegateInstance showHUD:@""];

    if (![APPDELEGATE xmppStream]) {
        [APPDELEGATE setupStream];
    }
    
    [APPDELEGATE startXMPPConnection];
    [self customButtonPressed:nil];
    [self commonCode];
    [self getTimer];
    [super viewWillAppear:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
    timer = nil;
    [super viewWillDisappear:YES];
}
- (IBAction)customButtonPressed:(id)sender {
    [messageTextView resignFirstResponder];
     customButton.hidden = YES;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        bottomView.frame=CGRectMake(bottomView.frame.origin.x,[[UIScreen mainScreen] bounds].size.height-80, bottomView.frame.size.width, bottomView.frame.size.height);
        scrollvw.contentSize = CGSizeMake(self.view.frame.size.width, contentSizeHeight);

    }
    else{
    bottomView.frame=CGRectMake(bottomView.frame.origin.x,[[UIScreen mainScreen] bounds].size.height-60, bottomView.frame.size.width, bottomView.frame.size.height);
     scrollvw.contentSize = CGSizeMake(self.view.frame.size.width, contentSizeHeight);
    }
}

- (void)updateCounter:(NSTimer *)theTimer {
    
    if(secondsLeft > 0 ){
        secondsLeft -- ;
        if (secondsLeft ==0 ) {
           // [self.navigationController popViewControllerAnimated:YES];
            [self runAPIForExpirePitch];
        }
        else{
            days = secondsLeft / (3600*24);
            hours = (secondsLeft % (3600*24))/3600;
            minutes = (secondsLeft % 3600) / 60;
            seconds = (secondsLeft %3600) % 60;
        daylabel.text = [NSString stringWithFormat:@"%02d Days",days];
        hoursLabel.text = [NSString stringWithFormat:@"%02d",hours];
         minutesLabel.text = [NSString stringWithFormat:@"%02d",minutes];
         secondsLabel.text = [NSString stringWithFormat:@"%02d",seconds];
        }
    }
}
-(void)countdownTimer{
  days =  hours = minutes = seconds = 0;
    if([timer isValid])
    {
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
}
-(void)runAPIForExpirePitch
{
    
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
    NSDictionary *dictParams;
    
    strWebService=[[NSString alloc]initWithFormat:@"%@expirepitch",AppURL];
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:pitchIdString,@"pitch_id",
                    nil];
    NSLog(@"%@",strWebService);
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
             [appdelegateInstance hideHUD];
             NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             if ([str isEqualToString:@"0"] )
             {
                 [self.navigationController popViewControllerAnimated:YES];
             }
             else if ([str isEqualToString:@"10"] )
             {
                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 alert.tag = 1234;
                 [alert show];
             }
             else if ([str isEqualToString:@"11"] )
             {
                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 alert.tag = 12000;
                 [alert show];
             }
             else{
//                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)getTimer{
    
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
     NSDictionary *dictParams;
    // pitchJournalistsString =1 for pitch 2 for journalists
    if ([pitchJournalistsString isEqualToString:@"1"]) {
        strWebService=[[NSString alloc]initWithFormat:@"%@setTimerJournalist",AppURL];
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:pitchIdString,@"pitch_id",
                    nil];
    }
   else if ([pitchJournalistsString isEqualToString:@"2"]) {
       strWebService=[[NSString alloc]initWithFormat:@"%@setTimerClient",AppURL];
       NSLog(@"%@",pitchIdString);
       dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:
                   [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",
                   pitchIdForSetTimer,@"pitch_id",
                   userIdString,@"user_id_second",
                   nil];
    }
    NSLog(@"%@",strWebService);
    NSLog(@"%@",dictParams);
       [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
             NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             if ([str isEqualToString:@"0"] )
             {
                 NSInteger count;
                  if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]integerValue]>0)
                  {
                      count=[[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]integerValue]-1;
                  }else{
                      count=0;
                  }
                 
                 [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lu", (long)count] forKey:@"Count"];
                 
                 secondsLeft = [[[[response valueForKey:@"data"] valueForKey:@"User"] valueForKey:@"seconds_remain"] integerValue];
                 [self countdownTimer];
                 deleteString  =[[[response valueForKey:@"data"] valueForKey:@"User"] valueForKey:@"del"];
                 StatusString  =[[[response valueForKey:@"data"] valueForKey:@"User"] valueForKey:@"status"];
                 if ([StatusString isEqualToString:@"0"] || [deleteString isEqualToString:@"0"]) {
                     UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     [alert show];
                     alert.tag = 100;
                 }
             }
             else if ([str isEqualToString:@"10"] )
             {
                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 alert.tag = 1234;
                 [alert show];
             }
             else if ([str isEqualToString:@"11"] )
             {
                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 alert.tag = 12000;
                 [alert show];
             }
             else
             {
//                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
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
    if (alertView.tag==100) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (alertView.tag==1234) {
        AppDelegate *appd= (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appd LogoutFromApp:self];
    }
    if (alertView.tag==12000) {
        [self.navigationController popViewControllerAnimated:YES];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)popview:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [APPDELEGATE disconnect];

}
- (void)sendChat
{
    [APPDELEGATE disconnect];

    [USERDEFAULTS removeObjectForKey:MYXMPPID];
    [USERDEFAULTS removeObjectForKey:OPENNENTNAME];
    [USERDEFAULTS synchronize];
    
        LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
        NSString*strWebService;
        NSDictionary *dictParams;
        strWebService=[[NSString alloc]initWithFormat:@"%@send_chat",AppURL];
        dictParams = [[NSDictionary alloc]initWithObjectsAndKeys:
                  [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"from_user"
                  ,userIdString,@"to_user",
                  [NSString stringWithFormat:@"%@_%@_%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"],userIdString,pitchIdString],@"chat_id",
                  pitchSelectorIdString,@"pitch_selector_id",
                  pitchIdString,@"pitch_id",
                  nil];

        NSLog(@"%@",strWebService);
        NSLog(@"%@",dictParams);
        [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
         {
             if (!error)
             {
                 NSLog(@"response of get request:%@",response);
                 NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
                 if ([str isEqualToString:@"0"] )
                 {
                     
                     
                 }
                 
                 NSString *strMessage1 = @"Congrats! You’ve started a Chat. This pitch will now remain in the Chat section and will no longer be in Liked Pitches. If you decide to umatch with this pitcher, simply hit End Chat.";
                 
                 if ([constant getDeviceVersion] >= 8.0)
                 {
                     UIAlertController *alertMessage= [UIAlertController alertControllerWithTitle:KAPPNAME message:strMessage1 preferredStyle:UIAlertControllerStyleAlert];
                     
                     UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Thanks, got it!" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                         
                         [self performSelector:@selector(dealay) withObject:nil afterDelay:1];
                         
                     }];
                     
                     [alertMessage addAction:ok];
                     [self presentViewController:alertMessage animated:YES completion:nil];
                     
                 }
                 else
                 {
                     UIAlertView *alertMessage = [[UIAlertView alloc] initWithTitle:KAPPNAME message:strMessage1 delegate:self cancelButtonTitle:@"Thanks, got it!" otherButtonTitles:nil, nil];
                     //                     alertMessage.tag = 100;
                     [alertMessage show];
                     
                     [self performSelector:@selector(dealay) withObject:nil afterDelay:1];
                 }
             }
             else
             {
                 NSLog(@"%@",error.description);
             }
         }];

    
   
}

-(void)dealay
{
     AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
//    if (app.count>0){
//        app.count=app.count-1;
//        app.totalNotifyCountMinusCount=0;
//        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lu",(long)app.totalNotifyCountMinusCount] forKey:@"MinusCount"];
//        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lu",(long)app.count] forKey:@"Count"];
//    }
//    else{
//        app.count=0;
//        app.totalNotifyCountMinusCount=0;
//        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lu", (long)app.count] forKey:@"Count"];
//        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lu",(long)app.totalNotifyCountMinusCount] forKey:@"MinusCount"];
//    }

    app.count=0;
    app.totalNotifyCountMinusCount=0;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lu", (long)app.count] forKey:@"Count"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lu",(long)app.totalNotifyCountMinusCount] forKey:@"MinusCount"];
    [APPDELEGATE disconnect];
     [[NSUserDefaults standardUserDefaults]setObject:@"showChatScreen" forKey:@"directCall"];
     [self.navigationController popViewControllerAnimated:YES];
}
- (void) textViewDidChange:(UITextView *)textView
{
    
    NSString *str=[messageTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    // messageTextView.text = ;
    
    if (str.length>0)
    {
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sendButton.userInteractionEnabled = YES;
    }
    else{
        [sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        sendButton.userInteractionEnabled = NO;
    }
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (messageTextView.text.length>0)
    {
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sendButton.userInteractionEnabled = YES;
    }
    else{
        [sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        sendButton.userInteractionEnabled = NO;
    }
}
- (IBAction)sendMessage:(id)sender
{
    messageTextView.text = [messageTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([messageTextView.text isEqualToString:@""] || messageTextView.text.length<=0 )
    {
        [constant alertViewWithMessage:@"Please enter some text." withView:self];
    }
    else
    {
        NSLog(@"oppend%@",_oppendXmppID);
        NSLog(@"journlistID%@",_strXmppID);
        
        [USERDEFAULTS setObject:_strXmppID forKey:MYXMPPID];
        [USERDEFAULTS setObject:_oppendXmppID forKey:OPENNENTNAME];
        [USERDEFAULTS synchronize];
//        if ([[USERDEFAULTS objectForKey:@"userTypeString"] isEqualToString:@"2"])
//        {
//            if (![APPDELEGATE xmppStream])
//            {
//                [APPDELEGATE setupStream];
//            }
//            [APPDELEGATE connectChannals:_strXmppID];
//        }else
//        {
            if (![APPDELEGATE xmppStream])
            {
                [APPDELEGATE setupStream];
            }
            [APPDELEGATE startXMPPConnection];
//        }

        sendButton.userInteractionEnabled = NO;
        [sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
       
        
        
        [messageTextView resignFirstResponder];
        messageTextView.text =@"";
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        bottomView.frame=CGRectMake(bottomView.frame.origin.x,[[UIScreen mainScreen] bounds].size.height-80, bottomView.frame.size.width, bottomView.frame.size.height);
                    customButton.hidden = YES;
             scrollvw.contentSize = CGSizeMake(self.view.frame.size.width, contentSizeHeight);

        }
        else{
        scrollvw.contentSize = CGSizeMake(self.view.frame.size.width, contentSizeHeight);
            bottomView.frame=CGRectMake(bottomView.frame.origin.x,[[UIScreen mainScreen] bounds].size.height-60, bottomView.frame.size.width, bottomView.frame.size.height);
            customButton.hidden = YES;
        }
    }
}
-(void)didConnectedToXmpp;
{    [appdelegateInstance hideHUD];
}
-(void)sendMessageXMPP
{
    NSString*time = @"";
    NSString*messageStr = @"";
    NSString*strFinalOpponentName = @"";
    NSDate *date = [NSDate date];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setTimeZone:[NSTimeZone localTimeZone]];
    [_formatter setDateFormat:@"dd/MM/yy HH:mm:ss.SSS"];
    

    time = [_formatter stringFromDate:date];
    messageStr = messageTextView.text;
    NSString*messageThreadID = @"";
        NSString *strIsRead =  @"1";
        NSDictionary *dicTemp;
        dicTemp = [NSDictionary dictionaryWithObjectsAndKeys:messageStr, @"lastMessage",
                   _strXmppID.uppercaseString, @"lastMessageFromUser",
                   time, @"messageTime",
                   _oppendXmppID.uppercaseString, @"opponentXMPPID",
                   strFinalOpponentName,@"opponentDisplayName",
                   strIsRead,@"isRead",@"1",@"userType",
                   nil];
        
        int tID1 = (int)[[Database sharedObject] insertToTable:@"lastMessageMaster" withValues:dicTemp];
        NSLog(@"%d",tID1);
    
    [[APPDELEGATE xmppMessenger] setTargetJID:[XMPPJID jidWithString:[_oppendXmppID stringByAppendingFormat:@"@%@",IPAddress]]];
    
    [[APPDELEGATE xmppMessenger] sendMessage:messageTextView.text];
   
    
}
- (IBAction)infoButtonPressed:(id)sender
{
    [APPDELEGATE disconnect];
    ProfileViewController*obj;
    obj=[self.storyboard instantiateViewControllerWithIdentifier:@"profileController"];
    obj.comeFromSring =@"1";
    obj.userIDShowProfile = userIdString;
    [self.navigationController pushViewController:obj animated:YES];

}
@end
