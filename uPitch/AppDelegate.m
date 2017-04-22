

#import "AppDelegate.h"
#import "PayPalMobile.h"
#import "LxReqRespManager.h"
#import "ComposeViewController.h"
#import "Utils.h"
#import "SWRevealViewController.h"
#import "ViewController.h"
#import <Fabric/Fabric.h>
#import "constant.h"
#import "LoginViewController.h"
#import "chatScreemViewController.h"
#import "manageJournalistViewController.h"
#import "PitchFeedJournalist_ViewController.h"
#import "viewPitchesViewController_Journalists.h"
#import "ChoosePersonViewController.m"
#import "ExpiryTimeViewController.h"
#import "METoast.h"
//Chat

#import "DDLog.h"
#import "DDTTYLogger.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"
//#import <Crashlytics/Crashlytics.h>

//./Fabric.framework/run f680359f97282d028e6a13bdd0afe9db6792b9ea 5d23c5d674bbeedbe34dbaa10da79bc69a3c04d7f6893dfc5f3ab3867156c145



@interface AppDelegate ()
{
    NSString *strChannel;
}

@end

@implementation AppDelegate
@synthesize count,NotificationCount,viewNotificationPopUp,totalNotifyCountMinusCount;
@synthesize xmppPing;
//Chat
@synthesize strCurrentChatOpponentName;

@synthesize xmppMessenger;
@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppvCardTempModule;
@synthesize xmppvCardAvatarModule;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;
@synthesize strOpponentTargetID;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //    if (![USERDEFAULTS boolForKey:@"HasLaunchedOnce"])
    //    {
    //        [USERDEFAULTS setBool:YES forKey:@"HasLaunchedOnce"];
    //        [USERDEFAULTS setBool:YES forKey:@"termsandconditions"];
    //        [USERDEFAULTS synchronize];
    //    }
    if (launchOptions != nil)
    {
        NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        NSString *strTypeOfNotification = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"type"]];
        
        if (dictionary != nil)
        {
            
            if ([[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"pubnub"]] isEqualToString:@"8"])
            {
                strTypeOfNotification = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"pubnub"]];
                [USERDEFAULTS setObject:strTypeOfNotification forKey:@"typeNot"];
                [APPDELEGATE insertLastMessage:dictionary];
                
                
            }else
            {
                [USERDEFAULTS setObject:strTypeOfNotification forKey:@"typeNot"];
                
                
            }
            [USERDEFAULTS setBool:YES forKey:@"FlagNot"];
            [USERDEFAULTS synchronize];
            NSLog(@"Launched from push notification: %@", dictionary);
        }
    }
    NSString *strBaseUrl = [USERDEFAULTS valueForKey:@"kBaseUrl"];
    NSString *strPitcher = [USERDEFAULTS valueForKey:@"xmpp_history_pitcher"];
    NSString *strJournalist = [USERDEFAULTS valueForKey:@"xmpp_history_journalist"];
    
    if (strBaseUrl == nil || strPitcher == nil || strJournalist == nil)
    {
        [USERDEFAULTS setValue:@"http://upitchnew.inheritxserver.net/api/" forKey:@"kBaseUrl"];
        [USERDEFAULTS setValue:@"http://upitchnew.inheritxserver.net/messagexmpp/get_last_message_pitcher" forKey:@"xmpp_history_pitcher"];
        [USERDEFAULTS setValue:@"http://upitchnew.inheritxserver.net/messagexmpp/get_last_message_journalist" forKey:@"xmpp_history_journalist"];
        
        
    }else
    {
        [USERDEFAULTS setValue:strBaseUrl forKey:@"kBaseUrl"];
        [USERDEFAULTS setValue:strPitcher forKey:@"xmpp_history_pitcher"];
        [USERDEFAULTS setValue:strJournalist forKey:@"xmpp_history_journalist"];
    }
    [USERDEFAULTS synchronize];
   
    [self updateBaseURl];
   
    NSLog(@"%@",AppURL);
    NSLog(@"%@",XmppHistoryPitcher);
    NSLog(@"%@",XmppHistoryJournalist);
    [self setViewInitially];
    revealController.delegate = self;
    
    unreadMessageCount = [[NSMutableArray alloc]init];
    channelArray       = [[NSMutableArray alloc]init];
    idArray            = [[NSMutableArray alloc]init];
    arrPitchId         = [[NSMutableArray alloc]init];
    //    [self subscribeChannel];
    
    // database code goes here
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runAPI:) name:@"backGroundAPI" object:nil];
    
    //testfghfhf
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"YOUR_CLIENT_ID_FOR_PRODUCTION",
                                                           PayPalEnvironmentSandbox : @"YOUR_CLIENT_ID_FOR_SANDBOX"}];
    // Override point for customization after application launch.
    
    [self registeredForPushNotification];
    NotificationCount = [[USERDEFAULTS valueForKey:@"Count"]integerValue]+[[USERDEFAULTS valueForKey:@"MinusCount"]integerValue];
    NSLog(@"%ld",(long)NotificationCount);
    //    application.applicationIconBadgeNumber = NotificationCount;
    return YES;
}

-(void)insertLastMessage:(NSDictionary*)dictMessage
{
    NSString*time = @"";
    NSString*messageStr = @"";
    NSString*to = @"";
    NSString*from = @"";
    NSString*strFinalOpponentName = @"";
    from = [dictMessage objectForKey:@"from"];
    to = [dictMessage objectForKey:@"to"];
    time = [NSString stringWithFormat:@"%@",[dictMessage objectForKey:@"time"]];
    NSString * timeStampString =[time substringFromIndex:2];
    //[timeStampString stringByAppendingString:@"000"];   //convert to ms
    double time1 = [timeStampString doubleValue]/1000;
    
    NSTimeInterval _interval=time1;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setTimeZone:[NSTimeZone localTimeZone]];
    [_formatter setDateFormat:@"dd/MM/yy HH:mm:ss.SSS"];
    
    
    time = [_formatter stringFromDate:date];
    
    messageStr = [dictMessage objectForKey:@"message"];
    NSString*messageThreadID = @"";
    {
        
        NSString *strIsRead =  @"0";
        NSDictionary *dicTemp;
        dicTemp = [NSDictionary dictionaryWithObjectsAndKeys:messageStr, @"lastMessage",
                   from.uppercaseString, @"lastMessageFromUser",
                   time, @"messageTime",
                   to.uppercaseString, @"opponentXMPPID",
                   strFinalOpponentName,@"opponentDisplayName",
                   strIsRead,@"isRead",@"2",@"userType",
                   nil];
        
        int tID1 = (int)[[Database sharedObject] insertToTable:@"lastMessageMaster" withValues:dicTemp];
    }

}
-(void)updateBaseURl
{
    
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
    

    strWebService = @"http://upitchnew.inheritxserver.net/config.json";
    
    NSLog(@"%@",strWebService);
    NSDictionary *dictParams;
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",nil];
    
    [rrManager requestAPIWithURL:strWebService withParameters:nil withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
         
         
             NSString *strWSUrl = [response valueForKey:@"base_url"];
             [USERDEFAULTS setValue:strWSUrl forKey:@"kBaseUrl"];
             
             NSString *strWSPitcher = [response valueForKey:@"xmpp_history_pitcher"];
             [USERDEFAULTS setValue:strWSPitcher forKey:@"xmpp_history_pitcher"];
             
             NSString *strWSJournalist  = [response valueForKey:@"xmpp_history_journalist"];
             [USERDEFAULTS setValue:strWSJournalist forKey:@"xmpp_history_journalist"];
             [USERDEFAULTS synchronize];
             
         }
         
     }];

}

- (void)registeredForPushNotification
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}



