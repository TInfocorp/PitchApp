 //
// ChoosePersonViewController.m
//
// Copyright (c) 2014 to present, Brian Gesiak @modocache
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "ChoosePersonViewController.h"
#import "Person.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "SWRevealViewController.h"
#import "MDCSwipeToChooseView.h"
#import "LxReqRespManager.h"
#import "UIImageView+WebCache.h"
#import "PitchDetailsViewController.h"
#import "Journalist_Pitches.h"
#import "constant.h"
#import "viewPitchesViewController_Journalists.h"
static const CGFloat ChoosePersonButtonHorizontalPadding = 80.f;
static const CGFloat ChoosePersonButtonVerticalPadding = 20.f;

@interface ChoosePersonViewController ()
{
    BOOL isDone;
    NSMutableArray *arrRedu;
    NSInteger holdpage;
}
@property (nonatomic, strong) NSMutableArray *people;
@end

@implementation ChoosePersonViewController

#pragma mark - Object Lifecycle

- (instancetype)init {
    self = [super init];
    _people = [NSMutableArray new];
    return self;
}

#pragma mark - UIViewController Overrides

-(void)leftSlider
{
    SWRevealViewController *revealController = [self revealViewController];
    //    revealController.panGestureRecognizer.enabled = YES;
    //    revealController.tapGestureRecognizer.enabled = YES;
    //    [revealController panGestureRecognizer];
    //    [revealController tapGestureRecognizer];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        button.frame = CGRectMake(0, 0, 80, 80);
    }
    else
    {
        button.frame = CGRectMake(0, 0, 60, 60);
    }
    [self.view addSubview:button];
    
}


-(void)viewDidDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"showHud"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PubNubNotification:) name:@"pubnubnot" object:nil];
    lblReason.frame=CGRectMake(reasinTextView.frame.origin.x+2, lblReason.frame.origin.y, lblReason.frame.size.width, lblReason.frame.size.height);
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"showHud"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}


-(void)PubNubNotification:(NSNotification *) notification
{
    [self getCount];
}


-(void) refreshView
{
    imgViewTinder=[[UIImageView alloc]init];
    imgViewTinderDope=[[UIImageView alloc]init];
    self.frontCardView=[[ChoosePersonView alloc]init];
    self.backCardView=[[ChoosePersonView alloc]init];
    undoOnce=NO;
    currentAcceptStatus=NO;
    makeFrontView=YES;
    currentacceptDelete=0;
    currentValue=0;
    viewArray = [[NSMutableArray alloc]init];
    SWRevealViewController *revealController = [self revealViewController];
    revealController.panGestureRecognizer.enabled = NO;
    revealController.tapGestureRecognizer.enabled = NO;
    
    arrRedu=[NSMutableArray new];
    pageNumber=0;
    viewRemoverCounter = 0;
    
    currentValue=0;
    mainArray=[[NSMutableArray alloc]init];
    appdelegateInstance = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    if ( [[[NSUserDefaults standardUserDefaults]objectForKey:@"showHud"]isEqualToString:@"1"])
    {
        [appdelegateInstance showHUD:@""];
        [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"showHud"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    
    [self showPitches];
    
    [self leftSlider];
    _people = [NSMutableArray new];
    self.navigationController.navigationBarHidden = YES;
    
    errorMessageLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 150, 200, 50)];
    [errorMessageLabel setCenter:self.view.center];
    [self.view addSubview:errorMessageLabel];
    [errorMessageLabel setCenter:self.view.center];
    errorMessageLabel.numberOfLines = 0;
    errorMessageLabel.textAlignment = NSTextAlignmentCenter;
    errorMessageLabel.text = @"No Pitches Found";
    errorMessageLabel.hidden=YES;
    
}
-(void)getCount
{
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"totalcount"]integerValue]>0 || [[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]integerValue]>0) {
        lblCount.hidden=NO;
        imgCount.hidden=NO;
        NSInteger show=[[[NSUserDefaults standardUserDefaults]valueForKey:@"chatcount"]integerValue]+[[[NSUserDefaults standardUserDefaults] valueForKey:@"matchcount"] integerValue]+[[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]integerValue]+[[[NSUserDefaults standardUserDefaults] valueForKey:@"MinusCount"] integerValue];
        
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
    [self refreshView];
    
    

    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortrait)
    {
        landscape=NO;
    }
    else
    {
        landscape=YES;
    }
}




-(void)showPitches
{
    
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService=[[NSString alloc]initWithFormat:@"%@pitch_tinder",AppURL];
    NSLog(@"%@",strWebService);
    NSDictionary *dictParams;
    
    
    
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)pageNumber],@"offset",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",
                nil];
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
             [appdelegateInstance hideHUD];
             NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             
             if ([str isEqualToString:[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]]]) {
                 
                 errorMessageLabel.hidden = NO;
             }
             if ([str isEqualToString:@"0"] )
             {
                 NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
                 if ([str isEqualToString:@"0"] )
                 {
                     for (int k=0; k<[[[response valueForKey:@"data"] valueForKey:@"Pitch"] count]; k++)
                     {
                         Journalist_Pitches *objectClass = [[Journalist_Pitches alloc] init];
                         objectClass.pitchId=[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"id"] objectAtIndex:k] ;
                         objectClass.pitchTitle=[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"title"] objectAtIndex:k] ;
                         objectClass.pitchImage=[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"image1_new"] objectAtIndex:k] ;
                         objectClass.pitchSummary=[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"summary"] objectAtIndex:k] ;
                         [mainArray addObject:objectClass];
                     }
                 }
                 messageLabel.hidden = YES;
                 
                 
                 if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                 {
                     [self makeTinderView];
                 }
                 
                 else{
                     [self makeTinderView];
                 }
             }
             else if ([str isEqualToString:@"1"] )
             {
                 if ([[response objectForKey:@"data"] isEqualToString:@"Sorry!you are paused by admin so you can not see any pitches. Please contact to administrator."]) {
                     [constant alertViewWithMessage:[response objectForKey:@"data"] withView:self];
                     errorMessageLabel.hidden = NO;
                     errorMessageLabel.text = @"Your are paused by administrator.";
                     
                 }else
                 {
                     if (mainArray.count==0) {
                         
                         if (mainArray.count>0) {
                             errorMessageLabel.hidden = YES;
                         }
                         else{
                             errorMessageLabel.hidden = NO;
                         }
                         
                     }

                   
                 }

            }
             else if ([str isEqualToString:@"10"] )
             {
                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 alert.tag = 1234;
                 [alert show];
             }
         }
         else
         {
             [appdelegateInstance hideHUD];
             //             UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Connectivity levels low. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
             //             [alert show];
             [constant alertViewWithMessage:@"Connectivity levels low. Please try again."withView:self];
             NSLog(@"Error returned:%@",[error localizedDescription]);
         }
     }];
    
    


}


