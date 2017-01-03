//
//  JournalistsSetting_ViewController.h
//  uPitch
//
//  Created by Puneet Rao on 18/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface JournalistsSetting_ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate>{
     AppDelegate*appdelegateInstance;
    __weak IBOutlet UIButton *saveButton;
    __weak IBOutlet UILabel *numberOfCategoryLabel;
    __weak IBOutlet UISlider *slider;
    __weak IBOutlet UITextField *zipcodeTextField;
    __weak IBOutlet UIButton *localNationalButton;
    __weak IBOutlet UIScrollView *scrollVw;
    __weak IBOutlet UIView *buttonFaturesViewBottom;
    __weak IBOutlet UIView *mediaCoverageView;
    IBOutlet UIButton *btnSelectCat;
    __weak IBOutlet UIView *zipcodeTopView;
    __weak IBOutlet UIView *zipcodeView;
    __weak IBOutlet UIView *categorySuperView;
    __weak IBOutlet UIView *categoryView;
    __weak IBOutlet UILabel *sliderValue;
    __weak IBOutlet UIView *tableSuperView;
    __weak IBOutlet UITableView *tableVw;
    NSInteger buttonTag;
    NSMutableArray*categoryNameArray,*categoryIdArray;
    NSMutableArray*selectedCategoryNameArray,*selectedCategoryIdArray;
    NSInteger categoryCounter;
    NSInteger yAxis,xAxis,TablePosition;
    IBOutlet UIToolbar *toolBar;
    IBOutlet UIButton *btnDelete;
    __weak IBOutlet UIButton *logoutButton;
    NSString*switchString;
    __weak IBOutlet UISwitch *notificationSwitch;
    __weak IBOutlet UIView *vwNotificationSetting;
    NSString *strMessageSwitch;
    IBOutlet UISwitch *swithcMessageNotification;
    //For Contact Support
    __weak IBOutlet UIView *contactView;
    __weak IBOutlet UIImageView *emailImageView;
    __weak IBOutlet UITextField *emailTextField;
    __weak IBOutlet UIImageView *textViewImageView;
    __weak IBOutlet UITextView *messageTextView;
    __weak IBOutlet UILabel *messageLabel;
   __weak IBOutlet UIButton *submitButton;
    

    __weak IBOutlet UIImageView *imgCount;
    __weak IBOutlet UILabel *lblCount;
    __weak IBOutlet UIButton *btnCount;
}

- (IBAction)AccountSettingPressed:(id)sender;
- (IBAction)stateMessageChanged:(id)sender;

- (IBAction)chatIconPressed:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)localNatiotnalButtonPressed:(id)sender;
- (IBAction)resignTableView:(id)sender;
- (IBAction)logoutAction:(id)sender;
- (IBAction)btnDeleteAccount:(id)sender;
- (IBAction)submitAction:(id)sender;
- (IBAction)help:(id)sender;
- (IBAction)privacyTerms:(id)sender;
- (IBAction)rateUs:(id)sender;

@end
