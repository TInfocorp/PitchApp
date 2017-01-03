//
//  viewPitchesViewController_Journalists.m
//  uPitch
//
//  Created by Puneet Rao on 18/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import "viewPitchesViewController_Journalists.h"
#import "SWRevealViewController.h"
#import "LxReqRespManager.h"
#import "UIImageView+WebCache.h"
#import "manageUserObjectClass.h"
#import "ExpiryTimeViewController.h"
#import "chatScreemViewController.h"
#import "CustomButton.h"
#import "PitchDetailsViewController.h"
#import "constant.h"
@interface viewPitchesViewController_Journalists ()

@end

@implementation viewPitchesViewController_Journalists
- (void)find:(id)sender
{
//    Database*database = [Database sharedObject];
//    unreadMessageCount = [[NSMutableArray alloc] init];
//    for(int i=0;i<[mainArrayChat count];i++)
//    {
//   
//        NSString* from = [NSString stringWithFormat:@"user_%@_0",[[mainArrayChat objectAtIndex:i] pitchId]];
//        NSString *to = [NSString stringWithFormat:@"user_%@_%@",[USERDEFAULTS objectForKey:@"userid"],[[mainArrayChat objectAtIndex:i] strPitchId]];
//        NSString *strSelectQuery = [NSString stringWithFormat:@"SELECT * FROM latestMessageMaster WHERE ((opponentXMPPID = '%@' AND lastMessageFromUser= '%@') OR (opponentXMPPID = '%@' AND lastMessageFromUser= '%@')) AND isRead='0'", from.uppercaseString, to.uppercaseString,to.uppercaseString,from.uppercaseString];
//        NSMutableArray*latest = [database executeSelectQuery:strSelectQuery];
//        NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc] init];
//        [dictTemp setObject:from forKey:@"opponentid"];
//        [dictTemp setObject:to forKey:@"userid"];
//        NSString *strUnreadCount = [NSString stringWithFormat:@"%d",latest.count];
//        [dictTemp setObject:strUnreadCount forKey:@"unreadcount"];
//        [unreadMessageCount addObject:dictTemp];
//    }
//    NSLog(@"%@",unreadMessageCount);
}
- (void)viewDidLoad
{
   
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTestNotification:) name:@"Matches" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PubNubNotificationhigh:) name:@"pubnubnotHighLight" object:nil];
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PubNubNotification:) name:@"pubnubnot" object:nil];
    
    NSLog(@"%@",[USERDEFAULTS objectForKey:@"typeNot"]);
    if ([USERDEFAULTS objectForKey:@"typeNot"] != nil)
    {
        if ([[NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"typeNot"]] isEqualToString:@"8"])
        {
        _matchesChatString = @"2";
        [USERDEFAULTS removeObjectForKey:@"typeNot"];
        }else
        {
        _matchesChatString = @"1";
        }
    }
    [super viewDidLoad];
    [_btnChat setExclusiveTouch:YES];
    [_btnLikedPitches setExclusiveTouch:YES];
       // Do any additional setup after loading the view.
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
-(void)compareDates1 : (NSDate*)date : (int)index{
    NSLog(@"compareDates1");
    date1 = date;
}
-(void)compareDates2 : (NSDate*)date : (int)index{
    date2 = date;
     NSLog(@"compareDates2 date1 is %@ and date2 is %@",date1,date2);
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

- (void) receiveTestNotification:(NSNotification *) notification
{
    _matchesChatString =@"1";
    //    tableVw.allowsMultipleSelectionDuringEditing = NO;
    //    [tableVw setEditing:YES animated:NO];
    lineImageViewMatches.hidden = NO;
    lineImageViewChat.hidden = YES;
    headerLabel.text =@"LIKED PITCHES";
    chatIconButton.hidden = NO;
    [self getCount];
    [appdelegateInstance showHUD:@""];

    [self runApi];
}
-(void)getLastMessage
{
    NSMutableArray *arrData = [[NSMutableArray alloc] init];

    
        Database*database = [Database sharedObject];
        unreadMessageCount= [[NSMutableArray alloc] init];
        for(int i=0;i<[mainArrayChat count];i++)
        {
//            NSString* from = [NSString stringWithFormat:@"user_%@_%@",[USERDEFAULTS objectForKey:@"userid"],[[mainArrayChat objectAtIndex:i] strPitchId]];
//            
//            NSString *to =  [NSString stringWithFormat:@"user_%@_0",[[mainArrayChat objectAtIndex:i] pitchId]];
//            
//            NSString *strSelectQuery = [NSString stringWithFormat:@"SELECT * FROM latestMessageMaster WHERE ((opponentXMPPID = '%@' AND lastMessageFromUser= '%@') OR (opponentXMPPID = '%@' AND lastMessageFromUser= '%@')) AND isRead='0'", from.uppercaseString, to.uppercaseString,to.uppercaseString,from.uppercaseString];
//            
//            NSString *strSelAll = [NSString stringWithFormat:@"SELECT * FROM latestMessageMaster WHERE (opponentXMPPID = '%@' AND lastMessageFromUser= '%@') OR (opponentXMPPID = '%@' AND lastMessageFromUser= '%@')", from.uppercaseString, to.uppercaseString,to.uppercaseString,from.uppercaseString];
//            NSMutableArray*latest = [database executeSelectQuery:strSelectQuery];
//            NSMutableArray *lastMessageArr = [database executeSelectQuery:strSelAll];
//            NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc] init];
//            [dictTemp setObject:from forKey:@"opponentid"];
//            [dictTemp setObject:to forKey:@"userid"];
//            NSString *strUnreadCount = [NSString stringWithFormat:@"%d",latest.count];
//            if (lastMessageArr.count > 0)
//            {
//               
//                [dictTemp setObject:[[lastMessageArr lastObject] objectForKey:@"lastMessage"] forKey:@"lastmessage"];
//            }
//            
//            manageUserObjectClass *obj = [mainArrayChat objectAtIndex:i];
//            obj.unreadcount = strUnreadCount;
//            
//            obj.lastmessage = [[lastMessageArr lastObject] objectForKey:@"lastMessage"];
//            obj.opponentid = from;
//            obj.xmppUserId = to;
//            obj.lastmessagetime = [[lastMessageArr lastObject] objectForKey:@"messageTime"];
//            [arrData addObject:obj];
//            [dictTemp setObject:strUnreadCount forKey:@"unreadcount"];
//            [unreadMessageCount addObject:dictTemp];
                      NSString* from = [NSString stringWithFormat:@"user_%@_%@",[USERDEFAULTS objectForKey:@"userid"],[[mainArrayChat objectAtIndex:i] strPitchId]];
           
                     NSString *to =  [NSString stringWithFormat:@"user_%@_0",[[mainArrayChat objectAtIndex:i] pitchId]];
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
    
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
    NSDictionary *dictParams;
    strWebService=[[NSString alloc]initWithFormat:@"%@match_pitch",AppURL];
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",
                nil];
    
    messageLabel.hidden= YES;
    if ([_matchesChatString isEqualToString:@"1"])
    {
        strWebService=[[NSString alloc]initWithFormat:@"%@match_pitch",AppURL];
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",
                    nil];
    }
    else
    {
        strWebService=[[NSString alloc]initWithFormat:@"%@show_chat",AppURL];
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",
                    nil];
    }
    NSLog(@"%@",strWebService);
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
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
             

             if ([_matchesChatString isEqualToString:@"1"])
             {
                 if ([str isEqualToString:@"0"] )
                 {
                     mainArray=[[NSMutableArray alloc]init];
                    
                     for (int k=0; k<[[[response valueForKey:@"data"] valueForKey:@"Pitch"] count]; k++) {
                         manageUserObjectClass* objectClass = [[manageUserObjectClass alloc] init];
                         objectClass.userName=[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"title"] objectAtIndex:k] ;
                         objectClass.userCompany=[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"summary"] objectAtIndex:k] ;
                         
                         objectClass.userImage=[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"image1_new"] objectAtIndex:k] ;
                         objectClass.pitchId=[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"pitch_id"] objectAtIndex:k] ;
                         
                         objectClass.userId=[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"creator_id"] objectAtIndex:k] ;
                         objectClass.pitchSelectorId=[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"pitch_selector_id"] objectAtIndex:k] ;
                         objectClass.highlightFlag = [[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"pitch_read_status"] objectAtIndex:k];
                         [mainArray addObject:objectClass];
                     }
