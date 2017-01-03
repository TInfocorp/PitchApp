//
//  WelComeVC.h
//  Happz App
//
//  Created by roza on 23/12/14.
//  Copyright (c) 2014 INX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelComeVC : UIViewController <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *btnSwipe;
@property (strong, nonatomic) IBOutlet UIButton *btnSkip;
@property (nonatomic) NSString *userType;
@end
