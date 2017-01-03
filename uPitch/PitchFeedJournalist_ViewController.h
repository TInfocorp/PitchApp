//
//  PitchFeedJournalist_ViewController.h
//  uPitch
//
//  Created by Puneet Rao on 19/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "AppDelegate.h"
@interface PitchFeedJournalist_ViewController : UIViewController<UIGestureRecognizerDelegate,UINavigationControllerDelegate>
{
    __weak IBOutlet UILabel *messageLabel;
    __weak IBOutlet UIButton *acceptButton;
    __weak IBOutlet UIButton *detailButton;
    __weak IBOutlet UIButton *refreshButton;
    __weak IBOutlet UIButton *decilneButton;
    __weak IBOutlet UIImageView *fullImageView;
    __weak IBOutlet UILabel *descLabel;
     AppDelegate*appdelegateInstance;
    __weak IBOutlet UIView *bottomViewOfFullView;
    __weak IBOutlet UIView *fullView;
    __weak IBOutlet UIView *semiView;
    NSMutableArray*mainArray;
    int apiCounter;
    int pageNumber;
    int yCord;
    NSInteger declineOrAcceptButtonPressedInt;
    NSString*pitchIdToBeRemove;
    NSString *acceptDeclineString;
    int viewRemoverCounter;
}
- (IBAction)test:(id)sender;
- (IBAction)forward:(id)sender;
@end
