//
//  PitchFeedJournalist_ViewController.m
//  uPitch
//
//  Created by Puneet Rao on 19/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import "PitchFeedJournalist_ViewController.h"
#import "SWRevealViewController.h"
#import "LxReqRespManager.h"
#import "UIImageView+WebCache.h"
#import "Journalist_Pitches.h"
#import "TinderViewStatic.h"
#import "PitchDetailsViewController.h"
#import "constant.h"
@interface PitchFeedJournalist_ViewController ()

@end

@implementation PitchFeedJournalist_ViewController


#pragma mark View Delegate
- (void)viewDidLoad {
    [super viewDidLoad];
   NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSLog(@"%@",currentTimeZone);
    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"ahola" message:[USERDEFAULTS objectForKey:@"jared"] delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil,nil];
    [Alert show];
    // Do any additional setup after loading the view.
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    SWRevealViewController *revealController = [self revealViewController];
    revealController.panGestureRecognizer.enabled = YES;
    revealController.tapGestureRecognizer.enabled = YES;
    [super viewWillDisappear:YES];
    // [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    mainArray=[[NSMutableArray alloc]init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        yCord= 90 ;
    }
    else{
        yCord= 70 ;
    }
    
    SWRevealViewController *revealController = [self revealViewController];
    revealController.panGestureRecognizer.enabled = NO;
    revealController.tapGestureRecognizer.enabled = NO;
    
    pageNumber=0;
    viewRemoverCounter = 0;
    
    NSArray *views = [self.view subviews];
    for (UIView *vw in views)
    {
        if (vw.tag==123 || vw.tag == 321 ) {
            
        }
        else{
            [vw removeFromSuperview];
        }
      
    }
    
    mainArray=[[NSMutableArray alloc]init];
    appdelegateInstance = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appdelegateInstance showHUD:@""];
    [self showPitches];

    
    //[self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
    self.navigationController.navigationBarHidden = YES;
    
  
    [self leftSlider];
    [super viewWillAppear:animated];
}
-(void)leftSlider
{
    SWRevealViewController *revealController = [self revealViewController];
    //    revealController.panGestureRecognizer.enabled = YES;
    //    revealController.tapGestureRecognizer.enabled = YES;
    //    [revealController panGestureRecognizer];
    //    [revealController tapGestureRecognizer];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    // [button setBackgroundImage:[UIImage imageNamed:@"menu55.png"] forState:UIControlStateNormal];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        button.frame = CGRectMake(0, 0, 80, 80);
    }
    else{
        button.frame = CGRectMake(0, 0, 60, 60);
    }
    [self.view addSubview:button];
    
}
#pragma mark API request
-(void)showPitches
{
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService=[[NSString alloc]initWithFormat:@"%@pitch_tinder",AppURL];
    NSLog(@"%@",strWebService);
    NSDictionary *dictParams;
   
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageNumber],@"offset",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",
                    nil];
   
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
                     for (int k=0; k<[[[response valueForKey:@"data"] valueForKey:@"Pitch"] count]; k++) {
                         Journalist_Pitches* objectClass = [[Journalist_Pitches alloc] init];
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
                  [self makeTinderView_iPad];
                 }
                 else{
                   [self makeTinderView];
                 }
             }
             else if ([str isEqualToString:@"1"] )
             {
                 if (mainArray.count==0) {
                      messageLabel.hidden = NO;
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1234) {
        AppDelegate *appd= (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appd LogoutFromApp:self];
    }
}