//                     [tableVw reloadData];
                     if (mainArray.count>0)
                     {
                         if ([[USERDEFAULTS objectForKey:ISUSERFIRSTTIME] boolValue] == YES)
                     {
                         [USERDEFAULTS setBool:NO forKey:ISUSERFIRSTTIME];
                         [USERDEFAULTS synchronize];
                         
//                         NSString *strMessage1 = @"When you click on a Liked Pitch a conversation initiate with the person who posted the pitch.";
                         
                          NSString *strMessage1 = @"To initiate a chat with the pitcher, tap the pitch and type your message into the message box at the bottom of your screen.";
                         NSString *strMessage2 = @"If a match is no longer in Liked Pitches it's because either a conversation has been started or a user unmatched with you.";
                         if ([constant getDeviceVersion] >= 8.0)
                         {
                             UIAlertController *alertMessage= [UIAlertController alertControllerWithTitle:KAPPNAME message:strMessage1 preferredStyle:UIAlertControllerStyleAlert];
                             
                             UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Thanks, got it!" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                 UIAlertController *alertMessage= [UIAlertController alertControllerWithTitle:KAPPNAME message:strMessage2 preferredStyle:UIAlertControllerStyleAlert];
                                 UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Thanks, got it!" style:UIAlertActionStyleCancel handler:nil];
                                 [alertMessage addAction:ok];
                                 
                                 [self presentViewController:alertMessage animated:YES completion:nil];
                                 
                             }];
                             
                             [alertMessage addAction:ok];
                             [self presentViewController:alertMessage animated:YES completion:nil];
                             
                         }else
                         {
                             UIAlertView *alertMessage = [[UIAlertView alloc] initWithTitle:KAPPNAME message:strMessage1 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                             alertMessage.tag = 100;
                             [alertMessage show];
                         }
                     }

                         tableVw.hidden = NO;
                         messageLabel.hidden = YES;

                         tableVw.delegate = self;
                         tableVw.dataSource =self;
                         [tableVw reloadData];
                     }
                     else{
                         messageLabel.text  =@"No matches found.";
                         tableVw.hidden = YES;
                         messageLabel.hidden = NO;
                         tableVw.delegate = self;
                         tableVw.dataSource =self;
                         [tableVw reloadData];
                     }
                     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                         [self setOrientation];
                     }
                     
                 }
                 else  if ([str isEqualToString:@"1"] )
                 {
                   
                     if ([[response objectForKey:@"data"] isEqualToString:@"Sorry!you are paused by admin so you can not see any pitches. Please contact to administrator."]) {
                         [constant alertViewWithMessage:[response objectForKey:@"data"] withView:self];
                         messageLabel.hidden = NO;
                         messageLabel.text = @"Your are paused by administrator.";

                     }else
                     {
                         
                         messageLabel.hidden = NO;
                         //  messageLabel.text  =@"You do not have any friend to chat";
                         messageLabel.text  =@"No matches found.";
                         tableVw.hidden = YES;
                         tableVw.delegate = self;
                         tableVw.dataSource =self;
                         [tableVw reloadData];
                     }

                 }
                 else if ([str isEqualToString:@"10"] )
                 {
                     UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                     alert.tag = 1234;
                     [alert show];
                 }
             }
             if ([_matchesChatString isEqualToString:@"2"])
             {
                 // chat screen goes here
                 if ([str isEqualToString:@"0"] )
                 {
                      userLoginImagePath = [response valueForKey:@"phototag"];
                     mainArrayChat = [[NSMutableArray alloc] init];
                     for (int k=0; k<[[response valueForKey:@"data"] count]; k++)
                     {
                         manageUserObjectClass* objectClass = [[manageUserObjectClass alloc] init];
                        
                         objectClass.userCompany=@"" ;
                        objectClass.userName=[[[[response valueForKey:@"data"] valueForKey:@"b"] valueForKey:@"name"] objectAtIndex:k] ;
                          objectClass.userImage=[[[[response valueForKey:@"data"] valueForKey:@"b"] valueForKey:@"photo"] objectAtIndex:k] ;
                         objectClass.pitchId=[[[[response valueForKey:@"data"] valueForKey:@"b"] valueForKey:@"user_id"] objectAtIndex:k] ;
                          objectClass.deviceToken=[[[[response valueForKey:@"data"] valueForKey:@"b"] valueForKey:@"device_id"] objectAtIndex:k] ;
                         
                         
                         
                         objectClass.strPitchId=[[[[response valueForKey:@"data"] valueForKey:@"0"] valueForKey:@"pitch_id"] objectAtIndex:k] ;
                          objectClass.strPitchTitle=[[[[response valueForKey:@"data"] valueForKey:@"0"] valueForKey:@"pitch_title"] objectAtIndex:k] ;
                         
                          objectClass.chatId=[[[[response valueForKey:@"data"] valueForKey:@"a"] valueForKey:@"id"] objectAtIndex:k] ;
                         [mainArrayChat addObject:objectClass];
                     }
                    // NSLog(@"%@",mainArrayChat);
                     if (mainArrayChat.count>0)
                     {
                         [self getLastMessage];

                         tableVw.delegate = self;
                         tableVw.dataSource =self;
                         tableVw.hidden = NO;
                         messageLabel.hidden = YES;
                         [tableVw reloadData];

                     }
                     else{
                          messageLabel.text  =@"You do not have a match to chat with";

                          //messageLabel.text  =@"You do not have any friend to chat";
                         tableVw.hidden = YES;
                         messageLabel.hidden = NO;
                         tableVw.delegate = self;
                         tableVw.dataSource =self;
                         [tableVw reloadData];
                     }
                 }
                 else if ([str isEqualToString:@"1"] )
                 {
                     if ([[response objectForKey:@"data"] isEqualToString:@"Sorry!you are paused by admin so you can not see any pitches. Please contact to administrator."]) {
                         [constant alertViewWithMessage:[response objectForKey:@"data"] withView:self];
                         messageLabel.hidden = NO;
                         messageLabel.text = @"Your are paused by administrator.";
                     }else
                     {
                     
                     messageLabel.hidden = NO;
                    //  messageLabel.text  =@"You do not have any friend to chat";
                      messageLabel.text  =@"You do not have a match to chat with.";
                     tableVw.hidden = YES;
                         [self deleteAllChat];
                     tableVw.delegate = self;
                     tableVw.dataSource =self;
                     [tableVw reloadData];
                     }
                 }
                 else if ([str isEqualToString:@"10"] )
                 {
                     UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                     alert.tag = 1234;
                     [alert show];
                 }
             }
