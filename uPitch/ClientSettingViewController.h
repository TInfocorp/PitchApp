//
//  ClientSettingViewController.h
//  uPitch
//
//  Created by Puneet Rao on 16/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface ClientSettingViewController : UIViewController
{
    __weak IBOutlet UISwitch *notifiactionSwitch;
    __weak IBOutlet UIView *bottomView;
    __weak IBOutlet UIView *contactView;
    __weak IBOutlet UIView *notificationView;
    __weak IBOutlet UIView *userTypeView;
    __weak IBOutlet UIScrollView *scrollview;
    __weak IBOutlet UIToolbar *toolBar;
    __weak IBOutlet UIButton *deleteButton;
    __weak IBOutlet UIButton *logoutButton;
    __weak IBOutlet UIButton *submitButton;
    __weak IBOutlet UIImageView *textViewImageView;
    __weak IBOutlet UIImageView *emailImageView;
     AppDelegate*appdelegateInstance;
    __weak IBOutlet UITextField *emailTextField;
    __weak IBOutlet UILabel *messageLabel;
    __weak IBOutlet UITextView *messageTextView;
    BOOL MaintainApiBool;
    __weak IBOutlet UIButton *upgradeButton;
    int contentOffsetY;
    NSInteger contentHeight;
    __weak IBOutlet UILabel *userTypeLabel;
    NSString*switchString;
    NSString*switchXpire;
    NSString *strOptionEmail;
    NSString *strOptionPush;
    __weak IBOutlet UIImageView *imgCount;
    __weak IBOutlet UILabel *lblCount;
    IBOutlet UISwitch *switchNotificationXpire;
    
    IBOutlet UISwitch *switchEmailNotification;
    
    IBOutlet UISwitch *switchPushNotification;
}
- (IBAction)AccountSettingPressed:(id)sender;
- (IBAction)requestFreeUpgrade:(id)sender;
- (IBAction)FAQAction:(id)sender;
- (IBAction)privacyTerms:(id)sender;
- (IBAction)rateUs:(id)sender;

- (IBAction)logoutAction:(id)sender;
- (IBAction)deleteAccountPressed:(id)sender;
- (IBAction)SetExpireState:(id)sender;
- (IBAction)submitAction:(id)sender;
- (IBAction)setEmailNotification:(id)sender;
- (IBAction)setState:(id)sender;
- (IBAction)setPushNotification:(id)sender;



@end