#pragma mark Make View Delegate
-(void)makeTinderView_iPad{
  
    for (int i=pageNumber; i<mainArray.count; i++) {
        
        UIView *mainView =[[UIView alloc]initWithFrame:CGRectMake(0, yCord, self.view.frame.size.width-20, 300)];
        mainView.tag = i+1000;
        [self.view addSubview:mainView];
        NSLog(@"main view tag is %@",[NSValue valueWithCGRect:mainView.frame]);
        
        if (i==0) {
            UISwipeGestureRecognizer *recognizerRight;
            recognizerRight.delegate=self;
            recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
            [recognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];
            [mainView addGestureRecognizer:recognizerRight];
            
            UISwipeGestureRecognizer *recognizerLeft;
            recognizerLeft.delegate=self;
            recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
            [recognizerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
            [mainView addGestureRecognizer:recognizerLeft];
        }
        mainView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        mainView.layer.borderWidth = 1.0;
        
        UILabel*titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, mainView.frame.size.width-20, 60)];
        [mainView addSubview:titleLabel];
        titleLabel.numberOfLines = 0;
        titleLabel.tag = 6000;
        titleLabel.textAlignment = NSTextAlignmentCenter;
          titleLabel.text  = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:i] pitchTitle]];
         titleLabel.font  = [UIFont fontWithName:@"Helvetica-Bold" size:23];
        //titleLabel.text = @"Athletic Shoe Hits Market 2 Provide More Endurance Athletic Shoe Hits Market 2 Provide More Endurance Athletic Shoe Hits Market 2 Provide More Endurance";
        
        
        int xforImageView = self.view.frame.size.width- 768;
        
        UIImageView*headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(xforImageView/2, titleLabel.frame.origin.y+titleLabel.frame.size.height+10, 728, 728*.33)];
        headerImageView.tag = 8000;
        headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        headerImageView.clipsToBounds=YES;
        [mainView addSubview:headerImageView];
        
        NSURL*Url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:i] pitchImage]]];
        
        [headerImageView setImageWithURL:Url1 placeholderImage:[UIImage imageNamed:@""] imagesize:CGSizeMake(400, 400)];
        
       // [headerImageView setImage:[UIImage imageNamed:@"download.jpeg"]];
        
        
        
        UILabel*desLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, headerImageView.frame.origin.y+headerImageView.frame.size.height+8, mainView.frame.size.width-20, 150)];
        desLabel.tag= 7000;
        //desLabel.layer.borderColor = [UIColor redColor].CGColor;
        // desLabel.layer.borderWidth = 2.0f;
         desLabel.text  = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:i] pitchSummary]];
        desLabel.font  = [UIFont fontWithName:@"Helvetica" size:23];
       // desLabel.text = @"Athletic Shoe Hits Market Athletic Shoe Hits Market Athletic Shoe Hits Market Athletic Shoe Hits Market Athletic Shoe Hits Market Athletic Shoe Hits Athletic Shoe Hits Market Athletic Shoe Hits Market Athletic Shoe Hits Market Athletic Shoe Hits Market Athletic Shoe Hits Market Athletic Shoe Hits Athletic Shoe Hits Market Athletic Shoe Hits Market Athletic Shoe Hits Market Athletic Shoe Hits Market Athletic Shoe Hits Market Athletic Shoe Hits Athletic Shoe Hits Market Athletic Shoe Hits Market Athletic Shoe Hits Market Athletic Shoe Hits Market Athletic Shoe Hits Market Athletic Shoe Hits";
        
        
        int labelfontSize;
        int maxHeight;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            labelfontSize =26;
            maxHeight =150;
        }
        else{
            labelfontSize =13;
            maxHeight =110;
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
        if (stringSize.height>maxHeight) {
            stringSize.height = maxHeight;
        }
        
        desLabel.frame = CGRectMake(desLabel.frame.origin.x, desLabel.frame.origin.y, desLabel.frame.size.width, stringSize.height);
        desLabel.textAlignment = NSTextAlignmentLeft;
        desLabel.numberOfLines = 0;
        [mainView addSubview:desLabel];
        
        
        mainView.frame =CGRectMake(10, yCord, self.view.frame.size.width-20, headerImageView.frame.origin.y+headerImageView.frame.size.height+270);
        
        int x= self.view.frame.size.width-768;
        UIView*bottomView = [[UIView alloc]initWithFrame:CGRectMake(x/2, mainView.frame.size.height-105, 748, 95)];
        [mainView addSubview:bottomView];
        bottomView.tag =9000;
        
        
        UIButton*crossButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [crossButton setBackgroundImage:[UIImage imageNamed:@"Forma_new"] forState:UIControlStateNormal];
        crossButton.tag = i+3000;
        [crossButton addTarget:self action:@selector(crossAcceptPressed:) forControlEvents:UIControlEventTouchUpInside];
        crossButton.frame = CGRectMake(5, 0, 137, 95);
        crossButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [bottomView addSubview:crossButton];
        
        UIButton*checkedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkedButton setBackgroundImage:[UIImage imageNamed:@"Forma_new1"] forState:UIControlStateNormal];
        checkedButton.tag = i+4000;
        checkedButton.frame = CGRectMake(bottomView.frame.size.width-142, 0, 137, 95);
         checkedButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [checkedButton addTarget:self action:@selector(crossAcceptPressed:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:checkedButton];
        
        int remainingWidth = bottomView.frame.size.width - 294;
        // NSLog(@"%d",remainingWidth);
        int space = remainingWidth-162;
        int xCord = space/3;
        
        UIButton*undoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [undoButton setBackgroundImage:[UIImage imageNamed:@"Forma 11_new"] forState:UIControlStateNormal];
        [undoButton addTarget:self
                       action:@selector(undoAction:)
             forControlEvents:UIControlEventTouchUpInside];
        undoButton.tag = i+2000;
        //undoButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        undoButton.frame = CGRectMake(crossButton.frame.origin.x+crossButton.frame.size.width+xCord, 4, 81, 81);
        [bottomView addSubview:undoButton];
        
        
        UIButton*detailCircleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [detailCircleButton setBackgroundImage:[UIImage imageNamed:@"Forma 12_new"] forState:UIControlStateNormal];
        [detailCircleButton addTarget:self
                               action:@selector(detailButtonPressed:)
                     forControlEvents:UIControlEventTouchUpInside];
        detailCircleButton.tag = i+5000;
        detailCircleButton.frame = CGRectMake(undoButton.frame.origin.x+undoButton.frame.size.width+xCord, 4, 81, 81);
        [bottomView addSubview:detailCircleButton];
        
        //        mainView.frame =CGRectMake(10, yCord, self.view.frame.size.width-20, desLabel.frame.origin.y+desLabel.frame.size.height+90);
        
        yCord= yCord+self.view.frame.size.height-160;
    }
    
}
-(void)makeTinderView{
    
    for (int i=pageNumber; i<mainArray.count; i++)
    {
        
        UIView *mainView =[[UIView alloc]initWithFrame:CGRectMake(0, yCord, self.view.frame.size.width-20, 300)];
        mainView.tag = i+1000;
        [self.view addSubview:mainView];
        
        if (i==0) {
        UISwipeGestureRecognizer *recognizerRight;
        recognizerRight.delegate=self;
        recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
        [recognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];
        [mainView addGestureRecognizer:recognizerRight];
        
        UISwipeGestureRecognizer *recognizerLeft;
        recognizerLeft.delegate=self;
        recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
        [recognizerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [mainView addGestureRecognizer:recognizerLeft];
        }

        
        
        mainView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        mainView.layer.borderWidth = 1.0;
        
        UILabel*titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, mainView.frame.size.width-20, 50)];
        [mainView addSubview:titleLabel];
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text  = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:i] pitchTitle]];
       // titleLabel.text = @"Athletic Shoe Hits Market 2 Provide More Endurance";
        

        
       
         UIImageView*headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(mainView.frame.origin.x+10, titleLabel.frame.origin.y+titleLabel.frame.size.height, mainView.frame.size.width-20, (mainView.frame.size.width-20)*.33)];
        headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        headerImageView.clipsToBounds=YES;
        [mainView addSubview:headerImageView];
        
        NSURL*Url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:i] pitchImage]]];
        [headerImageView setImageWithURL:Url1 placeholderImage:[UIImage imageNamed:@""] imagesize:CGSizeMake(400, 400)];
      
        //[headerImageView setImage:[UIImage imageNamed:@"download.jpeg"]];

        
        
        UILabel*desLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, headerImageView.frame.origin.y+headerImageView.frame.size.height+8, mainView.frame.size.width-20, 140)];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            desLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:23];
        }
        else
        {
            desLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:13]; 
        }
       
        //desLabel.layer.borderColor = [UIColor redColor].CGColor;
       // desLabel.layer.borderWidth = 2.0f;
        desLabel.text  = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:i] pitchSummary]];
       // desLabel.text = @" Athletic Shoe Hits Market Athletic Shoe Hits Market Athletic Shoe Hits Market Athletic Shoe Hits Market Athletic Shoe Hits Market Athletic Shoe Hits";

        
        int labelfontSize;
        int maxHeight;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            labelfontSize =26;
            maxHeight =100;
        }
        else{
            labelfontSize =13;
            maxHeight =110;
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
        if (stringSize.height>maxHeight) {
            stringSize.height = maxHeight;
        }
        
        desLabel.frame = CGRectMake(desLabel.frame.origin.x, desLabel.frame.origin.y, desLabel.frame.size.width, stringSize.height+3);
         desLabel.textAlignment = NSTextAlignmentLeft;
        desLabel.numberOfLines = 0;
        [mainView addSubview:desLabel];
        

        mainView.frame =CGRectMake(10, yCord, self.view.frame.size.width-20, headerImageView.frame.origin.y+headerImageView.frame.size.height+200);
        
        UIView*bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, mainView.frame.size.height-75, mainView.frame.size.width, 65)];
        [mainView addSubview:bottomView];

        
        UIButton*crossButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [crossButton setBackgroundImage:[UIImage imageNamed:@"Forma_new"] forState:UIControlStateNormal];
        crossButton.tag = i+3000;
        [crossButton addTarget:self action:@selector(crossAcceptPressed:) forControlEvents:UIControlEventTouchUpInside];
        crossButton.frame = CGRectMake(5, 0, 91, 62);
        [bottomView addSubview:crossButton];
        
        UIButton*checkedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkedButton setBackgroundImage:[UIImage imageNamed:@"Forma_new1"] forState:UIControlStateNormal];
        checkedButton.tag = i+4000;
        checkedButton.frame = CGRectMake(bottomView.frame.size.width-96, 0, 91, 62);
        [checkedButton addTarget:self action:@selector(crossAcceptPressed:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:checkedButton];
        
        int remainingWidth = bottomView.frame.size.width - 192;
       // NSLog(@"%d",remainingWidth);
        int space = remainingWidth-108;
        int xCord = space/3;
        
        UIButton*undoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [undoButton setBackgroundImage:[UIImage imageNamed:@"Forma 11_new"] forState:UIControlStateNormal];
        [undoButton addTarget:self
                   action:@selector(undoAction:)
         forControlEvents:UIControlEventTouchUpInside];
        undoButton.tag = i+2000;
        undoButton.frame = CGRectMake(crossButton.frame.origin.x+crossButton.frame.size.width+xCord, 4, 54, 54);
        [bottomView addSubview:undoButton];
        
        
        UIButton*detailCircleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [detailCircleButton setBackgroundImage:[UIImage imageNamed:@"Forma 12_new"] forState:UIControlStateNormal];
        [detailCircleButton addTarget:self
                       action:@selector(detailButtonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
        detailCircleButton.tag = i+5000;
        detailCircleButton.frame = CGRectMake(undoButton.frame.origin.x+undoButton.frame.size.width+xCord, 4, 54, 54);
        [bottomView addSubview:detailCircleButton];
        
//        mainView.frame =CGRectMake(10, yCord, self.view.frame.size.width-20, desLabel.frame.origin.y+desLabel.frame.size.height+90);
     
        yCord= yCord+self.view.frame.size.height-120;
    }
}

-(void)undoAction :(UIButton*)sender{
    // undo action
    NSLog(@"sender tag is %ld",(long)[sender tag]);
    if ([sender tag]>2000) {
     acceptDeclineString = @"3";
        viewRemoverCounter--;
        
         pitchIdToBeRemove = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:[sender tag]-2000] pitchId]];
        [self acceptDeclineUndoAPI];
        
    UIView *shiftToTopView =(UIView*)[self.view viewWithTag:[sender tag]-1001];
        // outer screen to top of the main view
    [self addGestureToTopView:shiftToTopView.tag];// geture will be added to this view
    UIView *shiftToBottomFromTopView =(UIView*)[self.view viewWithTag:[sender tag]-1000]; // top of the screen to bottom of the screem
    UIView *shiftToBottomView =(UIView*)[self.view viewWithTag:[sender tag]-999];
        // bottom of the screen to outer screen
    UIView *mainViewRemovePermanent =(UIView*)[self.view viewWithTag:[sender tag]-1002]; // permanent remove view
        [mainViewRemovePermanent removeFromSuperview];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.9];
         if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
              [shiftToBottomFromTopView setFrame:CGRectMake(10, self.view.frame.size.height-60 ,shiftToBottomFromTopView.frame.size.width, shiftToBottomFromTopView.frame.size.height)];
         }
         else{
    [shiftToBottomFromTopView setFrame:CGRectMake(10, self.view.frame.size.height-45 ,shiftToBottomFromTopView.frame.size.width, shiftToBottomFromTopView.frame.size.height)];
         }
    
    [shiftToTopView setFrame:CGRectMake(10, shiftToTopView.frame.origin.y ,shiftToTopView.frame.size.width, shiftToTopView.frame.size.height)];
    
    [shiftToBottomView setFrame:CGRectMake(shiftToBottomView.frame.origin.x, shiftToBottomFromTopView.frame.origin.y+shiftToBottomFromTopView.frame.size.height+100 ,shiftToBottomView.frame.size.width, shiftToBottomView.frame.size.height)];
    [UIView commitAnimations];
        [self disableUndo];
        
    }
 }
