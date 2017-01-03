//
// ChoosePersonViewController.h
//
// Copyright (c) 2014 to present, Brian Gesiak @modocache
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import "ChoosePersonView.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "Utils.h"

//#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
//#define IS_IPHONE_6      (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
//#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)

@interface ChoosePersonViewController : UIViewController <MDCSwipeToChooseDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    float old_scale;
    UIButton *buttonlike;
    UIButton *buttonDope;
    
    NSTimer *myTimer;
    NSDate* last_time;
    UITextView* label;
    IBOutlet UIView *viewMain;
    IBOutlet UIView *viewTinder;
    NSInteger viewRemoverCounter;
    AppDelegate*appdelegateInstance;
    NSMutableArray*mainArray;
    NSMutableArray*testArray;
    __weak IBOutlet UILabel *messageLabel;
    int apiCounter,pageNumber;
    NSMutableArray*viewArray;
    NSInteger currentValue;
    NSInteger currentacceptDelete;
    NSInteger maximumValue;
    NSInteger declineOrAcceptButtonPressedInt;
    __weak IBOutlet UIButton *btnDideMenu;
    //__weak IBOutlet UITextView *lblReason;
    __weak IBOutlet UILabel *lblReason;
    NSString*pitchIdToBeRemove;
    NSString *acceptDeclineString;
    
    CGFloat pointY;
    UIImageView *imgViewTinder;
    UIImageView *imgViewTinderDope;
    BOOL landscape;
    BOOL currentAcceptStatus;
    BOOL makeFrontView;
    BOOL ishud;
    BOOL undoOnce;
    float thesholdRatio;
    float thesholdRatio1;
    BOOL oneTimeUndo;
    UILabel *errorMessageLabel;
    __weak IBOutlet UIView*reasonView;
    __weak IBOutlet UITextView*reasinTextView;
    
    __weak IBOutlet UIImageView *imgCount;
    __weak IBOutlet UILabel *lblCount;

}
- (IBAction)hidereasonView:(id)sender;
- (IBAction)saveReportReason:(id)sender ;
-(void) refreshView;
-(void)crossAcceptPressed : (id)sender;
-(void)undoAction :(id)sender;
-(void)detailButtonPressed : (id)sender;
-(void)showPitches;

@property (nonatomic, strong) MDCSwipeToChooseViewOptions *options;
@property (nonatomic, strong) Person *currentPerson;
@property (nonatomic, strong) ChoosePersonView *frontCardView;
@property (nonatomic, strong) ChoosePersonView *backCardView;
@property (nonatomic, strong) ChoosePersonView *undoCardView;

@end
