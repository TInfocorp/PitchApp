//
//  ViewController.h
//  uPitch
//
//  Created by Puneet Rao on 04/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"
@interface ViewController : UIViewController<UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    __weak IBOutlet UIImageView *passwordImageView;
    __weak IBOutlet UIImageView *emailImageView;
    __weak IBOutlet UIButton *showHideButton;
    __weak IBOutlet UIImageView *logoImageView;
    
    __weak IBOutlet UIButton *loginCreateAccountButton;
    __weak IBOutlet UIButton *linkedinButtonJournalist;
    __weak IBOutlet UIButton *linkedinButtonCreator;
     AppDelegate*appdelegateInstance;
     LIALinkedInHttpClient *_client;
     NSString*userType;
    
    __weak IBOutlet UILabel *lblClient;
    __weak IBOutlet UILabel *lblJournalist;
    NSString* clientJournalsitsString;
    __weak IBOutlet UIToolbar *toolBar;
    __weak IBOutlet UITextField *passwordTextField;
    __weak IBOutlet UITextField *emailTextField;
    __weak IBOutlet UIImageView *clientCheckImageView;
    __weak IBOutlet UIImageView *journalistCheckImageView;
    __weak IBOutlet UIView *tandCView;
    __weak IBOutlet UIView *forgotPassView;
    __weak IBOutlet UIScrollView *scrollView;
    
    __weak IBOutlet UIImageView *arrowImageViewLogin;
    __weak IBOutlet UIButton *btnLogin;
    __weak IBOutlet UIButton *btnSignUp;
    __weak IBOutlet UIImageView *arrowImageViewSignUp;
    BOOL showPassowrdBool;
    
    // 23/01 highlight
    sqlite3 *contactDB;
    NSString *strMsgPub;
    NSString  *databasePath;
    NSMutableArray *chatDBId;
    NSMutableArray *idArray;
    NSMutableArray *arrPitchId;

    
}
- (IBAction)loginToExistingAccount:(id)sender;
- (IBAction)linkedInButtonPressed:(id)sender;

- (IBAction)userTypeButtonPressed:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)forgotPasswordClicked:(id)sender;
- (IBAction)loginSignUpPressed:(id)sender;
- (IBAction)TandCpressed:(id)sender;
- (IBAction)showPassword:(id)sender;

@end