//             [tableVw reloadData];
         }
         else
         {
             [appdelegateInstance hideHUD];
//             UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Please try again unable to process your request." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//             [alert show];
             [constant alertViewWithMessage:@"Please try again unable to process your request."withView:self];
             NSLog(@"Error returned:%@",[error localizedDescription]);
         }
     }];
    NSLog(@"%@",mainArray);
    NSLog(@"%@",mainArrayChat);

}
-(void)deleteAllChat
{
//    bool a = [[Database sharedObject] deleteData:@"delete from latestMessageMaster"];
    
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
//             UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Connectivity levels low. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//             [alert show];
             [constant alertViewWithMessage:@"Connectivity levels low. Please try again."withView:self];
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
    if (alertView.tag==1234) {
        AppDelegate *appd= (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appd LogoutFromApp:self];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    //if (indexPath.row>0) {
    if ([_matchesChatString isEqualToString:@"1"]){
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        deletedIndex = indexPath.row;
       
        [self deletePitch:[NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row] pitchId]] pitchSelector:[NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row] pitchSelectorId]]];
    }
      }
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
#pragma mark Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        if ([_matchesChatString isEqualToString:@"1"])
    {
    
        if ([[[mainArray objectAtIndex:indexPath.row] highlightFlag] isEqualToString:@"0"]) {
            LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
            NSString*strWebService;
            NSDictionary *dictParams;
            
            NSLog(@"%@",[mainArray objectAtIndex:indexPath.row]);
            
            strWebService=[[NSString alloc]initWithFormat:@"%@update_read_status",AppURL];
            dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",[NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row]pitchId]],@"pitch_id",[[mainArray objectAtIndex:indexPath.row]pitchSelectorId],@"pitch_selector_id",
                        nil];
            //pitch_selector_id
            
            [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
             {
                 
                 
                 NSLog(@"%@",response);
                 
             }];
        }

        
        ExpiryTimeViewController*obj;
        obj=[self.storyboard instantiateViewControllerWithIdentifier:@"expiryView"];
        obj.userIdString =  [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row]userId]];
        obj.pitchJournalistsString = @"1";
        obj.urlString = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row]userImage]];
        obj.summary = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row]userCompany]];
        obj.titleString = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row]userName]];
        obj.pitchIdString = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row]pitchId]];
        obj.pitchSelectorIdString = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row]pitchSelectorId]];
        obj.strXmppID = [NSString stringWithFormat:@"user_%@_%@",[USERDEFAULTS objectForKey:@"userid"],[[mainArray objectAtIndex:indexPath.row]pitchId]];
        obj.oppendXmppID = [NSString stringWithFormat:@"user_%@_0",[[mainArray objectAtIndex:indexPath.row] userId]];
        [USERDEFAULTS setObject:obj.strXmppID forKey:MYXMPPID];
        [USERDEFAULTS setObject:obj.oppendXmppID forKey:OPENNENTNAME];
        [USERDEFAULTS synchronize];
     
        [self.navigationController pushViewController:obj animated:YES];
    }
    else
    {
        
//        UIImageView *imgHighligh = [[tableVw cellForRowAtIndexPath:indexPath] viewWithTag:7005];
//        imgHighligh.hidden = NO;
        chatScreemViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"chatScreen"];
        
        obj.userIdString =  [NSString stringWithFormat:@"%@",[[mainArrayChat objectAtIndex:indexPath.row]pitchId]];
        obj.chatIdString =  [NSString stringWithFormat:@"%@",[[mainArrayChat objectAtIndex:indexPath.row]chatId]];
         obj.userNameHeaderString =  [NSString stringWithFormat:@"%@",[[mainArrayChat objectAtIndex:indexPath.row]userName]];
        obj.rivalImageViewPath =  [NSString stringWithFormat:@"%@",[[mainArrayChat objectAtIndex:indexPath.row]userImage]];
        obj.deviceTokenString =[NSString stringWithFormat:@"%@",[[mainArrayChat objectAtIndex:indexPath.row]deviceToken]];
         obj.loginImageViewPath = userLoginImagePath;
        obj.strPitchId=[NSString stringWithFormat:@"%@",[[mainArrayChat objectAtIndex:indexPath.row]strPitchId]];
        obj.strShowPitchName=[NSString stringWithFormat:@"%@",[[mainArrayChat objectAtIndex:indexPath.row]strPitchTitle]];
      
        obj.myXmppID = [NSString stringWithFormat:@"user_%@_%@",[USERDEFAULTS objectForKey:@"userid"],[[mainArrayChat objectAtIndex:indexPath.row] strPitchId]];
        obj.oppennetXmppID = [NSString stringWithFormat:@"user_%@_0",[[mainArrayChat objectAtIndex:indexPath.row] pitchId]];
        [USERDEFAULTS setObject:obj.myXmppID forKey:MYXMPPID];
        [USERDEFAULTS setObject:obj.oppennetXmppID forKey:OPENNENTNAME];
        [USERDEFAULTS synchronize];
        
        NSLog(@"%@",obj.loginImageViewPath);
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
    UIImageView*profileImage=(UIImageView*)[cell.contentView viewWithTag:1];
    UILabel*journalistName=(UILabel*)[cell.contentView viewWithTag:2];
    UILabel*companyName=(UILabel*)[cell.contentView viewWithTag:3];
    UILabel*Position=(UILabel*)[cell.contentView viewWithTag:4];
    UIImageView*imgLine=(UIImageView*)[cell.contentView viewWithTag:102];
    UIImageView *imgHighlight = (UIImageView*)[cell.contentView viewWithTag:7005];
    UILabel*unreadMessageLabel=(UILabel*)[cell viewWithTag:11];
    unreadMessageLabel.frame = CGRectMake(self.view.frame.size.width-44, unreadMessageLabel.frame.origin.y, unreadMessageLabel.frame.size.width, unreadMessageLabel.frame.size.height);

   