-(void)makeTinderView
{
    
    NSLog(@"%lu",(unsigned long)mainArray.count);
    
    for (int i=pageNumber; i<mainArray.count; i++)
    {
        UIView *mainView;
        mainView.backgroundColor=[UIColor clearColor];
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            CGFloat mainFrame= self.view.frame.size.width-30;
            CGFloat margin= mainFrame-600;
            //NSLog(@"%f",margin);
            
            
            mainView =[[UIView alloc]initWithFrame:CGRectMake(margin/2, 0, 600, [self frontCardViewFrame].size.height)];
           // NSLog(@"%f",[self frontCardViewFrame].size.height);
            if (i==0) {
                
            }
            mainView.layer.borderColor=[UIColor colorWithRed:(240/255.0) green:(240/255.0) blue:(240/255.0) alpha:1].CGColor;
            mainView.layer.borderWidth=4.0;
            
        }
        else
        {
            mainView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, [self frontCardViewFrame].size.width, [self frontCardViewFrame].size.height)];
            mainView.layer.borderColor=[UIColor colorWithRed:(240/255.0) green:(240/255.0) blue:(240/255.0) alpha:1].CGColor;
            mainView.layer.borderWidth=4.0;
            
            
        }
        
        mainView.tag = i+1000;
        
        //NSLog(@"%@",[NSValue valueWithCGRect:self.backCardView.frame]);
        //NSLog(@"%@",[NSValue valueWithCGRect:self.frontCardView.frame]);
        UILabel*titleLabel;
        titleLabel.tag=20;
        UIImageView*headerImageView;
        headerImageView.tag=30;
         CGFloat btnHeight;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 0, mainView.frame.size.width-90, 100)];

            UIButton*reportImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [reportImageButton setBackgroundImage:[UIImage imageNamed:@"shield.png"] forState:UIControlStateNormal];
            [reportImageButton addTarget:self
                                  action:@selector(reportButtonPressed:)
                        forControlEvents:UIControlEventTouchUpInside];
            reportImageButton.tag = i+6000;
            reportImageButton.frame = CGRectMake(mainView.frame.size.width-50,10, 40, 40);
            
//            titleLabel.layer.borderColor=[UIColor redColor].CGColor;
//            titleLabel.layer.borderWidth=3;
       
            [mainView addSubview:reportImageButton];
            
            
            [mainView addSubview:titleLabel];
            titleLabel.numberOfLines = 0;
            
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [titleLabel setFont:[UIFont systemFontOfSize:23]];
            
            if (landscape==YES)
            {
                headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(80, titleLabel.frame.origin.y+titleLabel.frame.size.height, mainView.frame.size.width-160, (mainView.frame.size.width-80)*.66)];
            }
            else
            {
                headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, titleLabel.frame.origin.y+titleLabel.frame.size.height, mainView.frame.size.width-40, (mainView.frame.size.width-40)*.66)];
            }
            
            headerImageView.tag = 1;
            headerImageView.contentMode = UIViewContentModeScaleAspectFill;
            headerImageView.clipsToBounds=YES;
            headerImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
            UIViewAutoresizingFlexibleLeftMargin |
            UIViewAutoresizingFlexibleHeight;
            [mainView addSubview:headerImageView];
        }
        else
        {
            titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, mainView.frame.size.width-80, 70)];
            UIButton*reportImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [reportImageButton setBackgroundImage:[UIImage imageNamed:@"shield.png"] forState:UIControlStateNormal];
            [reportImageButton addTarget:self
                                  action:@selector(reportButtonPressed:)
                        forControlEvents:UIControlEventTouchUpInside];
            reportImageButton.tag = i+6000;
            reportImageButton.frame = CGRectMake(mainView.frame.size.width-30,5, 20, 20);
            [mainView addSubview:reportImageButton];
            //holdpage=pageNumber;
//            if (i==pageNumber) {
//                 holdpage=pageNumber;
//            }
//            
//            if (holdpage==i) {
//                reportImageButton.userInteractionEnabled=YES;            }else {
//                    reportImageButton.userInteractionEnabled=NO;
//            }
           
            
            [mainView addSubview:titleLabel];
            titleLabel.numberOfLines = 0;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [titleLabel setFont:[UIFont systemFontOfSize:18]];
            
//            titleLabel.layer.borderWidth=2;
//            titleLabel.layer.borderColor=[UIColor greenColor].CGColor;
            
            headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(mainView.frame.origin.x+20, titleLabel.frame.origin.y+titleLabel.frame.size.height, mainView.frame.size.width-40, (mainView.frame.size.width-20)*.66)];
            headerImageView.tag = 1;
            headerImageView.contentMode = UIViewContentModeScaleAspectFill;
            headerImageView.clipsToBounds=YES;
            [mainView addSubview:headerImageView];
        }
        
        titleLabel.text  = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:i] pitchTitle]];
        titleLabel.backgroundColor=[UIColor clearColor];
        
        if (IS_IPHONE_6 || IS_IPHONE_6_PLUS)
        {
            btnHeight=55.0;
        }
        else{
            btnHeight=45.0;
        }

        

        
        
        NSURL*Url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:i] pitchImage]]];
        [headerImageView setImageWithURL1:Url1 placeholderImage:[UIImage imageNamed:@""] imagesize:CGSizeMake(headerImageView.frame.size.width, headerImageView.frame.size.height)];
        
        UILabel*desLabel;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            desLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, headerImageView.frame.origin.y+headerImageView.frame.size.height+8, mainView.frame.size.width-40, 180)];
            desLabel.tag=40;

            if (landscape==YES)
            {
                desLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18];
            }
            else{
                desLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:23];
            }
        }
        else
        {
          if (IS_IPHONE_6 || IS_IPHONE_6_PLUS )
            {
                 desLabel = [[UILabel alloc]initWithFrame:CGRectMake(headerImageView.frame.origin.x, headerImageView.frame.origin.y+headerImageView.frame.size.height+8, headerImageView.frame.size.width, 170)];
                 desLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:16];
                 [titleLabel setFont:[UIFont systemFontOfSize:20]];
            }
            else
            {
                 desLabel = [[UILabel alloc]initWithFrame:CGRectMake(headerImageView.frame.origin.x, headerImageView.frame.origin.y+headerImageView.frame.size.height+8, headerImageView.frame.size.width, 140)];
                desLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:12];
            }
        }
        desLabel.tag=40;
