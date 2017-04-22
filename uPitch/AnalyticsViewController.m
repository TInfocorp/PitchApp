//
//  AnalyticsViewController.m
//  uPitch
//
//  Created by Puneet Rao on 23/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import "AnalyticsViewController.h"
#import "SWRevealViewController.h"
#import "LxReqRespManager.h"
#import "UIImageView+WebCache.h"
#import "manageJournalistViewController.h"
#import "constant.h"
@interface AnalyticsViewController ()

@end

@implementation AnalyticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tabString =@"1";
    clickedIndex = -1;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PubNubNotification:) name:@"pubnubnot" object:nil];
}
- (IBAction)chatIconPressed:(id)sender {

    SWRevealViewController *revealController = self.revealViewController;
    manageJournalistViewController*obj;
    obj=[self.storyboard instantiateViewControllerWithIdentifier:@"manageJournalists"];
    
    
 

//    long chat = [[USERDEFAULTS valueForKey:@"chatcount"]integerValue];
//    long match = [[USERDEFAULTS valueForKey:@"matchcount"] integerValue];
//    
//    if (chat > 0  && match == 0)
//    {
//        obj.matchesChatString = @"2";
//        
//    }
//    else if ((chat < 0  && match > 0) || (chat < 0 && match < 0))
//    {
//        obj.matchesChatString = @"1";
//        
//    }
//    else if (chat > 0 && match > 0)
//    {
//        obj.matchesChatString = @"1";
//        
//    }
    obj.matchesChatString = @"1";
    long chat = [[USERDEFAULTS valueForKey:@"chatcount"]integerValue];
    long match = [[USERDEFAULTS valueForKey:@"matchcount"] integerValue];
    
    if (chat > 0  && match == 0)
    {
        obj.matchesChatString = @"2";
        
    }
    else if (chat == 0  && match > 0)
    {
        obj.matchesChatString = @"1";
        
    }
    else if (chat > 0 && match > 0)
    {
        obj.matchesChatString = @"1";
        
    }
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:obj];
    [revealController pushFrontViewController:navigationController animated:YES];
}
-(void)runApi
{
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService=[[NSString alloc]initWithFormat:@"%@analytic_report",AppURL];
    NSLog(@"%@",strWebService);
    NSDictionary *dictParams;
    
    
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"userid"]],@"user_id",tabString,@"tab",
                nil];
    NSLog(@"%@",dictParams);
    
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
             [appdelegateInstance hideHUD];
             NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             titleArray = [[NSMutableArray alloc]init];
              openPitchArray = [[NSMutableArray alloc]init];
              acceptDeclineArray = [[NSMutableArray alloc]init];
             if ([str isEqualToString:@"0"] )
             {
                 for (int h=0; h<[[[response valueForKey:@"data"] valueForKey:@"aaa"] count]; h++) {
                     [titleArray addObject:[NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"aaa"] valueForKey:@"title"] objectAtIndex:h]]];
                      [openPitchArray addObject:[NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"aaa"] valueForKey:@"ropen"] objectAtIndex:h]]];
                      [acceptDeclineArray addObject:[NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"aaa"] valueForKey:@"rinterest"] objectAtIndex:h]]];
                 }
                 if (titleArray.count==0) {
                     messagelabel.hidden = NO;
                     if ([tabString isEqualToString:@"1"]) {
                         messagelabel.text = @"No live pitch found";
                     }
                     else{
                         messagelabel.text = @"No expired pitch found";
                     }
                 }
                 else{
                      messagelabel.hidden = YES;
                 }
                 if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                     [USERDEFAULTS setObject:@"130" forKey:@"outerRadius"];
                     [USERDEFAULTS setObject:@"100" forKey:@"innerRadius"];
                     [self makeView_iPad];
                 }
                 else{
                     [USERDEFAULTS setObject:@"100" forKey:@"outerRadius"];
                     [USERDEFAULTS setObject:@"80" forKey:@"innerRadius"];
                 [self makeView];
                 }
                 [USERDEFAULTS synchronize];
              }
             else if ([str isEqualToString:@"1"] )
             {
                  messagelabel.hidden = NO;
                 if ([tabString isEqualToString:@"1"]) {
                      messagelabel.text = @"No live pitch found";
                 }
                 else{
                      messagelabel.text = @"No expired pitch found";
                 }
             }
             else if ([str isEqualToString:@"10"] )
             {
                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 alert.tag = 1234;
                 [alert show];
             }
             else if ([response valueForKey:@"Failure"] )
             {

                 [constant alertViewWithMessage:[response valueForKey:@"Failure"]withView:self];
             }
         }
         else
         {
             [appdelegateInstance hideHUD];
             [constant AlertMessageWithString:@"Connectivity levels low. Please try again." andWithView:self.view];

//             [constant alertViewWithMessage:@"Connectivity levels low. Please try again."withView:self];
             NSLog(@"Error returned:%@",[error localizedDescription]);
         }
     }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1234) {
        AppDelegate *appd= (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appd LogoutFromApp:self];
    }
}

