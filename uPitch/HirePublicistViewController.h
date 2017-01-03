//
//  HirePublicistViewController.h
//  uPitch
//
//  Created by Puneet Rao on 14/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PayPalMobile.h"
#define kPayPalEnvironment PayPalEnvironmentNoNetwork
@interface HirePublicistViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate,PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate, UIPopoverControllerDelegate>
{
    __weak IBOutlet UIImageView *line_Quote;
    __weak IBOutlet UIImageView *line_Pitch;
    __weak IBOutlet UIImageView *messageImageView;
    __weak IBOutlet UIImageView *emailImageView;
    __weak IBOutlet UIImageView *contactNumberImageView;
    __weak IBOutlet UIImageView *contactNameImageView;
    __weak IBOutlet UIView *scrollSubView_Common;
    __weak IBOutlet UIView *scrollSubViewTop_Quote;
    __weak IBOutlet UIView *scrollSubViewTop_Hire;
    AppDelegate*appdelegateInstance;
    __weak IBOutlet UIToolbar *toolBar;
    __weak IBOutlet UITextField *contactName;
    __weak IBOutlet UITextField *contactNumber;
    __weak IBOutlet UITextField *email;
    __weak IBOutlet UITextView *messageTextView;
    __weak IBOutlet UILabel *messageBaseLabel;
    __weak IBOutlet UIScrollView *scrollVw;
    __weak IBOutlet UIButton *submitButton;
    NSString*pitchServiceQuoteString;
    int contentOffsetY;
    
    __weak IBOutlet UIImageView *imgCount;
    __weak IBOutlet UILabel *lblCount;
}
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *payPalSuccessId;
- (IBAction)bottomButtonAction:(id)sender;

- (IBAction)submitButtonPressed:(id)sender;
@end
