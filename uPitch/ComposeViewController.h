//
//  ComposeViewController.h
//  uPitch
//
//  Created by Puneet Rao on 10/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Utils.h"
#import "HFImageEditorViewController.h"
#import "ImageCropView.h"

//#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
//#define IS_IPHONE_6      (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
//#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)

@class GKImagePicker;
@interface ComposeViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,SWRevealViewControllerDelegate,UIGestureRecognizerDelegate,ImageProtocol,ImageCropViewControllerDelegate>
{
    __weak IBOutlet UIImageView *blackTransparentVw;
    BOOL tableViewOpenBool;
    __weak IBOutlet UIView *expiryView;
    __weak IBOutlet UIView *selectedCategoryVw;
    __weak IBOutlet UIButton *submitButton;
    __weak IBOutlet UILabel *headerTitle;
    __weak IBOutlet UIButton *selectCategoryButton;
    __weak IBOutlet UIView *testView;
    __weak IBOutlet UIToolbar *toolBar;
    __weak IBOutlet UIView *bottomViewOfMediaCoverage;
    __weak IBOutlet UIView *tableSuperView;
    __weak IBOutlet UIToolbar *toolbarTwitterLike;
    IBOutlet UIBarButtonItem *toolBarDone;
    __weak IBOutlet UIView *categoryView;
    AppDelegate*appdelegateInstance;
    NSMutableArray*categoryMainArray,*selectedCategoryArray,*expiryDaysArray,*selectedCategoryIdArray,*socialnetworkLinkArray;
    __weak IBOutlet UITableView *tableVw;
    
    __weak IBOutlet UIButton *expiresButton;
    __weak IBOutlet UIView *expiresinView;
    __weak IBOutlet UIView *socialMediaView;
    __weak IBOutlet UIView *mediaCoverageView;
    __weak IBOutlet UIButton *addImageButton5;
    __weak IBOutlet UIButton *addImageButton4;
    __weak IBOutlet UIButton *addImageButton3;
    __weak IBOutlet UIButton *addImageButton2;
    __weak IBOutlet UIButton *addImageButton1;
    __weak IBOutlet UILabel *pitchDetailLabel;
    __weak IBOutlet UILabel *pitchSummaryLabel;
    __weak IBOutlet UIScrollView *scrollVw;
    __weak IBOutlet UITextField *pitchTitle;
    __weak IBOutlet UITextView *pitchSummary;
    __weak IBOutlet UITextView *pitchDetailIno;
    NSInteger intvalueTwitter;
//    UIAlertView *alertText;
    BOOL aletShow;
    UIActionSheet *actionSheet1;
    BOOL actionSheetOpenBool;
    
    __weak IBOutlet UIImageView *borderImageVw;
    __weak IBOutlet UITextField *zipcode;
    __weak IBOutlet UIView *categoryBottomSubView;
    NSInteger addimageInt;
    NSInteger tagOfTableToShow;
    NSInteger maxExpireDays;
    NSInteger imageCounter;
    NSInteger tagOfSocialNetwork;
    NSInteger localNationalInt;
    BOOL CoverImageBool;
    __weak IBOutlet UIButton *localNationalButton;
    BOOL localNationalBool;
    __weak IBOutlet UIView *socialNetworkView;
    __weak IBOutlet UILabel *socialNetworkLabelInView;
    __weak IBOutlet UITextField *socialNetworkTextField;
    __weak IBOutlet UITextField *websiteUrlTextField;
   IBOutlet  UIImageView*buttonImageTemp1 ;
   IBOutlet  UIImageView*buttonImageTemp2 ;
   IBOutlet  UIImageView*buttonImageTemp3 ;
   IBOutlet  UIImageView*buttonImageTemp4 ;
   IBOutlet  UIImageView*buttonImageTemp5 ;
    UIPopoverController *popoverIpad;
    __weak IBOutlet UITextView *txtViewTwitter;
    __weak IBOutlet UILabel *lblTwitterView;
    NSString*pitchCreatedDate;
    NSData *data_first;
    UIImage *imgDummy;
    UIImage *imgToLoad;
    NSData *data2_Second;
    
    NSTimer* _timer;
    NSArray *arrLocal;
    __weak IBOutlet UIView *viewTwitterLike;
    __weak IBOutlet UIView *textBoxView;
    __weak IBOutlet UILabel *titleLabelForPopUpText;
    __weak IBOutlet UITextField *popupTextField;
    __weak IBOutlet UITextView *popupTextView;
    __weak IBOutlet UILabel *remainingLabel;
    __weak IBOutlet UIBarButtonItem *RemainCountlbl;
     int   maxlimit;
    NSString*timeZoneString;
    __weak IBOutlet UIBarButtonItem *toolbarCance;
    NSString *strUploadingImage;
    
    __weak IBOutlet UIImageView *imgCount;
    __weak IBOutlet UILabel *lblCount;
    
    
    //New Image Picker
    
    // UIImage* image1;
    
}
@property (nonatomic, strong) ImageCropView* imageCropView;
//-(void)dismissKeyboard;
- (IBAction)hidepopUpTextView:(id)sender;
@property (nonatomic, strong) NSString *EditNewString;
@property (nonatomic, strong) NSString *pitchIdString;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) NSString *pitchActiveExpireStatusString;
- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)addimageButtonPressed:(id)sender;
- (IBAction)textBoxButtonPressed:(id)sender;
- (IBAction)selectCategoryAction:(id)sender;
- (IBAction)resignTableVw:(id)sender;
- (IBAction)resignAllKeys:(id)sender;

- (IBAction)submit:(id)sender;
- (IBAction)crossScocialView:(id)sender;
- (IBAction)saveSocialLink:(id)sender;

- (IBAction)popToView:(id)sender;
- (IBAction)btnDeleteTxtView:(id)sender;
- (IBAction)btnTwitterDone:(id)sender;

@end