#pragma mark make View Method
-(void)makeView_iPad
{
    
    int y= 10;
    for (int g=0; g<titleArray.count; g++) {
        
        UIView*mainView =[[UIView alloc]initWithFrame:CGRectMake(-2, y, self.view.frame.size.width+4, 80)];
        mainView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        mainView.layer.borderWidth =1.5f;
        mainView.tag = 1000+g;
        mainView.backgroundColor = [UIColor whiteColor];
        mainView.clipsToBounds =YES;
        [scrollView addSubview:mainView];
        
        UIView*topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainView.frame.size.width, 80)];
        topView.tag = 3000+g;
        topView.backgroundColor = [UIColor clearColor];
        [mainView addSubview:topView];
        
        UILabel*titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, topView.frame.size.width-20, 80)];
        titleLabel.text = [NSString stringWithFormat:@"%@",[titleArray objectAtIndex:g]];
        titleLabel.tag = 6000+g;
        titleLabel.numberOfLines = 0;
        titleLabel.font  = [UIFont fontWithName:@"Helvetica" size:30];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [topView addSubview:titleLabel];
        
        UIButton*customButton = [UIButton buttonWithType:UIButtonTypeCustom];
        customButton.tag = 2000+g;
        [customButton addTarget:self action:@selector(expandButtonPressed_ipad:) forControlEvents:UIControlEventTouchUpInside];
        customButton.frame = CGRectMake(0, 0, topView.frame.size.width, topView.frame.size.height);
        [topView addSubview:customButton];

                
        UIView*bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 81, mainView.frame.size.width, 470)];
        bottomView.tag = 4000+g;
        [mainView addSubview:bottomView];
        
        int x = self.view.frame.size.width-468;
        UIView*openPitchView = [[UIView alloc]initWithFrame:CGRectMake(x/2, 10, 468, 220)];
        openPitchView.tag = 7000+g;
        openPitchView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        openPitchView.layer.borderWidth = 1.0f;
        [bottomView addSubview:openPitchView];
        
        UILabel*openPitchLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 448, 45)];
        openPitchLabel.text = @"Opened Pitch";
        openPitchLabel.font  = [UIFont fontWithName:@"Helvetica-Bold" size:40];
        openPitchLabel.textColor = [UIColor colorWithRed:40.0f/255.0f green:180.0f/255.0f blue:220.0f/255.0f alpha:1];
        openPitchLabel.textAlignment = NSTextAlignmentCenter;
        [openPitchView addSubview:openPitchLabel];
        
        UIImageView*openPitchdivider=[[UIImageView alloc]initWithFrame:CGRectMake(90, 60, 288, 2)];
        openPitchdivider.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1];
        [openPitchView addSubview:openPitchdivider];
        
        OCDView *openPitchview = [[OCDView alloc] initWithFrame:CGRectMake(169, 80, 160, 160)];
        openPitchview.backgroundColor = [UIColor clearColor];
        
        [openPitchView addSubview:openPitchview];
        
        UILabel*percentageLabel = [[UILabel alloc]initWithFrame:CGRectMake(170, 125, 130, 40)];
        percentageLabel.text = [NSString stringWithFormat:@"%@",[openPitchArray objectAtIndex:g]];