//        desLabel.layer.borderColor = [UIColor redColor].CGColor;
//        desLabel.layer.borderWidth = 3.0f;
        desLabel.text  = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:i] pitchSummary]];
        int labelfontSize;
        int maxHeight;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            labelfontSize =23;
            maxHeight =180;
        }
        else{
            
            if (IS_IPHONE_6 || IS_IPHONE_6_PLUS )
            {
                maxHeight =140;
                labelfontSize =16;
            }
            else{
            maxHeight =110;
            labelfontSize =12;
            }
        }
        CGSize constraintSize;
        constraintSize.height = MAXFLOAT;
        constraintSize.width = desLabel.frame.size.width;
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIFont fontWithName:@"HelveticaNeue-Light" size:labelfontSize], NSFontAttributeName,
                                              nil];
        
        CGRect frame = [desLabel.text boundingRectWithSize:constraintSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:attributesDictionary
                                                   context:nil];
        
        CGSize stringSize = frame.size;
        if (stringSize.height>maxHeight)
        {
            stringSize.height = maxHeight;
        }
        desLabel.frame = CGRectMake(desLabel.frame.origin.x, desLabel.frame.origin.y, desLabel.frame.size.width, stringSize.height+5);
        desLabel.textAlignment = NSTextAlignmentLeft;
        desLabel.numberOfLines = 0;
        
        desLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleBottomMargin;
        mainView.backgroundColor=[UIColor clearColor];
        [mainView addSubview:desLabel];
        
        CGFloat height =(self.view.frame.size.width-20)*1.18;
        CGFloat heightAvail=(self.view.frame.size.height-118);
        CGFloat position = (heightAvail-height)/2;
        NSLog(@"%f",position);
      //  CGFloat topPadding = 64+position;
      //  CGFloat FinalPosition=topPadding+height+20;
        
       
        UIView*bottomView;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {//70 80
            btnHeight=75.0;
            bottomView = [[UIView alloc]initWithFrame:CGRectMake(10, mainView.frame.size.height-80, mainView.frame.size.width-20, btnHeight)];
            [mainView addSubview:bottomView];
            
        }
        else
        {
            if (IS_IPHONE_6 || IS_IPHONE_6_PLUS)
            {
                btnHeight=55.0;
                bottomView = [[UIView alloc]initWithFrame:CGRectMake(10, mainView.frame.size.height-65, mainView.frame.size.width-20, btnHeight)];
                [mainView addSubview:bottomView];
                
            }
            else{
                btnHeight=45.0;
                bottomView = [[UIView alloc]initWithFrame:CGRectMake(10, mainView.frame.size.height-55, mainView.frame.size.width-20, btnHeight)];
                [mainView addSubview:bottomView];
            }
            
        }
        
        
        
        bottomView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin ; [mainView addSubview:bottomView];
        CGFloat btnWidth=bottomView.frame.size.width/4;
        //NSLog(@"%f",btnWidth);
        //NSLog(@"%f",btnHeight);
        bottomView.tag=50;
        UIButton*crossButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [crossButton setBackgroundImage:[UIImage imageNamed:@"u01.png"] forState:UIControlStateNormal];
        crossButton.tag = i+3000;
        [crossButton addTarget:self action:@selector(crossAcceptPressed:) forControlEvents:UIControlEventTouchUpInside];
        crossButton.frame = CGRectMake(0, 0, btnWidth, btnHeight);
        [bottomView addSubview:crossButton];
        
        UIButton*checkedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkedButton setBackgroundImage:[UIImage imageNamed:@"u04.png"] forState:UIControlStateNormal];
        checkedButton.tag = i+4000;
        checkedButton.frame = CGRectMake(btnWidth*3, 0, btnWidth, btnHeight);
        [checkedButton addTarget:self action:@selector(crossAcceptPressed:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:checkedButton];
        
        UIButton*undoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [undoButton setBackgroundImage:[UIImage imageNamed:@"u02.png"] forState:UIControlStateNormal];
        [undoButton addTarget:self
                       action:@selector(undoAction:)
             forControlEvents:UIControlEventTouchUpInside];
        undoButton.tag = i+2000;
        undoButton.frame = CGRectMake(btnWidth*1, 0, btnWidth, btnHeight);
        [bottomView addSubview:undoButton];
        
        UIButton*detailCircleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [detailCircleButton setBackgroundImage:[UIImage imageNamed:@"u03.png"] forState:UIControlStateNormal];
        [detailCircleButton addTarget:self
                               action:@selector(detailButtonPressed:)
                     forControlEvents:UIControlEventTouchUpInside];
        detailCircleButton.tag = i+5000;
        detailCircleButton.frame = CGRectMake(btnWidth*2, 0, btnWidth, btnHeight);
        [bottomView addSubview:detailCircleButton];
        
        
       
//        UIButton*reportImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [reportImageButton setBackgroundImage:[UIImage imageNamed:@"u05.png"] forState:UIControlStateNormal];
//        [reportImageButton addTarget:self
//                              action:@selector(reportButtonPressed:)
//                    forControlEvents:UIControlEventTouchUpInside];
//        reportImageButton.tag = i+6000;
//        reportImageButton.frame = CGRectMake(btnWidth*4, 0, btnWidth, btnHeight);
//        [bottomView addSubview:reportImageButton];
        
        //  cross u01.png  undo u02.png detail u03.png right u04.png report u05.png
        
        
        
        NSArray *srt=[[[mainArray objectAtIndex:i] pitchSummary] componentsSeparatedByString:@"\n"];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            desLabel.minimumScaleFactor = 0.2;
            desLabel.adjustsFontSizeToFitWidth = YES;
        }
        else{
            
        if (desLabel.text.length>100||srt.count>3) {
            desLabel.minimumScaleFactor = 0.2;
            desLabel.adjustsFontSizeToFitWidth = YES;
              desLabel.frame = CGRectMake(desLabel.frame.origin.x, desLabel.frame.origin.y, desLabel.frame.size.width,mainView.frame.size.height-desLabel.frame.origin.y-bottomView.frame.size.height-10);
        }
        
        }
      
        
        [viewArray addObject: mainView];
        
        UIView*blankView=[[UIView alloc]init];
        blankView.backgroundColor=[UIColor clearColor];
        
        Person *per=[[Person alloc]initWithName:@"" image:blankView viewtag:1234];
        [_people addObject:per];
        
        
    }
    testArray=[viewArray mutableCopy];
    maximumValue = (unsigned long)viewArray.count;
    
    
    
    if (mainArray.count>0) {
        errorMessageLabel.hidden = YES;
    }
    else{
        errorMessageLabel.hidden = NO;
    }
    if (makeFrontView==YES)
    {
        
        self.frontCardView = [self popPersonViewWithFrame:[self frontCardViewFrame]];
        if (currentValue==0)
        {
            if (viewArray.count>0)
            {
                [self.frontCardView addSubview:[viewArray objectAtIndex:currentValue]];
            }
        }
        
        self.frontCardView.backgroundColor=[UIColor whiteColor];
        self.backCardView.backgroundColor=[UIColor whiteColor];
        self.frontCardView.layer.borderColor=[[UIColor whiteColor]CGColor];
        self.backCardView.layer.borderColor=[[UIColor whiteColor]CGColor];
        [self.view addSubview:self.frontCardView];
        //NSLog(@"%@",[NSValue valueWithCGRect:self.frontCardView.frame]);
        self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]];
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        self.frontCardView.layer.borderColor=[[UIColor whiteColor]CGColor];
        self.backCardView.layer.borderColor=[[UIColor whiteColor]CGColor];
        //NSLog(@"%@",[NSValue valueWithCGRect:self.frontCardView.frame]);
        
        if (viewArray.count>1)
        {
            [self.backCardView addSubview:[viewArray objectAtIndex:currentValue+1]];
        }
        makeFrontView=NO;
    }
}




