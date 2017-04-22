//
//  manageJournalistViewController.m
//  uPitch
//
//  Created by Puneet Rao on 18/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import "manageJournalistViewController.h"
#import "SWRevealViewController.h"
#import "LxReqRespManager.h"
#import "UIImageView+WebCache.h"
#import "manageUserObjectClass.h"
#import "ExpiryTimeViewController.h"
#import "chatScreemViewController.h"
#import "CustomButton.h"
#import "constant.h"
#import "PitchDetailsViewController.h"
@interface manageJournalistViewController ()

@end

@implementation manageJournalistViewController

- (void)viewDidLoad {
    // tableVw.allowsMultipleSelectionDuringEditing = NO;
    //[tableVw setEditing:YES animated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PubNubNotification:) name:@"pubnubnot" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PubNubNotificationhigh:) name:@"pubnubnotHighLight" object:nil];
    if ([USERDEFAULTS objectForKey:@"typeNot"] != nil)
    {
 
        if ([[USERDEFAULTS objectForKey:@"typeNot"] isEqualToString:@"8"])
        {
            _matchesChatString = @"2";
            [USERDEFAULTS removeObjectForKey:@"typeNot"];
        }else
        {
            _matchesChatString = @"1";
        }
    }
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTestNotification:) name:@"Matches" object:nil];
    [super viewDidLoad];
    [_btnChat setExclusiveTouch:YES];
    [_btnMatch setExclusiveTouch:YES];
    // Do any additional setup after loading the view.
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    _matchesChatString =@"1";
    //    tableVw.allowsMultipleSelectionDuringEditing = NO;
    //    [tableVw setEditing:YES animated:NO];
    lineImageViewMatches.hidden = NO;
    lineImageViewChat.hidden = YES;
    headerLabel.text =@"MATCHES";
    chatIconButton.hidden = NO;
    
    [self getCount];
    [appdelegateInstance showHUD:@""];

    [self runApi];
}
-(void)PubNubNotification:(NSNotification *) notification
{
    
    NSLog(@"PUbnubNoti");
    if ([_matchesChatString isEqualToString:@"1"]){
        [self getCount];
    }
    
}
-(void)PubNubNotificationhigh:(NSNotification *) notification
{
    
    NSLog(@"PUbnubNoti");
    if ([_matchesChatString isEqualToString:@"1"]){
        [self getCount];
    }
    
}
- (id) init
{
    self = [super init];
    if (!self) return nil;
    
    // Add this instance of TestClass as an observer of the TestNotification.
    // We tell the notification center to inform us of "TestNotification"
    // notifications using the receiveTestNotification: selector. By
    // specifying object:nil, we tell the notification center that we are not
    // interested in who posted the notification. If you provided an actual
    // object rather than nil, the notification center will only notify you
    // when the notification was posted by that particular object.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(PubNubNotificationhigh:)
                                                 name:@"pubnubnotHighLight"
                                               object:nil];
    
    return self;
}

