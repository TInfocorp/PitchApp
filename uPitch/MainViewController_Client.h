//
//  MainViewController_Client.h
//  uPitch
//
//  Created by Puneet Rao on 10/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface MainViewController_Client : UIViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,SWRevealViewControllerDelegate,UIImagePickerControllerDelegate>
{
    __weak IBOutlet UIButton *composeButton;
    __weak IBOutlet UILabel *unReadMessage;
    __weak IBOutlet UILabel *messageLabel;
    AppDelegate*appdelegateInstance;
    __weak IBOutlet UITableView *tableVw;
    __weak IBOutlet UIButton *matchesButton;
    NSMutableArray*mainArray;
    int counter;
    NSInteger deletedIndex;
    NSString*userAccountType;
    
    __weak IBOutlet UIImageView *imgCount;
    __weak IBOutlet UILabel *lblCount;
}
- (IBAction)chatIconPressed:(id)sender;
- (IBAction)pitchesButtonPressed:(id)sender;
- (IBAction)matchesButtonAction:(id)sender;
@end