//        percentageLabel.text = @"60%";
        percentageLabel.font  = [UIFont fontWithName:@"Helvetica-Bold" size:35];
        percentageLabel.textColor = [UIColor colorWithRed:40.0f/255.0f green:180.0f/255.0f blue:220.0f/255.0f alpha:1];
        percentageLabel.textAlignment = NSTextAlignmentCenter;
        [openPitchView addSubview:percentageLabel];
        
        NSString *interestValue = [NSString stringWithFormat:@"%@",[openPitchArray objectAtIndex:g] ];
        interestValue = [interestValue stringByReplacingOccurrencesOfString:@"%" withString:@""];
        NSInteger diffinterest = 100-[interestValue integerValue];
        NSString*diifStrinterest = [NSString stringWithFormat:@"%ld",(long)diffinterest];
        NSNumberFormatter *formatterinterest = [[NSNumberFormatter alloc] init];
        formatterinterest.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *value1 = [formatterinterest numberFromString:interestValue];
        NSNumber *value2 = [formatterinterest numberFromString:diifStrinterest];
        
        NSArray *openPitchData = @[ @{@"Browser": @"Chrome",             @"Percent": value1},
                                    @{@"Browser": @"Safari",             @"Percent":value2} ];
        
        OCDNodeFormatter *arcFormatter = [OCDNodeFormatter arcNodeFormatterWithInnerRadius:50
                                                                               outerRadius:65];
        OCDPieLayout *pieLayout = [OCDPieLayout layoutForDataArray:openPitchData usingKey:@"Percent"];
        pieLayout.startAngle = -M_PI_2;
        pieLayout.endAngle = (2 * M_PI) -M_PI_2;
        
        OCDSelection *arcs = [[openPitchview selectAllWithIdentifier:@"arcs"] setData:[pieLayout layoutData]
                                                                             usingKey:nil];
        [arcs setEnter:^(OCDNode *node) {
            [arcFormatter formatNode:node];
            if (counter==0 ) {
                [node setValue:(id)[UIColor colorWithRed:240.0f/255.0f green:140.0f/255.0f blue:50.0f/255.0f alpha:1].CGColor forAttributePath:@"fillColor"];
            }
            else{
                [node setValue:(id)[UIColor colorWithRed:208.0f/255.0f green:208.0f/255.0f blue:208.0f/255.0f alpha:1].CGColor forAttributePath:@"fillColor"];
            }
            [self setValue_openPitch];
            
                   
            [openPitchview appendNode:node withTransition:^(CAAnimationGroup *animationGroup, id data, NSUInteger index) {
                
            } completion:^(BOOL finished) {
                
            }];
        }];
        if (counter==2) {
            counter =0 ;
        }
        
        
        UIView*interestView = [[UIView alloc]initWithFrame:CGRectMake(x/2, 240, 468, 220)];
        interestView.tag = 8000+g;
        interestView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        interestView.layer.borderWidth = 1.0f;
        [bottomView addSubview:interestView];
        
                
        OCDView *interestviewsub = [[OCDView alloc] initWithFrame:CGRectMake(169, 80, 160, 160)];
        interestviewsub.backgroundColor = [UIColor clearColor];
        [interestView addSubview:interestviewsub];
        
        
        
        UILabel*interestLabelValue = [[UILabel alloc]initWithFrame:CGRectMake(170, 125, 130, 40)];
        interestLabelValue.text = [NSString stringWithFormat:@"%@",[acceptDeclineArray objectAtIndex:g]];
        interestLabelValue.font  = [UIFont fontWithName:@"Helvetica-Bold" size:35];
        interestLabelValue.textColor = [UIColor colorWithRed:240.0f/255.0f green:140.0f/255.0f blue:50.0f/255.0f alpha:1];
        interestLabelValue.textAlignment = NSTextAlignmentCenter;
        [interestView addSubview:interestLabelValue];
        
        
        NSString *acceptPitchValue = [NSString stringWithFormat:@"%@",[acceptDeclineArray objectAtIndex:g] ];
        acceptPitchValue = [acceptPitchValue stringByReplacingOccurrencesOfString:@"%" withString:@""];
        NSInteger diffaccept = 100-[acceptPitchValue integerValue];
        NSString*diifStraccept = [NSString stringWithFormat:@"%ld",(long)diffaccept];
        NSNumberFormatter *formatteraccept = [[NSNumberFormatter alloc] init];
        formatteraccept.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *value3 = [formatteraccept numberFromString:acceptPitchValue];
        NSNumber *value4 = [formatteraccept numberFromString:diifStraccept];
        
        
        
        NSArray *interestData = @[ @{@"Browser": @"Chrome",             @"Percent": value3 },
                                   @{@"Browser": @"Safari",             @"Percent": value4} ];
        
        OCDNodeFormatter *arcFormatter1 = [OCDNodeFormatter arcNodeFormatterWithInnerRadius:50
                                                                                outerRadius:65];
        OCDPieLayout *pieLayout1 = [OCDPieLayout layoutForDataArray:interestData usingKey:@"Percent"];
        pieLayout1.startAngle = -M_PI_2;
        pieLayout1.endAngle = (2 * M_PI) -M_PI_2;
        
        OCDSelection *arcs1 = [[interestviewsub selectAllWithIdentifier:@"arcs"] setData:[pieLayout1 layoutData]
                                                                                usingKey:nil];
        [arcs1 setEnter:^(OCDNode *node) {
            [arcFormatter1 formatNode:node];
            if (counterinterestView==0 ) {
                [node setValue:(id)[UIColor colorWithRed:40.0f/255.0f green:140.0f/255.0f blue:180.0f/255.0f alpha:1].CGColor forAttributePath:@"fillColor"];
            }
            else{
                [node setValue:(id)[UIColor colorWithRed:208.0f/255.0f green:208.0f/255.0f blue:208.0f/255.0f alpha:1].CGColor forAttributePath:@"fillColor"];
            }
            [self setValue_interest];
            
            [interestviewsub appendNode:node withTransition:^(CAAnimationGroup *animationGroup, id data, NSUInteger index) {
                
            } completion:^(BOOL finished) {
                
            }];
        }];
        
        if (counterinterestView==2) {
            counterinterestView =0 ;
        }
        
        UIImageView*interestdivider=[[UIImageView alloc]initWithFrame:CGRectMake(90, 60, 288, 2)];
        interestdivider.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1];
        [interestView addSubview:interestdivider];
        
        
        UILabel*interestLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 448, 50)];
        interestLabel.text = @"Interested";
        interestLabel.font  = [UIFont fontWithName:@"Helvetica" size:40];
        interestLabel.textColor = [UIColor colorWithRed:240.0f/255.0f green:137.0f/255.0f blue:25.0f/255.0f alpha:1];
        interestLabel.textAlignment = NSTextAlignmentCenter;
        [interestView addSubview:interestLabel];
        
        
        y= y+90;
        
        
        if ([tabString  isEqual: @"1"])
        {
            [self LiveViewIpad];
        }
        scrollView.backgroundColor=[UIColor lightGrayColor];
        mainView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    if ([tabString  isEqual: @"0"])
    {
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, y);
    }
}

