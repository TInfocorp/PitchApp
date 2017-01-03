//
//  LoginViewController.h
//  uPitch
//
//  Created by Puneet Rao on 19/05/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface LoginViewController : UIViewController <UITextFieldDelegate>
{
    __weak IBOutlet UIButton *journalists;
    __weak IBOutlet UIButton *pitchCreator;
    __weak IBOutlet UIToolbar *toolBar;
    __weak IBOutlet UITextField *passwordTextField;
    __weak IBOutlet UITextField *emailTextField;
    __weak IBOutlet UIView *textFieldView;
     AppDelegate*appdelegateInstance;
     NSString*userType;
}
@property(nonatomic,strong)NSString* clientJournalsitsString;
- (IBAction)userTypeButtonPressed:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)forgotPasswordClicked:(id)sender;
- (IBAction)popview:(id)sender;
@end
