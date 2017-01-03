//
//  RegisterPage2.h
//  uPitch
//
//  Created by Puneet Rao on 19/05/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface RegisterPage2 : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    AppDelegate*appdelegateInstance;
   UIActionSheet*actionSheet;
    __weak IBOutlet UITextField *companyName;
    __weak IBOutlet UITextField *designation;
    __weak IBOutlet UITextField *lastName;
    __weak IBOutlet UITextField *firstName;
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIImageView *userImageView;
    __weak IBOutlet UIToolbar *toolBar;
    BOOL actionSheetOpenBool;
}
@property(nonatomic,strong)NSString*userTypeString;
@property(nonatomic,strong)NSString*emailString;

- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)doneToolBar:(id)sender;
- (IBAction)cancelToolBar:(id)sender;
- (IBAction)userImageTapped:(id)sender;
- (IBAction)popView:(id)sender;
@end