-(void)makeView
{
    int y= 5;
    for (int g=0; g<titleArray.count; g++)
    {
        
        UIView*mainView =[[UIView alloc]initWithFrame:CGRectMake(-2, y, self.view.frame.size.width+4, 60)];
        mainView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        mainView.layer.borderWidth = .5f;
        mainView.tag = 1000+g;
        mainView.backgroundColor = [UIColor whiteColor];
        mainView.clipsToBounds =YES;
        [scrollView addSubview:mainView];
        
        UIView*topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainView.frame.size.width, 60)];
        topView.tag = 3000+g;
        [mainView addSubview:topView];
        
        
        UIView*bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 61, mainView.frame.size.width, 370)];
        bottomView.tag = 4000+g;
        [mainView addSubview:bottomView];
        
        
       
        
        int x = self.view.frame.size.width-280;
        UIView*openPitchView = [[UIView alloc]initWithFrame:CGRectMake(x/2, 10, 280, 170)];
        openPitchView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        openPitchView.layer.borderWidth = .5f;
        [bottomView addSubview:openPitchView];
        
        UILabel*openPitchLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 260, 35)];
        openPitchLabel.text = @"Opened Pitch";
        openPitchLabel.font  = [UIFont fontWithName:@"Helvetica-Bold" size:30];
        openPitchLabel.textColor = [UIColor colorWithRed:40.0f/255.0f green:180.0f/255.0f blue:220.0f/255.0f alpha:1];
        openPitchLabel.textAlignment = NSTextAlignmentCenter;
        [openPitchView addSubview:openPitchLabel];
        
        UIImageView*openPitchdivider=[[UIImageView alloc]initWithFrame:CGRectMake(30, 50, 220, 2)];
        openPitchdivider.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1];
        [openPitchView addSubview:openPitchdivider];
        
        
        OCDView *openPitchview = [[OCDView alloc] initWithFrame:CGRectMake(90, 60, 100, 100)];
      
          [openPitchView addSubview:openPitchview];
      
        UILabel*percentageLabel = [[UILabel alloc]initWithFrame:CGRectMake(103, 96, 80, 25)];
        percentageLabel.text = [NSString stringWithFormat:@"%@",[openPitchArray objectAtIndex:g]];