-(void)dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
}
//
//- (id) init
//{
//    self = [super init];
//    if (!self) return nil;
//
//    // Add this instance of TestClass as an observer of the TestNotification.
//    // We tell the notification center to inform us of "TestNotification"
//    // notifications using the receiveTestNotification: selector. By
//    // specifying object:nil, we tell the notification center that we are not
//    // interested in who posted the notification. If you provided an actual
//    // object rather than nil, the notification center will only notify you
//    // when the notification was posted by that particular object.
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(receiveTestNotification:)
//                                                 name:@"pubnubnot"
//                                               object:nil];
//
//    return self;
//}
-(void)getCount
{
    
    //    if ([_matchesChatString isEqualToString:@"1"])
    //    {
    //        btnCount.hidden=NO;
    //        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]integerValue]>0) {
    //            lblCount.hidden=NO;
    //            imgCount.hidden=NO;
    //            lblCount.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]];
    //        }
    //        else
    //        {
    //
    //            AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    //            app.count=0;
    //            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lu", (long)app.count] forKey:@"Count"];
    //            lblCount.hidden=YES;
    //            imgCount.hidden=YES;
    //        }
    //    }
    //    else
    //    {
    //        AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    //        app.count=0;
    //        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lu", (long)app.count] forKey:@"Count"];
    //        lblCount.hidden=YES;
    //        imgCount.hidden=YES;
    //        btnCount.hidden=YES;
    //    }
    
    if (lineImageViewChat.hidden)
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
    }
    else
    {
        NSLog(@"Nothidden");
        AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
        app.count=0;
        app.totalNotifyCountMinusCount=0;
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lu",(long)app.totalNotifyCountMinusCount] forKey:@"MinusCount"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lu", (long)app.count] forKey:@"Count"];
        lblCount.hidden=YES;
        imgCount.hidden=YES;
        btnCount.hidden=YES;
    }
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}
-(void)compareDates1 : (NSDate*)date : (int)index{
    NSLog(@"compareDates1");
    date1 = date;
}
-(void)compareDates2 : (NSDate*)date : (int)index{
    NSLog(@"compareDates2");
    date2 = date;
    if ([date1 compare:date2] == NSOrderedDescending)
    {
        NSLog(@"NSOrderedDescending %@ %@",date1,date2);
        dateCompareBool = YES;
    }
    else if ([date1 compare:date2] == NSOrderedAscending)
    {
        NSLog(@"NSOrderedAscending %@ %@",date1,date2);
        dateCompareBool = NO;
    }
}
-(void)getLastMessage
{
    NSMutableArray *arrData = [[NSMutableArray alloc] init];
    Database*database = [Database sharedObject];
    unreadMessageCount= [[NSMutableArray alloc] init];
    for(int i=0;i<[mainArrayChat count];i++)
    {
//        NSString* from = [NSString stringWithFormat:@"user_%@_0",[USERDEFAULTS objectForKey:@"userid"]];
//        
//        NSString *to = [NSString stringWithFormat:@"user_%@_%@",[[mainArrayChat objectAtIndex:i] userId],[[mainArrayChat objectAtIndex:i] strPitchId]];
//        
//        NSString *strSelectQuery = [NSString stringWithFormat:@"SELECT * FROM latestMessageMaster WHERE ((opponentXMPPID = '%@' AND lastMessageFromUser= '%@') OR (opponentXMPPID = '%@' AND lastMessageFromUser= '%@')) AND isRead='0'", from.uppercaseString, to.uppercaseString,to.uppercaseString,from.uppercaseString];
//        
//        NSString *strSelAll = [NSString stringWithFormat:@"SELECT * FROM latestMessageMaster WHERE (opponentXMPPID = '%@' AND lastMessageFromUser= '%@') OR (opponentXMPPID = '%@' AND lastMessageFromUser= '%@')", from.uppercaseString, to.uppercaseString,to.uppercaseString,from.uppercaseString];
//        NSMutableArray*latest = [database executeSelectQuery:strSelectQuery];
//        NSMutableArray *lastMessageArr = [database executeSelectQuery:strSelAll];
//        NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc] init];
//        [dictTemp setObject:from forKey:@"opponentid"];
//        [dictTemp setObject:to forKey:@"userid"];
//        NSString *strUnreadCount = [NSString stringWithFormat:@"%d",latest.count];
//        
//        if (lastMessageArr.count > 0)
//        {
//            [dictTemp setObject:[[lastMessageArr lastObject] objectForKey:@"lastMessage"] forKey:@"lastmessage"];
//        }
//        manageUserObjectClass *obj = [mainArrayChat objectAtIndex:i];
//        obj.unreadcount = strUnreadCount;
//        
//        obj.lastmessage = [[lastMessageArr lastObject] objectForKey:@"lastMessage"];
//        obj.opponentid = from;
//        obj.xmppUserId = to;
//        obj.lastmessagetime = [[lastMessageArr lastObject] objectForKey:@"messageTime"];
//        [arrData addObject:obj];
//        [dictTemp setObject:strUnreadCount forKey:@"unreadcount"];
//        [unreadMessageCount addObject:dictTemp];
        NSString* from = [NSString stringWithFormat:@"user_%@_0",[USERDEFAULTS objectForKey:@"userid"]];
  
        NSString *to = [NSString stringWithFormat:@"user_%@_%@",[[mainArrayChat objectAtIndex:i] userId],[[mainArrayChat objectAtIndex:i] strPitchId]];
        
        NSString *strSelectQuery = [NSString stringWithFormat:@"SELECT * FROM lastMessageMaster WHERE ((opponentXMPPID = '%@' AND lastMessageFromUser= '%@') OR (opponentXMPPID = '%@' AND lastMessageFromUser= '%@')) AND isRead='0'", from.uppercaseString, to.uppercaseString,to.uppercaseString,from.uppercaseString];
        
        NSString *strSelAll = [NSString stringWithFormat:@"SELECT * FROM lastMessageMaster WHERE (opponentXMPPID = '%@' AND lastMessageFromUser= '%@') OR (opponentXMPPID = '%@' AND lastMessageFromUser= '%@')", from.uppercaseString, to.uppercaseString,to.uppercaseString,from.uppercaseString];
        NSMutableArray*latest = [database executeSelectQuery:strSelectQuery];
        NSMutableArray *lastMessageArr = [database executeSelectQuery:strSelAll];
        NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc] init];
        [dictTemp setObject:from forKey:@"opponentid"];
        [dictTemp setObject:to forKey:@"userid"];
        NSString *strUnreadCount = [NSString stringWithFormat:@"%d",latest.count];
        
        if (lastMessageArr.count > 0)
        {
            [dictTemp setObject:[[lastMessageArr lastObject] objectForKey:@"lastMessage"] forKey:@"lastmessage"];
        }
        manageUserObjectClass *obj = [mainArrayChat objectAtIndex:i];
        obj.unreadcount = strUnreadCount;
        
        obj.lastmessage = [[lastMessageArr lastObject] objectForKey:@"lastMessage"];
        obj.opponentid = from;
        obj.xmppUserId = to;
        obj.lastmessagetime = [[lastMessageArr lastObject] objectForKey:@"messageTime"];
        [arrData addObject:obj];
        [dictTemp setObject:strUnreadCount forKey:@"unreadcount"];
        [unreadMessageCount addObject:dictTemp];
        
    }
  
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastmessagetime"
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSArray *sortedArray = [arrData sortedArrayUsingDescriptors:sortDescriptors];
    mainArrayChat = [[NSMutableArray alloc] init];

    mainArrayChat = [sortedArray mutableCopy];
    [tableVw reloadData];
    NSLog(@"%@",unreadMessageCount);
    
}

