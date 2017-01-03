 //
//  MainViewController_Client.m
//  uPitch
//
//  Created by Puneet Rao on 10/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import "MainViewController_Client.h"
#import "SWRevealViewController.h"
#import "ComposeViewController.h"
#import "CustomCellManagePitchClient.h"
#import "LxReqRespManager.h"
#import "UIImageView+WebCache.h"
#import "MainViewObjectClass.h"
#import "ComposeViewController.h"
#import "PitchDetailsViewController.h"
#import "manageJournalistViewController.h"
#import "constant.h"
@interface MainViewController_Client ()


@end

@implementation MainViewController_Client

- (void)viewDidLoad {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PubNubNotification:) name:@"pubnubnot" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upgradeNotification:) name:@"clientReload" object:nil];
    
    SWRevealViewController *revealController = [self revealViewController];
    revealController.delegate = self;
    [super viewDidLoad];
    //NSMutableArray*test = [[NSMutableArray alloc]init];
   // NSLog(@"%@",[test objectAtIndex:1]);
    
    // Do any additional setup after loading the view.
}
-(void)upgradeNotification:(NSNotification *) notification
{
    [self showPitches];
}
-(void)PubNubNotification:(NSNotification *) notification
{
    [self getCount];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self getCount];
    self.navigationController.navigationBar.hidden=YES;
    counter = 0;
    appdelegateInstance = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    tableVw.delegate = nil;
    tableVw.dataSource = nil;
    tableVw.hidden = YES;
    composeButton.userInteractionEnabled = YES;
    [self showPitches];
    
    [self leftSlider];
    [super viewWillAppear:animated];
    // self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
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

