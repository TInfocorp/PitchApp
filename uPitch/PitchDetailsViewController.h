//
//  PitchDetailsViewController.h
//  uPitch
//
//  Created by Ashwani on 30/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface PitchDetailsViewController : UIViewController<UIScrollViewDelegate,UIPageViewControllerDataSource,UIPageViewControllerDelegate,UITextViewDelegate>

{
    IBOutlet UIScrollView *scrlView;
    IBOutlet UIView *viewSlideShow;
    IBOutlet UIView *viewCatagories;
    IBOutlet UIView *viewPitchDetails;
    IBOutlet UIView *viewMediaCovarage;
    IBOutlet UIView *viewUrl;
    IBOutlet UIView *viewSocialShare;
    UIActivityIndicatorView *indicator;
    IBOutlet UIButton *leftArrow;
    IBOutlet UIButton *fbBtn;
    IBOutlet UIButton *twitterBtn;
    IBOutlet UIButton *rightArrow;
    IBOutlet UIButton *linkdinBtn;
    IBOutlet UIButton *instagramBtn;
    SWRevealViewController *revealController;
    IBOutlet UIView *viewSharingSub;
    NSString*strMatch;
    NSString*strShowError;
    IBOutlet UIView *viewIndicator;
    IBOutlet UIView *viewSlideContainor;
    IBOutlet UIImageView *imgSlideShow;
    IBOutlet UILabel *lblHeader;
    IBOutlet UIScrollView *scrlHorizontal;
    IBOutlet UIPageControl *pageControlOutlet;
    IBOutlet UITextView *txtViewDetails;
    IBOutlet UILabel *lblMediaCovrage;
    IBOutlet UIView *viewCovrageDetails;
    AppDelegate*appdelegateInstance;
    IBOutlet UILabel *lblUrl;
    NSInteger imageCount;
    NSMutableArray * staticImages;
    int isProceed;
    
    IBOutlet UIButton *btnTopChat;
     NSString *strPitchId;
    IBOutlet UILabel *lblMaximumRange;
    NSMutableArray *socialnetworkLinkArray;
    NSMutableArray *arrSelectedCategoryId;
    NSMutableArray *arrSelectedCategory;
    __weak IBOutlet UIButton *notInterestedButton;
    __weak IBOutlet UIButton *interestedButton;
    NSString*acceptDeclineString;
    IBOutlet UIButton *LeftBtn;
    IBOutlet UIButton *rightBtn;
    
    __weak IBOutlet UIImageView *imgCount;
    __weak IBOutlet UILabel *lblCount;

}
- (IBAction)popView:(id)sender;
- (IBAction)bottomButtonPressed:(id)sender;
@property(nonatomic,strong)  NSString *strPitchId;
@property(nonatomic,strong)  NSString *clientJournalistString;
@property(nonatomic,strong)  NSString *strHideTopIcons;
- (IBAction)btnFbShare:(id)sender;
- (IBAction)btnTwitterShare:(id)sender;
- (IBAction)BTNLinkdinShare:(id)sender;

- (IBAction)btnLeft:(id)sender;
- (IBAction)btnRight:(id)sender;
- (IBAction)btnInstagramShare:(id)sender;

- (IBAction)btnUrlShare:(id)sender;

@end