#pragma mark Dada Code
-(void) setViewInitially
{
    //Notification Alert
    viewNotificationPopUp=[[UIView alloc]initWithFrame:CGRectMake(0,-64,[UIScreen mainScreen].bounds.size.width,64)];
    
    viewNotificationPopUp.backgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    
    lblText=[[UILabel alloc]initWithFrame:CGRectMake(60, 28, viewNotificationPopUp.frame.size.width-70,35)];
    [lblText setFont:[UIFont systemFontOfSize:10]];
    UIImageView *imglogo=[[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 40, 40)];
    imglogo.image=[UIImage imageNamed:@"MyLogo.png"];
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(60, 22, 100, 14)];
    lbl.text=@"upitch";
    lbl.textColor=[UIColor whiteColor];
    [lbl setFont:[UIFont boldSystemFontOfSize:12]];
    lblText.textAlignment=NSTextAlignmentLeft;
    lblText.textColor=[UIColor whiteColor];
    lblText.numberOfLines=0;
    
    [viewNotificationPopUp addSubview:lblText];
    [viewNotificationPopUp addSubview:lbl];
    [viewNotificationPopUp addSubview:imglogo];
}


-(void)showNotificationPopUp:(NSString*)strMsg type:(NSString*)strtype
{
    
    strtype = [NSString stringWithFormat:@"%@",strtype];
    [self.window.rootViewController.view addSubview:viewNotificationPopUp];
    lblText.text=strMsg;
    NSLog(@"%@ ... %@",strMsg,strtype);
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [UIView animateWithDuration:0.5f animations:^{
                           viewNotificationPopUp.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,64);
                           
                           if ([strtype isEqualToString:@"2"])
                           {
                               _btn = [[UIButton alloc] initWithFrame:CGRectMake(viewNotificationPopUp.frame.origin.x, viewNotificationPopUp.frame.origin.y, viewNotificationPopUp.frame.size.width, viewNotificationPopUp.frame.size.height)];
                               [self.btn addTarget:self action:@selector(goMatchScreen:) forControlEvents:UIControlEventTouchUpInside];
                               [viewNotificationPopUp addSubview:_btn];
                               //2/12
                               //                               [viewNotificationPopUp bringSubviewToFront:btn];
                               //                               viewNotificationPopUp.userInteractionEnabled = YES;
                           }else if([strtype isEqualToString:@"8"])
                           {
                               _btn = [[UIButton alloc] initWithFrame:CGRectMake(viewNotificationPopUp.frame.origin.x, viewNotificationPopUp.frame.origin.y, viewNotificationPopUp.frame.size.width, viewNotificationPopUp.frame.size.height)];
                               [self.btn addTarget:self action:@selector(goChatListingScreen:) forControlEvents:UIControlEventTouchUpInside];
                               [viewNotificationPopUp addSubview:_btn];
                           }else if([strtype isEqualToString:@"1"])
                           {
                               _btn = [[UIButton alloc] initWithFrame:CGRectMake(viewNotificationPopUp.frame.origin.x, viewNotificationPopUp.frame.origin.y, viewNotificationPopUp.frame.size.width, viewNotificationPopUp.frame.size.height)];
                               [self.btn addTarget:self action:@selector(goPitchFeed:) forControlEvents:UIControlEventTouchUpInside];
                               [viewNotificationPopUp addSubview:_btn];
                           }
                           
                       }completion:^(BOOL finish)
                        {
                            
                            [self performSelector:@selector(removeAfterAllocatedTime) withObject:nil afterDelay:5.0];
                        }];
                   });
    
}

-(void)removeAfterAllocatedTime
{
    
    
    [UIView animateWithDuration:0.5f animations:^{
        viewNotificationPopUp.frame=CGRectMake(0,-64, [UIScreen mainScreen].bounds.size.width,64);
        _btn.frame =CGRectMake(0,-64, [UIScreen mainScreen].bounds.size.width,64);
        
    }completion:^(BOOL finish)
     {
         
     }];
}
-(void)showToast:(NSString*)Message
{
    [METoast toastWithMessage:Message];
    
}
-(IBAction)goPitchFeed:(id)sender
{
    viewNotificationPopUp.hidden = YES;
    [USERDEFAULTS setObject:[NSString stringWithFormat:@"%lu",(long)totalNotifyCountMinusCount] forKey:@"MinusCount"];
    [USERDEFAULTS setObject:[NSString stringWithFormat:@"%lu", (long)count] forKey:@"Count"];
    NSLog(@"show chat data");
    presentedViewController = (UINavigationController *)self.window.rootViewController;
    nav =(UINavigationController*)[[presentedViewController.viewControllers lastObject] frontViewController];
    UIStoryboard *storyboard;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iPad" bundle: nil];
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        
    }
    if ([[[nav viewControllers] lastObject] isKindOfClass:[ChoosePersonViewController class]])
    {
        [(ChoosePersonViewController*)[[nav viewControllers] lastObject] performSelector:@selector(refreshView)];
        
    }else
    {
        ChoosePersonViewController *pitchFeed = [storyboard instantiateViewControllerWithIdentifier:@"pitchFeedtest"];
        [nav pushViewController:pitchFeed animated:YES];
    }
}
-(IBAction)goMatchScreen:(id)sender
{
    viewNotificationPopUp.hidden = YES;
    
    [USERDEFAULTS setObject:[NSString stringWithFormat:@"%lu",(long)totalNotifyCountMinusCount] forKey:@"MinusCount"];
    [USERDEFAULTS setObject:[NSString stringWithFormat:@"%lu", (long)count] forKey:@"Count"];
    NSLog(@"show chat data");
    presentedViewController = (UINavigationController *)self.window.rootViewController;
    nav =(UINavigationController*)[[presentedViewController.viewControllers lastObject] frontViewController];
    UIStoryboard *storyboard;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iPad" bundle: nil];
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        
    }
    if ([[[nav viewControllers] lastObject] isKindOfClass:[manageJournalistViewController class]])
    {
        
    }else
    {
        manageJournalistViewController *mng = [storyboard instantiateViewControllerWithIdentifier:@"manageJournalists"];
        [nav pushViewController:mng animated:YES];
        
    }
    // 3/12 changes
    
}
-(IBAction)goChatListingScreen:(id)sender
{
    viewNotificationPopUp.hidden = YES;
    
    [self disconnect];
    [USERDEFAULTS setObject:[NSString stringWithFormat:@"%lu",(long)totalNotifyCountMinusCount] forKey:@"MinusCount"];
    [USERDEFAULTS setObject:[NSString stringWithFormat:@"%lu", (long)count] forKey:@"Count"];
    NSLog(@"show chat data");
    presentedViewController = (UINavigationController *)self.window.rootViewController;
    nav =(UINavigationController*)[[presentedViewController.viewControllers lastObject] frontViewController];
    
    
    UIStoryboard *storyboard;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iPad" bundle: nil];
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        
    }
    if ([[USERDEFAULTS objectForKey:@"userTypeString"] isEqualToString:@"1"])
    {
        
        manageJournalistViewController *chat = [storyboard instantiateViewControllerWithIdentifier:@"manageJournalists"];
        [USERDEFAULTS setObject:@"showChatScreen" forKey:@"directCall"];
        chat.matchesChatString = @"2";
        
        [nav pushViewController:chat animated:YES];
    }else
    {
        
        viewPitchesViewController_Journalists *chat = [storyboard instantiateViewControllerWithIdentifier:@"viewPitches"];
        chat.matchesChatString = @"2";
        [USERDEFAULTS setObject:@"showChatScreen" forKey:@"directCall"];
        [nav pushViewController:chat animated:YES];
        
    }
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self goOffline];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //    [UIApplication sharedApplication].applicationIconBadgeNumber = NotificationCount;
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginStatus"] isEqualToString:@"loggedin"])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [constant getIntialCountForUserId:[NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"userid"]] andDeviceId:[NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"deviceToken"]]];
        });
    }
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginStatus"] isEqualToString:@"loggedin"])
    {
        if (![xmppStream isConnected])
        {
            [self goOnline];
        }
        
    }
    //    if ([[USERDEFAULTS objectForKey:@"userTypeString"] isEqualToString:@"1"])
    //    {
    //        if ([[constant myXMPPId] length])
    //        {
    //            if (!xmppStream)
    //            {
    //                [self setupStream];
    //            }
    //            if (![xmppStream isConnected])
    //            {
    //                [self startXMPPConnection];
    //            }
    //        }
    //
    //    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

