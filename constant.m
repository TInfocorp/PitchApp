//
//  constant.m
//  UPitch
//
//  Created by Inheritx-iPhone on 09/11/15.
//  Copyright © 2015 Puneet Rao. All rights reserved.
//

#import "constant.h"
#import "UIView+Toast.h"
#import "AppDelegate.h"

@implementation constant

+(void)alertViewWithMessage:(NSString*)strAlertMessage withView:(UIViewController*)view
{
    if ([self getDeviceVersion] >= 8.0)
    {
        UIAlertController *alertMessage= [UIAlertController alertControllerWithTitle:KAPPNAME message:strAlertMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alertMessage addAction:ok];
        [view presentViewController:alertMessage animated:YES completion:nil];
        
    }else
    {
        UIAlertView *alertMessage = [[UIAlertView alloc] initWithTitle:KAPPNAME message:strAlertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertMessage show];
    }
    
}

+(void)clearChatMatchCountP:(NSString*)deviceID userIDfor:(NSString*)userID type:(NSString*)strType
{
    
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
    NSDictionary *dictParams;
    if ([strType isEqualToString:@"1"])
    {
        NSString *strCount = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"matchcount"]];
        strWebService=[[NSString alloc]initWithFormat:@"%@clear_match_count",AppURL];
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:userID,@"user_id",strCount,@"match_badge_count",
                    nil];
    }else
    {
        NSString *strCount = [NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"chatcount"]];
        strWebService=[[NSString alloc]initWithFormat:@"%@clear_chat_count",AppURL];
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:userID,@"user_id",strCount,@"chat_badge_count",
                    nil];
      
    }
    NSLog(@"%@",strWebService);
    NSLog(@"%@",dictParams);
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
             
             [constant getIntialCountForUserId:[NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"userid"]] andDeviceId:[NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"deviceToken"]]];
             
         }
     }
     ];
}
+(void)getIntialCountForUserId:(NSString*)userID andDeviceId:(NSString*)DeviceId
{
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    
    NSString*strWebService;
    NSDictionary *dictParams;
    
    strWebService=[[NSString alloc]initWithFormat:@"%@get_initial_counts",AppURL];
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:userID,@"user_id",
                nil];
    NSLog(@"%@",strWebService);
    NSLog(@"%@",dictParams);
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
             NSString *str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             [USERDEFAULTS setObject:[NSString stringWithFormat:@"%@",[response objectForKey:@"match_badge_count"]] forKey:@"matchcount"];
             [USERDEFAULTS setObject:[NSString stringWithFormat:@"%@",[response objectForKey:@"chat_badge_count"]] forKey:@"chatcount"];
             
             [USERDEFAULTS setObject:[response objectForKey:@"total_badge_count"] forKey:@"totalcount"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"pubnubnot" object:nil];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[USERDEFAULTS objectForKey:@"totalcount"] integerValue]];
             });

             

