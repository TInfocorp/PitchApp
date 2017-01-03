//
//  ForgotPasswordViewController.h
//  uPitch
//
//  Created by Puneet Rao on 19/05/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface ForgotPasswordViewController : UIViewController
{
    __weak IBOutlet UITextField *conPassword;
    __weak IBOutlet UITextField *password;
    __weak IBOutlet UITextField *confirmationCode;
    __weak IBOutlet UIButton *submitButton;
    __weak IBOutlet UIView *resetView;
    __weak IBOutlet UIView *emailView;
    AppDelegate*appdelegateInstance;
    __weak IBOutlet UITextField *email;
    __weak IBOutlet UIToolbar *toolBar;
    NSString*stateString;
    __weak IBOutlet UIImageView *borderImageView;
    __weak IBOutlet UILabel *lblMsg;
}

@property (strong,nonatomic)NSString *strMessage;
@property (strong,nonatomic)NSString *strClientJournalist;
- (IBAction)doneToolBar:(id)sender;
- (IBAction)cancelToolBar:(id)sender;
- (IBAction)submitButtonPressed:(id)sender;
- (IBAction)popView:(id)sender;
@end