#pragma mark Notification Delegate
#ifdef __IPHONE_8_0

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}


- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}

#endif

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"error description." message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    _dToken = deviceToken;
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"Device token :- %@",token);
    if (token.length<10) {
        [USERDEFAULTS setObject:@"" forKey:@"deviceToken"];
    }
    else{
        [USERDEFAULTS setObject:token forKey:@"deviceToken"];
    }
    
    //    UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"DeviceToken" message:token delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //    [alt show];
    
    //        NSString *str=[[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //        UIAlertView *alt1=[[UIAlertView alloc]initWithTitle:@"UDID" message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //        [alt1 show];
    [USERDEFAULTS synchronize];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    if ([[USERDEFAULTS objectForKey:@"FlagNot"] boolValue] == NO)
    {   [USERDEFAULTS synchronize];
        NSString *strTypeNot = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"type"]];
        diction=[NSMutableDictionary dictionaryWithDictionary:userInfo];
        NSLog(@"user info %@",userInfo);
        NSString *strPubNub;
        if ([userInfo valueForKey:@"pubnub"]){
            strPubNub=[NSString stringWithFormat:@"%@",[userInfo valueForKey:@"pubnub"]];
            
        }
        else
        {
            presentedViewController = (UINavigationController *)self.window.rootViewController;
            nav =(UINavigationController*)[[presentedViewController.viewControllers lastObject] frontViewController];
            UIApplicationState state = [application applicationState];
            if (state == UIApplicationStateActive && [strTypeNot isEqualToString:@"11"])
            {
                if ([[[nav viewControllers] lastObject] isKindOfClass:[chatScreemViewController class]])
                {
                    if ([self getDeviceVersion] >= 8.0)
                    {
                        UIAlertController *alertMessage= [UIAlertController alertControllerWithTitle:KAPPNAME message:[[userInfo valueForKey:@"aps"] objectForKey:@"alert"] preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                             {
                                                 NSLog(@"end Chat");
                                                 [nav popViewControllerAnimated:YES];
                                             }];
                        
                        [alertMessage addAction:ok];
                        
                        
                        [[[nav viewControllers] objectAtIndex:1] presentViewController:alertMessage  animated:YES completion:nil];
                        
                    }else
                    {
                        UIAlertView *alertMessage = [[UIAlertView alloc] initWithTitle:KAPPNAME message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
                        alertMessage.tag = 7005;
                        [alertMessage show];
                    }
                    
                }else
                {
                    if ([[[nav viewControllers] lastObject] isKindOfClass:[manageJournalistViewController class]])
                    {
                        [(manageJournalistViewController*)[[nav viewControllers] lastObject] performSelector:@selector(runApi)];
                    }
                    else if ([[[nav viewControllers] lastObject] isKindOfClass:[viewPitchesViewController_Journalists class]])
                    {
                        [(viewPitchesViewController_Journalists*)[[nav viewControllers]lastObject] performSelector:@selector(runApi)];
                    }
                }
            }
            
        }
        viewNotificationPopUp.hidden = NO;
        UIApplicationState state = [application applicationState];
        if (state == UIApplicationStateActive  || state == UIApplicationStateBackground)
        {
            if ([strTypeNot integerValue]==3)
            {
                
                [self performSelector:@selector(LogoutAppdelegate) withObject:nil afterDelay:7.0];
                [self showNotificationPopUp:[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] type:strTypeNot];
                
            }
            else if ([strTypeNot integerValue]==5||[strTypeNot integerValue]==6)
            {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Matches" object:nil];
                [self showNotificationPopUp:[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] type:strTypeNot];
                
            }
            else if ([strTypeNot integerValue]==7||[strTypeNot integerValue]==9)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"clientReload" object:nil];
                [self showNotificationPopUp:[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] type:strTypeNot];
                
            }else if ([strTypeNot integerValue]==11)
            {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"clientReload" object:nil];
                
                [self showNotificationPopUp:[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] type:strTypeNot];
                if (state == UIApplicationStateActive)
                {
                    if ([[[nav viewControllers] lastObject] isKindOfClass:[manageJournalistViewController class]])
                    {
                        [(manageJournalistViewController*)[[nav viewControllers] lastObject] performSelector:@selector(runApi)];
                    }
                    else if ([[[nav viewControllers] lastObject] isKindOfClass:[viewPitchesViewController_Journalists class]])
                    {
                        [(viewPitchesViewController_Journalists*)[[nav viewControllers]lastObject] performSelector:@selector(runApi)];
                    }
                }
                
            }
            else if ([strTypeNot integerValue]==12)
            {
                [self showNotificationPopUp:[userInfo valueForKey:@"message"] type:@"8"];
                
            }
            else
            {
                NSString*time = @"";
                NSString*messageStr = @"";
                NSString*to = @"";
                NSString*from = @"";
                NSString*strFinalOpponentName = @"";
                from = [userInfo objectForKey:@"from"];
                to = [userInfo objectForKey:@"to"];
                time = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"time"]];
                NSString * timeStampString =[time substringFromIndex:2];
                //[timeStampString stringByAppendingString:@"000"];   //convert to ms
                double time1 = [timeStampString doubleValue]/1000;
                
                NSTimeInterval _interval=time1;
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
                NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
                [_formatter setTimeZone:[NSTimeZone localTimeZone]];
                [_formatter setDateFormat:@"dd/MM/yy HH:mm:ss.SSS"];
                
                
                time = [_formatter stringFromDate:date];
                
                messageStr = [userInfo objectForKey:@"message"];
                NSString*messageThreadID = @"";
                {
                    
                    NSString *strIsRead =  @"0";
                    NSDictionary *dicTemp;
                    dicTemp = [NSDictionary dictionaryWithObjectsAndKeys:messageStr, @"lastMessage",
                               from.uppercaseString, @"lastMessageFromUser",
                               time, @"messageTime",
                               to.uppercaseString, @"opponentXMPPID",
                               strFinalOpponentName,@"opponentDisplayName",
                               strIsRead,@"isRead",@"2",@"userType",
                               nil];
                    
                    int tID1 = (int)[[Database sharedObject] insertToTable:@"lastMessageMaster" withValues:dicTemp];
                    NSLog(@"%d",tID1);
                    // int tID = [self insertMessage:dicTemp];
                    
                    //                    NSMutableArray *data = [[NSMutableArray alloc] init];
                    //                    data= [database executeSelectQuery:@"select *from latestMessageMaster"];
                    if (state == UIApplicationStateActive)
                    {
                        if ([[[nav viewControllers] lastObject] isKindOfClass:[chatScreemViewController class]])
                        {
                            if([[USERDEFAULTS objectForKey:@"userTypeString"] isEqualToString:@"1"])
                            {
                                if(![from isEqualToString:[[constant myXMPPIdNoHost] uppercaseString]] && ![to isEqualToString:[[USERDEFAULTS objectForKey:OPENNENTNAME] uppercaseString]])
                                {
                                    [self showNotificationPopUp:messageStr type:@"8"];
                                    
                                }
                                
                            }
                        }else
                        {
                            [self showNotificationPopUp:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] type:[userInfo objectForKey:@"type"]];
                        }
                        
                    }
                    
                    
                    //                    NSLog(@"%@",data);
                    if (tID1)
                    {
                        if (state == UIApplicationStateActive)
                        {
                            if ([[[nav viewControllers] lastObject] isKindOfClass:[manageJournalistViewController class]])
                            {
                                [(manageJournalistViewController*)[[nav viewControllers] lastObject] performSelector:@selector(runApi)];
                            }
                            else if ([[[nav viewControllers] lastObject] isKindOfClass:[viewPitchesViewController_Journalists class]])
                            {
                                [(viewPitchesViewController_Journalists*)[[nav viewControllers]lastObject] performSelector:@selector(runApi)];
                            }
                            
                        }
                        messageThreadID = [NSString stringWithFormat:@"%d",tID1];
                        
                    }
                    
                }
            }
        }
        else if (state == UIApplicationStateBackground || state == UIApplicationStateInactive )
        {
            
            if ([[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"type"]] isEqualToString:@"2"])
            {
                [self goMatchScreen:nil];
            }
            else if([strTypeNot isEqualToString:@"8"] || [strPubNub isEqualToString:@"8"])
            {
                
                [self goChatListingScreen:nil];
                
            }else if ([strTypeNot isEqualToString:@"1"])
            {
                [self goPitchFeed:nil];
                
            } else if ([strTypeNot integerValue]==12)
            {
                [self goChatListingScreen:nil];
            }
            
        }
        
        NotificationCount=[[USERDEFAULTS valueForKey:@"Count"]integerValue]+[[[NSUserDefaults standardUserDefaults] valueForKey:@"MinusCount"]integerValue];
        //    application.applicationIconBadgeNumber = NotificationCount;
    }else
    {
        [USERDEFAULTS setObject:@"YES" forKey:@"isFromNotification"];
        [USERDEFAULTS synchronize];
    }
    
    
    UIApplicationState state = [application applicationState];
    
    if (state == UIApplicationStateActive)
    {
        [constant getIntialCountForUserId:[NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"userid"]] andDeviceId:[NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"deviceToken"]]];
    }
}