//        percentageLabel.text = @"60%";
        percentageLabel.font  = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        percentageLabel.textColor = [UIColor colorWithRed:40.0f/255.0f green:180.0f/255.0f blue:220.0f/255.0f alpha:1];
        percentageLabel.textAlignment = NSTextAlignmentCenter;
        [openPitchView addSubview:percentageLabel];

        
        
        NSString *interestValue = [NSString stringWithFormat:@"%@",[openPitchArray objectAtIndex:g] ];
        interestValue = [interestValue stringByReplacingOccurrencesOfString:@"%" withString:@""];
        NSInteger diffinterest = 100-[interestValue integerValue];
        NSString*diifStrinterest = [NSString stringWithFormat:@"%ld",(long)diffinterest];
        NSNumberFormatter *formatterinterest = [[NSNumberFormatter alloc] init];
        formatterinterest.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *value1 = [formatterinterest numberFromString:interestValue];
        NSNumber *value2 = [formatterinterest numberFromString:diifStrinterest];
        
        
        
        
          NSArray *openPitchData = @[ @{@"Browser": @"Chrome",             @"Percent": value1},
                             @{@"Browser": @"Safari",             @"Percent":value2} ];
      
          OCDNodeFormatter *arcFormatter = [OCDNodeFormatter arcNodeFormatterWithInnerRadius:35
                                                                                 outerRadius:50];
          OCDPieLayout *pieLayout = [OCDPieLayout layoutForDataArray:openPitchData usingKey:@"Percent"];
          pieLayout.startAngle = -M_PI_2;
          pieLayout.endAngle = (2 * M_PI) -M_PI_2;
      
          OCDSelection *arcs = [[openPitchview selectAllWithIdentifier:@"arcs"] setData:[pieLayout layoutData]
                                                                      usingKey:nil];
          [arcs setEnter:^(OCDNode *node) {
              [arcFormatter formatNode:node];
              if (counter==0 ) {
                   [node setValue:(id)[UIColor colorWithRed:240.0f/255.0f green:140.0f/255.0f blue:50.0f/255.0f alpha:1].CGColor forAttributePath:@"fillColor"];
              }
              else{
                   [node setValue:(id)[UIColor colorWithRed:208.0f/255.0f green:208.0f/255.0f blue:208.0f/255.0f alpha:1].CGColor forAttributePath:@"fillColor"];
              }
              [self setValue_openPitch];
             

      
              [openPitchview appendNode:node withTransition:^(CAAnimationGroup *animationGroup, id data, NSUInteger index) {
                 
              } completion:^(BOOL finished) {
                  
              }];
          }];
        if (counter==2) {
            counter =0 ;
        }
        
        
        UIView*interestView = [[UIView alloc]initWithFrame:CGRectMake(x/2, 190, 280, 170)];
        interestView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        interestView.layer.borderWidth = .5f;
        [bottomView addSubview:interestView];
        
        
        
        OCDView *interestviewsub = [[OCDView alloc] initWithFrame:CGRectMake(90, 60, 100, 100)];
        
        [interestView addSubview:interestviewsub];
        
        
        
        UILabel*interestLabelValue = [[UILabel alloc]initWithFrame:CGRectMake(103, 96, 80, 25)];
        interestLabelValue.text = [NSString stringWithFormat:@"%@",[acceptDeclineArray objectAtIndex:g]];
        interestLabelValue.font  = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        interestLabelValue.textColor = [UIColor colorWithRed:240.0f/255.0f green:140.0f/255.0f blue:50.0f/255.0f alpha:1];
        interestLabelValue.textAlignment = NSTextAlignmentCenter;
        [interestView addSubview:interestLabelValue];
        
        
        NSString *acceptPitchValue = [NSString stringWithFormat:@"%@",[acceptDeclineArray objectAtIndex:g] ];
        acceptPitchValue = [acceptPitchValue stringByReplacingOccurrencesOfString:@"%" withString:@""];
        NSInteger diffaccept = 100-[acceptPitchValue integerValue];
        NSString*diifStraccept = [NSString stringWithFormat:@"%ld",(long)diffaccept];
        NSNumberFormatter *formatteraccept = [[NSNumberFormatter alloc] init];
        formatteraccept.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *value3 = [formatteraccept numberFromString:acceptPitchValue];
        NSNumber *value4 = [formatteraccept numberFromString:diifStraccept];
        
        
        
        NSArray *interestData = @[ @{@"Browser": @"Chrome",             @"Percent": value3 },
                                    @{@"Browser": @"Safari",             @"Percent": value4} ];
        
        OCDNodeFormatter *arcFormatter1 = [OCDNodeFormatter arcNodeFormatterWithInnerRadius:35
                                                                               outerRadius:50];
        OCDPieLayout *pieLayout1 = [OCDPieLayout layoutForDataArray:interestData usingKey:@"Percent"];
        pieLayout1.startAngle = -M_PI_2;
        pieLayout1.endAngle = (2 * M_PI) -M_PI_2;
        
        OCDSelection *arcs1 = [[interestviewsub selectAllWithIdentifier:@"arcs"] setData:[pieLayout1 layoutData]
                                                                             usingKey:nil];
        [arcs1 setEnter:^(OCDNode *node) {
            [arcFormatter1 formatNode:node];
            
            if (counterinterestView==0 ) {
                [node setValue:(id)[UIColor colorWithRed:40.0f/255.0f green:140.0f/255.0f blue:180.0f/255.0f alpha:1].CGColor forAttributePath:@"fillColor"];
            }
            else{
                [node setValue:(id)[UIColor colorWithRed:208.0f/255.0f green:208.0f/255.0f blue:208.0f/255.0f alpha:1].CGColor forAttributePath:@"fillColor"];
            }
            
            [self setValue_interest];
            
            [interestviewsub appendNode:node withTransition:^(CAAnimationGroup *animationGroup, id data, NSUInteger index) {
                
            } completion:^(BOOL finished) {
                
            }];
        }];

        if (counterinterestView==2) {
            counterinterestView =0 ;
        }
        
        UIImageView*interestdivider=[[UIImageView alloc]initWithFrame:CGRectMake(30, 50, 220, 2)];
        interestdivider.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1];
        [interestView addSubview:interestdivider];
        
        
        UILabel*interestLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 260, 35)];
        interestLabel.text = @"Interested";
        interestLabel.font  = [UIFont fontWithName:@"Helvetica" size:30];
        interestLabel.textColor = [UIColor colorWithRed:240.0f/255.0f green:137.0f/255.0f blue:25.0f/255.0f alpha:1];
        interestLabel.textAlignment = NSTextAlignmentCenter;
        [interestView addSubview:interestLabel];
        
        UILabel*titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, topView.frame.size.width-20, 60)];
        titleLabel.text = [NSString stringWithFormat:@"%@",[titleArray objectAtIndex:g]];
        titleLabel.numberOfLines = 0;
         titleLabel.font  = [UIFont fontWithName:@"Helvetica" size:20];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [topView addSubview:titleLabel];
        
        UIButton*customButton = [UIButton buttonWithType:UIButtonTypeCustom];
        customButton.tag = 2000+g;
        [customButton addTarget:self action:@selector(expandButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        customButton.frame = CGRectMake(0, 0, topView.frame.size.width, topView.frame.size.height);
        [topView addSubview:customButton];
        
        y= y+65;
        
        if ([tabString  isEqual: @"1"])
        {
            [self LiveView];
        }
        scrollView.backgroundColor=[UIColor lightGrayColor];
        mainView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    if ([tabString  isEqual: @"0"])
    {
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, y);
    }
   
}