//    
//    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]integerValue]>0)
//    {
//        lblCount.hidden=NO;
//        imgCount.hidden=NO;
//        NSInteger show=[[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]integerValue]+[[[NSUserDefaults standardUserDefaults] valueForKey:@"MinusCount"] integerValue];
//        lblCount.text=[NSString stringWithFormat:@"%ld",(long)show];
//        //lblCount.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]];
//    }
//    else
//    {
//         if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"MinusCount"]integerValue]>0)
//         {
//           lblCount.hidden=NO;
//           imgCount.hidden=NO;
//           lblCount.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"MinusCount"]];
//             
//         }
//         else
//         {
//        lblCount.hidden=YES;
//        imgCount.hidden=YES;
//         }
//    }
}
-(void)showPitches{
    
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService=[[NSString alloc]initWithFormat:@"%@showpitch",AppURL];
    NSLog(@"%@",strWebService);
    NSDictionary *dictParams;
    
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",
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
                 userAccountType = [NSString stringWithFormat:@"%@",[response valueForKey:@"account_type"]];
                 mainArray=[[NSMutableArray alloc]init];
                 for (int k=0; k<[[response valueForKey:@"data"] count]; k++) {
                     MainViewObjectClass* objectClass = [[MainViewObjectClass alloc] init];
                     
                     objectClass.pitchId=[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"id"] objectAtIndex:k] ;
                      objectClass.pitchTitle=[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"title"] objectAtIndex:k] ;
                      objectClass.pitchDesc=[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"description"] objectAtIndex:k] ;
                      objectClass.status=[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"status"] objectAtIndex:k] ;
                      objectClass.coverImage=[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"image1_new"] objectAtIndex:k] ;
                     objectClass.strPitchBlock=[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"pitch_block"] objectAtIndex:k] ;
                     
               
                     [mainArray addObject:objectClass];
                 }
                 
                 for (int j=0 ; j<[mainArray count]; j++) {
                     if ([[[mainArray objectAtIndex:j] status] isEqualToString:@"1"]) {
                        // composeButton.userInteractionEnabled = NO;
                     }
                     else{
                         counter++;
                     }
                     
                 }
               //  mainArray =[[NSMutableArray alloc]init];
                 if (mainArray.count>0) {
                     messageLabel.hidden = YES;
                     tableVw.delegate = self;
                     tableVw.dataSource = self;
                     tableVw.hidden = NO;
                     [tableVw reloadData];
                     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                     [self setOrientation];
                     }
                 }
                 else{
                     messageLabel.hidden = NO;
//                     UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"You does not have any pitch." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                     [alert show];
                 }
                 
                 
             }
            else  if ([str isEqualToString:@"1"] )
             {
                   messageLabel.hidden = NO;
             }
            else if ([str isEqualToString:@"10"] )
             {
                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 alert.tag = 1234;
                 [alert show];
             }
             else if ([response valueForKey:@"Failure"] )
             {
//                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"Failure"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                 [alert show];
                 [constant alertViewWithMessage:[response valueForKey:@"Failure"]withView:self];
             }
             else{
                 if (response == nil||response == (id)[NSNull null])
                 {
//                     UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"upitch" message:@"An unknown error has occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                     [alert show];
                     [constant alertViewWithMessage:@"An unknown error has occurred." withView:self];
                 }
                 else
                 {
//                     UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"upitch" message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                     [alert show];
                     [constant alertViewWithMessage:[response valueForKey:@"message"]withView:self];
                 }
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
-(void)leftSlider
{
    SWRevealViewController *revealController = [self revealViewController];
    revealController.panGestureRecognizer.enabled = YES;
    revealController.tapGestureRecognizer.enabled = YES;
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
 //   [button setBackgroundImage:[UIImage imageNamed:@"menu56.png"] forState:UIControlStateNormal];
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
    button.frame = CGRectMake(0, 0, 70, 70);
     }
     else{
          button.frame = CGRectMake(0, 0, 60, 60);
     }
   // button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    // Disable iOS 7 back gesture
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//    }
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
     [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Enable iOS 7 back gesture
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//        self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    }
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}
-(void)detailPage :(id)sender{
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableVw];
    NSIndexPath *indexPath = [tableVw indexPathForRowAtPoint:buttonPosition];
    
    if ([[[mainArray objectAtIndex:indexPath.row] status] isEqualToString:@"1"]) {
        ComposeViewController*obj;
        obj=[self.storyboard instantiateViewControllerWithIdentifier:@"composePitch"];
        obj.EditNewString= @"Edit";
        obj.pitchIdString = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row] pitchId]];
        obj.pitchActiveExpireStatusString = @"0";
        [self.navigationController pushViewController:obj animated:YES];
    }
}

-(void)deletePitch :(NSString*)idOfPitch{
    
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService=[[NSString alloc]initWithFormat:@"%@deletepitch",AppURL];
    NSLog(@"%@",strWebService);
    NSDictionary *dictParams;
    
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",idOfPitch],@"pitch_id",
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
                 [mainArray removeObjectAtIndex:deletedIndex];
                 [tableVw reloadData];
                 if (mainArray.count==0)
                 {
                      messageLabel.hidden = NO;
                     tableVw.hidden=YES;
                 }
              }
             else  if ([str isEqualToString:@"1"] )
             {
                 
                 
             }
             else if ([str isEqualToString:@"10"] )
             {
                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 alert.tag = 1234;
                 [alert show];
             }
             else
             {
                 if (response == nil||response == (id)[NSNull null])
                 {
//                     UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"upitch" message:@"An unknown error has occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                     [alert show];
                     [constant alertViewWithMessage:@"An unknown error has occurred."withView:self];
                 }
                 else
                 {
//                     UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//                     [alert show];
                     [constant alertViewWithMessage:[response valueForKey:@"message"]withView:self];
                 }
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
#pragma mark Table View Delegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    //if (indexPath.row>0) {
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            deletedIndex = indexPath.row;
            [self deletePitch:[NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row] pitchId]]];
        }
  //  }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