-(float)getDeviceVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}
-(void)getIDArray{
    
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    
    NSString*strWebService;
    NSDictionary *dictParams;
    
    strWebService=[[NSString alloc]initWithFormat:@"%@show_chat",AppURL];
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",
                nil];
    NSLog(@"%@",strWebService);
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
             NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             if ([str isEqualToString:@"0"] )
             {
                 idArray=[[NSMutableArray alloc]init];
                 arrPitchId=[[NSMutableArray alloc]init];
                 for (int k=0; k<[[response valueForKey:@"data"] count]; k++) {
                     [idArray addObject:[[[[response valueForKey:@"data"] valueForKey:@"b"] valueForKey:@"user_id"] objectAtIndex:k]];
                     [arrPitchId addObject:[[[[response valueForKey:@"data"] valueForKey:@"0"] valueForKey:@"pitch_id"] objectAtIndex:k]];
                 }
                 [self getLastMessage];
             }
         }
     }];
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    
    count=0;
    totalNotifyCountMinusCount=0;
    NotificationCount=[[[NSUserDefaults standardUserDefaults] valueForKey:@"Count"]integerValue]+[[[NSUserDefaults standardUserDefaults] valueForKey:@"MinusCount"]integerValue];
    //    application.applicationIconBadgeNumber = NotificationCount;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lu", (long)count] forKey:@"Count"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lu", (long)count] forKey:@"MinusCount"];
    
}

-(void)getLastMessage{
    
}
//- (void)subscribeChannel
//{
//    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]) {
//        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"userTypeString"] isEqualToString:@"1"]) {
//            // cleint
//            [self getIDArray];
//        }
//        else{
//            // jounalists
//            [self getIDArray];
//        }
//
//    }
//}
- (void)runAPI:(NSNotification *)notification
{
    
    //
    //    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    //    NSString*strWebService;
    //    NSDictionary *dictParams;
    //    strWebService=[[NSString alloc]initWithFormat:@"%@send_chat",AppURL];
    //    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:
    //                [notification.userInfo valueForKey:@"from_user"],@"from_user",
    //                [notification.userInfo valueForKey:@"to_user"],@"to_user",
    //                [notification.userInfo valueForKey:@"chat_id"],@"chat_id",
    //                [notification.userInfo valueForKey:@"pitch_selector_id"],@"pitch_selector_id",
    //                [notification.userInfo valueForKey:@"pitch_id"],@"pitch_id",
    //                [notification.userInfo valueForKey:@"message"],@"message",
    //
    //                nil];
    //
    //    NSLog(@"%@",strWebService);
    //    NSLog(@"%@",dictParams);
    //    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
    //     {
    //         if (!error)
    //         {
    //             NSLog(@"response of get request:%@",response);
    //             NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
    //             if ([str isEqualToString:@"0"] )
    //             {
    //
    //
    //             }
    //         }
    //         else
    //         {
    //             NSLog(@"%@",error.description);
    //         }
    //     }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==1234) {
        [self LogoutAppdelegate];
    }
    if (alertView.tag==1256) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Matches" object:nil];
    }
    if (alertView.tag==126)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"clientReload" object:nil];
    }
    if (alertView.tag == 7005) {
        [nav popViewControllerAnimated:YES];
    }
    
}


#pragma mark - HUD Methods

- (void)showHUD:(NSString*)title
{
    [self.HUD show:YES];
    [self.HUD setLabelText:title];
    [self.HUD setDetailsLabelText:@""];
}

- (void)showHUDSubtitle:(NSString*)subtitle
{
    [self.HUD show:YES];
    [self.HUD setLabelText:@""];
    [self.HUD setDetailsLabelText:subtitle];
}

- (void)hideHUD
{
    [self.HUD hide:YES];
}
#pragma mark chat delegate
// #1 Delegate looks for subscribe events
-(void)Notify
{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate date];
    localNotification.alertBody = [NSString stringWithFormat:@"<html><body><b>H&M</b> test</body></html>"];
    localNotification.alertAction = @"Show me the item";
    localNotification.userInfo = nil;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

// send the log to proper view controller.
- (void)addLog:(NSString*)log {
    UINavigationController *navvc = (UINavigationController*)self.window.rootViewController;
    
    for (UIViewController* vc in navvc.childViewControllers) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            UITabBarController* tabvc = (UITabBarController*)vc;
            for (UIViewController* vc in tabvc.viewControllers) {
                if ([vc respondsToSelector:@selector(addLog:)])
                    [vc performSelector:@selector(addLog:) withObject:log];
            }
        }
    }
}


#pragma mark pubnub delegate