//    Position.layer.borderColor=[UIColor redColor].CGColor;
//    Position.layer.borderWidth=1;
//    btn.layer.borderColor=[UIColor yellowColor].CGColor;
//    btn.layer.borderWidth=1;
//    companyName.layer.borderColor=[UIColor greenColor].CGColor;
//    companyName.layer.borderWidth=1;
    if ([_matchesChatString isEqualToString:@"1"])
    {
        unreadMessageLabel.hidden = YES;
        Position.hidden = YES;
        companyName.numberOfLines=0;
        companyName.lineBreakMode = NSLineBreakByWordWrapping;
        imgLine.frame = CGRectMake(imgLine.frame.origin.x, 99, self.view.frame.size.width-imgLine.frame.origin.x, 1);
        journalistName.text = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row] userName]];
        companyName.text = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row] userCompany]];
        Position.text = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row] userPosition]];
       
        int labelfontSize;
        int maxHeight;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            labelfontSize =20;
            maxHeight =80;
            companyName.frame = CGRectMake(130, 60, self.view.frame.size.width-150, 80);
            journalistName.frame = CGRectMake(130, 10, self.view.frame.size.width-150, 40);
             profileImage.frame = CGRectMake(13, 20, 100, 66);
            imgHighlight.frame = CGRectMake(5, 5, 45, 30);

        }
        else
        {
            imgHighlight.frame = CGRectMake(5, 5, 45, 30);
            companyName.frame = CGRectMake(110, 39, self.view.frame.size.width-150,60);
            journalistName.frame = CGRectMake(110, 10, self.view.frame.size.width-150, 30);
            profileImage.frame = CGRectMake(20, 18, 80, 54);
            labelfontSize =13;
            maxHeight =55;
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
        if (stringSize.height>maxHeight) {
            stringSize.height = maxHeight;
        }
        companyName.frame = CGRectMake(companyName.frame.origin.x, companyName.frame.origin.y, companyName.frame.size.width, stringSize.height);
        NSURL*Url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row] userImage]]];
        [profileImage setImageWithURL:Url1 placeholderImage:[UIImage imageNamed:@"userDefault.jpg"] imagesize:CGSizeMake(100, 100)];
        
        NSLog(@"%@",[[mainArray objectAtIndex:indexPath.row] highlightFlag]);
        
        if ([[[mainArray objectAtIndex:indexPath.row] highlightFlag] isEqualToString:@"0"])
        {
            imgHighlight.image=[UIImage imageNamed:@"icn_new_arrival.png"];
            imgHighlight.hidden = NO;
        }
        else
        {
            imgHighlight.hidden = YES;
        }
    }
    else
    {
        UIImageView *imgHighlight = (UIImageView*)[cell.contentView viewWithTag:7005];
        imgHighlight.hidden = YES;
        unreadMessageLabel.hidden = YES;
        imgLine.frame = CGRectMake(imgLine.frame.origin.x, 109, self.view.frame.size.width-imgLine.frame.origin.x, 1);
        companyName.lineBreakMode = NSLineBreakByWordWrapping;
        journalistName.text = [NSString stringWithFormat:@"%@",[[mainArrayChat objectAtIndex:indexPath.row] userName]];
       // if (!tableReloadBool) {
            companyName.text = [NSString stringWithFormat:@"%@",[[mainArrayChat objectAtIndex:indexPath.row] userCompany] ];
       // }
        Position.hidden = NO;
        Position.numberOfLines=0;
        Position.lineBreakMode = NSLineBreakByWordWrapping;
        Position.text=[NSString stringWithFormat:@"Pitch Title:\n%@",[[mainArrayChat objectAtIndex:indexPath.row] strPitchTitle]];
        
        NSLog(@"%lu",(unsigned long)Position.text.length);
        companyName.numberOfLines=0;
        companyName.lineBreakMode = NSLineBreakByWordWrapping;

        profileImage.layer.cornerRadius = 1;
        profileImage.layer.masksToBounds = YES;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            //companyName.numberOfLines=1;
            companyName.frame = CGRectMake(130, 50, self.view.frame.size.width-150, 30);
            Position.frame = CGRectMake(130, 80, self.view.frame.size.width-150, 50);
            profileImage.frame = CGRectMake(13, 20, 100, 100);
            imgHighlight.frame = CGRectMake(5, 5, 30, 20);

        }
        else{
            imgHighlight.frame = CGRectMake(5, 5, 45, 30);

            companyName.frame = CGRectMake(110, 35, self.view.frame.size.width-170, 20);
            Position.frame = CGRectMake(110, 55, self.view.frame.size.width-150, 50);
            profileImage.frame = CGRectMake(20, 15, 80, 80);
        }
        
        NSLog(@"pid:%@pUserid",[[mainArrayChat objectAtIndex:indexPath.row] strPitchId]);
        NSLog(@"%@",unreadMessageCount);
        companyName.text = [[mainArrayChat objectAtIndex:indexPath.row] lastmessage];