-(void)crossAcceptPressed : (UIButton*)sender{
    
    isDone=YES;
    if ([sender tag]>=4000) {
        declineOrAcceptButtonPressedInt = [sender tag]-3000;
        [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
        [self acceptThePitch:declineOrAcceptButtonPressedInt];
    }
    else{
        declineOrAcceptButtonPressedInt = [sender tag]-2000;
        [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
        [self declineThePitch:declineOrAcceptButtonPressedInt];
    }
}
-(void)reportButtonPressed :(UIButton*)sender{
    
    NSLog(@"%lu",(unsigned long)mainArray.count);
    NSLog(@"%ld",(long)[sender tag]);
    NSLog(@"%@",[[mainArray objectAtIndex:[sender tag]-6000] pitchId]);
    NSLog(@"%@",viewArray);

 NSString * pitchIdToBeRemove1 = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:currentValue] pitchId]];
    
    
  pitchIdToBeRemove = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:[sender tag]-6000] pitchId]];
    

    if ([pitchIdToBeRemove1 intValue]== [pitchIdToBeRemove intValue])
    {
        reasonView.hidden = NO;
        [self.view bringSubviewToFront:reasonView];
    }
  
    //[self.view addSubview:reasonView];
}
-(void)acceptThePitch :(NSInteger) tag
{
    if (tag>=1000)
    {
        acceptDeclineString= @"1";
        // NSLog(@"%ld",tag+2);
        pitchIdToBeRemove = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:tag-1000] pitchId]];
        
        
        [self acceptDeclineUndoAPI];
        apiCounter++;
        if (apiCounter%5==1) {
            pageNumber = pageNumber+5;
            [self showPitches];
        }
    }
}

-(void)declineThePitch1
{
    acceptDeclineString= @"2";
    pitchIdToBeRemove = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:currentValue] pitchId]];
    
    
    if (isDone) {
        isDone=NO;
    }
    else
    {
         [self acceptDeclineUndoAPI];
    }
    
   
    apiCounter++;
    if (apiCounter%5==1) {
        pageNumber = pageNumber+5;
        [self showPitches];
    }
}

-(void)acceptThePitch1
{
    acceptDeclineString= @"1";
    pitchIdToBeRemove = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:currentValue] pitchId]];
    if (isDone) {
        isDone=NO;
    }
    else
    {
        
    [self acceptDeclineUndoAPI];
    }
    apiCounter++;
    if (apiCounter%5==1) {
        pageNumber = pageNumber+5;
        [self showPitches];
    }
}


-(void)declineThePitch :(NSInteger)tag
{
    if (tag>=1000) {
        NSLog(@"%ld",(long)tag);
        acceptDeclineString= @"2";
        
        pitchIdToBeRemove = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:tag-1000] pitchId]];
        
        if (isDone) {
            isDone=NO;
        }else{
        [self acceptDeclineUndoAPI];
        }
        apiCounter++;
        if (apiCounter%5==1) {
            pageNumber = pageNumber+5;
            [self showPitches];
        }
    }
}

-(void)detailButtonPressed : (UIButton*)sender
{
    NSLog(@"detail button pressed %ld",(long)[sender tag]);
    PitchDetailsViewController*obj;
    obj=[self.storyboard instantiateViewControllerWithIdentifier:@"pitchDetailJournalist"];
    obj.strPitchId = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:[sender tag]-5000] pitchId]];
    [self.navigationController pushViewController:obj animated:YES];
    
}

-(void)acceptDeclineUndoAPI
{
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
    if ([acceptDeclineString isEqualToString:@"3"]) {
         holdpage=holdpage-1;
        strWebService=[[NSString alloc]initWithFormat:@"%@undopitch",AppURL];
    }
    else  if ([acceptDeclineString isEqualToString:@"2"] ||[acceptDeclineString isEqualToString:@"1"] ) {
        strWebService=[[NSString alloc]initWithFormat:@"%@pitch_selector",AppURL];
        //holdpage=holdpage++;
    }
    NSLog(@"%@",strWebService);
    NSDictionary *dictParams;
    
    if ([acceptDeclineString isEqualToString:@"3"]) {
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:pitchIdToBeRemove,@"id",
                    nil];
        
    }
    else  if ([acceptDeclineString isEqualToString:@"2"] ||[acceptDeclineString isEqualToString:@"1"] ) {
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:pitchIdToBeRemove,@"pitch_id",acceptDeclineString,@"status",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]],@"user_id",@"2",@"create_from",
                    nil];
        holdpage++;
        
    }
    NSLog(@"%@",dictParams);
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
             [appdelegateInstance hideHUD];
             NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             if ([str isEqualToString:@"0"] )
             {
                 NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
                 if ([str isEqualToString:@"0"] )
                 {
                     
                 }
             }
             else if ([str isEqualToString:@"1"] )
             {
                 // UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 // [alert show];
             }
             else if ([str isEqualToString:@"10"] )
             {
                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 alert.tag = 1234;
                 [alert show];
             }
         }
         else
         {
             [appdelegateInstance hideHUD];
//             UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Connectivity levels low. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//             [alert show];
             [constant alertViewWithMessage:@"Connectivity levels low. Please try again."withView:self];
             NSLog(@"Error returned:%@",[error localizedDescription]);
         }
     }];
    
}