//    if ([[[mainArray objectAtIndex:indexPath.row] status] isEqualToString:@"1"]) {
//        ComposeViewController*obj;
//        obj=[self.storyboard instantiateViewControllerWithIdentifier:@"composePitch"];
//        obj.EditNewString= @"Edit";
//        obj.pitchIdString = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row] pitchId]];
//        obj.pitchActiveExpireStatusString = @"0";
//        
//        [self.navigationController pushViewController:obj animated:YES];
//    }

    
        if ([[[mainArray objectAtIndex:indexPath.row] status] isEqualToString:@"0"]) {
        
        PitchDetailsViewController*obj;
        obj=[self.storyboard instantiateViewControllerWithIdentifier:@"pitchDetailJournalist"];
        obj.clientJournalistString = @"1";
        obj.strPitchId = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row] pitchId]];
        [self.navigationController pushViewController:obj animated:YES];
        }
        else
        {
            ComposeViewController*obj;
                    obj=[self.storyboard instantiateViewControllerWithIdentifier:@"composePitch"];
                    obj.EditNewString= @"Edit";
                    obj.pitchIdString = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row] pitchId]];
                    obj.pitchActiveExpireStatusString = @"0";
            
                    [self.navigationController pushViewController:obj animated:YES];
        
        }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                
                                     reuseIdentifier:SimpleTableIdentifier] ;
                tableView.backgroundColor=[UIColor colorWithRed:250.0f/255.0f green:249.0f/255.0f blue:250.0f/255.0f alpha:1.0f];
                
                UIImageView*leftImageView= [[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 22, 33)];
                leftImageView.tag = 10;
                [cell.contentView addSubview:leftImageView];
        
            UIImageView*rightImageView= [[UIImageView alloc]init];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            
            UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
            if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortrait) {
                rightImageView.frame = CGRectMake(980, 54, 27, 41);
            }
            else{
                rightImageView.frame = CGRectMake(700, 54, 27, 41);
            }
            
        }
        else {
             rightImageView.frame= CGRectMake(self.view.frame.size.width-30, 38, 14, 23);
        }
                rightImageView.tag = 20;
                [cell.contentView addSubview:rightImageView];
                
                UIImageView*dividerImageView= [[UIImageView alloc]initWithFrame:CGRectMake(50, 10, 2, 80)];
                dividerImageView.tag = 80;
                dividerImageView.backgroundColor = [UIColor lightGrayColor];
                [cell.contentView addSubview:dividerImageView];
                
                
                UIImageView*middleImageView= [[UIImageView alloc]initWithFrame:CGRectMake(70, 20, 90, 60)];
                middleImageView.tag = 70;
                [cell.contentView addSubview:middleImageView];
                
                UILabel*pitchTitle= [[UILabel alloc]initWithFrame:CGRectMake(170, 16, self.view.frame.size.width-200, 21)];
                pitchTitle.tag = 30;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            
            pitchTitle.frame = CGRectMake(290, 16, 420, 85);
        }

                [cell.contentView addSubview:pitchTitle];
                
        UILabel*pitchDes= [[UILabel alloc]initWithFrame:CGRectMake(170, 39, self.view.frame.size.width-210, 53)];
        pitchDes.tag = 40;
         pitchDes.font  = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            
            pitchDes.frame = CGRectMake(290, 45, 420, 85);
             pitchDes.font  = [UIFont fontWithName:@"HelveticaNeue-Light" size:26];
        }
                pitchDes.textColor= [UIColor colorWithRed:108.0f/255.0f green:108.0f/255.0f blue:108.0f/255.0f alpha:1.0];
        
                pitchDes.numberOfLines=0;
                [cell.contentView addSubview:pitchDes];

         //NSLog(@"%@",[NSValue valueWithCGRect:pitchDes.frame]);
        
                UIButton*rightCustomButton = [UIButton buttonWithType:UIButtonTypeCustom];
                rightCustomButton.frame = CGRectMake(self.view.frame.size.width-45, 27, 45, 45);
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            
            rightCustomButton.frame = CGRectMake(700, 40, 65, 65);
        }

                rightCustomButton.tag = 50;
                [rightCustomButton addTarget:self action:@selector(detailPage:) forControlEvents:UIControlEventTouchUpInside];
                 [cell.contentView addSubview:rightCustomButton];
        
        }
    UIImageView*leftImageView = (UIImageView*)[cell viewWithTag:10];
    UIImageView*dividerImageView = (UIImageView*)[cell viewWithTag:80];
    UIImageView*middleImageView = (UIImageView*)[cell viewWithTag:70];
    UIImageView*rightImageView = (UIImageView*)[cell viewWithTag:20];
    UILabel*pitchTitle = (UILabel*)[cell viewWithTag:30];
    UILabel*pitchDesc = (UILabel*)[cell viewWithTag:40];
     UIButton*rightButton = (UIButton*)[cell viewWithTag:50];
    
    middleImageView.layer.borderColor = [UIColor blackColor].CGColor;
    middleImageView.layer.borderWidth=0.2f;
    middleImageView.layer.cornerRadius = 2;
    middleImageView.layer.masksToBounds = YES;
    
    
     pitchTitle.frame = CGRectMake(pitchTitle.frame.origin.x, pitchTitle.frame.origin.y, self.view.frame.size.width-200, pitchTitle.frame.size.height);
 
    
    pitchTitle.text = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row] pitchTitle]];
    pitchDesc.text = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row] pitchDesc]];
    
    if ([[[mainArray objectAtIndex:indexPath.row] pitchDesc] isEqualToString:@"0"]) {
        
    }
    
    NSString*statusStr= [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row] status]];
    if ([statusStr isEqualToString:@"1"])
    {
        [leftImageView setImage:[UIImage imageNamed:@"Formas 1.png"]];
        [rightImageView setImage:[UIImage imageNamed:@"pencil.png"]];
        leftImageView.frame = CGRectMake(leftImageView.frame.origin.x, 32, 30, 37);
       
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            leftImageView.frame = CGRectMake(leftImageView.frame.origin.x, 47, 45, 56);
            UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
            if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortrait) {
            rightImageView.frame = CGRectMake(720, 59, 30, 33);
            }
            else{
                 rightImageView.frame = CGRectMake(980, 59, 30, 33);
            }
        }
        else{
             rightImageView.frame = CGRectMake(rightImageView.frame.origin.x, 40, 20, 21);
        }
    }
    else{
        [leftImageView setImage:[UIImage imageNamed:@"cut.png"]];
        [rightImageView setImage:[UIImage imageNamed:@"right_arrow.png"]];
       //  leftImageView.frame = CGRectMake(leftImageView.frame.origin.x, 30, 27, 39);
         rightImageView.frame = CGRectMake(rightImageView.frame.origin.x, 39, 12, 22);
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            leftImageView.frame = CGRectMake(leftImageView.frame.origin.x, 46, 42, 58);
          
           
            rightImageView.frame = CGRectMake(self.view.frame.size.width-38, 59, 18, 33);
           
        }
    }
    
    
  //  NSLog(@"pitch frame is %@",[NSValue valueWithCGRect:pitchDesc.frame]);
    int labelfontSize;
    int maxHeight;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        labelfontSize =26;
        maxHeight =85;
    }
    else{
      labelfontSize =13;
         maxHeight =53;
    }
    CGSize constraintSize;
    constraintSize.height = MAXFLOAT;
    constraintSize.width = pitchDesc.frame.size.width;
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:@"HelveticaNeue-Light" size:labelfontSize], NSFontAttributeName,
                                          nil];
    
    CGRect frame = [pitchDesc.text boundingRectWithSize:constraintSize
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:attributesDictionary
                                                context:nil];
    
    CGSize stringSize = frame.size;
    if (stringSize.height>maxHeight) {
        stringSize.height = maxHeight;
    }
    pitchDesc.frame = CGRectMake(pitchDesc.frame.origin.x, pitchDesc.frame.origin.y, pitchDesc.frame.size.width, stringSize.height);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        pitchTitle.frame = CGRectMake(290, pitchTitle.frame.origin.y, self.view.frame.size.width-340, 30);
        
          middleImageView.frame = CGRectMake(120, 25, 150, 100);
        dividerImageView.frame = CGRectMake(85, 10, 2, 130);
        
     pitchDesc.font  = [UIFont fontWithName:@"HelveticaNeue-Light" size:23];
        pitchTitle.font  = [UIFont fontWithName:@"HelveticaNeue-Light" size:26];
