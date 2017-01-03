//
//  manageJournalistViewController.h
//  uPitch
//
//  Created by Puneet Rao on 18/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface manageJournalistViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    __weak IBOutlet UIButton *chatIconButton;
    __weak IBOutlet UILabel *headerLabel;
    __weak IBOutlet UILabel *headertext;
    __weak IBOutlet UIImageView *lineImageViewChat;
    __weak IBOutlet UIImageView *lineImageViewMatches;
    __weak IBOutlet UILabel *messageLabel;
     AppDelegate*appdelegateInstance;
    __weak IBOutlet UITableView *tableVw;
    NSMutableArray*mainArray;
     NSMutableArray*mainArrayChat;
//    NSString*matchesChatString;
    NSMutableArray*unreadMessageCount;
    NSString*userLoginImagePath;
     NSDate*date1,*date2;
    BOOL dateCompareBool;
     NSInteger deletedIndex;
    BOOL tableReloadBool;
    __weak IBOutlet UIButton *btnCount;
    
    __weak IBOutlet UIImageView *imgCount;
    __weak IBOutlet UILabel *lblCount;
}
@property (weak, nonatomic) IBOutlet UIButton *btnMatch;
@property (weak, nonatomic) IBOutlet UIButton *btnChat;
@property(strong,nonatomic) NSString *matchesChatString;
-(void)runApi;
@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *contactDB;
- (IBAction)cahtButtonPressed:(id)sender;
- (IBAction)matchesButtonPressed:(id)sender;
- (IBAction)topchatIconPressed:(id)sender;
@end
