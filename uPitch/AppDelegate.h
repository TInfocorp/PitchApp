

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"
#import <sqlite3.h>
#import "XMPPFramework.h"
#import "XMPPMessenger.h"
#import "XMPPMessage+XEP_0184.h"
#import "Database.h"
//#define AppURL @"http://192.168.1.103/upitch/api/"
//#define AppURL @"http://www.cgtechnosoft.net/upitch/api/"

//#define AppURL @"http://upitchapp.com/api/"

//#define AppURL @"http://upitchapp.com/upitch_final/api/"
//#define AppURL @"http://upitchnew.inheritxserver.net/api/"    // Harshit
#define AppURL [USERDEFAULTS valueForKey:@"kBaseUrl"]


#define XmppHistoryPitcher [USERDEFAULTS valueForKey:@"xmpp_history_pitcher"]
#define XmppHistoryJournalist [USERDEFAULTS valueForKey:@"xmpp_history_journalist"]
//#define AppURL @"http://192.168.1.149/upitchnew/api/"
//#define AppURL @"http://www.upitchadmin.com/api/"
#define APPDELEGATE (AppDelegate *)[UIApplication sharedApplication].delegate

#define KEY_Email @"email"
#define KEY_Password @"Password"

//#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
//#define IS_IPHONE_6      (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
//#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate,SWRevealViewControllerDelegate>
{
//    NSMutableArray      *gChannels;
//    NSMutableArray      *gMessages;
//    NSMutableDictionary *gMessage;
    UINavigationController *presentedViewController;
    UINavigationController *nav;
    NSMutableArray*unreadMessageCount,*channelArray,*idArray,*arrPitchId;
  
    SWRevealViewController *revealController;
    NSMutableDictionary *diction;
    NSInteger msgUnreadCount;
    //UIView *viewNotificationPopUp;
    UILabel *lblText;
    NSString *strUserIdFromMsg;
    NSString *strMsgPub;
    BOOL *Flag;
    
    
    
@private
    XMPPStream *xmppStream;
    XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
    XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
    XMPPvCardTempModule *xmppvCardTempModule;
    XMPPvCardAvatarModule *xmppvCardAvatarModule;
    XMPPCapabilities *xmppCapabilities;
    XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    XMPPPing *xmppPing;
    
    NSString *strOpponentTargetID;
    
    //	NSString *password;
    
    BOOL allowSelfSignedCertificates;
    BOOL allowSSLHostNameMismatch;
    
    NSString *strCurrentChatOpponentName;
}
-(void)connectChannals:(NSString *)channels;

@property (nonatomic) UIButton *btn;
@property (nonatomic) UIView *viewNotificationPopUp;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) NSInteger NotificationCount;
@property (nonatomic,assign) NSInteger totalNotifyCountMinusCount;
@property NSData *dToken;
@property (strong, nonatomic) SWRevealViewController *SwRevealviewController;
@property (strong, nonatomic) MBProgressHUD *HUD;
- (void)showHUD:(NSString*)title;
- (void)showHUDSubtitle:(NSString*)subtitle;
- (void)hideHUD;
//- (void)subscribeChannel;
- (void)addLog:(NSString*)log;

//Chat
@property (nonatomic,strong)NSString *strCurrentChatOpponentName;
@property (strong, nonatomic) XMPPMessenger *xmppMessenger;
@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
@property (nonatomic, strong, readonly) XMPPPing *xmppPing ;
- (void)goOffline;

@property(nonatomic,strong)NSString *strOpponentTargetID;
-(void)startXMPPConnection;
-(void)setupStream;
-(void)callSetUpXmppStream;
- (BOOL)connect;
- (void)disconnect;
-(NSString*)timestamp2date:(NSString*)timestamp;
-(int)insertMessage:(NSDictionary *)dictparams;

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *contactDB;
-(void)LogoutFromApp:(UIViewController *)view;
@end