//
//        if (unreadMessageCount.count>0)
//        {
////            for (int i = 0; i<unreadMessageCount.count; i++) {
//
//                NSString *strChatIDThread =[NSString stringWithFormat:@"%@_%@_%@",[[mainArrayChat objectAtIndex:indexPath.row]pitchId],[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"],[[mainArrayChat objectAtIndex:indexPath.row]strPitchId]];
//                
//                NSLog(@"%D",indexPath.row);
//                
//                NSString *strChatIdFromDB =[[unreadMessageCount objectAtIndex:i]objectForKey:@"chatid"];
//                
//                NSLog(@"%@ and %@",strChatIDThread,strChatIdFromDB);
//                if ([strChatIdFromDB isEqualToString:strChatIDThread])
//                {
                    if([[[mainArrayChat objectAtIndex:indexPath.row] unreadcount] integerValue]>0)
                    {
                        unreadMessageLabel.hidden = YES;
//                        unreadMessageLabel.text = [NSString stringWithFormat:@"%ld",(long)[[[mainArrayChat objectAtIndex:indexPath.row] unreadcount] integerValue]];
                        imgHighlight.image=[UIImage imageNamed:@"icn_new_arrival.png"];
                        imgHighlight.hidden = NO;
                    }
                    else
                    {
                        unreadMessageLabel.hidden = YES;

                        imgHighlight.hidden = YES;
                    }