-(void)undoAction :(id)sender
{
    if (oneTimeUndo==YES)
    {
        
        oneTimeUndo=NO;
    //    Person *per=[[Person alloc]initWithName:@"" image:[testArray objectAtIndex:currentacceptDelete-1] viewtag:1234];
    //
    //   // [_people addObject:per];
    //    [_people insertObject:per atIndex:0];
    //    [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
    //
    if (currentValue==0)
    {
        
    }
    else{
        //}
        UIView*blankView=[[UIView alloc]init];
        blankView.backgroundColor=[UIColor clearColor];
        
        Person *per=[[Person alloc]initWithName:@"" image:blankView viewtag:1234];
        [_people addObject:per];
        
        if (undoOnce==NO)
        {
            maximumValue=maximumValue+1;
            undoOnce=YES;
        }
        
        if (maximumValue==currentValue+2)
        {
            NSLog(@"");
            self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]];
            [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
            self.frontCardView.layer.borderColor=[[UIColor whiteColor]CGColor];
            self.backCardView.layer.borderColor=[[UIColor whiteColor]CGColor];
            
        }
        //
        for(UIView *subview in [self.frontCardView subviews])
        {
            [subview removeFromSuperview];
        }
        for(UIView *subview in [self.backCardView subviews])
        {
            [subview removeFromSuperview];
        }
        if (currentValue>0)
        {
            currentValue=currentValue-1;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                                   forView:self.frontCardView
                                     cache:YES];
            
            
            
            [self.frontCardView addSubview:[viewArray objectAtIndex:currentValue]];
            [UIView commitAnimations];
            
            //        [UIView beginAnimations:nil context:nil];
            //        [UIView setAnimationDuration:2.0];
            //        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown
            //                               forView:self.backCardView
            //                                 cache:YES];
            //
            
            [self.backCardView addSubview:[viewArray objectAtIndex:currentValue+1]];
            //[UIView commitAnimations];
        }
        acceptDeclineString = @"3";
        viewRemoverCounter--;
        pitchIdToBeRemove = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:currentValue] pitchId]];
        [self acceptDeclineUndoAPI];
        if (currentValue==maximumValue)
        {
            errorMessageLabel.hidden=NO;
        }
        else
        {
            errorMessageLabel.hidden=YES;
        }
      }
    }
}
- (IBAction)chatIconPressed:(id)sender
{
//    [[NSUserDefaults standardUserDefaults]setObject:@"showChatScreen" forKey:@"directCall"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
    SWRevealViewController *revealController = self.revealViewController;
    viewPitchesViewController_Journalists*obj;

    obj=[self.storyboard instantiateViewControllerWithIdentifier:@"viewPitches"];
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
    //- If user has a new match and no new message it defaults user to matches
   // - If user has new message, but no new match it defaults user to messages
  //  - If user has new message AND new match it defaults user to match
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:obj];
    [revealController pushFrontViewController:navigationController animated:YES];
}

- (void)scaleTextView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    CGFloat scale = 0;
    NSMutableAttributedString *string;
    
    switch (pinchGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            old_scale = 1.0;
            last_time = [NSDate date];
            break;
            
        case UIGestureRecognizerStateChanged:
            scale = pinchGestureRecognizer.scale - old_scale;
            
            if( [last_time timeIntervalSinceNow] < -0.2 )  {       //  updating 5 times a second is best I can do - faster than this and we get buffered changes going on for ages!
                last_time = [NSDate date];
                string = [self getScaledStringFrom:[label.attributedText mutableCopy] withScale:1.0 + scale];
                if( string )    {
                    label.attributedText = string;
                    old_scale = pinchGestureRecognizer.scale;
                }
            }
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            break;
            
        default:
            break;
    }
}

- (NSMutableAttributedString*) getScaledStringFrom:(NSMutableAttributedString*)string withScale:(CGFloat)scale
{
    [string beginEditing];
    [string enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, string.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value) {
            UIFont *oldFont = (UIFont *)value;
            UIFont *newFont = [oldFont fontWithSize:oldFont.pointSize * scale];
            [string removeAttribute:NSFontAttributeName range:range];
            [string addAttribute:NSFontAttributeName value:newFont range:range];
        }
    }];
    [string endEditing];
    return string;
}


-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView viewWithTag:10];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGFloat chk =self.frontCardView.frame.origin.y;
    // self.frontCardView.frame=CGRectMake(self.frontCardView.frame.origin.x, chk-5, self.frontCardView.frame.size.width, self.frontCardView.frame.size.height);
    
    // self.backCardView.frame=CGRectMake(self.backCardView.frame.origin.x, self.backCardView.frame.origin.y-5, self.backCardView.frame.size.width, self.backCardView.frame.size.height);
    
    // Get the specific point that was touched
    CGPoint point = [touch locationInView:self.frontCardView];
    NSLog(@"Y Location: %f",point.y);
    
    //  pointY=point.x;
    pointY=self.frontCardView.frame.origin.x;
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        
        imgViewTinderDope.image =[UIImage imageNamed:@"not_in_3x.png"];
        
        
        imgViewTinder.image=[UIImage imageNamed:@"interest_3x.png"];
        
        NSLog(@"%hhd",landscape);
        
        if (landscape==NO)
        {
            
            imgViewTinderDope.frame = CGRectMake(self.frontCardView.frame.size.width-370, 30, 300, 202);
            imgViewTinder.frame = CGRectMake(self.frontCardView.frame.origin.x+80, 30, 300, 202);
            
        }
        else
        {
            imgViewTinderDope.frame = CGRectMake(self.frontCardView.frame.size.width-420, 50, 200, 128);
            imgViewTinder.frame = CGRectMake(self.frontCardView.frame.origin.x+180, 50, 200, 128);
            
        }
    }
    else{
        
        imgViewTinderDope.image =[UIImage imageNamed:@"not_in_2x.png"];
        
        
        imgViewTinder.image=[UIImage imageNamed:@"interest_2x.png"];
        if (IS_IPHONE_6)
        {
            imgViewTinderDope.frame = CGRectMake(self.frontCardView.frame.size.width-150, 30, 150, 101);
            imgViewTinder.frame = CGRectMake(self.frontCardView.frame.origin.x-8, 30, 150, 101);
        }
        else
        {
            imgViewTinderDope.frame = CGRectMake(self.frontCardView.frame.size.width-120, 30, 120, 81);
            imgViewTinder.frame = CGRectMake(self.frontCardView.frame.origin.x-8, 30, 120, 81);
        }
    }
    
    myTimer= [NSTimer scheduledTimerWithTimeInterval:0.1
                                              target:self
                                            selector:@selector(chkPosition)
                                            userInfo:nil
                                             repeats:YES];
    [UIView animateWithDuration:0.5 animations:^(void) {
        imgViewTinder.alpha = 0;
        imgViewTinder.alpha = 1;
    }];
    
    
}


-(void)chkPosition
{
    CGFloat point2;
    point2=self.frontCardView.frame.origin.x;
    
    //  NSLog(@"fvfrtjnyjy %@",[NSValue valueWithCGRect:self.frontCardView.frame]);
   // NSLog(@" pointY %f",pointY);
    //NSLog(@" point2 %f",point2);
    
    
    if (point2>pointY)
        
    {[imgViewTinderDope removeFromSuperview];
        [self.frontCardView addSubview:imgViewTinder];
        
        NSLog(@"delete");
    }
    if (point2<pointY)
    {
        [imgViewTinder removeFromSuperview];
        [self.frontCardView addSubview:imgViewTinderDope];
        
        NSLog(@"accept");
        
        
    }
    
    
    
}