//             NSLog(@"%@ %@",response,str);
             
         }
     }
     ];
}
+(void)AlertMessageWithString:(NSString *)strAlertMessage andWithView:(UIView *)viewForToast
{
    strAlertMessage = [strAlertMessage stringByTrimmingCharactersInSet:
                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (![strAlertMessage isEqualToString:@"(null)"])
        [viewForToast makeToast:strAlertMessage];
    
    else
        [viewForToast makeToast:@"Something went wrong."];
    
    //    if ([strAlertMessage isEqualToString:NODATAFOUND])
    //        [viewForToast makeToast:strAlertMessage];
    //
    //    else if ([strAlertMessage rangeOfString:DATASAVEDSUCCESSFULLY].location != NSNotFound)
    //        [viewForToast makeToast:strAlertMessage];
    //
    //    else if ([strAlertMessage isEqualToString:MEMBERDETAILSSAVED])
    //        [viewForToast makeToast:strAlertMessage];
    //
    //    else if ([strAlertMessage isEqualToString:UPDATINGDATA])
    //        [viewForToast makeToast:strAlertMessage];
    //
    //    else if ([strAlertMessage isEqualToString:DEVICECONNECTED])
    //        [viewForToast makeToast:strAlertMessage];
    //
    //    else if ([strAlertMessage isEqualToString:DISSCONNECTSUCCESS])
    //        [viewForToast makeToast:strAlertMessage];
    //
    //    else if (![strAlertMessage isEqualToString:NULLMESSAGE])
    //        [Alerts showAlertWithMessage:strAlertMessage withBlock:nil andButtons:ALERT_BTN_OK, nil];
    //
    //    else
    //        [viewForToast makeToast:ALERTUNKNOWNMSG];
}
+ (NSString*)myXMPPId
{
    if ([[USERDEFAULTS objectForKey:@"userTypeString"] isEqualToString:@"1"]) {
        NSString *myXMPPId;
        myXMPPId = [NSString stringWithFormat:@"user_%@_0@%@",[USERDEFAULTS objectForKey:@"userid"],IPAddress];
        return myXMPPId;
    }
  
    NSString *myXMPPId = [USERDEFAULTS objectForKey:MYXMPPID];
    myXMPPId = [myXMPPId stringByAppendingFormat:@"@%@",IPAddress];

//        return @"2259_1824_807@50.62.134.174";
    return myXMPPId;
}

+ (NSString*)myXMPPIdNoHost
{
    if ([[USERDEFAULTS objectForKey:@"userTypeString"] isEqualToString:@"1"]) {
        NSString *myXMPPId;
        myXMPPId = [NSString stringWithFormat:@"user_%@_0",[USERDEFAULTS objectForKey:@"userid"]];
        return myXMPPId;
    }
    
    
    NSString *myXMPPId = [USERDEFAULTS objectForKey:MYXMPPID];
//    NSLog(@"myXMPPId::%@",myXMPPId);
    return myXMPPId;


}

+ (NSString*)myXMPPPassword
{
    return @"upitch@123";
}

+ (NSString*)myWannAId
{
    NSString *myWannAId = @"";
    if([USERDEFAULTS objectForKey:MYUSERINFO]){
        NSDictionary *dict = [USERDEFAULTS objectForKey:MYUSERINFO];
        if ([dict objectForKey:KEYWANNAID]) {
            myWannAId = [dict objectForKey:KEYWANNAID];
        }
    }
    
    return myWannAId;
}

+ (NSString*)myWannAName
{
    NSString *myWannAName = @"";
    if([USERDEFAULTS objectForKey:MYUSERINFO]){
        NSDictionary *dict = [USERDEFAULTS objectForKey:MYUSERINFO];
        if ([[dict objectForKey:MYUSERINFO] objectForKey:KEYWANNANAME])
        {
            myWannAName = [[dict objectForKey:MYUSERINFO] objectForKey:KEYWANNANAME];
        }
    }
    
    return myWannAName;
}
+ (NSString*)myFirstName
{
    NSString *myFirstName = @"";
    if([USERDEFAULTS objectForKey:MYUSERINFO]){
        NSDictionary *dict = [USERDEFAULTS objectForKey:MYUSERINFO];
        if ([dict objectForKey:KEYFIRSTNAME]) {
            myFirstName = [dict objectForKey:KEYFIRSTNAME];
        }
    }
    NSString *myXMPPId = [USERDEFAULTS objectForKey:MYXMPPID];

    return myXMPPId;
  //return @"92ebd19b";   //sid
}

+ (NSString*)myLastName
{
    NSString *myLastName = @"";
    if([USERDEFAULTS objectForKey:MYUSERINFO]){
        NSDictionary *dict = [USERDEFAULTS objectForKey:MYUSERINFO];
        if ([[dict objectForKey:MYUSERINFO] objectForKey:KEYLASTNAME]) {
            myLastName = [[dict objectForKey:MYUSERINFO] objectForKey:KEYLASTNAME];
        }
    }
    
    return myLastName;
}

+ (NSString*)myUserId
{
    NSString *myUserId = @"";
    if([USERDEFAULTS objectForKey:MYUSERINFO]){
        NSDictionary *dict = [USERDEFAULTS objectForKey:MYUSERINFO];
        if ([dict objectForKey:KEYUSERID]) {
            myUserId = [dict objectForKey:KEYUSERID];
        }
    }
    return myUserId;
}
+(float)getDeviceVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}
@end