//                }
                
           // }
//            
//        }

       
        int labelfontSize;
        int maxHeight;
        int stringWidth;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            labelfontSize =26;
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
      //  companyName.numberOfLines = 1;
      //  companyName.frame = CGRectMake(companyName.frame.origin.x, companyName.frame.origin.y, stringSize.width, stringSize.height+3);
       // NSLog(@"journalists:%@",[NSValue valueWithCGRect:companyName.frame]);
        NSURL*Url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[mainArrayChat objectAtIndex:indexPath.row] userImage]]];
        [profileImage setImageWithURL:Url1 placeholderImage:[UIImage imageNamed:@"userDefault.jpg"] imagesize:CGSizeMake(100, 100)];
        
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
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return 150;
    }else{
     if ([_matchesChatString isEqualToString:@"1"])
     {
       return 100;
     }
    }
    return 110;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_matchesChatString isEqualToString:@"1"]) {
         return mainArray.count;
    }
    return mainArrayChat.count;
}

-(void)PubNubNotification:(NSNotification *) notification
{
    if ([_matchesChatString isEqualToString:@"1"]){
    [self getCount];
    }
    
//    unreadMessageCount = [[NSMutableArray alloc] init];
//    [self find:nil];
//    [tableVw reloadData];
}

-(void)getCount
{
   
    if (lineImageViewChat.hidden)
    {
        // If Image Line Hidden
        btnCount.hidden=NO;
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]integerValue]>0) {
            lblCount.hidden=NO;
            imgCount.hidden=NO;
            NSInteger show=[[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]integerValue]+[[[NSUserDefaults standardUserDefaults] valueForKey:@"MinusCount"] integerValue];
            lblCount.text=[NSString stringWithFormat:@"%ld",(long)show];
           // lblCount.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]];
        }
        else
        {
            
            AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
            app.count=0;

            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"totalcount"]integerValue]>0 || [[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]integerValue]>0)
            {
                lblCount.hidden=NO;
                imgCount.hidden=NO;
                NSInteger show=[[[NSUserDefaults standardUserDefaults]valueForKey:@"chatcount"]integerValue]+[[[NSUserDefaults standardUserDefaults] valueForKey:@"matchcount"] integerValue]+[[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]integerValue]+[[[NSUserDefaults standardUserDefaults] valueForKey:@"MinusCount"] integerValue];
                lblCount.text=[NSString stringWithFormat:@"%ld",(long)show];
            }
            else
            {
                lblCount.hidden=YES;
                imgCount.hidden=YES;
            }
           
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lu", (long)app.count] forKey:@"Count"];
           
        }
    }
    else{
        //If image Line Not Hidden
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


-(void)viewWillAppear:(BOOL)animated
{
    
   
    
    // database code goes here
 
    [self find:nil];

    self.navigationController.navigationBar.hidden=YES;
    tableVw.delegate = nil;
    tableVw.dataSource =nil;
    
    appdelegateInstance = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdelegateInstance showHUD:@""];
   
     [appdelegateInstance showHUD:@""];
    NSInteger countNoti=[[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]integerValue];
    NSInteger countMinusNoti=[[[NSUserDefaults standardUserDefaults]valueForKey:@"MinusCount"]integerValue];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"directCall"] isEqualToString:@"showChatScreen"])
    {
        if (countMinusNoti-countNoti>0 && countNoti==0)
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
    tableVw.hidden = YES;
    messageLabel.hidden = YES;

    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"directCall"] isEqualToString:@"showChatScreen"])
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"directCall"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        _matchesChatString =@"2";
        [self chatButtonPressed:nil];
    }
    else
    {
        if ([_matchesChatString isEqualToString:@"2"])
        {
            [self chatButtonPressed:nil];

        }else if ([_matchesChatString isEqualToString:@"1"])
        {
            [self matchesButtonPressed:nil];
        }else
        {
            _matchesChatString =@"1";

            [self runApi];
        }
    }
    
