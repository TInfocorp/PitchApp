//
//  TandCViewController.h
//  uPitch
//
//  Created by Puneet Rao on 28/05/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TandCViewController : UIViewController
{
    
    __weak IBOutlet UIWebView *webView;
    __weak IBOutlet UILabel *lblTitle;
}

@property (strong,nonatomic)NSString *strComeFrom;
- (IBAction)popView:(id)sender;
@end
