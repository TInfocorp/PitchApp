//
//  viewPitchesViewController_Journalists.h
//  uPitch
//
//  Created by Puneet Rao on 18/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface viewPitchesViewController_Journalists : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UIButton *chatIconButton;
    __weak IBOutlet UILabel *headerLabel;
    __weak IBOutlet UILabel *messageLabel;
    AppDelegate*appdelegateInstance;
    __weak IBOutlet UITableView *tableVw;
    NSMutableArray*mainArray;
    NSMutableArray*mainArrayChat;
    NSInteger deletedIndex;
     NSString*userLoginImagePath;
    
    __weak IBOutlet UIButton *btnCount;
    __weak IBOutlet UIImageView *lineImageViewChat;
    __weak IBOutlet UIImageView *lineImageViewMatches;
  //  NSString*matchesChatString;

     NSMutableArray*unreadMessageCount;
    NSDate*date1,*date2;
    BOOL dateCompareBool;
    BOOL tableReloadBool;
    __weak IBOutlet UIImageView *imgCount;
    __weak IBOutlet UILabel *lblCount;

}
@property (weak, nonatomic) IBOutlet UIButton *btnLikedPitches;
@property (weak, nonatomic) IBOutlet UIButton *btnChat;
@property (strong, nonatomic) NSString *databasePath;
@property (strong, nonatomic) NSString *matchesChatString;
@property (nonatomic) sqlite3 *contactDB;
- (IBAction)chatButtonPressed:(id)sender;
- (IBAction)matchesButtonPressed:(id)sender;
- (IBAction)topChatIconPressed:(id)sender;
-(void)runApi;
@end