//    [self runApi];
    [self getCount];
    [self leftSlider];
    [super viewWillAppear:animated];

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
        button.frame = CGRectMake(0, 0, 50, 55);
    }    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chatButtonPressed:(id)sender
{
    
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    app.count=0;
    app.totalNotifyCountMinusCount=0;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lu",(long)app.totalNotifyCountMinusCount] forKey:@"MinusCount"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lu", (long)app.count] forKey:@"Count"];
    
    
    _matchesChatString =@"2";
   
    lineImageViewMatches.hidden = YES;
    lineImageViewChat.hidden = NO;
    headerLabel.text =@"CHATS";
//    tableVw.allowsMultipleSelectionDuringEditing = NO;
//    [tableVw setEditing:NO animated:NO];

    [mainArray removeAllObjects];
    [mainArrayChat removeAllObjects];
    unreadMessageCount = [[NSMutableArray alloc]init];

    [self find:nil];
    [tableVw reloadData];
    chatIconButton.hidden = YES;
    [self getCount];
    [appdelegateInstance showHUD:@""];

    [self runApi];
    [self getLastMessage];
}

- (IBAction)matchesButtonPressed:(id)sender {
    _matchesChatString =@"1";
//    tableVw.allowsMultipleSelectionDuringEditing = NO;
//    [tableVw setEditing:YES animated:NO];
   
    lineImageViewMatches.hidden = NO;
    lineImageViewChat.hidden = YES;
    headerLabel.text =@"LIKED PITCHES";
    [mainArray removeAllObjects];
    [mainArrayChat removeAllObjects];
    [tableVw reloadData];
    chatIconButton.hidden = NO;
    [self getCount];
    [appdelegateInstance showHUD:@""];

    [self runApi];
}