-(void)LogoutAppdelegate
{
    
    [self showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
    
    strWebService=[[NSString alloc]initWithFormat:@"%@logout",AppURL];
    NSLog(@"%@",strWebService);
    NSDictionary *dictParams;
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:
                [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],
                @"user_id1",
                nil];
    NSLog(@"%@",dictParams);
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
             [self hideHUD];
             NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             if ([str isEqualToString:@"0"] )
             {
                 [self executeAPNSRequest:^(NSData *devicePushToken) {
                     
                     
                 }];
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Count"];
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"MinusCount"];
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:LINKEDIN_TOKEN_KEY];
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:LINKEDIN_EXPIRATION_KEY];
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:KEY_PROFILE_TAG];
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userid"];
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userTypeString"];
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"matchcount"];
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"chatcount"];
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"totalcount"];
                 [[NSUserDefaults standardUserDefaults]setObject:@"loggedout" forKey:@"LoginStatus"];
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 
                 [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                 
                 UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
                 [navController.visibleViewController.navigationController popToRootViewControllerAnimated:YES];
             }
             else if ([str isEqualToString:@"1"])
             {
                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"Failure"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 [alert show];
             }
         }
         else
         {
             [self hideHUD];
//             UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Connectivity levels low. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//             [alert show];
             [constant AlertMessageWithString:@"Connectivity levels low. Please try again." andWithView:APPDELEGATE.window.rootViewController.navigationController.topViewController.view];

             NSLog(@"Error returned:%@",[error localizedDescription]);
         }
     }];
    
}


- (void)executeAPNSRequest:(void(^)(NSData *devicePushToken))request {
    if (_dToken) {
        
        request(_dToken);
    }
    else {
    }
}
-(void)LogoutFromApp:(UIViewController *)view
{
    [self showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
    
    strWebService=[[NSString alloc]initWithFormat:@"%@logout",AppURL];
    NSLog(@"%@",strWebService);
    NSDictionary *dictParams;
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:
                [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],
                @"user_id1",
                nil];
    NSLog(@"%@",dictParams);
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             [self disconnect];
             NSLog(@"response of get request:%@",response);
             [self hideHUD];
             NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             if ([str isEqualToString:@"0"] )
             {
                 [self executeAPNSRequest:^(NSData *devicePushToken) {
                     
                     
                 }];
                 
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Count"];
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"MinusCount"];
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:LINKEDIN_TOKEN_KEY];
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:LINKEDIN_EXPIRATION_KEY];
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:KEY_PROFILE_TAG];
                 //                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userid"];
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userTypeString"];
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 [[NSUserDefaults standardUserDefaults]setObject:@"loggedout" forKey:@"LoginStatus"];
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 UINavigationController *frontNavigationController = (id)view.revealViewController.frontViewController;
                 
                 [frontNavigationController.navigationController popViewControllerAnimated:YES];
                 [self deleteAllChat];
             }
             else if ([str isEqualToString:@"1"])
             {
                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"Failure"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 [alert show];
             }
         }
         else
         {
             [self hideHUD];
            // [constant AlertMessageWithString:@"Connectivity levels low. Please try again." andWithView:self.view];
             [constant AlertMessageWithString:@"Connectivity levels low. Please try again." andWithView:APPDELEGATE.window.rootViewController.navigationController.topViewController.view];

//             UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Connectivity levels low. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//             [alert show];
             NSLog(@"Error returned:%@",[error localizedDescription]);
         }
     }];
    
    
}
-(void)deleteAccount:(UIViewController *)view
{
    UINavigationController *frontNavigationController = (id)view.revealViewController.frontViewController;
    
    [frontNavigationController.navigationController popToRootViewControllerAnimated:YES];
    [self deleteAllChat];

}
//Chat
#pragma mark Core Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSManagedObjectContext *)managedObjectContext_roster
{
    return [xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities
{
    return [xmppCapabilitiesStorage mainThreadManagedObjectContext];
}

- (void)disconnect
{
    [self goOffline];
    [xmppStream disconnect];
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    //    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    
    NSLog(@"%@",iq);
    return NO;
}

- (BOOL)connect
{
    NSLog(@"5 Call");
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    
    
    NSString *myJID = [[NSUserDefaults standardUserDefaults] stringForKey:[constant myXMPPId]];
    NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:[constant myXMPPPassword]];
    
    //
    // If you don't want to use the Settings view to set the JID,
    // uncomment the section below to hard code a JID and password.
    //
    // myJID = @"user@gmail.com/xmppframework";
    // myPassword = @"";
    
    if (myJID == nil || myPassword == nil) {
        return NO;
    }
    
    [xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
    //    password = [Constant myXMPPPassword];
    
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
                                                            message:@"See console for error details."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        //        NSLog(@"Error connecting: %@", error);
        
        return NO;
    }
    
    return YES;
}


#pragma XMPP Delegate

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)callSetUpXmppStream
{
    
    if ([[constant myUserId] intValue])
    {
        if ([[constant myXMPPId] length])
        {
            if (![APPDELEGATE xmppStream])
            {
                [APPDELEGATE setupStream];
            }
            if (![[APPDELEGATE xmppStream] isConnected])
            {
                [APPDELEGATE startXMPPConnection];
            }
        }
    }
    
}

-(void)setupStream
{
    NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
    
    // Setup xmpp stream
    //
    // The XMPPStream is the base class for all activity.
    // Everything else plugs into the xmppStream, such as modules/extensions and delegates.
    
    xmppStream = [[XMPPStream alloc] init];
    
#if !TARGET_IPHONE_SIMULATOR
    {
        // Want xmpp to run in the background?
        //
        // P.S. - The simulator doesn't support backgrounding yet.
        //        When you try to set the associated property on the simulator, it simply fails.
        //        And when you background an app on the simulator,
        //        it just queues network traffic til the app is foregrounded again.
        //        We are patiently waiting for a fix from Apple.
        //        If you do enableBackgroundingOnSocket on the simulator,
        //        you will simply see an error message from the xmpp stack when it fails to set the property.
        
        xmppStream.enableBackgroundingOnSocket = YES;
    }
#endif
    
    // Setup reconnect
    //
    // The XMPPReconnect module monitors for "accidental disconnections" and
    // automatically reconnects the stream for you.
    // There's a bunch more information in the XMPPReconnect header file.
    
    xmppReconnect = [[XMPPReconnect alloc] init];
    
    // Setup roster
    //
    // The XMPPRoster handles the xmpp protocol stuff related to the roster.
    // The storage for the roster is abstracted.
    // So you can use any storage mechanism you want.
    // You can store it all in memory, or use core data and store it on disk, or use core data with an in-memory store,
    // or setup your own using raw SQLite, or create your own storage mechanism.
    // You can do it however you like! It's your application.
    // But you do need to provide the roster with some storage facility.
    
    xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    //	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
    
    xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
    
    xmppRoster.autoFetchRoster = YES;
    xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
    // Setup vCard support
    //
    // The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
    // The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
    
    xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
    
    xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
    
    // Setup capabilities
    //
    // The XMPPCapabilities module handles all the complex hashing of the caps protocol (XEP-0115).
    // Basically, when other clients broadcast their presence on the network
    // they include information about what capabilities their client supports (audio, video, file transfer, etc).
    // But as you can imagine, this list starts to get pretty big.
    // This is where the hashing stuff comes into play.
    // Most people running the same version of the same client are going to have the same list of capabilities.
    // So the protocol defines a standardized way to hash the list of capabilities.
    // Clients then broadcast the tiny hash instead of the big list.
    // The XMPPCapabilities protocol automatically handles figuring out what these hashes mean,
    // and also persistently storing the hashes so lookups aren't needed in the future.
    //
    // Similarly to the roster, the storage of the module is abstracted.
    // You are strongly encouraged to persist caps information across sessions.
    //
    // The XMPPCapabilitiesCoreDataStorage is an ideal solution.
    // It can also be shared amongst multiple streams to further reduce hash lookups.
    
    xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    
    xmppCapabilities.autoFetchHashedCapabilities = YES;
    xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
    // Activate xmpp modules
    
    xmppPing = [[XMPPPing alloc] initWithDispatchQueue:dispatch_get_main_queue()];
    //    XMPPAutoPing.pingInterval = 25.f; // default is 60
    //    XMPPAutoPing.pingTimeout = 10.f; // default is 10
    [xmppPing addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppPing activate:self.xmppStream];
    
    [xmppReconnect         activate:xmppStream];
    [xmppRoster            activate:xmppStream];
    [xmppvCardTempModule   activate:xmppStream];
    [xmppvCardAvatarModule activate:xmppStream];
    [xmppCapabilities      activate:xmppStream];
    
    // Add ourself as a delegate to anything we may be interested in
    
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // Optional:
    //
    // Replace me with the proper domain and port.
    // The example below is setup for a typical google talk account.
    //
    // If you don't supply a hostName, then it will be automatically resolved using the JID (below).
    // For example, if you supply a JID like 'user@quack.com/rsrc'
    // then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
    //
    // If you don't specify a hostPort, then the default (5222) will be used.
    
    
    [xmppStream setHostName:IPAddress];
    [xmppStream setHostPort:5222];
    
    // You may need to alter these settings depending on the server you're connecting to
    allowSelfSignedCertificates = NO;
    allowSSLHostNameMismatch = NO;
}