-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //     NSLog(@"delete");
    //    UITouch *touch = [touches anyObject];
    //    CGPoint point = [touch locationInView:self.frontCardView];
    //
    //    CGFloat point2;
    //    point2=self.frontCardView.frame.origin.x;
    //
    //    if (point.x>pointY)
    //    {
    //        imgViewTinder.image =[UIImage imageNamed:@"1430596761_DeleteRed.png"];
    //        imgViewTinder.frame = CGRectMake(self.frontCardView.frame.origin.x+10, 10, 80, 80);
    //        [self.frontCardView addSubview:imgViewTinder];
    //        NSLog(@"delete");
    //    }
    //    if (point.x<pointY)
    //    {
    //        imgViewTinder.image=[UIImage imageNamed:@"1430596797_package-installed-updated"];
    //        imgViewTinder.frame = CGRectMake(self.frontCardView.frame.size.width-100, 10, 80, 80);
    //        [self.frontCardView addSubview:imgViewTinder];
    //        NSLog(@"accept");
    //
    //    }
    
}



-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    //self.frontCardView.frame=CGRectMake(self.frontCardView.frame.origin.x, self.frontCardView.frame.origin.y+5, self.frontCardView.frame.size.width, self.frontCardView.frame.size.height);
    //  self.backCardView.frame=CGRectMake(self.backCardView.frame.origin.x, self.backCardView.frame.origin.y+5, self.backCardView.frame.size.width, self.backCardView.frame.size.height);
    
    [myTimer invalidate];
    myTimer = nil;
    
    [imgViewTinder removeFromSuperview];
    [imgViewTinderDope removeFromSuperview];
    
}




- (void)panGestureHandler:(UIPanGestureRecognizer *)sender
{
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ( event.subtype == UIEventTypeMotion )
    {
        NSLog(@"deletefbhd");
        
        
    }
}

#pragma mark TextView delegate
- (void)textViewDidEndEditing:(UITextView *)theTextView
{
    if (![reasinTextView hasText])
    {
        lblReason.hidden = NO;
    }
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    
//    scrollVw.contentOffset = CGPointMake(0,mediaCoverageView.frame.origin.y+mediaCoverageView.frame.size.height+categoryView.frame.size.height+  textView.frame.origin.y);
}

- (void) textViewDidChange:(UITextView *)textView
{
    
    if(![reasinTextView hasText]) {
        lblReason.hidden = NO;
    }
    else{
        lblReason.hidden = YES;
    }
}

#pragma mark Report Image Methods
-(void)reportImage{
    reasonView.hidden = NO;
}
- (IBAction)hidereasonView:(id)sender {
    
    reasinTextView.text=@"";
    lblReason.hidden=NO;
    [self.view endEditing:YES];
     reasonView.hidden = YES;
   // [reasonView removeFromSuperview];
}
- (IBAction)saveReportReason:(id)sender {
    [self.view endEditing:YES];
    reasinTextView.text = [reasinTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (reasinTextView.text.length>0) {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:@"Are you sure you want to report this pitch?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        alert.tag = 100;
        [alert show];
    }
    else{
//        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please enter some text to report the pitch" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//        [alert show];
        [constant alertViewWithMessage:@"Please enter some text to report the pitch."withView:self];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex==0) {
            NSLog(@"Cancel");
        }
        else if (buttonIndex==1) {
            NSLog(@"Ok");
            [self reportUserApi];
        }
    }
    if (alertView.tag == 300)
    {
        if (buttonIndex==0)
        {
            NSLog(@"You liked %@.", self.currentPerson.name);
            [self declineThePitch1];
            [myTimer invalidate];
            myTimer = nil;
            oneTimeUndo=YES;
        }
    }
    if (alertView.tag == 200)
    {
        if (buttonIndex==0)
        {
            NSLog(@"You liked %@.", self.currentPerson.name);
            oneTimeUndo=YES;
            [self acceptThePitch1];
            [myTimer invalidate];
            myTimer = nil;
        }
    }
    if (alertView.tag==1234) {
        AppDelegate *appd= (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appd LogoutFromApp:self];
    }
}
-(void)reportUserApi
{
    reasonView.hidden = YES;
    //[reasonView removeFromSuperview];
    [reasinTextView resignFirstResponder];
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
    NSDictionary *dictParams;
    strWebService=[[NSString alloc]initWithFormat:@"%@report_pitches",AppURL];
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",pitchIdToBeRemove,@"pitch_id",reasinTextView.text,@"reason",nil];
    NSLog(@"%@",strWebService);
    
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
             [appdelegateInstance hideHUD];
             NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             if ([str isEqualToString:@"0"])
             {
                 reasinTextView.text=@"";
                 lblReason.hidden = NO;
             }
             else  if ([str isEqualToString:@"1"])
             {
//                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                 [alert show];
                 [constant alertViewWithMessage:[response valueForKey:@"message"]withView:self];
             }
             else if ([str isEqualToString:@"10"] )
             {
                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 alert.tag = 1234;
                 [alert show];
             }
         }
         else
         {
             [appdelegateInstance hideHUD];
//             UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Connectivity levels low. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//             [alert show];
             [constant alertViewWithMessage:@"Connectivity levels low. Please try again."withView:self];
             NSLog(@"Error returned:%@",[error localizedDescription]);
         }
     }];
}
#pragma mark - MDCSwipeToChooseDelegate Protocol Methods

// This is called when a user didn't fully swipe left or right.

- (BOOL)view:(UIView *)view shouldBeChosenWithDirection:(MDCSwipeDirection)direction;
{
    NSLog(@"got it");
    
    return YES;
}