-(void)runApi
{
    messageLabel.hidden = NO;
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    
    NSString*strWebService;
    NSDictionary *dictParams;
    if ([_matchesChatString isEqualToString:@"1"]) {
        strWebService=[[NSString alloc]initWithFormat:@"%@match_journalist",AppURL];
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",
                    nil];
        messageLabel.text = @"No matches found.";
        messageLabel.hidden = YES;
    }
    else{
        strWebService=[[NSString alloc]initWithFormat:@"%@show_chat",AppURL];
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",
                    nil];
        messageLabel.text = @"You do not have a match to chat with.";
        messageLabel.hidden = YES;

    }
    NSLog(@"%@",strWebService);
    
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         NSLog(@"in");
         if (!error)
         {
             mainArray=[[NSMutableArray alloc]init];
             mainArrayChat=[[NSMutableArray alloc]init];
             
             NSString *strDeviceToken = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"deviceToken"]];
             NSString *strUserID = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"userid"]];
             
             [constant clearChatMatchCountP:strDeviceToken userIDfor:strUserID type:_matchesChatString];

             NSLog(@"response of get request:%@",response);
             [appdelegateInstance hideHUD];
             NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             
             if ([_matchesChatString isEqualToString:@"1"]) {
                 if ([str isEqualToString:@"0"] )
                 {
                     mainArray = [[NSMutableArray alloc] init];

                     for (int k=0; k<[[response valueForKey:@"data"] count]; k++)
                     {
                         manageUserObjectClass* objectClass = [[manageUserObjectClass alloc] init];
                         
                         objectClass.userName = [NSString stringWithFormat:@"%@ %@",[[[[response valueForKey:@"data"] valueForKey:@"User"] valueForKey:@"first_name"] objectAtIndex:k],[[[[response valueForKey:@"data"] valueForKey:@"User"] valueForKey:@"last_name"] objectAtIndex:k]];
                         objectClass.userCompany=[[[[response valueForKey:@"data"] valueForKey:@"User"] valueForKey:@"company"] objectAtIndex:k] ;
                         objectClass.userPosition=[[[[response valueForKey:@"data"] valueForKey:@"User"] valueForKey:@"designation"] objectAtIndex:k] ;
                         objectClass.userImage=[[[[response valueForKey:@"data"] valueForKey:@"User"] valueForKey:@"photo"] objectAtIndex:k] ;
                         
                         objectClass.pitchNewId=[[[[response valueForKey:@"data"] valueForKey:@"pitch_selectors"] valueForKey:@"pitch_id"] objectAtIndex:k] ;
                         
                         objectClass.userId=[[[[response valueForKey:@"data"] valueForKey:@"pitch_selectors"] valueForKey:@"user_id"] objectAtIndex:k] ;
                         objectClass.pitchId=[[[[response valueForKey:@"data"] valueForKey:@"pitch_selectors"] valueForKey:@"id"] objectAtIndex:k] ;
                         objectClass.pitchTitle=[[[[response valueForKey:@"data"] valueForKey:@"pitches"] valueForKey:@"title"] objectAtIndex:k] ;
                         objectClass.highlightFlag = [[[[response valueForKey:@"data"] valueForKey:@"pitch_selectors"] valueForKey:@"pitcher_pitch_read_status"] objectAtIndex:k];
                         objectClass.pitchSelectorId =[NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"pitch_selectors"] valueForKey:@"pitch_id"] objectAtIndex:k] ] ;
                         [mainArray addObject:objectClass];
                     }
                     if (mainArray.count>0) {
                        
                         if ([[USERDEFAULTS objectForKey:ISUSERFIRSTTIME] boolValue] == YES)
                         {
                             [USERDEFAULTS setBool:NO forKey:ISUSERFIRSTTIME];
                             [USERDEFAULTS synchronize];
//                             NSString *strMessage1 = @"When you click on a Liked Pitch a conversation initiate with the person who posted the pitch.";
                             
                              NSString *strMessage1 = @"To initiate a chat with the pitcher, tap the pitch and type your message into the message box at the bottom of your screen.";
                             
                             NSString *strMessage2 = @"If a match is no longer in Liked Pitches it's because either a conversation has been started or a user unmatched with you.";
                             if ([constant getDeviceVersion] >= 8.0)
                             {
                                 UIAlertController *alertMessage= [UIAlertController alertControllerWithTitle:KAPPNAME message:strMessage1 preferredStyle:UIAlertControllerStyleAlert];
                                
                                 UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Thanks, got it!" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                     UIAlertController *alertMessage= [UIAlertController alertControllerWithTitle:KAPPNAME message:strMessage2 preferredStyle:UIAlertControllerStyleAlert];
                                     UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                                     [alertMessage addAction:ok];

                                     [self presentViewController:alertMessage animated:YES completion:nil];

                                 }];
                                 
                                 [alertMessage addAction:ok];
                                 [self presentViewController:alertMessage animated:YES completion:nil];
                                 
                             }else
                             {
                                 UIAlertView *alertMessage = [[UIAlertView alloc] initWithTitle:KAPPNAME message:strMessage1 delegate:self cancelButtonTitle:@"Thanks, got it!" otherButtonTitles:nil, nil];
                                 alertMessage.tag = 100;
                                 [alertMessage show];
                             }
                             
                             
                             
                         }
                         tableVw.delegate = self;
                         tableVw.dataSource =self;
                         [tableVw reloadData];
                         tableVw.hidden = NO;
                         messageLabel.hidden = YES;
                     }
                     else{
                         tableVw.hidden = YES;
                         messageLabel.hidden = NO;
                     }
                 }
                 else if ([str isEqualToString:@"1"] )
                 {
                     tableVw.hidden = YES;
                     messageLabel.hidden = NO;
                     tableVw.delegate = self;
                     tableVw.dataSource =self;
                     [tableVw reloadData];
                 }
                 else if ([str isEqualToString:@"10"] )
                 {
                     UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                     alert.tag = 1234;
                     [alert show];
                 }
             }
             if ([_matchesChatString isEqualToString:@"2"]) {
                 // chat screen goes here
                 if ([str isEqualToString:@"0"] )
                 {
                     mainArrayChat=[[NSMutableArray alloc]init];
                     userLoginImagePath = [response valueForKey:@"phototag"];
                     
                     for (int k=0; k<[[response valueForKey:@"data"] count]; k++) {
                         manageUserObjectClass* objectClass = [[manageUserObjectClass alloc] init];
                         objectClass.userName=[[[[response valueForKey:@"data"] valueForKey:@"b"] valueForKey:@"name"] objectAtIndex:k] ;
                         //  objectClass.userCompany=[[[[response valueForKey:@"data"] valueForKey:@"User"] valueForKey:@"company"] objectAtIndex:k] ;
                         objectClass.userCompany=@"" ;
                         //  objectClass.userPosition=[[[[response valueForKey:@"data"] valueForKey:@"User"] valueForKey:@"designation"] objectAtIndex:k] ;
                         objectClass.userImage=[[[[response valueForKey:@"data"] valueForKey:@"b"] valueForKey:@"photo"] objectAtIndex:k] ;
                         objectClass.userId=[[[[response valueForKey:@"data"] valueForKey:@"b"] valueForKey:@"user_id"] objectAtIndex:k] ;
                         // objectClass.pitchId=[[[[response valueForKey:@"data"] valueForKey:@"b"] valueForKey:@"to_user"] objectAtIndex:k] ;
                         objectClass.chatId=[[[[response valueForKey:@"data"] valueForKey:@"a"] valueForKey:@"id"] objectAtIndex:k] ;
                         objectClass.deviceToken=[[[[response valueForKey:@"data"] valueForKey:@"b"] valueForKey:@"device_id"] objectAtIndex:k] ;
                         
                         objectClass.strPitchId=[[[[response valueForKey:@"data"] valueForKey:@"0"] valueForKey:@"pitch_id"] objectAtIndex:k] ;
                         objectClass.strPitchTitle=[[[[response valueForKey:@"data"] valueForKey:@"0"] valueForKey:@"pitch_title"] objectAtIndex:k] ;
                         
                         [mainArrayChat addObject:objectClass];
                     }
                     [self getLastMessage];
                     if (mainArrayChat.count>0)
                     {
                         
                         tableVw.delegate = self;
                         tableVw.dataSource =self;
                         
                         tableVw.hidden = NO;
                         messageLabel.hidden = YES;
                     }
                     else{
                         messageLabel.text  =@"You do not have a match to chat with.";

                         //messageLabel.text  =@"You do not have any friend to chat";
                         tableVw.hidden = YES;
                         messageLabel.hidden = NO;
                         [tableVw reloadData];
                     }
                 }
                 else if ([str isEqualToString:@"1"] )
                 {
                     //messageLabel.text  =@"You do not have any friend to chat";
                     messageLabel.text  =@"You do not have a match to chat with.";
                     [self deleteAllChat];

                     messageLabel.hidden = NO;
                     tableVw.hidden = YES;
                     tableVw.delegate = self;
                     tableVw.dataSource =self;
                     [tableVw reloadData];
                 }
                 else if ([str isEqualToString:@"10"] )
                 {
                     UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                     alert.tag = 1234;
                     [alert show];
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        [constant alertViewWithMessage:@"If a match is no longer in Liked Pitches it's because either a conversation has been started or a user unmatched with you." withView:self];
    }
   
    if (alertView.tag==1234)
    {
        AppDelegate *appd= (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appd LogoutFromApp:self];
    }
}

