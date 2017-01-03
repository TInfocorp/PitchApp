//
//  AddUserProfileViewController.h
//  uPitch
//
//  Created by Puneet Rao on 20/05/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@protocol updateTable <NSObject>
-(void)updateTableData;
@end
@interface AddUserProfileViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate,UITextViewDelegate>
{
    __weak IBOutlet UITextField *todate;
    __weak IBOutlet UIToolbar *toolBar;
     AppDelegate*appdelegateInstance;
    __weak IBOutlet UITextField *collegeName;
    __weak IBOutlet UITextField *educationTime;
    __weak IBOutlet UITextField *degreeName;
    
    __weak IBOutlet UIPickerView *monthYearPicker;
    __weak IBOutlet UIView *datepickerView;
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UITextField *industryName;
    __weak IBOutlet UITextView *fieldName;
    __weak IBOutlet UITextField *experienceTime;
    __weak IBOutlet UITextField *companyName;
    __weak IBOutlet UILabel *descriptionLabel;
    __weak IBOutlet UIView *educationView;
    __weak IBOutlet UIView *experienceView;
    __weak IBOutlet UIButton *deleteButton;
    __weak IBOutlet UILabel *headerTitle;
    NSMutableArray*monthArray,*yearArray;
    NSString*monthString,*yearString;
    NSInteger fromToDateInt;
    __weak IBOutlet UIImageView *checkUncheckImageView;
    __weak IBOutlet UIButton *toDateButton;
    __weak IBOutlet UITextField *toDateEdu;
    NSDate * fromDateToCompare ,*toDateToCompare;
    __weak IBOutlet UISwitch *switchOnOff;
}
- (IBAction)unchecCheckAction:(id)sender;
- (IBAction)openDatePicker:(id)sender;
- (IBAction)popView:(id)sender;
- (IBAction)saveDetail:(id)sender;
- (IBAction)deleteButtonPressed:(id)sender;
- (IBAction)cancelToolbar:(id)sender;
- (IBAction)doneToolBar:(id)sender;

@property(strong)  id<updateTable> delegate;

@property(nonatomic,strong)NSString*headerString;
@property(nonatomic,strong)NSString*editString;
//For delete tag
@property(nonatomic,strong)NSString*strUserTag;

@property(nonatomic,strong)NSString*degreeString;
@property(nonatomic,strong)NSString*collegeString;
@property(nonatomic,strong)NSString*fromDateEduString;
@property(nonatomic,strong)NSString*toDateEduString;

@property(nonatomic,strong)NSString*professionalString;
@property(nonatomic,strong)NSString*companyString;
@property(nonatomic,strong)NSString*fromDateExString;
@property(nonatomic,strong)NSString*toDateExString;
@property(nonatomic,strong)NSString*descriptionString;

@property(nonatomic,strong)NSString*idString;
@end
