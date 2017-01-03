//
//  chatScreemViewController.h
//  uPitch
//
//  Created by Puneet Rao on 16/04/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <sqlite3.h>
@interface chatScreemViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
     AppDelegate*appdelegateInstance;
    __weak IBOutlet UITableView *dataTableVw;
    __weak IBOutlet UIView *bottomView;
    __weak IBOutlet UIImageView *borderImageView;
    __weak IBOutlet UILabel *userNameHeader;
    NSMutableArray*mainArray;
    NSMutableArray*dateArray;
    NSMutableArray*mainObjectArray;
    NSInteger filterCounter;
    BOOL increaseBoolChannel1,increaseBoolChannel2;
    UIImageView*rivalImageView;
     UIImageView*loginImageView;
    int tableViewHeight;
    IBOutlet UILabel *lblPitchTitle;
    IBOutlet UIView *vwTitleName;
    __weak IBOutlet UIButton *sendButton;
    NSString *from;
    NSString *to;

}
@property (nonatomic,strong) NSString *myXmppID;
@property (nonatomic,strong) NSString *oppennetXmppID;
 @property NSData *deviceToken;
@property(nonatomic,strong) NSString *userNameHeaderString;
@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *contactDB;
@property(nonatomic,strong) NSString*deviceTokenString;
@property(nonatomic,strong) NSString*userIdString;
@property(nonatomic,strong) NSString*chatIdString;
@property(nonatomic,strong) NSString*rivalImageViewPath;
@property(nonatomic,strong) NSString*loginImageViewPath;
@property(nonatomic,strong) NSString*strShowPitchName;
@property(nonatomic,strong) NSString*strPitchId;
@property(nonatomic,weak) UITextView *messageTextView;
@property (nonatomic, weak) IBOutlet UITextView *requestOutput;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
-(void)messageSend;
-(void)getChatData;
-(void)didConnectedToXmpp;

- (IBAction)sendAction:(id)sender;
- (IBAction)popView:(id)sender;
- (IBAction)endChat:(id)sender;

@end