- (void)teardownStream
{
    [xmppStream removeDelegate:self];
    [xmppRoster removeDelegate:self];
    
    [xmppReconnect         deactivate];
    [xmppRoster            deactivate];
    [xmppvCardTempModule   deactivate];
    [xmppvCardAvatarModule deactivate];
    [xmppCapabilities      deactivate];
    [xmppPing removeDelegate:self];
    
    [xmppStream disconnect];
    
    xmppPing = nil;
    xmppStream = nil;
    xmppReconnect = nil;
    xmppRoster = nil;
    xmppRosterStorage = nil;
    xmppvCardStorage = nil;
    xmppvCardTempModule = nil;
    xmppvCardAvatarModule = nil;
    xmppCapabilities = nil;
    xmppCapabilitiesStorage = nil;
}

// It's easy to create XML elments to send and to read received XML elements.
// You have the entire NSXMLElement and NSXMLNode API's.
//
// In addition to this, the NSXMLElement+XMPP category provides some very handy methods for working with XMPP.
//
// On the iPhone, Apple chose not to include the full NSXML suite.
// No problem - we use the KissXML library as a drop in replacement.
//
// For more information on working with XML elements, see the Wiki article:
// https://github.com/robbiehanson/XMPPFramework/wiki/WorkingWithElements

- (void)goOnline
{
    
    XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    
    NSLog(@"%@",xmppStream.myJID);
    
    NSString *domain = [xmppStream.myJID domain];
    
    
    //Google set their presence priority to 24, so we do the same to be compatible.
    
    
    if([domain isEqualToString:@"gmail.com"]
       || [domain isEqualToString:@"gtalk.com"]
       || [domain isEqualToString:@"talk.google.com"])
    {
        NSXMLElement *priority = [NSXMLElement elementWithName:@"priority" stringValue:@"24"];
        [presence addChild:priority];
    }
    
    //    NSLog(@"self xmppstream %@",[self xmppStream]);
    [[self xmppStream] sendElement:presence];
}

- (void)goOffline
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    
    [[self xmppStream] sendElement:presence];
}