-(void)deleteAllChat
{
//    bool a = [[Database sharedObject] deleteData:@"delete from latestMessageMaster"];

}

#pragma mark Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_matchesChatString isEqualToString:@"1"]) {
        
        if ([[[mainArray objectAtIndex:indexPath.row] highlightFlag] isEqualToString:@"0"]) {
            LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
            NSString*strWebService;
            NSDictionary *dictParams;
            
            NSLog(@"%@",[mainArray objectAtIndex:indexPath.row]);
            
            strWebService=[[NSString alloc]initWithFormat:@"%@update_pitcher_read_status",AppURL];
            dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",[NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row]pitchSelectorId]],@"pitch_id",[[mainArray objectAtIndex:indexPath.row]pitchId],@"pitch_selector_id",
                        nil];
            //pitch_selector_id
            
            [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
             {
                 
                 
                 NSLog(@"%@",response);
                 
             }];
        }
        ExpiryTimeViewController*obj;
        obj=[self.storyboard instantiateViewControllerWithIdentifier:@"expiryView"];
        obj.pitchJournalistsString = @"2";
        obj.urlString = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row]userImage]];
        obj.compantNameString = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row]userCompany]];
        obj.positionString = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row]userPosition]];
        obj.userIdString = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row]userId]];
        obj.pitchSelectorIdString = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row]pitchId]];
        obj.pitchIdForSetTimer= [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row]pitchNewId]];
        obj.pitchIdString=[NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row]pitchNewId]];
        // userId
        obj.strXmppID =[NSString stringWithFormat:@"user_%@_0",[USERDEFAULTS objectForKey:@"userid"]];
        obj.oppendXmppID =[NSString stringWithFormat:@"user_%@_%@",[[mainArray objectAtIndex:indexPath.row] userId],[[mainArray objectAtIndex:indexPath.row] pitchNewId]];
        [USERDEFAULTS setObject:obj.strXmppID forKey:MYXMPPID];
        [USERDEFAULTS setObject:obj.oppendXmppID forKey:OPENNENTNAME];
        [USERDEFAULTS synchronize];
        
       
        [self.navigationController pushViewController:obj animated:YES];
    }
    else{
        chatScreemViewController*obj;
        obj=[self.storyboard instantiateViewControllerWithIdentifier:@"chatScreen"];
        obj.userIdString =  [NSString stringWithFormat:@"%@",[[mainArrayChat objectAtIndex:indexPath.row]userId]];
        obj.chatIdString =  [NSString stringWithFormat:@"%@",[[mainArrayChat objectAtIndex:indexPath.row]chatId]];
        obj.rivalImageViewPath =  [NSString stringWithFormat:@"%@",[[mainArrayChat objectAtIndex:indexPath.row]userImage]];
        obj.userNameHeaderString =  [NSString stringWithFormat:@"%@",[[mainArrayChat objectAtIndex:indexPath.row]userName]];
        obj.deviceTokenString =  [NSString stringWithFormat:@"%@",[[mainArrayChat objectAtIndex:indexPath.row]deviceToken]];
        obj.strPitchId=[NSString stringWithFormat:@"%@",[[mainArrayChat objectAtIndex:indexPath.row]strPitchId]];
        obj.strShowPitchName=[NSString stringWithFormat:@"%@",[[mainArrayChat objectAtIndex:indexPath.row]strPitchTitle]];
        obj.myXmppID = [NSString stringWithFormat:@"user_%@_0",[USERDEFAULTS objectForKey:@"userid"]];
        
        obj.oppennetXmppID = [NSString stringWithFormat:@"user_%@_%@",[[mainArrayChat objectAtIndex:indexPath.row] userId],[[mainArrayChat objectAtIndex:indexPath.row] strPitchId]];
        [USERDEFAULTS setObject:obj.myXmppID forKey:MYXMPPID];
        [USERDEFAULTS setObject:obj.oppennetXmppID forKey:OPENNENTNAME];
        [USERDEFAULTS synchronize];
        
      
        
        obj.loginImageViewPath = userLoginImagePath;
        
        
        [self.navigationController pushViewController:obj animated:YES];
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    static NSString *SimpleTableIdentifier = @"customCellManage";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                
                                     reuseIdentifier:SimpleTableIdentifier] ;
    }
    UIImageView*profileImage=(UIImageView*)[cell viewWithTag:1];
    UIImageView*circleImageView=(UIImageView*)[cell viewWithTag:10];
    UILabel*journalistName=(UILabel*)[cell viewWithTag:2];
    UILabel*companyName=(UILabel*)[cell viewWithTag:3];
    UILabel*Position=(UILabel*)[cell viewWithTag:4];
    UILabel*unreadMessageLabel=(UILabel*)[cell viewWithTag:11];
    UILabel*pitchTitleLabel=(UILabel*)[cell viewWithTag:12];
    UIImageView *imgHighlight = (UIImageView*)[cell.contentView viewWithTag:7005];

    
    
    circleImageView.hidden = YES;
    unreadMessageLabel.hidden = YES;
    pitchTitleLabel.hidden = YES;
    
    circleImageView.frame = CGRectMake(self.view.frame.size.width-40, circleImageView.frame.origin.y, circleImageView.frame.size.width, circleImageView.frame.size.height);
    unreadMessageLabel.frame = CGRectMake(self.view.frame.size.width-44, unreadMessageLabel.frame.origin.y, unreadMessageLabel.frame.size.width, unreadMessageLabel.frame.size.height);
    if ([_matchesChatString isEqualToString:@"1"])
    {
        Position.hidden = NO;
        pitchTitleLabel.hidden = NO;
        circleImageView.layer.cornerRadius = 0.1f;
        journalistName.text = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row] userName]];
        companyName.text = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row] userCompany]];
        Position.text = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row] userPosition]];
        pitchTitleLabel.text = [NSString stringWithFormat:@"Pitch Title:%@",[[mainArray objectAtIndex:indexPath.row] pitchTitle]];
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            imgHighlight.frame = CGRectMake(5, 5, 45, 30);
            
            companyName.frame = CGRectMake(160, 50, self.view.frame.size.width-150, 40);
            journalistName.frame = CGRectMake(160, 10, self.view.frame.size.width-150, 40);
            Position.frame = CGRectMake(160, 80, self.view.frame.size.width-150, 40);
        }
        else
        {
            imgHighlight.frame = CGRectMake(5, 5, 45, 30);
            
            Position.frame = CGRectMake(110, 55, self.view.frame.size.width-150, 30);
            companyName.frame = CGRectMake(110, 35, self.view.frame.size.width-150, 30);
            journalistName.frame = CGRectMake(110, 10, self.view.frame.size.width-150, 30);
        }
        profileImage.layer.cornerRadius = profileImage.frame.size.height/2;
        profileImage.layer.masksToBounds = YES;
        
        NSURL*Url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row] userImage]]];
        [profileImage setImageWithURL:Url1 placeholderImage:[UIImage imageNamed:@"userDefault.jpg"] imagesize:CGSizeMake(90, 90)];
        
        NSLog(@"%@",[[mainArray objectAtIndex:indexPath.row] highlightFlag]);
        if ([[[mainArray objectAtIndex:indexPath.row] highlightFlag] isEqualToString:@"0"]) {
            imgHighlight.image=[UIImage imageNamed:@"icn_new_arrival.png"];
            imgHighlight.hidden = NO;
        }
        else
        {
            imgHighlight.hidden = YES;
        }
    }
    else{
        // chat screen goes here
        UIImageView *imgHighlight = (UIImageView*)[cell.contentView viewWithTag:7005];
        unreadMessageLabel.hidden = YES;
        companyName.lineBreakMode = NSLineBreakByWordWrapping;
        circleImageView.hidden = NO;
        circleImageView.layer.cornerRadius = circleImageView.frame.size.height/2;
        
        
        journalistName.text = [NSString stringWithFormat:@"%@",[[mainArrayChat objectAtIndex:indexPath.row] userName]];
        if (!tableReloadBool) {
            companyName.text = [NSString stringWithFormat:@"%@",[[mainArrayChat objectAtIndex:indexPath.row] userCompany]];
        }
        
//        unreadMessageLabel.hidden = YES;
//        circleImageView.hidden = YES;
        
        ///        else{
        //            unreadMessageLabel.hidden = NO;
        //            circleImageView.hidden = NO;
        //        }
        circleImageView.layer.masksToBounds = YES;
        Position.hidden = NO;
        
        Position.numberOfLines=3;
        Position.font=[UIFont fontWithName:@"HelveticaNeue" size:13];
        Position.textColor=[UIColor blackColor];
        
        
        profileImage.layer.cornerRadius = 1;
        profileImage.layer.masksToBounds = YES;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            companyName.frame = CGRectMake(163, journalistName.frame.size.height+5, self.view.frame.size.width-210, 40);
            Position.frame = CGRectMake(163, 80,self.view.frame.size.width-210, 50);
            imgHighlight.frame = CGRectMake(5, 5, 45, 30);
            Position.font=[UIFont fontWithName:@"HelveticaNeue" size:17];
        }
        else{
            //  companyName.frame = CGRectMake(110, 35, self.view.frame.size.width-150, 60);
            journalistName.frame = CGRectMake(110, 10, self.view.frame.size.width-150, 30);
            companyName.frame = CGRectMake(110, 35, self.view.frame.size.width-120, 20);
            imgHighlight.frame = CGRectMake(5, 5, 45, 30);
            Position.frame = CGRectMake(110, 55,self.view.frame.size.width-150, 50);
        }
        companyName.text = [[mainArrayChat objectAtIndex:indexPath.row] lastmessage];

     
            
            //                NSLog(@"%@ and %@",[NSString stringWithFormat:@"%@_%@_%@",[[mainArrayChat objectAtIndex:indexPath.row]userId],[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"],[[mainArrayChat objectAtIndex:indexPath.row]strPitchId]],[[unreadMessageCount objectAtIndex:i] objectForKey:@"chatid"]);
            //
            //                NSString *strChatId =[NSString stringWithFormat:@"%@_%@_%@",[[mainArrayChat objectAtIndex:indexPath.row]userId],[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"],[[mainArrayChat objectAtIndex:indexPath.row]strPitchId]];
            //
            //                NSString *strChatIdFrom =[[unreadMessageCount objectAtIndex:i] objectForKey:@"chatid"];
            //
            //                if ([strChatId isEqualToString:strChatIdFrom])
            //                {
            if([[[mainArrayChat objectAtIndex:indexPath.row] unreadcount] integerValue]>0)
            {
                unreadMessageLabel.hidden = YES;
//                unreadMessageLabel.text = [NSString stringWithFormat:@"%ld",(long)[[[mainArrayChat objectAtIndex:indexPath.row] unreadcount] integerValue]];
                imgHighlight.hidden = NO;
                
            }
            else
            {
                unreadMessageLabel.hidden = YES;
                imgHighlight.hidden = YES;
            }
            //
            //                }
            
            
       
        
        
        
        
        Position.text=[NSString stringWithFormat:@"Pitch Title:\n%@",[[mainArrayChat objectAtIndex:indexPath.row] strPitchTitle]];
        int labelfontSize;
        int maxHeight;
        int stringWidth;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            labelfontSize =23;
            maxHeight =85;
            stringWidth = self.view.frame.size.width-170;
        }
        else{
            labelfontSize =13;
            maxHeight =60;
            stringWidth = self.view.frame.size.width-110;
        }
        CGSize constraintSize;
        constraintSize.height = MAXFLOAT;
        constraintSize.width = companyName.frame.size.width;
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIFont fontWithName:@"HelveticaNeue-Light" size:labelfontSize], NSFontAttributeName,
                                              nil];
        
        CGRect frame = [companyName.text boundingRectWithSize:constraintSize
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:attributesDictionary
                                                      context:nil];
        
        CGSize stringSize = frame.size;
        if (stringSize.width>stringWidth) {
            stringSize.width= stringWidth;
            constraintSize.width = stringSize.width;
            frame = [companyName.text boundingRectWithSize:constraintSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary context:nil];
            stringSize = frame.size;
            
        }
        if (stringSize.height>maxHeight) {
            stringSize.height = maxHeight;
        }
        companyName.numberOfLines = 1;
        // companyName.frame = CGRectMake(companyName.frame.origin.x, companyName.frame.origin.y, stringSize.width, stringSize.height+3);
        
        
        
        NSURL*Url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[mainArrayChat objectAtIndex:indexPath.row] userImage]]];
        [profileImage setImageWithURL:Url1 placeholderImage:[UIImage imageNamed:@"userDefault.jpg"] imagesize:CGSizeMake(90, 90)];
        
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)ShowPitch:(id)sender
{
    CustomButton *btn=(CustomButton*)sender;
    
    PitchDetailsViewController*obj;
    obj=[self.storyboard instantiateViewControllerWithIdentifier:@"pitchDetailJournalist"];
    obj.clientJournalistString = @"1";
    obj.strPitchId = [NSString stringWithFormat:@"%@",[[mainArrayChat objectAtIndex:btn.BtnIndex] strPitchId]];
    [self.navigationController pushViewController:obj animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        return 150;
    }
    if ([_matchesChatString isEqualToString:@"1"]) {
        return 130;
    }
    return 110;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_matchesChatString isEqualToString:@"1"]) {
        return mainArray.count;
    }
    return mainArrayChat.count;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    if ([_matchesChatString isEqualToString:@"1"]){
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            deletedIndex=indexPath.row;
            [self deletePitch:[NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row] pitchId]] pitchSelector:[NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row] pitchId]]];
        }
    }
}
-(void)deletePitch :(NSString*)idOfPitch pitchSelector:(NSString*)pitchSelectorId
{
    
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService=[[NSString alloc]initWithFormat:@"%@delete_match",AppURL];
    NSLog(@"%@",strWebService);
    NSDictionary *dictParams;
    
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",pitchSelectorId],@"pitch_selector_id",
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
                 [mainArray removeObjectAtIndex:deletedIndex];
                 [tableVw reloadData];
                 if (mainArray.count==0)
                 {
                     messageLabel.hidden = NO;
                     tableVw.hidden=YES;
                 }
             }
             else  if ([str isEqualToString:@"1"] )
             {
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
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    if ([_matchesChatString isEqualToString:@"1"]){
        return YES;
    }
    return NO;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Detemine if it's in editing mode
    if ([_matchesChatString isEqualToString:@"1"])
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (void)find:(id)sender
{
    //    Database*database = [Database sharedObject];
    //    unreadMessageCount = [[NSMutableArray alloc] init];
    //    for(int i=0;i<[mainArrayChat count];i++)
    //    {
    //        NSString* from = [NSString stringWithFormat:@"user_%@_0",[USERDEFAULTS objectForKey:@"userid"]];
    //        NSString *to = [NSString stringWithFormat:@"user_%@_%@",[[mainArrayChat objectAtIndex:i] userId],[[mainArrayChat objectAtIndex:i] strPitchId]];
    //        NSString *strSelectQuery = [NSString stringWithFormat:@"SELECT * FROM latestMessageMaster WHERE ((opponentXMPPID = '%@' AND lastMessageFromUser= '%@') OR (opponentXMPPID = '%@' AND lastMessageFromUser= '%@')) AND isRead='0'", from.uppercaseString, to.uppercaseString,to.uppercaseString,from.uppercaseString];
    //        NSMutableArray*latest = [database executeSelectQuery:strSelectQuery];
    //        NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc] init];
    //        [dictTemp setObject:from forKey:@"opponentid"];
    //        [dictTemp setObject:to forKey:@"userid"];
    //        NSString *strUnreadCount = [NSString stringWithFormat:@"%d",latest.count];
    //        [dictTemp setObject:@"10" forKey:@"unreadcount"];
    //        [dictTemp setObject:[latest objectAtIndex:latest.count-1                                                                          ] forKey:@"lastmessage"];
    //        [unreadMessageCount addObject:dictTemp];
    //    }
    //    NSLog(@"%@",unreadMessageCount);
}
-(void)viewWillAppear:(BOOL)animated
{
    
    // database code goes here
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"uPitchDb.sqlite"]];
    unreadMessageCount = [[NSMutableArray alloc]init];
    
    self.navigationController.navigationBar.hidden=YES;
    tableVw.delegate = nil;
    tableVw.dataSource =nil;
    tableVw.hidden = YES;
    
    appdelegateInstance = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appdelegateInstance showHUD:@""];
    
    NSInteger countNoti=[[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]integerValue];
    NSInteger countMinusNoti=[[[NSUserDefaults standardUserDefaults]valueForKey:@"MinusCount"]integerValue];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"directCall"] isEqualToString:@"showChatScreen"])
    {
        if (countMinusNoti-countNoti>0 &&countNoti==0)
        {
            AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
            app.NotificationCount=0;
            app.totalNotifyCountMinusCount=0;
            lblCount.hidden=YES;
            imgCount.hidden=YES;
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lu",(long)app.totalNotifyCountMinusCount] forKey:@"MinusCount"];
            [[NSUserDefaults standardUserDefaults]setObject:@"nice" forKey:@"directCall"];
        }
    }
    

    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"directCall"] isEqualToString:@"showChatScreen"]) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"directCall"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        _matchesChatString =@"2";
        //        AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
        //        app.count=0;
        [self cahtButtonPressed:nil];
    }
    else
    {
        if ([_matchesChatString isEqualToString:@"2"])
        {
            [self cahtButtonPressed:nil];
            
        }else if ([_matchesChatString isEqualToString:@"1"])
        {
            [self matchesButtonPressed:nil];
        }else
        {
            _matchesChatString =@"1";
            [self runApi];
        };
    }
    
    
    NSString *strDeviceToken = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"deviceToken"]];
    NSString *strUserID = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"userid"]];
    
    [self getCount];
