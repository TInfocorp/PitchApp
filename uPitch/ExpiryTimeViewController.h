//
//  ExpiryTimeViewController.h
//  uPitch
//
//  Created by Puneet Rao on 03/04/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ExpiryTimeViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>{
    
    __weak IBOutlet UIButton *sendButton;
    
    __weak IBOutlet UIView *bottomView;

    __weak IBOutlet UIButton *customButton;
    __weak IBOutlet UITextView *messageTextView;
     AppDelegate*appdelegateInstance;
    __weak IBOutlet UILabel *position;
    __weak IBOutlet UILabel *companyName;
    __weak IBOutlet UIImageView *userImageView;
    __weak IBOutlet UIScrollView *scrollvw;
    __weak IBOutlet UIView *expiryView;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *summaryLabel;
    __weak IBOutlet UIView *pitchSubView;
    __weak IBOutlet UIView *journalistView;
    __weak IBOutlet UIView *pitchView;
    __weak IBOutlet UIImageView *borderImageView;
    __weak IBOutlet UILabel *headerLabel;
    __weak IBOutlet UITextField *messageText;
    __weak IBOutlet UILabel *daylabel;
    __weak IBOutlet UILabel *hoursLabel;
    __weak IBOutlet UILabel *minutesLabel;
    __weak IBOutlet UILabel *secondsLabel;
    NSTimer *timer;
    NSInteger secondsLeft;
    int hours, minutes, seconds,days;
    int contentSizeHeight;
   // __weak IBOutlet UIButton *sendButton;
    NSString*deleteString,*StatusString;
}
-(void)didConnectedToXmpp;

- (IBAction)customButtonPressed:(id)sender;
-(void)updateCounter:(NSTimer *)theTimer;
-(void)countdownTimer;
@property(nonatomic,strong) NSString*pitchIdString;
@property(nonatomic,strong) NSString*urlString;
@property(nonatomic,strong) NSString*summary;
@property(nonatomic,strong) NSString*titleString;
@property(nonatomic,strong) NSString*compantNameString;
@property(nonatomic,strong) NSString*positionString;
@property(nonatomic,strong) NSString*pitchJournalistsString;
@property(nonatomic,strong) NSString*userIdString;
@property(nonatomic,strong) NSString*pitchSelectorIdString;

@property(nonatomic,strong) NSString *strXmppID;
@property(nonatomic,strong) NSString *oppendXmppID;
@property(nonatomic,strong) NSString *pitchIdForSetTimer;

@property(nonatomic,strong)IBOutlet UIImageView*pitchImageView;
- (IBAction)popview:(id)sender;
- (IBAction)sendMessage:(id)sender;
- (IBAction)infoButtonPressed:(id)sender;
-(void)sendMessageXMPP;
- (void)sendChat;

@end