-(void)startXMPPConnection
{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    //	DDLogVerbose(@"%@: %@", [xmppStream class], THIS_METHOD);
    {
        if (!xmppStream || ![xmppStream isConnected])
        {
            
            // chat Screen
            
            xmppStream.myJID = [XMPPJID jidWithString:[constant myXMPPId]];
            
            self.xmppMessenger = [[XMPPMessenger alloc] init];
            self.xmppMessenger.pingTimeout = 5;
            
            [self.xmppMessenger activate:xmppStream];
            
            [self.xmppMessenger addDelegate:self delegateQueue:dispatch_get_main_queue()];
            
            NSError *error = nil;
            if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
            {
                presentedViewController = (UINavigationController *)self.window.rootViewController;
                nav =(UINavigationController*)[[presentedViewController.viewControllers lastObject] frontViewController];
                
                if ([(ExpiryTimeViewController*)[[nav viewControllers] lastObject] respondsToSelector:@selector(sendMessageXMPP)])
                {
                    [(ExpiryTimeViewController*)[[nav viewControllers] lastObject] performSelector:@selector(sendMessageXMPP)];
                }else if ([(chatScreemViewController*)[[nav viewControllers] lastObject] respondsToSelector:@selector(messageSend)])
                {
                    [(chatScreemViewController*)[[nav viewControllers] lastObject] performSelector:@selector(messageSend)];
                }
                
            }
        }
        else
        {
            
            //            xmppStream.myJID = [XMPPJID jidWithString:[constant myXMPPId]];
            //
            //            self.xmppMessenger = [[XMPPMessenger alloc] init];
            //            self.xmppMessenger.pingTimeout = 5;
            //
            //            [self.xmppMessenger activate:xmppStream];
            //
            //            [self.xmppMessenger addDelegate:self delegateQueue:dispatch_get_main_queue()];
            NSError *error = nil;
            if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
            {
                presentedViewController = (UINavigationController *)self.window.rootViewController;
                nav =(UINavigationController*)[[presentedViewController.viewControllers lastObject] frontViewController];
                
                if ([(ExpiryTimeViewController*)[[nav viewControllers] lastObject] respondsToSelector:@selector(sendMessageXMPP)])
                {
                    [(ExpiryTimeViewController*)[[nav viewControllers] lastObject] performSelector:@selector(sendMessageXMPP)];
                }else if ([(chatScreemViewController*)[[nav viewControllers] lastObject] respondsToSelector:@selector(messageSend)])
                {
                    [(chatScreemViewController*)[[nav viewControllers] lastObject] performSelector:@selector(messageSend)];
                }
                
                
            }
            
        }
    }
}
-(void)connectChannals:(NSString *)channels
{
    
    // chat Screen
    xmppStream.myJID = [XMPPJID jidWithString:channels];
    
    self.xmppMessenger = [[XMPPMessenger alloc] init];
    self.xmppMessenger.pingTimeout = 5;
    
    [self.xmppMessenger activate:xmppStream];
    
    [self.xmppMessenger addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        NSError *error = nil;
        if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
        {
            presentedViewController = (UINavigationController *)self.window.rootViewController;
            nav =(UINavigationController*)[[presentedViewController.viewControllers lastObject] frontViewController];
            
            if ([(ExpiryTimeViewController*)[[nav viewControllers] lastObject] respondsToSelector:@selector(sendMessageXMPP)])
            {
                [(ExpiryTimeViewController*)[[nav viewControllers] lastObject] performSelector:@selector(sendMessageXMPP)];
            }else if ([(chatScreemViewController*)[[nav viewControllers] lastObject] respondsToSelector:@selector(messageSend)])
            {
                [(chatScreemViewController*)[[nav viewControllers] lastObject] performSelector:@selector(messageSend)];
            }
            
            
        }
        
    }
}
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
    //	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
    //	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    if (allowSelfSignedCertificates)
    {
        //Changes
        //        [settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
        [settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLValidatesCertificateChain];
    }
    
    if (allowSSLHostNameMismatch)
    {
        [settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
    }
    else
    {
        NSString *expectedCertName = [xmppStream.myJID domain];
        
        if (expectedCertName)
        {
            [settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
        }
    }
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
    //	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSError *error = nil;
    
    if (![xmppStream authenticateWithPassword:[constant myXMPPPassword] error:&error])
    {
        NSLog(@"%@: Error xmppStreamDidConnect authenticating: %@", [self class], error);
    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"xmppStreamDidAuthenticate");
    NSLog(@"%@",(sender.isConnected ? @"YES":@"NO"));
    
    //	DDLogVerbose(@"%@: %@", [self class], THIS_METHOD);
    [self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    NSLog(@"xmppStream didNotAuthenticate");
    //	DDLogVerbose(@"%@: %@", [self class], THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    //	DDLogVerbose(@"%@: %@ ", [self class], THIS_METHOD);
    
    NSLog(@"xmppStreamDidDisconnect Error : %@",[error description]);
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    presentedViewController = (UINavigationController *)self.window.rootViewController;
    nav =(UINavigationController*)[[presentedViewController.viewControllers lastObject] frontViewController];
    if ([(chatScreemViewController*)[[nav viewControllers] lastObject] respondsToSelector:@selector(didConnectedToXmpp)])
    {
        [(chatScreemViewController*)[[nav viewControllers] lastObject] performSelector:@selector(didConnectedToXmpp)];
    }else if([(ExpiryTimeViewController*)[[nav viewControllers] lastObject] respondsToSelector:@selector(didConnectedToXmpp)])
    {
        [(ExpiryTimeViewController*)[[nav viewControllers] lastObject] performSelector:@selector(didConnectedToXmpp)];
        
    }
    NSLog(@"did receive presence");
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    [self xmppStream:sender didReceiveMessage:message];
}


- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSLog(@"%@",message);
    if ([message isChatMessageWithBody])
    {
        XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[message from]
                                                                 xmppStream:xmppStream
                                                       managedObjectContext:[self managedObjectContext_roster]];
        
        //Changes 6/11/15
        
        /*NSString *body = [[message elementForName:@"body"] stringValue];
         NSString *displayName = [user displayName];
         
         if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
         {
         //			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
         //                                                                message:body
         //                                                               delegate:nil
         //                                                      cancelButtonTitle:@"Ok"
         //                                                      otherButtonTitles:nil];
         //			[alertView show];
         }
         else
         {
         // We are not active, so use a local notification instead
         UILocalNotification *localNotification = [[UILocalNotification alloc] init];
         localNotification.alertAction = @"Ok";
         localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",displayName,body];
         
         [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
         }*/
        //Changes 6/11/15
    }
    //    [[[UIAlertView alloc] initWithTitle:@"Got message." message:[message debugDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    NSLog(@"message %@",[message description]);
    NSString*WannAId = @"";
    NSString*time = @"";
    NSString*messageStr = @"";
    NSString*to = @"";
    NSString*from = @"";
    NSString*opponent = @"";
    NSString*opponentDisplayName = @"";
    
    from = [message fromStr];
    to = [message toStr];
    
    for (int i=0; i<[message childCount]; i++)
    {
        DDXMLNode*node = [message childAtIndex:i];
        //        NSLog(@"name %@",[node name]);
        if ([[node name] isEqualToString:@"thread"])
        {
            WannAId = [node stringValue];
        }
        else if ([[node name] isEqualToString:@"body"])
        {
            messageStr = [node stringValue];
        }
        else if ([[node name] isEqualToString:@"subject"])
        {
            opponentDisplayName = [node stringValue];
        }
        else if ([[node name] isEqualToString:@"delay"])
        {
            DDXMLElement *el = [[DDXMLElement alloc] initWithXMLString:[node XMLString] error:nil];
            time = [[el attributeForName:@"stamp"] stringValue];
            //            messageStr = [node att];
        }
    }
    from = [[from componentsSeparatedByString:@"@"] objectAtIndex:0];
    to = [[to componentsSeparatedByString:@"@"] objectAtIndex:0];
    
    NSDate* date = nil;
    NSDateFormatter*dateformatter = [[NSDateFormatter alloc] init];
    if ([time isEqualToString:@""])
    {
        date = [NSDate date];
    }
    else
    {
        time = [[time stringByReplacingOccurrencesOfString:@"T" withString:@" "] stringByReplacingOccurrencesOfString:@"Z" withString:@""];
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];//2012-10-26T10:08:31Z
        //        2016-05-18T12:15:11.418Z
        date = [dateformatter dateFromString:time];
        NSInteger interval = [[NSTimeZone localTimeZone] secondsFromGMT];
        date = [date dateByAddingTimeInterval:interval];
    }
    
    [dateformatter setDateFormat:@"dd/MM/yy HH:mm:ss.SSS"];
    time = [dateformatter stringFromDate:date];
    if (from == (id)[NSNull null] || !from)
    {
        from = [constant myXMPPIdNoHost];
        
        opponent = [to uppercaseString];
    }
    else
    {
        opponent = [from uppercaseString];
    }
    from = [from uppercaseString];
    to = [to uppercaseString];
    //    messageStr = [messageStr stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];
    messageStr = [self replacePattern:@"'" withReplacement:@"'" forString:messageStr usingCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"'"]];
    NSLog(@"from %@",from);
    NSLog(@"to %@",to);
    NSLog(@"WannAId %@",WannAId);
    NSLog(@"messageStr %@",messageStr);
    NSLog(@"time %@",time);
    NSLog(@"opponentDisplayName %@",opponentDisplayName);
    NSLog(@"===================================");
    
    
    NSString*messageThreadID = @"";
    {
        NSString*opponentID = @"";
        if ([from isEqualToString:[[constant myXMPPIdNoHost] uppercaseString]])
        {
            opponentID = to;
        }
        else
        {
            opponentID = from;
        }
        
        NSString *strIsRead =  @"0";
        if([from isEqualToString:[[constant myXMPPIdNoHost] uppercaseString]])
        {
            strIsRead = @"1";
        }
        else
        {
            
            strIsRead = @"0";
        }
        
        
        NSString *strFinalOpponentName;
        NSDictionary *dicTemp;
        if([opponentDisplayName length]==0)
        {
            strFinalOpponentName = self.strCurrentChatOpponentName;
        }
        else
        {
            strFinalOpponentName = opponentDisplayName;
        }
        strFinalOpponentName = @"";
        if ([from isEqualToString:[[constant myXMPPIdNoHost] uppercaseString]])
        {
            dicTemp = [NSDictionary dictionaryWithObjectsAndKeys:messageStr, @"lastMessage",
                       from, @"lastMessageFromUser",
                       time, @"messageTime",
                       to, @"opponentXMPPID",
                       strFinalOpponentName,@"opponentDisplayName",
                       strIsRead,@"isRead",@"1",@"userType",
                       nil];
            
        }else
        {
            dicTemp = [NSDictionary dictionaryWithObjectsAndKeys:messageStr, @"lastMessage",
                       from, @"lastMessageFromUser",
                       time, @"messageTime",
                       to, @"opponentXMPPID",
                       strFinalOpponentName,@"opponentDisplayName",
                       strIsRead,@"isRead",@"2",@"userType",
                       nil];
            //        NSLog(@"dic::%@",[dicTemp description]);
        }
        presentedViewController = (UINavigationController *)self.window.rootViewController;
        nav =(UINavigationController*)[[presentedViewController.viewControllers lastObject] frontViewController];
        if ([[[nav viewControllers] lastObject] isKindOfClass:[ExpiryTimeViewController class]])
        {
            if(![from isEqualToString:[[constant myXMPPIdNoHost] uppercaseString]])
            {
                int flagid = (int)[[Database sharedObject] insertToTable:@"lastMessageMaster" withValues:dicTemp];
                NSLog(@"%d",flagid);
                
                [self showNotificationPopUp:messageStr type:@"8"];
            }
            
        }
        
        int tID = [self insertMessage:dicTemp];
        
//        NSMutableArray *data = [[NSMutableArray alloc] init];
//        data= [[Database sharedObject] executeSelectQuery:@"select *from latestMessageMaster"];
        if (tID>0)
        {
            presentedViewController = (UINavigationController *)self.window.rootViewController;
            nav =(UINavigationController*)[[presentedViewController.viewControllers lastObject] frontViewController];
            if ([[[nav viewControllers] lastObject] isKindOfClass:[ExpiryTimeViewController class]])
            {
                [(ExpiryTimeViewController*)[[nav viewControllers] lastObject] performSelector:@selector(sendChat)];
            }
            else if ([[[nav viewControllers] lastObject] isKindOfClass:[chatScreemViewController class]])
            {
                [(chatScreemViewController*)[[nav viewControllers]lastObject] performSelector:@selector(getChatData)];
            }
            
            
            messageThreadID = [NSString stringWithFormat:@"%d",tID];
            
        }
    }
    
    if ([messageThreadID intValue])
    {
        //        UIViewController* vc = [(UINavigationController*)self.window.rootViewController visibleViewController];
        //        if ([vc isKindOfClass:[PrivateChatVC class]])
        //        {
        //            if ([vc respondsToSelector:@selector(gotNewMessagewithID:sender:thread:)])
        //            {
        //                NSLog(@"Call Got Message With Id");
        //                [(PrivateChatVC*)vc gotNewMessagewithID:[NSString stringWithFormat:@"%@",messageThreadID] sender:from thread:messageThreadID];
        //            }
        //        }
        //        else
        //        {
        //            NSLog(@"receive message different controller");
        //
        //            if ([USERDEFAULTS objectForKey:@"CurrentView"]) {
        //                NSString *strCurrentView = [USERDEFAULTS objectForKey:@"CurrentView"];
        //                if ([strCurrentView isEqualToString:@"PrivateChatUserList"]) {
        //                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UNREADMESSAGECOUNT object:@"PrivateChatUserView"];
        //                }
        //                else if([strCurrentView isEqualToString:@"HomeView"]){
        //                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UNREADMESSAGECOUNT object:@"HomeView"];
        //                }
        //            }
        //        }
        // got new message
    }
}

