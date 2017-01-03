//
//  AnalyticsViewController.h
//  uPitch
//
//  Created by Puneet Rao on 23/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCD3.h"
#import "AppDelegate.h"
@interface AnalyticsViewController : UIViewController
{
    __weak IBOutlet UILabel *messagelabel;
     int counter,counterinterestView  ;
     AppDelegate*appdelegateInstance;
    __weak IBOutlet UIImageView *liveArrowImageView;
    __weak IBOutlet UIImageView *expiredArrowImageView;
    __weak IBOutlet UIScrollView *scrollView;
    NSMutableArray *titleArray,*openPitchArray,*acceptDeclineArray;
    NSString*tabString;
    NSInteger clickedIndex;
    __weak IBOutlet UIImageView *imgCount;
    __weak IBOutlet UILabel *lblCount;
}
- (IBAction)bottomButtonPressed:(id)sender;
@end