//    [self runApi];
    [self leftSlider];
    [super viewWillAppear:animated];
    // for PopUp first time journalist log in
    
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
        button.frame = CGRectMake(0, 0, 50, 55);
    }
    [self.view addSubview:button];
    
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

- (IBAction)cahtButtonPressed:(id)sender {
    
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    app.count=0;
    app.totalNotifyCountMinusCount=0;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lu",(long)app.totalNotifyCountMinusCount] forKey:@"MinusCount"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lu", (long)app.count] forKey:@"Count"];
    NSLog(@"show chat data");
    
    tableVw.allowsMultipleSelectionDuringEditing = NO;
    [tableVw setEditing:NO animated:NO];
    _matchesChatString =@"2";
   
    lineImageViewMatches.hidden = YES;
    lineImageViewChat.hidden = NO;
    headerLabel.text = @"CHATS";
    chatIconButton.hidden = YES;
    
    [self getCount];
    //    chatScreemViewController*obj;
    //    obj=[self.storyboard instantiateViewControllerWithIdentifier:@"chatScreen"];
    //    [self.navigationController pushViewController:obj animated:YES];
    [mainArray removeAllObjects];
    [mainArrayChat removeAllObjects];
    //    tableVw.delegate = self;
    //    tableVw.dataSource =self;
    [tableVw reloadData];
    [appdelegateInstance showHUD:@""];
    [self runApi];
    unreadMessageCount = [[NSMutableArray alloc]init];
}

- (IBAction)matchesButtonPressed:(id)sender {
    tableVw.allowsMultipleSelectionDuringEditing = NO;
    [tableVw setEditing:NO animated:YES];
    _matchesChatString =@"1";
    NSString *strDeviceToken = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"deviceToken"]];
    NSString *strUserID = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"userid"]];
    
    [constant clearChatMatchCountP:strDeviceToken userIDfor:strUserID type:_matchesChatString];
    lineImageViewMatches.hidden = NO;
    lineImageViewChat.hidden = YES;
    headerLabel.text = @"MATCHES";
    chatIconButton.hidden = NO;
    [self getCount];
    [mainArray removeAllObjects];
    [mainArrayChat removeAllObjects];
    //    tableVw.delegate = self;
    //    tableVw.dataSource =self;
    [tableVw reloadData];
    [appdelegateInstance showHUD:@""];
    [self runApi];
}
- (IBAction)topchatIconPressed:(id)sender
{
    [self cahtButtonPressed:nil];
}
@end