- (NSString*)replacePattern:(NSString*)pattern withReplacement:(NSString*)replacement forString:(NSString*)string usingCharacterSet:(NSCharacterSet*)characterSetOrNil
{
    // Check if a NSCharacterSet has been provided, otherwise use our "default" one
    if (!characterSetOrNil)
        characterSetOrNil = [NSCharacterSet characterSetWithCharactersInString:@"'"];
    
    // Create a mutable copy of the string supplied, setup all the default variables we’ll need to use
    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:string];
    NSString *beforePatternString = nil;
    NSRange outputrange = NSMakeRange(0, 0);
    
    // Check if the string contains the "pattern" you’re looking for, otherwise simply return it.
    NSRange containsPattern = [mutableString rangeOfString:pattern];
    if (containsPattern.location != NSNotFound)
        // Found the pattern, let’s run with the changes
    {
        // Firstly, we grab the full string range
        NSRange stringrange = NSMakeRange(0, [mutableString length]);
        NSScanner *scanner = [[NSScanner alloc] initWithString:mutableString];
        
        // Now we use NSScanner to scan UP TO the pattern provided
        [scanner scanUpToString:pattern intoString:&beforePatternString];
        
        // Check for nil here otherwise you will crash – you will get nil if the pattern is at the very beginning of the string
        // outputrange represents the range of the string right BEFORE your pattern
        // We need this to know where to start searching for our characterset (i.e. end of output range = beginning of our pattern)
        if (beforePatternString != nil)
            outputrange = [mutableString rangeOfString:beforePatternString];
        
        // Search for any of the character sets supplied to know where to stop.
        // i.e. for a URL you’d be looking at non-URL friendly characters, including spaces (this may need a bit more research for an exhaustive list)
        NSRange characterAfterPatternRange = [mutableString rangeOfCharacterFromSet:characterSetOrNil options:NSLiteralSearch range:NSMakeRange(outputrange.length, stringrange.length-outputrange.length)];
        
        // Check if the link is not at the very end of the string, in which case there will be no characters AFTER it so set the NSRage location to the end of the string (== it’s length)
        if (characterAfterPatternRange.location == NSNotFound)
            characterAfterPatternRange.location = [mutableString length];
        
        // Assign the pattern’s start position and length, and then replace it with the pattern
        NSInteger patternStartPosition = outputrange.length;
        NSInteger patternLength = (characterAfterPatternRange.location - outputrange.length);
        [mutableString replaceCharactersInRange:NSMakeRange(patternStartPosition, patternLength) withString:replacement];
        
        
        // Reset containsPattern for new mutablestring and let the loop continue
        containsPattern = [mutableString rangeOfString:pattern];
    }
    return [mutableString copy];
}
-(int)insertMessage:(NSDictionary *)dictparams
{
  
    NSArray *arrDub = [[NSArray alloc] init];
//@"SELECT * FROM latestMessageMaster WHERE (opponentXMPPID = '%@' AND lastMessageFromUser= '%@') OR (opponentXMPPID = '%@' AND lastMessageFromUser= '%@')"
    NSString *strRow = [dictparams objectForKey:@"messageTime"];
    NSString *strPer = @"%";
    NSString *strMessageLastTime = [NSString stringWithFormat:@"%@%@",[strRow substringToIndex:strRow.length-4],strPer];
    
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM latestMessageMaster WHERE lastMessage = '%@' AND lastMessageFromUser = '%@' AND messageTime LIKE '%@' AND opponentXMPPID = '%@'" ,[dictparams objectForKey:@"lastMessage"],[dictparams objectForKey:@"lastMessageFromUser"],strMessageLastTime,[dictparams objectForKey:@"opponentXMPPID"]];
    arrDub =[[[Database sharedObject] executeSelectQuery:selectQuery] mutableCopy];
    
 
    if (arrDub.count>0)
    {
        return 0;
    }else
    {
    int tID = (int)[[Database sharedObject] insertToTable:@"latestMessageMaster" withValues:dictparams];
    return tID;
    }
}
-(NSString*)timestamp2date:(NSString*)timestamp
{
    NSString * timeStampString =[timestamp substringFromIndex:2];
    //[timeStampString stringByAppendingString:@"000"];   //convert to ms
    double time = [timeStampString doubleValue]/1000;
    
    NSTimeInterval _interval=time;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setTimeZone:[NSTimeZone localTimeZone]];
    [_formatter setDateFormat:@"yy/MM/dd HH:mm:ss.SSS"];
    return [_formatter stringFromDate:date];
}
- (void)xmppMessengerDidSentMessage:(XMPPMessage *)message
{
    //    [[[UIAlertView alloc] initWithTitle:@"Message" message:[message debugDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    //    [self xmppMessengerDidReceiveMessage:message];
    //    [self xmppStream:xmppStream didReceiveMessage:message];
}

//- (void)xmppAutoPingDidTimeout:(XMPPAutoPing *)sender
//{
//    //	DDLogVerbose(@"%@: %@", [self class], THIS_METHOD);
//}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRosterDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence
{
    //	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[presence from]
                                                             xmppStream:xmppStream
                                                   managedObjectContext:[self managedObjectContext_roster]];
    
    NSString *displayName = [user displayName];
    NSString *jidStrBare = [presence fromStr];
    NSString *body = nil;
    
    if (![displayName isEqualToString:jidStrBare])
    {
        body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
    }
    else
    {
        body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
    }
    
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
                                                            message:body
                                                           delegate:nil
                                                  cancelButtonTitle:@"Not implemented"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        // We are not active, so use a local notification instead
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertAction = @"Not implemented";
        localNotification.alertBody = body;
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
}
-(void)deleteAllChat
{
    bool a = [[Database sharedObject] deleteData:@"delete from latestMessageMaster"];
    a = [[Database sharedObject] deleteData:@"delete from lastMessageMaster"];
}


@end