#pragma mark Expand View Method

-(void)expandButtonPressed_ipad :(UIButton*)sender
{
    NSLog(@"%ld",(long)[sender tag]);
    UIView*mainclickedView =(UIView*)[scrollView viewWithTag:[sender tag]-1000];
    clickedIndex = mainclickedView.tag;
    int yAxis = 10;
    for ( int i=0; i<titleArray.count; i++) 
    {
        UIView*mainView=(UIView*)[scrollView viewWithTag:1000+i];
        
        mainView.frame = CGRectMake(mainView.frame.origin.x, yAxis, mainView.frame.size.width, 80);
        if (mainclickedView.tag == mainView.tag) 
        {
            mainclickedView.frame = CGRectMake(mainclickedView.frame.origin.x, yAxis, mainclickedView.frame.size.width, 550);
            NSLog(@"tag same");
            yAxis  = yAxis+560;
        }
        else{
            yAxis  = yAxis+90;
        }
    }
    scrollView.contentSize = CGSizeMake(768, yAxis);
}
-(void)LiveViewIpad
{
    UIView*mainclickedView =(UIView*)[scrollView viewWithTag:1000];
    clickedIndex = mainclickedView.tag;
    int yAxis = 10;
    for ( int i=0; i<titleArray.count; i++) 
    {
        UIView*mainView=(UIView*)[scrollView viewWithTag:1000+i];
        
        mainView.frame = CGRectMake(mainView.frame.origin.x, yAxis, mainView.frame.size.width, 80);
        if (mainclickedView.tag == mainView.tag) {
            mainclickedView.frame = CGRectMake(mainclickedView.frame.origin.x, yAxis, mainclickedView.frame.size.width, 550);
            NSLog(@"tag same");
            yAxis  = yAxis+560;
        }
        else{
            yAxis  = yAxis+90;
        }
    }
    scrollView.contentSize = CGSizeMake(768, yAxis);
}




