//
//  RegisterPage1.h
//  uPitch
//
//  Created by Puneet Rao on 19/05/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface RegisterPage1 : UIViewController
{
    AppDelegate*appdelegateInstance;
    __weak IBOutlet UIToolbar *toolBar;
    __weak IBOutlet UITextField *confirmpasswordTextField;
    __weak IBOutlet UITextField *passwordTextField;
    __weak IBOutlet UITextField *emailTextField;
}
@property(nonatomic,strong)NSString*userTypeString;
- (IBAction)doneToolBar:(id)sender;
- (IBAction)cancelToolBar:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)popView:(id)sender;
@end