- (void)viewDidCancelSwipe:(UIView *)view
{
    NSLog(@"You couldn't decide on %@.", self.currentPerson.name);
    
    CGFloat chk =self.frontCardView.frame.origin.y;
    // self.frontCardView.frame=CGRectMake(self.frontCardView.frame.origin.x, chk+5, self.frontCardView.frame.size.width, self.frontCardView.frame.size.height);
    
    // self.backCardView.frame=CGRectMake(self.backCardView.frame.origin.x, self.backCardView.frame.origin.y+5, self.backCardView.frame.size.width, self.backCardView.frame.size.height);
    [imgViewTinderDope removeFromSuperview];
    [imgViewTinder removeFromSuperview];
    [myTimer invalidate];
    myTimer = nil;
    
    
}
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction
{
    NSString*statusString;
    
    if (direction == MDCSwipeDirectionLeft)
    {
        NSLog(@"You noped %@.", self.currentPerson.name);
        
        
        if ([[USERDEFAULTS objectForKey:ISFIRSTTIMELEFTJOURALIST] boolValue] == YES)
        {
            [USERDEFAULTS setBool:NO forKey:ISFIRSTTIMELEFTJOURALIST];
            [USERDEFAULTS synchronize];
//            [constant alertViewWithMessage:@"All pitches swiped left will be discarded."  withView:self];
            UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"All pitches swiped left will be discarded." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
           
        }
        [self declineThePitch1];
        [myTimer invalidate];
        myTimer = nil;
        statusString = @"2";
        oneTimeUndo=YES;
        // for PopUp first time journalist log in

    }
    else
    {
        if ([[USERDEFAULTS objectForKey:ISFIRSTTIMERIGHTJOURNALIST] boolValue] == YES)
        {
            [USERDEFAULTS setBool:NO forKey:ISFIRSTTIMERIGHTJOURNALIST];
            [USERDEFAULTS synchronize];
            
            //UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"All pitches which you swipe right which will be in your Liked Pitches section." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Once you swipe right on a pitch, it will be in your Liked Pitches section." delegate:self cancelButtonTitle:@"Thanks, got it!" otherButtonTitles:nil];
            
            [alert show];
        }// for PopUp first time journalist log in
        NSLog(@"You liked %@.", self.currentPerson.name);
        oneTimeUndo=YES;
        [self acceptThePitch1];
        [myTimer invalidate];
        myTimer = nil;
        statusString = @"1";
    }
    
    NSLog(@"%ld",(long)currentValue);
    
    self.frontCardView = self.backCardView;
    currentValue=currentValue+1;
    
    
    self.frontCardView.backgroundColor=[UIColor whiteColor];
    self.backCardView.backgroundColor=[UIColor whiteColor];
    
    NSLog(@"%@",self.backCardView.subviews);
    
    if ((self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]])) {
        self.backCardView.alpha = 0.f;
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backCardView.alpha = 1.f;
                         } completion:nil];
    }
    NSLog(@"%ld",(long)currentValue);
    if (currentValue+1<maximumValue)
    {
        NSLog(@"%ld",(long)currentValue);
        NSLog(@"%ld",(long)currentValue);
        if (undoOnce==YES)
        {
            if (currentValue+1<maximumValue-1)
            {
                [self.backCardView addSubview:[viewArray objectAtIndex:currentValue+1]];
            }
        }
        else
        {
            [self.backCardView addSubview:[viewArray objectAtIndex:currentValue+1]];
        }
    }
    else
    {
        if (currentValue==maximumValue)
        {
            errorMessageLabel.hidden=NO;
        }
        else
        {
            errorMessageLabel.hidden=YES;
        }
    }
}
#pragma mark - Internal Methods

- (void)setFrontCardView:(ChoosePersonView *)frontCardView
{
    _frontCardView = frontCardView;
    self.currentPerson = frontCardView.person;
}

- (NSArray *)defaultPeople
{
    return nil;
}

- (ChoosePersonView *)popPersonViewWithFrame:(CGRect)frame {
    if ([self.people count] == 0) {
        return nil;
    }
    
    CGRect frontFrame = [self frontCardViewFrame];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        thesholdRatio=frontFrame.size.height+40.f;
    }
    else
    {
        
        if (IS_IPHONE_6 || IS_IPHONE_6_PLUS)
        {
            thesholdRatio=frontFrame.size.height+45.f;
        }
        else{
            thesholdRatio=frontFrame.size.height+25.f;
        }
    }
    
    self.frontCardView.layer.borderColor=[[UIColor whiteColor]CGColor];
    self.backCardView.layer.borderColor=[[UIColor whiteColor]CGColor];
    
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 160.f;
    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y - (state.thresholdRatio * thesholdRatio),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
    };
    
    // Create a personView with the top person in the people array, then pop
    // that person off the stack.
    ChoosePersonView *personView = [[ChoosePersonView alloc] initWithFrame:frame
                                                                    person:self.people[0]
                                                                   options:options];
    
    
    //[viewArray addObject:self.people[0]];
    [self.people removeObjectAtIndex:0];
    
    return personView;
}


- (ChoosePersonView *)unduPersonViewWithFrame:(CGRect)frame {
    if ([viewArray count] == 2)
    {
        return nil;
    }
    CGRect frontFrame = [self frontCardViewFrame];
    thesholdRatio=frontFrame.size.height+25.f;
    
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 160.f;
    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y - (state.thresholdRatio * thesholdRatio),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
    };
    
    // Create a personView with the top person in the people array, then pop
    // that person off the stack.
    ChoosePersonView *personView = [[ChoosePersonView alloc] initWithFrame:frame
                                                                    person:[viewArray objectAtIndex:viewArray.count-3]
                                                                   options:options];
    
    
    [self.people insertObject:[viewArray lastObject] atIndex:0];
    [viewArray removeLastObject];
    return personView;
}



#pragma mark View Contruction

-(CGRect)undoCardViewFrame
{
    self.undoCardView=[[UIView alloc]init];
    
    
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y-125.f,
                      CGRectGetWidth(frontFrame),
                      CGRectGetHeight(frontFrame));
}


- (CGRect)frontCardViewFrame
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        NSLog(@"%hhd",landscape);
        if (landscape==NO)
        {
            CGFloat horizontalPadding = 15.f;
            CGFloat height =(self.view.frame.size.width-30)*1.1;
            CGFloat heightAvail=(self.view.frame.size.height-118);
            CGFloat position = (heightAvail-height)/2;
            NSLog(@"%f",position);
            CGFloat topPadding = 80+10;
            CGFloat bottomPadding = position;
            return CGRectMake(horizontalPadding,
                              topPadding,
                              self.view.frame.size.width-20,
                              height);
            
            
        }
        else{
            
            CGFloat horizontalPadding = 15.f;
            CGFloat height =(self.view.frame.size.width-30)*0.68;
            CGFloat heightAvail=(self.view.frame.size.height-118);
            CGFloat position = (heightAvail-height)/2;
            NSLog(@"%f",position);
            CGFloat topPadding = 80+10;
            CGFloat bottomPadding = position;
            return CGRectMake(horizontalPadding,
                              topPadding,
                              self.view.frame.size.width-20,
                              height);                }
        
    }
    else
    {
        CGFloat horizontalPadding = 10.f;
        CGFloat height =(self.view.frame.size.width-20)*1.35;
        CGFloat heightAvail=(self.view.frame.size.height-118);
        CGFloat position = (heightAvail-height)/2;
        NSLog(@"%f",position);
        CGFloat topPadding = 64+10;
        CGFloat bottomPadding = position;
        return CGRectMake(horizontalPadding,
                          topPadding,
                          self.view.frame.size.width-20,
                          height);
        
    }
}

- (CGRect)backCardViewFrame

