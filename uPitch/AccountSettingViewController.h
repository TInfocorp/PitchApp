

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Utils.h"

@interface AccountSettingViewController : UIViewController
{
    IBOutlet UIScrollView *scrlVw;
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtNewEmail;
    AppDelegate*appdelegateInstance;
    IBOutlet UIButton *btnChangeEmail;
    __weak IBOutlet UIToolbar *toolBar;
    IBOutlet UITextField *txtOldPaswd;
    IBOutlet UITextField *txtNewPaswd;
    IBOutlet UITextField *txtConfrmNewPasw;
    IBOutlet UIButton *btnChangePaswd;
    IBOutlet UIButton *btnDelete;
    NSInteger contentHeight;
    IBOutlet UIButton *showHideButton;
    BOOL showPassowrdBool;

}
- (IBAction)showPassword:(id)sender;

- (IBAction)ChangeEmail:(id)sender;
- (IBAction)ChangePassword:(id)sender;
- (IBAction)DeleteAccount:(id)sender;
- (IBAction)Back:(id)sender;



@end
