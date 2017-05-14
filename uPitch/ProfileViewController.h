//
//  ProfileViewController.h
//  uPitch
//
//  Created by Puneet Rao on 10/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"
#import "ProfileCellTableViewCell.h"
#import "AddUserProfileViewController.h"
@interface ProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,updateTable>
{
     LIALinkedInHttpClient *_client;
    __weak IBOutlet UIView *importLinkedInView;
    __weak IBOutlet UIView *topView;
    __weak IBOutlet UIButton *reportButton;
    __weak IBOutlet UIToolbar *toolBar;
    __weak IBOutlet UITextView *reasinTextView;
    __weak IBOutlet UIView *reasonView;
    __weak IBOutlet UIImageView *leftBackIcon;
    __weak IBOutlet UIImageView *leftMenuIcon;
    __weak IBOutlet UILabel *userComapnyPosition;
    __weak IBOutlet UILabel *userCompanyName;
    __weak IBOutlet UILabel *userName;
     AppDelegate*appdelegateInstance;
    __weak IBOutlet UIImageView *userImageView;
    __weak IBOutlet UITableView *tableVw;
    __weak IBOutlet UILabel *header;
    NSMutableArray *mainArray,*titleHeaderArray;
    int indexCounter;
    BOOL setFrameBool;
    NSInteger sharedConnectionCount;
    __weak IBOutlet UIView *popupLinkedInView;
    __weak IBOutlet UIButton *backButton;
    BOOL educationBool,experienceBool;
    __weak IBOutlet UIButton *saveButton;
    BOOL actionSheetOpenBool;
    UIActionSheet*actionSheet1;
    ProfileCellTableViewCell *cellObj;
     UIImage *imageUser ;
    NSString *holdFirstname,*holdlLastName,*holdComanayName,*holdPosition;
    UIImage *holdImage;
    NSString*userFirstNameString,*userLastNameString,*companyNameString,*designationNameString,*userImageUrl;
    __weak IBOutlet UIButton *logoutButton;
    __weak IBOutlet UILabel *lblReason;
    
}
 @property NSData *dToken;
- (IBAction)chatButtonPressed:(id)sender;
- (IBAction)closeReportView:(id)sender;
- (IBAction)doneToolBar:(id)sender;
- (IBAction)closeLinkedInView:(id)sender;
- (IBAction)uploadUserPhoto:(id)sender;
- (IBAction)importLinkedButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)logoutAction:(id)sender;

- (IBAction)saveReportReason:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)reportUser:(id)sender;
@property(nonatomic,strong) NSString*userIDShowProfile;
- (IBAction)cancelToolBar:(id)sender;
@property(nonatomic,strong) NSString*comeFromSring;

@property(nonatomic,strong) NSString *comeTag;
@property(nonatomic,strong) NSString *statusLogin;


@end
