//
//  constant.h
//  UPitch
//
//  Created by Inheritx-iPhone on 09/11/15.
//  Copyright © 2015 Puneet Rao. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "LxReqRespManager.h"
#define KAPPNAME @"uPitch"
#define USERDEFAULTS [NSUserDefaults standardUserDefaults]
#define XMPPHOSTNAME @"HostName"
#define KEYFROMXMPPID @"fromXMPPID"
#define KEYMESSAGE @"message"
#define KEYMESSAGETIME @"messageTime"
#define KEYOPPONENTUSERNAME @"opponentDisplayName"
#define VIDEO_ADD @"isVideoAdded"
#define DATABASEFILE @"upitchChat.sqlite"

#define MYUSERINFO @"UserInfo"
#define KEYLASTNAME @"last_name"
#define KEYUSERID @"user_id"
#define KEYXMPPUSERID @"ejabberd_name"
#define KEYXMPPUSERPASSWORD @"ejabberd_pwd"
#define KEYWANNAID @"upitch_id"
#define KEYWANNANAME @"upitch_name"
//#define IPAddress @"192.168.1.63"
#define IPAddress @"upitchapp.com"
#define KEYFIRSTNAME @"user_name"
#define USERTYPE @"userType"
//#define XMPPENID @"aujyyh34cr"
#define MYXMPPID @"myxmmpid"
#define OPENNENTNAME @"opennentid"
#define ISUSERFIRSTTIME @"isUserFirstTime"
#define ISFIRSTTIMELEFTJOURALIST @"isFirstTimeLeftJournalist"
#define ISFIRSTTIMERIGHTJOURNALIST @"isFirstTimeRightJournalist"
//#define XMPPENID @"92ebd19b"
////return @"92ebd19b";
//#define MYXMPPID @"sid"
//#define OPENNENTNAME @"kandhal"
@interface constant : NSObject
{

}
+ (NSString*)myFirstName;
+ (NSString*)myLastName;
+ (NSString*)myUserId;

+(void)alertViewWithMessage:(NSString*)strAlertMessage withView:(UIViewController*)view;
+(void)AlertMessageWithString:(NSString *)strAlertMessage andWithView:(UIView *)viewForToast;
+(void)clearChatMatchCountP:(NSString*)deviceID userIDfor:(NSString*)userID type:(NSString*)strType;
+ (NSString*)myWannAId;
+ (NSString*)myWannAName;
+ (NSString*)myXMPPId;
+ (NSString*)myXMPPPassword;
+ (NSString*)myXMPPIdNoHost;
+(void)getIntialCountForUserId:(NSString*)userID andDeviceId:(NSString*)DeviceId;
+(float)getDeviceVersion;
@end