-(void)expandButtonPressed :(UIButton*)sender
{
    
    NSLog(@"%ld",(long)[sender tag]);
    UIView*mainclickedView =(UIView*)[scrollView viewWithTag:[sender tag]-1000];
    int yAxis = 5;
    for ( int i=0; i<titleArray.count; i++) {
        UIView*mainView=(UIView*)[scrollView viewWithTag:1000+i];
        
        mainView.frame = CGRectMake(mainView.frame.origin.x, yAxis, mainView.frame.size.width, 60);
        if (mainclickedView.tag == mainView.tag) {
            mainclickedView.frame = CGRectMake(mainclickedView.frame.origin.x, yAxis, mainclickedView.frame.size.width, 430);
            NSLog(@"tag same");
             yAxis  = yAxis+435;
        }
        else{
            yAxis  = yAxis+65;
        }
    }
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, yAxis);
}
-(void)LiveView
{
    UIView*mainclickedView =(UIView*)[scrollView viewWithTag:1000];
    int yAxis = 5;
    for ( int i=0; i<titleArray.count; i++) {
        UIView*mainView=(UIView*)[scrollView viewWithTag:1000+i];
        
        mainView.frame = CGRectMake(mainView.frame.origin.x, yAxis, mainView.frame.size.width, 60);
        if (mainclickedView.tag == mainView.tag) {
            mainclickedView.frame = CGRectMake(mainclickedView.frame.origin.x, yAxis, mainclickedView.frame.size.width, 430);
            NSLog(@"tag same");
            yAxis  = yAxis+435;
        }
        else{
            yAxis  = yAxis+65;
        }
    }
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, yAxis+20);
}

-(void)PubNubNotification:(NSNotification *) notification
{
    [self getCount];
}

-(void)getCount
{
    
    
    if ([[USERDEFAULTS valueForKey:@"totalcount"]integerValue]>0 || [[USERDEFAULTS valueForKey:@"Count"]integerValue]>0)
    {
        lblCount.hidden=NO;
        imgCount.hidden=NO;
        NSInteger show=[[USERDEFAULTS valueForKey:@"chatcount"]integerValue]+[[USERDEFAULTS valueForKey:@"matchcount"] integerValue]+[[USERDEFAULTS valueForKey:@"Count"]integerValue]+[[USERDEFAULTS valueForKey:@"MinusCount"] integerValue];
            lblCount.text=[NSString stringWithFormat:@"%ld",(long)show];
    
            //lblCount.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]];
        }
        else
        {
            lblCount.hidden=YES;
            imgCount.hidden=YES;
        }
//    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]integerValue]>0) {
//        lblCount.hidden=NO;
//        imgCount.hidden=NO;
//        NSInteger show=[[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]integerValue]+[[[NSUserDefaults standardUserDefaults] valueForKey:@"MinusCount"] integerValue];
//        lblCount.text=[NSString stringWithFormat:@"%ld",(long)show];
//        
//        //lblCount.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]];
//    }
//    else
//    {
//        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"MinusCount"]integerValue]>0)
//        {
//            lblCount.hidden=NO;
//            imgCount.hidden=NO;
//            lblCount.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"MinusCount"]];
//            
//        }
//        else
//        {
//            lblCount.hidden=YES;
//            imgCount.hidden=YES;
//        }
//    }
}

-(void)viewWillAppear:(BOOL)animated
{
    
 
    
    [self getCount];
    
    appdelegateInstance = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.navigationController.navigationBar.hidden=YES;
    [self runApi];

    [self leftSlider];
    [super viewWillAppear:animated];
}