//        
//        
//        CGSize constraintSize;
//        constraintSize.height = MAXFLOAT;
//        constraintSize.width = pitchDesc.frame.size.width;
//        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                              [UIFont fontWithName:@"HelveticaNeue-Light" size:26], NSFontAttributeName,
//                                              nil];
//        
//        CGRect frame = [pitchDesc.text boundingRectWithSize:constraintSize
//                                                    options:NSStringDrawingUsesLineFragmentOrigin
//                                                 attributes:attributesDictionary
//                                                    context:nil];
//        
//        CGSize stringSize = frame.size;
//        if (stringSize.height>85) {
//            stringSize.height = 85;
//        }
      //  pitchDesc.frame = CGRectMake(pitchDesc.frame.origin.x, pitchDesc.frame.origin.y, pitchDesc.frame.size.width, stringSize.height);
        
    }
    else{
       // NSLog(@"frame is %@",[NSValue valueWithCGRect:pitchDesc.frame]);
         pitchDesc.frame = CGRectMake(pitchDesc.frame.origin.x, pitchDesc.frame.origin.y, pitchDesc.frame.size.width, pitchDesc.frame.size.height);
    }
   
     rightButton.frame = CGRectMake(rightImageView.frame.origin.x-5, rightImageView.frame.origin.y-5, rightButton.frame.size.width, rightButton.frame.size.height);
    
    
    NSURL*Url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:indexPath.row] coverImage]]];
   // NSLog(@"%@",Url1);
    [middleImageView setImageWithURL:Url1 placeholderImage:[UIImage imageNamed:@""] imagesize:CGSizeMake(100, 100)];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
         return 150;
     }
    return 100;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mainArray.count;
}
-(void)setOrientation{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortrait) {
        NSLog(@"portrait");
        UILabel*desLabel;
         UILabel*titleLabel;
        UIImageView*rightImageView;
        UIButton*rightButton;
        for (int i=0; i<mainArray.count; i++) {
            NSIndexPath *idxCell = [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *cell = [tableVw cellForRowAtIndexPath:idxCell];
            desLabel=(UILabel*)[cell viewWithTag:40];
             titleLabel=(UILabel*)[cell viewWithTag:30];
            rightImageView=(UIImageView*)[cell viewWithTag:20];
            rightButton=(UIButton*)[cell viewWithTag:50];
            desLabel.frame = CGRectMake(290, desLabel.frame.origin.y, 420, desLabel.frame.size.height);
             titleLabel.frame = CGRectMake(290, titleLabel.frame.origin.y, 420, titleLabel.frame.size.height);
            
            NSString*statusStr= [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:i] status]];
            if ([statusStr isEqualToString:@"1"]) {
                rightImageView.frame = CGRectMake(720, 59, 30, 33);
            }
            else{
                rightImageView.frame = CGRectMake(self.view.frame.size.width-38, 59, 18, 33);
            }
            rightButton.frame = CGRectMake(rightImageView.frame.origin.x-15, rightButton.frame.origin.y, rightButton.frame.size.width, rightButton.frame.size.height);
            
        }
        
    }
    else if (orientation == UIInterfaceOrientationLandscapeLeft ||
             orientation == UIInterfaceOrientationLandscapeRight)
    {
        NSLog(@"landscape");
        UILabel*desLabel;
        UIImageView*rightImageView;
        UIButton*rightButton;
        UILabel*titleLabel;
        for (int i=0; i<mainArray.count; i++) {
            NSIndexPath *idxCell = [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *cell = [tableVw cellForRowAtIndexPath:idxCell];
            desLabel=(UILabel*)[cell viewWithTag:40];
            rightImageView=(UIImageView*)[cell viewWithTag:20];
            rightButton=(UIButton*)[cell viewWithTag:50];
            desLabel.frame = CGRectMake(290, desLabel.frame.origin.y, 660, desLabel.frame.size.height);
             titleLabel.frame = CGRectMake(290, titleLabel.frame.origin.y, 660, titleLabel.frame.size.height);
            
            NSString*statusStr= [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:i] status]];
            if ([statusStr isEqualToString:@"1"]) {
                rightImageView.frame = CGRectMake(980, 59, 30, 33);
            }
            else{
                rightImageView.frame = CGRectMake(self.view.frame.size.width-38, 59, 18, 33);
            }
            rightButton.frame = CGRectMake(rightImageView.frame.origin.x-15, rightButton.frame.origin.y, rightButton.frame.size.width, rightButton.frame.size.height);
        }
    }

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
- (IBAction)chatIconPressed:(id)sender {
//    [[NSUserDefaults standardUserDefaults]setObject:@"showChatScreen" forKey:@"directCall"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
        SWRevealViewController *revealController = self.revealViewController;
        manageJournalistViewController*obj;
    
        obj=[self.storyboard instantiateViewControllerWithIdentifier:@"manageJournalists"];
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

- (IBAction)pitchesButtonPressed:(id)sender {
    counter =0 ;
     [self showPitches];
}
- (IBAction)matchesButtonAction:(id)sender
{
    if ([userAccountType isEqualToString:@"1"])
    {
        NSString *strStatus;
        for (MainViewObjectClass *obj in mainArray) {
            
            if ([obj.status integerValue]==1) {
                strStatus=@"1";
                break;
            }
        }

        if ([strStatus integerValue]==1)
        {
           UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"You are only allowed 1 live pitch at a time. If you are a Publicist and would like a free trial upgrade please request by going to filter/settings." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag  = 100;
            [alert show];
        }else{
            ComposeViewController*obj;
            obj=[self.storyboard instantiateViewControllerWithIdentifier:@"composePitch"];
            obj.EditNewString= @"New";
            obj.pitchActiveExpireStatusString = @"0";
            [self.navigationController pushViewController:obj animated:YES];
            
        }

        

    }
    else if ([userAccountType isEqualToString:@"3"]){
       
        
        NSString *strMaintainStatus;
        for (MainViewObjectClass *obj in mainArray) {
            
            if ([obj.status integerValue]==1) {
                strMaintainStatus=@"1";
                break;
            }
        }
        if ([strMaintainStatus integerValue]==1)
        {
//            UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Request for Free Upgrade is pending for approval." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
            [constant alertViewWithMessage:@"Request for Free Upgrade is pending for approval."withView:self];
        }else{
            ComposeViewController*obj;
            obj=[self.storyboard instantiateViewControllerWithIdentifier:@"composePitch"];
            obj.EditNewString= @"New";
            obj.pitchActiveExpireStatusString = @"0";
            [self.navigationController pushViewController:obj animated:YES];

        }
        
    }
    else{
        ComposeViewController*obj;
        obj=[self.storyboard instantiateViewControllerWithIdentifier:@"composePitch"];
        obj.EditNewString= @"New";
        obj.pitchActiveExpireStatusString = @"0";
        [self.navigationController pushViewController:obj animated:YES];
    }
//    if (mainArray.count == counter) {
//        ComposeViewController*obj;
//        obj=[self.storyboard instantiateViewControllerWithIdentifier:@"composePitch"];
//        obj.EditNewString= @"New";
//        obj.pitchActiveExpireStatusString = @"0";
//        [self.navigationController pushViewController:obj animated:YES];
//    }
}
-(void)upgradeUser{
    
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService=[[NSString alloc]initWithFormat:@"%@save_client_account",AppURL];
    NSLog(@"%@",strWebService);
    NSDictionary *dictParams;
    
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",
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
                 userAccountType = @"3";
//                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                 [alert show];
                 [constant alertViewWithMessage:[response valueForKey:@"message"]withView:self];
//                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Request sent successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                 [alert show];
                 composeButton.userInteractionEnabled = YES;
              }
             else if ([str isEqualToString:@"1"] )
             {
//                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"Failure"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                 [alert show];
                 [constant alertViewWithMessage:[response valueForKey:@"Failure"]withView:self];
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==100)
    {
        if (buttonIndex==0) {
        }
        else if(buttonIndex==1) {
            [self upgradeUser];
        }
    }
   
    if (alertView.tag==1234) {
        AppDelegate *appd= (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appd LogoutFromApp:self];
    }
    
}
#pragma mark orientation Method
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
             UILabel*desLabel;
              UILabel*titleLabel;
             UIImageView*rightImageView;
             UIButton*rightButton;
                 for (int i=0; i<mainArray.count; i++) {
                     NSIndexPath *idxCell = [NSIndexPath indexPathForRow:i inSection:0];
                     UITableViewCell *cell = [tableVw cellForRowAtIndexPath:idxCell];
                     desLabel=(UILabel*)[cell viewWithTag:40];
                      titleLabel=(UILabel*)[cell viewWithTag:30];
                    rightImageView=(UIImageView*)[cell viewWithTag:20];
                      rightButton=(UIButton*)[cell viewWithTag:50];
                     desLabel.frame = CGRectMake(290, desLabel.frame.origin.y, 420, desLabel.frame.size.height);
                    
                     titleLabel.frame = CGRectMake(290, titleLabel.frame.origin.y, 400, titleLabel.frame.size.height);
                    //  NSLog(@"portrait %@",[NSValue valueWithCGRect:titleLabel.frame]);
                     
                     NSString*statusStr= [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:i] status]];
                     if ([statusStr isEqualToString:@"1"]) {
                         rightImageView.frame = CGRectMake(720, 59, 30, 33);
                          }
                     else{
                          rightImageView.frame = CGRectMake(self.view.frame.size.width-38, 59, 18, 33);
                     }
                     rightButton.frame = CGRectMake(rightImageView.frame.origin.x-15, rightButton.frame.origin.y, rightButton.frame.size.width, rightButton.frame.size.height);
                    
                 }
             
         }
         else if (orientation == UIInterfaceOrientationLandscapeLeft ||
                  orientation == UIInterfaceOrientationLandscapeRight)
         {
             NSLog(@"landscape");
             UILabel*desLabel;
               UILabel*titleLabel;
              UIImageView*rightImageView;
              UIButton*rightButton;
             for (int i=0; i<mainArray.count; i++) {
                 NSIndexPath *idxCell = [NSIndexPath indexPathForRow:i inSection:0];
                 UITableViewCell *cell = [tableVw cellForRowAtIndexPath:idxCell];
                 desLabel=(UILabel*)[cell viewWithTag:40];
                   titleLabel=(UILabel*)[cell viewWithTag:30];
                  rightImageView=(UIImageView*)[cell viewWithTag:20];
                  rightButton=(UIButton*)[cell viewWithTag:50];
                 desLabel.frame = CGRectMake(290, desLabel.frame.origin.y, 660, desLabel.frame.size.height);
               
                 titleLabel.frame = CGRectMake(290, titleLabel.frame.origin.y, 660, titleLabel.frame.size.height);
                // NSLog(@"landscape %@",[NSValue valueWithCGRect:titleLabel.frame]);
                 
                 NSString*statusStr= [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:i] status]];
                 if ([statusStr isEqualToString:@"1"]) {
                     rightImageView.frame = CGRectMake(980, 59, 30, 33);
                 }
                 else{
                     rightImageView.frame = CGRectMake(self.view.frame.size.width-38, 59, 18, 33);
                 }
                   rightButton.frame = CGRectMake(rightImageView.frame.origin.x-15, rightButton.frame.origin.y, rightButton.frame.size.width, rightButton.frame.size.height);
             }
         }
         
         // do whatever
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}
@end