{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        CGRect frontFrame = [self frontCardViewFrame];
        return CGRectMake(frontFrame.origin.x,
                          frontFrame.origin.y+frontFrame.size.height+40.f,
                          CGRectGetWidth(frontFrame),
                          CGRectGetHeight(frontFrame));
        
    }
    else
    {
        
        if (IS_IPHONE_6 || IS_IPHONE_6_PLUS)
        {
            CGRect frontFrame = [self frontCardViewFrame];
            return CGRectMake(frontFrame.origin.x,
                              frontFrame.origin.y+frontFrame.size.height+45.f,
                              CGRectGetWidth(frontFrame),
                              CGRectGetHeight(frontFrame));
            
        }
        else
        {
            CGRect frontFrame = [self frontCardViewFrame];
            return CGRectMake(frontFrame.origin.x,
                              frontFrame.origin.y+frontFrame.size.height+25.f,
                              CGRectGetWidth(frontFrame),
                              CGRectGetHeight(frontFrame));
            
        }
        
        
        
        
    }
    
    
    
    
}


// Create and add the "nope" button.
- (void)constructNopeButton
{
    buttonDope = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"nope"];
    buttonDope.frame = CGRectMake(ChoosePersonButtonHorizontalPadding,
                                  CGRectGetMaxY(self.frontCardView.frame) + ChoosePersonButtonVerticalPadding,
                                  image.size.width,
                                  image.size.height);
    [buttonDope setImage:image forState:UIControlStateNormal];
    [buttonDope setTintColor:[UIColor colorWithRed:247.f/255.f
                                             green:91.f/255.f
                                              blue:37.f/255.f
                                             alpha:1.f]];
    [buttonDope addTarget:self
                   action:@selector(nopeFrontCardView)
         forControlEvents:UIControlEventTouchUpInside];
}

// Create and add the "like" button.

- (void)constructLikedButton
{
    
    buttonlike = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"liked"];
    buttonlike.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - image.size.width - ChoosePersonButtonHorizontalPadding,
                                  CGRectGetMaxY(self.frontCardView.frame) + ChoosePersonButtonVerticalPadding,
                                  image.size.width,
                                  image.size.height);
    [buttonlike setImage:image forState:UIControlStateNormal];
    [buttonlike setTintColor:[UIColor colorWithRed:29.f/255.f
                                             green:245.f/255.f
                                              blue:106.f/255.f
                                             alpha:1.f]];
    [buttonlike addTarget:self
                   action:@selector(likeFrontCardView)
         forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark Control Events
- (void)nopeFrontCardView
{
    [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
}

- (void)likeFrontCardView
{
    [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
}




#pragma mark Orientation Method

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


- (void)listSubviewsOfView:(UIView *)view {
    
    // Get the subviews of the view
    NSArray *subviews = [view subviews];
    
    // Return if there are no subviews
    if ([subviews count] == 0) return;
    
    for (UIView *subview in subviews) {
        
        NSLog(@"%@", subview);
        
        // List the subviews of subview
        [self listSubviewsOfView:subview];
    }
}



- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
         if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortrait)
         {
             
             landscape=NO;
             NSArray *views = [self.view subviews];
             
             for (UIView *vw in views)
             {
                 if (vw.tag!=500)
                 {
                     if (vw.tag!=501) {
                         [vw removeFromSuperview];
                     }
                     
                 }
                 
             }
             
             [self refreshView];
             
             //[self listSubviewsOfView:self.frontCardView];
             
             
             //             UIView*main = (UIView*)[self.frontCardView viewWithTag:1000];
             //             UILabel*titleLabel = (UILabel*)[main viewWithTag:20];
             //             UIImageView*headerImageView = (UIImageView*)[main viewWithTag:30];
             //             UILabel*desLabel=(UILabel*)[main viewWithTag:40];
             //             UIView*bottomView = (UILabel*)[main viewWithTag:50];
             //
             //             CGFloat mainFrame= self.view.frame.size.width-30;
             //             CGFloat margin= mainFrame-600;
             //             NSLog(@"%f",margin);
             //
             //             main.frame=CGRectMake(margin/2, 0, 600, [self frontCardViewFrame].size.height);
             //
             //             titleLabel.frame=CGRectMake(10, 0, main.frame.size.width-20, 100);
             //
             //            headerImageView.frame=CGRectMake(20, titleLabel.frame.origin.y+titleLabel.frame.size.height, main.frame.size.width-40, (main.frame.size.width-20)*.66);
             //
             //            headerImageView.clipsToBounds=YES;
             //
             //            CGFloat btnHeight=80.0;
             //
             //
             //
             //              bottomView = [[UIView alloc]initWithFrame:CGRectMake(10, main.frame.size.height-100, main.frame.size.width-20, btnHeight)];
             
             
             
             
             
         }
         
         else if (orientation == UIInterfaceOrientationLandscapeLeft ||
                  orientation == UIInterfaceOrientationLandscapeRight)
         {
             
             if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                 
             {
                 landscape=YES;
                 NSArray *views = [self.view subviews];
                 for (UIView *vw in views)
                 {
                     if (vw.tag!=500)
                     {
                         if (vw.tag!=501) {
                             [vw removeFromSuperview];
                         }
                     }
                 }
                 [self refreshView];
                 //[self showPitches];
                 
                 
                 //                 UIView*main = (UIView*)[self.frontCardView viewWithTag:1000];
                 //                 UILabel*titleLabel = (UILabel*)[main viewWithTag:20];
                 //                 UIImageView*headerImageView = (UIImageView*)[main viewWithTag:30];
                 //                 UILabel*desLabel=(UILabel*)[main viewWithTag:40];
                 //                 UIView*bottomView = (UILabel*)[main viewWithTag:50];
                 //
                 //                 CGFloat mainFrame= self.view.frame.size.width-30;
                 //                 CGFloat margin= mainFrame-600;
                 //                 NSLog(@"%f",margin);
                 //                 
                 //                 main.frame=CGRectMake(margin/2, 0, 600, [self frontCardViewFrame].size.height);
                 //                 
                 //                 titleLabel.frame=CGRectMake(10, 0, main.frame.size.width-20, 100);
                 //                 
                 //                 headerImageView.frame=CGRectMake(20, titleLabel.frame.origin.y+titleLabel.frame.size.height, main.frame.size.width-40, (main.frame.size.width-20)*.66);
                 //                 
                 //                 headerImageView.clipsToBounds=YES;
                 //                 
                 //                 CGFloat btnHeight=80.0;
                 //                 
                 //                 
                 //                 
                 //                 bottomView = [[UIView alloc]initWithFrame:CGRectMake(10, main.frame.size.height-100, main.frame.size.width-20, btnHeight)];
             }
             
             
         }
         
         // do whatever
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"showHud"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.frontCardView removeFromSuperview];
    [self.backCardView removeFromSuperview];
}


@end