-(void)leftSlider
{
    SWRevealViewController *revealController = [self revealViewController];
    revealController.panGestureRecognizer.enabled = YES;
    revealController.tapGestureRecognizer.enabled = YES;
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    //  [button setBackgroundImage:[UIImage imageNamed:@"menu55.png"] forState:UIControlStateNormal];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        button.frame = CGRectMake(0, 0, 80, 80);
    }
    else{
        button.frame = CGRectMake(0, 0, 60, 60);
    }
    [self.view addSubview:button];
    
}
#pragma mark set Counter Method
-(void)setValue_interest{
    counterinterestView++;
}
-(void)setValue_openPitch{
    counter++;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)bottomButtonPressed:(UIButton*)sender {
    if ([sender tag]==1) {
        liveArrowImageView.hidden = NO;
        expiredArrowImageView.hidden = YES;
        tabString=@"1";
        
    }
   else if ([sender tag]==2) {
       liveArrowImageView.hidden = YES;
       expiredArrowImageView.hidden = NO;
       tabString=@"0";
    }
    NSArray *views = [scrollView subviews];
    for (UIView *vw in views)
    {
        [vw removeFromSuperview];
    }
    [self runApi];
}
#pragma mark Orientation Method
- (BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
         if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortrait) {
             
             //  NSLog(@"portrait");
             int y = 10;
             for (int j=0; j<titleArray.count; j++) {
                 UIView*mainView = (UIView*)[scrollView viewWithTag:1000+j];
                 
                 if (clickedIndex == mainView.tag) {
                     mainView.frame = CGRectMake(-2, y, self.view.frame.size.width+4, 550);
                     y = y+560;
                 }
                 else{
                     mainView.frame = CGRectMake(-2, y, self.view.frame.size.width+4, 80);
                     y = y+90;
                 }
                 UIView*topView = (UIView*)[mainView viewWithTag:3000+j];
                 UILabel*titleLabel = (UILabel*)[topView viewWithTag:6000+j];
                 titleLabel.frame = CGRectMake(10,0, self.view.frame.size.width-20, 80);
                 
                 UIView*openPitchView = (UIView*)[mainView viewWithTag:7000+j];
                 int x = self.view.frame.size.width-openPitchView.frame.size.width;
                 openPitchView.frame = CGRectMake(x/2, openPitchView.frame.origin.y, openPitchView.frame.size.width, openPitchView.frame.size.height);
                 
                 UIView*acceptViewView = (UIView*)[mainView viewWithTag:8000+j];
                 acceptViewView.frame = CGRectMake(x/2, acceptViewView.frame.origin.y, acceptViewView.frame.size.width, acceptViewView.frame.size.height);
                 
             }

             
         }
         else if (orientation == UIInterfaceOrientationLandscapeLeft ||
                  orientation == UIInterfaceOrientationLandscapeRight)
         {
             //  NSLog(@"landscape");
             int y = 10;
             for (int j=0; j<titleArray.count; j++) {
                 UIView*mainView = (UIView*)[scrollView viewWithTag:1000+j];
                
                 if (clickedIndex == mainView.tag) {
                     mainView.frame = CGRectMake(-2, y, self.view.frame.size.width+4, 550);
                     y = y+560;
                 }
                 else{
                      mainView.frame = CGRectMake(-2, y, self.view.frame.size.width+4, 80);
                     y = y+90;
                 }
                  UIView*topView = (UIView*)[mainView viewWithTag:3000+j];
                 UILabel*titleLabel = (UILabel*)[topView viewWithTag:6000+j];
                 titleLabel.frame = CGRectMake(10,0, self.view.frame.size.width-20, 80);
                 
                  UIView*openPitchView = (UIView*)[mainView viewWithTag:7000+j];
                 int x = self.view.frame.size.width-openPitchView.frame.size.width;
                 openPitchView.frame = CGRectMake(x/2, openPitchView.frame.origin.y, openPitchView.frame.size.width, openPitchView.frame.size.height);
                 
                 UIView*acceptViewView = (UIView*)[mainView viewWithTag:8000+j];
                 acceptViewView.frame = CGRectMake(x/2, acceptViewView.frame.origin.y, acceptViewView.frame.size.width, acceptViewView.frame.size.height);
                 
             }
        }
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

@end