#pragma mark Undo Enable/Disable
-(void)enableUndo{
    //apiCounter--;
    for (int k=0; k<mainArray.count; k++) {
        UIView*mainView= (UIView*)[self.view viewWithTag:k+1000];
        UIButton*undoButton = (UIButton*)[mainView viewWithTag:k+2000];
        undoButton.userInteractionEnabled = YES;
    }
}
-(void)disableUndo
{
     //apiCounter--;
    for (int k=0; k<mainArray.count; k++) {
         UIView*mainView= (UIView*)[self.view viewWithTag:k+1000];
        UIButton*undoButton = (UIButton*)[mainView viewWithTag:k+2000];
        undoButton.userInteractionEnabled = NO;
    }
}
#pragma mark others

-(void)acceptDeclineUndoAPI{
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
     if ([acceptDeclineString isEqualToString:@"3"]) {
         strWebService=[[NSString alloc]initWithFormat:@"%@undopitch",AppURL];
     }
     else  if ([acceptDeclineString isEqualToString:@"2"] ||[acceptDeclineString isEqualToString:@"1"] ) {
         strWebService=[[NSString alloc]initWithFormat:@"%@pitch_selector",AppURL];
     }
    NSLog(@"%@",strWebService);
    NSDictionary *dictParams;
    
    if ([acceptDeclineString isEqualToString:@"3"]) {
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:pitchIdToBeRemove,@"id",
                    nil];

    }
    else  if ([acceptDeclineString isEqualToString:@"2"] ||[acceptDeclineString isEqualToString:@"1"] ) {
       // dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:pitchIdToBeRemove,@"pitch_id",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",acceptDeclineString,@"status",
         //           nil];
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:pitchIdToBeRemove,@"pitch_id",acceptDeclineString,@"status",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]],@"user_id",@"2",@"create_from",
                    nil];


    }
    
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
-(void)crossAcceptPressed : (UIButton*)sender{
  
    if ([sender tag]>=4000) {
          declineOrAcceptButtonPressedInt = [sender tag]-3000;
        [self acceptThePitch:declineOrAcceptButtonPressedInt];
    }
    else{
          declineOrAcceptButtonPressedInt = [sender tag]-2000;
        [self declineThePitch:declineOrAcceptButtonPressedInt];
    }
}
-(void)detailButtonPressed :(UIButton*)sender{
    NSLog(@"detail button pressed %ld",(long)[sender tag]);
    PitchDetailsViewController*obj;
      obj=[self.storyboard instantiateViewControllerWithIdentifier:@"pitchDetailJournalist"];
    obj.strPitchId = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:[sender tag]-5000] pitchId]];
      [self.navigationController pushViewController:obj animated:YES];

}