- (IBAction)topChatIconPressed:(id)sender {
    [self chatButtonPressed:nil];
}


#pragma mark rotation Methods

-(void)setOrientation{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortrait) 
    {
        UILabel*journalistName;
        UILabel*companyName;
        
        for (int i=0; i<mainArray.count; i++) 
        {
            NSIndexPath *idxCell = [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *cell = [tableVw cellForRowAtIndexPath:idxCell];
            journalistName=(UILabel*)[cell viewWithTag:2];
            companyName=(UILabel*)[cell viewWithTag:3];
            
            journalistName.frame = CGRectMake(130, journalistName.frame.origin.y, 616, journalistName.frame.size.height);
            
            companyName.frame = CGRectMake(130, companyName.frame.origin.y, 610, companyName.frame.size.height);
            
            //  NSLog(@"portrait %@",[NSValue valueWithCGRect:titleLabel.frame]);
            
            
        }
        
    }
    else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation==UIInterfaceOrientationLandscapeRight)
    {
        NSLog(@"landscape");
        UILabel*journalistName;
        UILabel*companyName;
        
        for (int i=0; i<mainArray.count; i++) 
        {
            NSIndexPath *idxCell = [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *cell = [tableVw cellForRowAtIndexPath:idxCell];
            journalistName=(UILabel*)[cell viewWithTag:2];
            companyName=(UILabel*)[cell viewWithTag:3];
            
            journalistName.frame = CGRectMake(130, journalistName.frame.origin.y,820, journalistName.frame.size.height);
            
            companyName.frame = CGRectMake(130, companyName.frame.origin.y, 820, companyName.frame.size.height);
            
            //  NSLog(@"portrait %@",[NSValue valueWithCGRect:titleLabel.frame]);
            
            
        }
        
    }
}

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
         
         if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortrait) 
         {
             NSLog(@"portrait");
           
             [self setOrientation];
        }
         else if (orientation == UIInterfaceOrientationLandscapeLeft ||
                  orientation == UIInterfaceOrientationLandscapeRight)
         {
            [self setOrientation];
         }
         
         // do whatever
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

@end