#pragma mark Decline the Pitch
-(void)addGestureToTopView : (NSInteger)tag{
      UIView *addGestureView =(UIView*)[self.view viewWithTag:tag];
    UISwipeGestureRecognizer *recognizerRight;
    recognizerRight.delegate=self;
    recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [recognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [addGestureView addGestureRecognizer:recognizerRight];
    
    UISwipeGestureRecognizer *recognizerLeft;
    recognizerLeft.delegate=self;
    recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [recognizerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [addGestureView addGestureRecognizer:recognizerLeft];
}
-(void)declineThePitch :(NSInteger)tag{
    
    if (tag>=1000) {
        NSLog(@"%ld",(long)tag);
        acceptDeclineString= @"2";
        
        pitchIdToBeRemove = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:tag-1000] pitchId]];
        if (tag-999 == mainArray.count) {
            NSLog(@"equal");
            messageLabel.hidden = NO;
        }
        else{
            messageLabel.hidden = YES;
        }
        [self acceptDeclineUndoAPI];
        
        UIView *shiftDeletedView =(UIView*)[self.view viewWithTag:tag];
        // top view goes out of the screen
        UIView *shiftBottomToTopView =(UIView*)[self.view viewWithTag:tag+1];
        // bottom view goes to the top of the screen
        [self addGestureToTopView:shiftBottomToTopView.tag];// geture will be added to this view
        UIView *shiftToBottomView =(UIView*)[self.view viewWithTag:tag+2];
        // unseen view becomes the bottom view of the screen
        UIView *mainViewRemovePermanent =(UIView*)[self.view viewWithTag:tag-2]; // permanent remove view
        if ((tag-1)>=1000) {
            viewRemoverCounter++;
        }
        [mainViewRemovePermanent removeFromSuperview];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.9];
        [shiftDeletedView setFrame:CGRectMake(-1500, shiftDeletedView.frame.origin.y ,shiftDeletedView.frame.size.width, shiftDeletedView.frame.size.height)];
        [shiftBottomToTopView setFrame:CGRectMake(shiftBottomToTopView.frame.origin.x, shiftDeletedView.frame.origin.y ,shiftBottomToTopView.frame.size.width, shiftBottomToTopView.frame.size.height)];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
             [shiftToBottomView setFrame:CGRectMake(shiftToBottomView.frame.origin.x, self.view.frame.size.height-60 ,shiftToBottomView.frame.size.width, shiftToBottomView.frame.size.height)];
        }
        else{
             [shiftToBottomView setFrame:CGRectMake(shiftToBottomView.frame.origin.x, self.view.frame.size.height-45 ,shiftToBottomView.frame.size.width, shiftToBottomView.frame.size.height)];
        }
       
        [UIView commitAnimations];
        apiCounter++;
        if (apiCounter%5==1) {
            pageNumber = pageNumber+5;
            [self showPitches];
        }
        [self enableUndo];
    }
}
-(void)swipeLeft: (UISwipeGestureRecognizer *)swipe
{
    //decline
    NSLog(@"right to left gesture declining the pitch");
     [self declineThePitch:swipe.view.tag];
  }
#pragma mark Accept the Pitch
-(void)acceptThePitch :(NSInteger) tag{
    if (tag>=1000) {
         acceptDeclineString= @"1";
       // NSLog(@"%ld",tag+2);
        pitchIdToBeRemove = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:tag-1000] pitchId]];
        if (tag-999 == mainArray.count) {
            NSLog(@"equal");
            messageLabel.hidden = NO;
        }
        else{
            messageLabel.hidden = YES;
        }
        [self acceptDeclineUndoAPI];
        
        UIView *shiftDeletedView =(UIView*)[self.view viewWithTag:tag];
        // top view goes out of the screen
        UIView *shiftBottomToTopView =(UIView*)[self.view viewWithTag:tag+1];
        // bottom view goes to the top of the screen
          [self addGestureToTopView:shiftBottomToTopView.tag];// geture will be added to this view
        UIView *shiftToBottomView =(UIView*)[self.view viewWithTag:tag+2];
        // unseen view goes to the bottom of the screen
        UIView *mainViewRemovePermanent =(UIView*)[self.view viewWithTag:tag-2]; // permanent remove view
        if ((tag-1)>=1000) {
            viewRemoverCounter++;
        }
        [mainViewRemovePermanent removeFromSuperview];
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.9];
        [shiftDeletedView setFrame:CGRectMake(1500, shiftDeletedView.frame.origin.y ,shiftDeletedView.frame.size.width, shiftDeletedView.frame.size.height)];
        [shiftBottomToTopView setFrame:CGRectMake(shiftBottomToTopView.frame.origin.x, shiftDeletedView.frame.origin.y ,shiftBottomToTopView.frame.size.width, shiftBottomToTopView.frame.size.height)];
         if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
              [shiftToBottomView setFrame:CGRectMake(shiftToBottomView.frame.origin.x, self.view.frame.size.height-60 ,shiftToBottomView.frame.size.width, shiftToBottomView.frame.size.height)];
         }
         else{
        [shiftToBottomView setFrame:CGRectMake(shiftToBottomView.frame.origin.x, self.view.frame.size.height-45 ,shiftToBottomView.frame.size.width, shiftToBottomView.frame.size.height)];
         }
        NSLog(@"frame is %@ and class des %@",[NSValue valueWithCGRect:shiftToBottomView.frame],[[shiftToBottomView class]description]);
        [UIView commitAnimations];
        apiCounter++;
        if (apiCounter%5==1) {
            pageNumber = pageNumber+5;
            [self showPitches];
        }
        [self enableUndo];
    }
}
-(void)swipeRight: (UISwipeGestureRecognizer *)swipe
{
    //accept
    NSLog(@"left to right gesture accepting the pitch");
     NSLog(@"tag is %ld",(long)swipe.view.tag);
    [self acceptThePitch:swipe.view.tag];
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
             
             NSLog(@"portrait");
             if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
             {
                  int ycordinate = 90;
                 for ( int j=viewRemoverCounter; j<mainArray.count; j++) {
                     
                     UIView*mainView = (UIView*)[self.view viewWithTag:j+1000];
                      if ([mainView isKindOfClass:[UIView class]]) {
                     if (j==viewRemoverCounter) {
                         mainView.frame = CGRectMake(mainView.frame.origin.x, mainView.frame.origin.y, self.view.frame.size.width-20, mainView.frame.size.height);
                         if (viewRemoverCounter==0 ) {
                             if (mainView.frame.origin.x == -1500 || mainView.frame.origin.x == 1500) {
                                
                             }
                             else{
                                  ycordinate= ycordinate+self.view.frame.size.height-160;
                             }
                         }
                     }
                     else{
                         mainView.frame = CGRectMake(10, ycordinate, self.view.frame.size.width-20, mainView.frame.size.height);
                     }
                     UILabel*titleLabel = (UILabel*)[mainView viewWithTag:6000];
                     titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, mainView.frame.size.width-20, titleLabel.frame.size.height);
                     UILabel*desLabel = (UILabel*)[mainView viewWithTag:7000];
                     desLabel.frame = CGRectMake(desLabel.frame.origin.x, desLabel.frame.origin.y, mainView.frame.size.width-20, desLabel.frame.size.height);
                     UIImageView*headerImageView = (UIImageView*)[mainView viewWithTag:8000];
                      headerImageView.frame = CGRectMake(10, headerImageView.frame.origin.y, headerImageView.frame.size.width, headerImageView.frame.size.height);
                     UIView*bottomView = (UIView*)[mainView viewWithTag:9000];
                     bottomView.frame = CGRectMake(0, bottomView.frame.origin.y, bottomView.frame.size.width, bottomView.frame.size.height);

                     if (j!=viewRemoverCounter) {
                      ycordinate= ycordinate+self.view.frame.size.height-160;
                     }
                      }
                 }

                
             }
             
         }
         else if (orientation == UIInterfaceOrientationLandscapeLeft ||
                  orientation == UIInterfaceOrientationLandscapeRight)
         {
             NSLog(@"landscape");
             if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
             {
                 int ycordinate = 90;
                 for ( int j=viewRemoverCounter; j<mainArray.count; j++) {
                     
                     UIView*mainView = (UIView*)[self.view viewWithTag:j+1000];
                     

                     if ([mainView isKindOfClass:[UIView class]]) {
                         if (j==viewRemoverCounter) {
                         mainView.frame = CGRectMake(mainView.frame.origin.x, mainView.frame.origin.y, self.view.frame.size.width-20, mainView.frame.size.height);
                         if (viewRemoverCounter==0 ) {
                             if (mainView.frame.origin.x == -1500 || mainView.frame.origin.x == 1500) {
                             }
                             else{
                                 ycordinate= ycordinate+self.view.frame.size.height-160;
                             }

                           
                         }
                     }
                     else{
                      mainView.frame = CGRectMake(10, ycordinate, self.view.frame.size.width-20, mainView.frame.size.height);
                     }
                     UILabel*titleLabel = (UILabel*)[mainView viewWithTag:6000];
                     titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, mainView.frame.size.width-20, titleLabel.frame.size.height);
                     UILabel*desLabel = (UILabel*)[mainView viewWithTag:7000];
                     desLabel.frame = CGRectMake(desLabel.frame.origin.x, desLabel.frame.origin.y, mainView.frame.size.width-20, desLabel.frame.size.height);
                     UIImageView*headerImageView = (UIImageView*)[mainView viewWithTag:8000];
                     int xCord = self.view.frame.size.width-768;
                      headerImageView.frame = CGRectMake(xCord/2, headerImageView.frame.origin.y, headerImageView.frame.size.width, headerImageView.frame.size.height);
                     UIView*bottomView = (UIView*)[mainView viewWithTag:9000];
                     
                     int x = self.view.frame.size.width-bottomView.frame.size.width;
                     
                     bottomView.frame = CGRectMake(x/2, bottomView.frame.origin.y, bottomView.frame.size.width, bottomView.frame.size.height);
                     
                       if (j!=viewRemoverCounter) {
                     ycordinate= ycordinate+self.view.frame.size.height-160;
                       }
                     }
                 }

             }
             
         }
         
         // do whatever
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
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

- (IBAction)test:(id)sender {
    PitchDetailsViewController*obj;
    obj=[self.storyboard instantiateViewControllerWithIdentifier:@"pitchDetailJournalist"];
    [self.navigationController pushViewController:obj animated:YES];
}

- (IBAction)forward:(id)sender {
    PitchDetailsViewController*obj;
    obj=[self.storyboard instantiateViewControllerWithIdentifier:@"pitchDetailJournalist"];
    obj.strPitchId = @"8";
    [self.navigationController pushViewController:obj animated:YES];
}
@end
