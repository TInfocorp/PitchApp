//
//  ProfileViewController.m
//  uPitch
//
//  Created by Puneet Rao on 10/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import "ProfileViewController.h"
#import "SWRevealViewController.h"
#import "ProfileCellTableViewCell.h"
#import "LxReqRespManager.h"
#import "UIImageView+WebCache.h"
#import "profileObjectclass.h"
#import "manageJournalistViewController.h"
#import "viewPitchesViewController_Journalists.h"
#import "AddUserProfileViewController.h"
#import "Utils.h"
#import "ProfileCellTableViewCell.h"
#import "PitchFeedJournalist_ViewController.h"
#import "MainViewController_Client.h"
#import "constant.h"
#import "WelComeVC.h"
@interface ProfileViewController ()
{
    NSString *strProfileComplete;
    UIImage *ImgDummy;
    NSData *dataDummy;
}

@end

@implementation ProfileViewController
@synthesize userIDShowProfile,comeFromSring;
-(void)sendNotification{
    
  
}
#pragma mark View Delegate
- (void)viewDidLoad {
    
    ImgDummy=[UIImage imageNamed:@"userDefault.jpg"];
    dataDummy = UIImagePNGRepresentation(ImgDummy);
    [toolBar removeFromSuperview];
    reasinTextView.inputAccessoryView=toolBar;
    lblReason.frame=CGRectMake(reasinTextView.frame.origin.x+2, lblReason.frame.origin.y, lblReason.frame.size.width, lblReason.frame.size.height);
    [self loadInitialdata];
    [super viewDidLoad];
}
-(void)getUserData{
    
    //[appdelegateInstance showHUD:@""];
    [appdelegateInstance showHUD:@"Loading Profile"];
    //    leftMenuIcon.hidden = NO;
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService=[[NSString alloc]initWithFormat:@"%@userprofilenew",AppURL];
    NSDictionary *dictParams;
    NSLog(@"s%@s",userIDShowProfile);
    if ([userIDShowProfile length]==0) {
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:
                    [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",
                    nil];
        
        //send 0
    }
    else{
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:
                    userIDShowProfile,@"user_id",
                    @"0",@"rtag",nil];
        
        //Send1
    }
    
    NSLog(@"%@",strWebService);
    NSLog(@"%@",dictParams);
    
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
             if (response == nil) {
                 saveButton.hidden = YES;
                 leftMenuIcon.hidden = NO;
                 [self leftSlider];
                 
                 //                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Connectivity levels low. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 //                 [alert show];
                 [constant AlertMessageWithString:@"Connectivity levels low. Please try again." andWithView:self.view];
             }
             [appdelegateInstance hideHUD];
             NSString*str = [NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             if ([str isEqualToString:@"0"])
             {
                 userFirstNameString = [NSString stringWithFormat:@"%@",[[[response valueForKey:@"data"] valueForKey:@"User"] valueForKey:@"first_name"]];
                 userLastNameString = [NSString stringWithFormat:@"%@",[[[response valueForKey:@"data"] valueForKey:@"User"] valueForKey:@"last_name"]];
                 companyNameString = [NSString stringWithFormat:@"%@",[[[response valueForKey:@"data"] valueForKey:@"User"] valueForKey:@"company"]];
                 designationNameString = [NSString stringWithFormat:@"%@",[[[response valueForKey:@"data"] valueForKey:@"User"] valueForKey:@"designation"]];
                 
                 if ([[[[response valueForKey:@"data"] valueForKey:@"User"] valueForKey:@"profile_tag"]integerValue]==1)
                 {
                     strProfileComplete=@"complete";
                     [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:KEY_PROFILE_TAG];
                 }else{
                     [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:KEY_PROFILE_TAG];
                 }
                 
                 if ([userIDShowProfile length]==0){
                     [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",userFirstNameString] forKey:@"username"];
                     
                     [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@ %@",userFirstNameString,userLastNameString] forKey:@"fullName"];
                     
                     [[NSUserDefaults standardUserDefaults]synchronize];
                 }
                 
                 if ([strProfileComplete isEqualToString:@"complete"])
                 {
                     if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"first"]isEqualToString:@"onsignup"]&&![companyNameString isEqualToString:@""]) {
                         UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Profile updated successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                         alert.tag=1001;
                         [alert show];
                         [[NSUserDefaults standardUserDefaults]setObject:@"NotOnSignup" forKey:@"first"];
                     }else{
                         [[NSUserDefaults standardUserDefaults]setObject:@"NotOnSignup" forKey:@"first"];
                     }
                 }
                 
                 
                 
                 if ([userFirstNameString isEqualToString:@""] || [userFirstNameString length]==0) {
                     
                     saveButton.hidden = NO;
                     logoutButton.hidden = NO;
                     leftMenuIcon.hidden = YES;
                     SWRevealViewController *revealController = [self revealViewController];
                     revealController.panGestureRecognizer.enabled = NO;
                     revealController.tapGestureRecognizer.enabled = NO;
                 }
                 else{
                     logoutButton.hidden = YES;
                     backButton.hidden = NO;
                     saveButton.hidden = NO;
                     if ([comeFromSring isEqualToString:@"1"]) {
                         saveButton.hidden = YES;
                     }
                     else{
                         leftMenuIcon.hidden = NO;
                         [self leftSlider];
                     }
                     SWRevealViewController *revealController = [self revealViewController];
                     revealController.panGestureRecognizer.enabled = YES;
                     revealController.tapGestureRecognizer.enabled = YES;
                     
                 }
                 sharedConnectionCount = [[[[response valueForKey:@"data"] valueForKey:@"User"] valueForKey:@"count_connection"] integerValue];
                 
                 userImageUrl = [NSString stringWithFormat:@"%@",[[[response valueForKey:@"data"] valueForKey:@"User"] valueForKey:@"photo"]];
                 if ([[[[response valueForKey:@"data"] valueForKey:@"User"] valueForKey:@"photo"] isEqualToString:@""]|| [[[[response valueForKey:@"data"] valueForKey:@"User"] valueForKey:@"photo"] length]==0) {
                     [userImageView setImage:[UIImage imageNamed:@"userDefault.jpg"]];
                 }
                 else{
                     [userImageView setImageWithURL:[NSURL URLWithString:userImageUrl] placeholderImage:[UIImage imageNamed:@"userDefault.jpg"] imagesize:CGSizeMake(400, 400)];
                 }
                 
                 userImageView.layer.cornerRadius = userImageView.frame.size.height/2;
                 userImageView.layer.masksToBounds = YES;
                 
                 NSDictionary*innerDict = [response valueForKey:@"data"];
                 
                 for (NSString *key in [innerDict allKeys])
                 {
                     if ([[innerDict valueForKey:key] isKindOfClass:[NSDictionary class]])
                     {
                     }
                     else if ([[innerDict valueForKey:key] isKindOfClass:[NSMutableArray class]]){
                         
                         if ([key isEqualToString:@"User_Connections"]) {
                             
                             profileObjectclass *profileObject=[profileObjectclass new];
                             // [titleHeaderArray replaceObjectAtIndex:3 withObject:@"Shared Connection"];
                             profileObject.conn_Name = [[NSMutableArray alloc]init];
                             profileObject.conn_Imageurl = [[NSMutableArray alloc]init];
                             for (int h=0; h< [[innerDict valueForKey:key] count]; h++) {
                                 [profileObject.conn_Name addObject:[[[innerDict valueForKey:key] valueForKey:@"share_name"] objectAtIndex:h]];
                                 [profileObject.conn_Imageurl addObject:[[[innerDict valueForKey:key] valueForKey:@"share_url"] objectAtIndex:h]];
                             }
                             //                             [mainArray addObject:profileObject];
                             [mainArray replaceObjectAtIndex:3 withObject:profileObject];
                         }
                         if ([key isEqualToString:@"User_Educations"]) {
                             profileObjectclass *profileObject=[profileObjectclass new];
                             // [titleHeaderArray replaceObjectAtIndex:2 withObject:@"Education"];
                             profileObject.edu_Name = [[NSMutableArray alloc]init];
                             profileObject.edu_Degree = [[NSMutableArray alloc]init];
                             profileObject.edu_Time_From = [[NSMutableArray alloc]init];
                             profileObject.edu_Time_To = [[NSMutableArray alloc]init];
                             profileObject.educationIdArray = [[NSMutableArray alloc]init];
                             for (int h=0; h< [[innerDict valueForKey:key] count]; h++) {
                                 [profileObject.edu_Name addObject:[[[innerDict valueForKey:key] valueForKey:@"college"] objectAtIndex:h]];
                                 [profileObject.edu_Degree addObject:[[[innerDict valueForKey:key] valueForKey:@"degree"] objectAtIndex:h]];
                                 [profileObject.edu_Time_From addObject:[[[innerDict valueForKey:key] valueForKey:@"from_date"] objectAtIndex:h]];
                                 [profileObject.edu_Time_To addObject:[[[innerDict valueForKey:key] valueForKey:@"to_date"] objectAtIndex:h]];
                                 [profileObject.educationIdArray addObject:[[[innerDict valueForKey:key] valueForKey:@"id"] objectAtIndex:h]];
                             }
                             //[mainArray addObject:profileObject];
                             [mainArray replaceObjectAtIndex:2 withObject:profileObject];
                         }
                         if ([key isEqualToString:@"User_Exps"])
                         {
                             profileObjectclass *profileObject=[profileObjectclass new];
                             // [titleHeaderArray addObject:@"Experience"];
                             //[titleHeaderArray replaceObjectAtIndex:0 withObject:@"Experience"];
                             
                             profileObject.exp_JobTitle = [[NSMutableArray alloc]init];
                             profileObject.exp_companyName = [[NSMutableArray alloc]init];
                             profileObject.exp_TimeFrame_From = [[NSMutableArray alloc]init];
                             profileObject.exp_TimeFrame_To = [[NSMutableArray alloc]init];
                             profileObject.exp_Desc = [[NSMutableArray alloc]init];
                             profileObject.experienceIdArray = [[NSMutableArray alloc]init];
                             profileObject.arrUserTag = [[NSMutableArray alloc]init];
                             for (int h=0; h< [[innerDict valueForKey:key] count]; h++) {
                                 [profileObject.exp_JobTitle addObject:[[[innerDict valueForKey:key] valueForKey:@"job_title"] objectAtIndex:h]];
                                 [profileObject.exp_companyName addObject:[[[innerDict valueForKey:key] valueForKey:@"company_name"] objectAtIndex:h]];
                                 
                                 [profileObject.arrUserTag addObject:[[[innerDict valueForKey:key] valueForKey:@"user_tag"] objectAtIndex:h]];
                                 [profileObject.exp_TimeFrame_From addObject:[[[innerDict valueForKey:key] valueForKey:@"from_date"] objectAtIndex:h]];
                                 [profileObject.exp_TimeFrame_To addObject:[[[innerDict valueForKey:key] valueForKey:@"to_date"] objectAtIndex:h]];
                                 [profileObject.exp_Desc addObject:[[[innerDict valueForKey:key] valueForKey:@"description"] objectAtIndex:h]];
                                 [profileObject.experienceIdArray addObject:[[[innerDict valueForKey:key] valueForKey:@"id"] objectAtIndex:h]];
                             }
                             // [mainArray addObject:profileObject];
                             [mainArray replaceObjectAtIndex:1 withObject:profileObject];
                             
                         }
                         
                     }
                 }
                 int counter =0 ;
                 for (int k=0; k<titleHeaderArray.count; k++) {
                     if ([[titleHeaderArray objectAtIndex:k] isEqualToString:@""]) {
                         counter++;
                     }
                 }
                 
                 if (counter == 4) {
                     tableVw.hidden =YES;
                 }
                 else
                 {
                     tableVw.delegate = self;
                     tableVw.dataSource = self;
                     [tableVw reloadData];
                     tableVw.hidden =NO;
                     //[titleHeaderArray replaceObjectAtIndex:2 withObject:@"Shared Connection"];
                     //[titleHeaderArray replaceObjectAtIndex:1 withObject:@"Education"];
                     // [titleHeaderArray replaceObjectAtIndex:0 withObject:@"Experience"];
                 }
                 
             }
             else if ([str isEqualToString:@"0"] )
             {
                 if ([comeFromSring isEqualToString:@"1"]) {
                 }
                 else{
                     leftMenuIcon.hidden = NO;
                     [self leftSlider];
                 }
             }else if ([str isEqualToString:@"10"] )
             {
                 
                 if ([userIDShowProfile length]==0) {
                     UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                     alert.tag = 1234;
                     [alert show];
                 }
                 else{
                     
                     
                 }
             }
         }
         else
         {
             if ([comeFromSring isEqualToString:@"1"]) {
             }
             else{
                 leftMenuIcon.hidden = NO;
                 [self leftSlider];
             }
             
             saveButton.hidden = true; // kandhal
             
             [appdelegateInstance hideHUD];
             [constant AlertMessageWithString:@"Connectivity levels low. Please try again." andWithView:self.view];
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
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        button.frame = CGRectMake(0, 0, 70, 70);
    }
    else{
        button.frame = CGRectMake(0, 0, 50, 55);
    }
    [self.view addSubview:button];
}

- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark linkedin Methods
- (LIALinkedInHttpClient *)client {
    LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:@"https://localhost"
                                                                                    clientId:LINKED_ID_API_KEY
                                                                                clientSecret:LINKED_ID_SECURE_KEY
                                                                                       state:@"DCEEFWF45453sdffef424"
                                                                               grantedAccess:@[@"r_emailaddress",@"r_basicprofile"]];
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
}
- (void)requestMeWithToken:(NSString *)accessToken
{
    [appdelegateInstance showHUD:@""];
    NSString *strLinkedInUrl=[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,firstName,lastName,email-address,phone-numbers,num-connections,pictureUrl,threeCurrentPositions,Positions,industry,headline,educations:(school-name,field-of-study,start-date,end-date,degree,activities))?oauth2_access_token=%@&format=json",accessToken];
    [_client GET:strLinkedInUrl parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result)
     {
         NSLog(@"current user %@", result);
         NSString *strResult;
         strResult=[NSString stringWithFormat:@"%@",result];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSString *jsonString ;
             NSError *error;
             NSData *jsonData = [NSJSONSerialization dataWithJSONObject:result
                                                                options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                  error:&error];
             if (! jsonData) {
                 NSLog(@"Got an error: %@", error);
             }
             else
             {
                 jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
             }
             [self RunAPI:[NSString stringWithFormat:@"%@ %@",[result valueForKey:@"firstName"],[result valueForKey:@"lastName"]] :[result valueForKey:@"id"] :[[[[[result valueForKey:@"positions"] valueForKey:@"values"] objectAtIndex:0] valueForKey:@"company"] valueForKey:@"name"] :[result valueForKey:@"headline"] :[result valueForKey:@"pictureUrl"] : jsonString];
         }
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             [appdelegateInstance hideHUD];
             [[NSUserDefaults standardUserDefaults]removeObjectForKey:LINKEDIN_TOKEN_KEY];
             [[NSUserDefaults standardUserDefaults]removeObjectForKey:LINKEDIN_EXPIRATION_KEY];
             //             UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"LinkedIn" message:@"LinkedIn is not connecting.Request token expired." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
             //             [alert show];
             [constant alertViewWithMessage:@"LinkedIn is not connecting.Request token expired."withView:self];
         }];
}
-(void)RunAPI :(NSString*)Name :(NSString*)idOfUser :(NSString*)Company :(NSString*)position :(NSString*)ImageUrl :(NSString*)Response{
    
    
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService=[[NSString alloc]initWithFormat:@"%@linkedin_import",AppURL];
    NSDictionary *dictParams;
    
    
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:
                Response,@"linkedin_array",[NSString stringWithFormat:@"%@",
                                            [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",nil];
    NSLog(@"%@",strWebService);
    NSLog(@"%@",dictParams);
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
             if (response == nil) {
                 saveButton.hidden = YES;
             }
             [appdelegateInstance hideHUD];
             NSString*str = [NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             if ([str isEqualToString:@"0"])
             {
                 if ( [[[NSUserDefaults standardUserDefaults]valueForKey:@"first"]isEqualToString:@"onsignup"]||[userFirstNameString isEqualToString:@""] || [userFirstNameString length]==0) {
                     strProfileComplete=@"complete";
                     //                     UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     //                     alert.tag=1001;
                     //                     [alert show];
                     //                     [[NSUserDefaults standardUserDefaults]setObject:@"NotOnSignup" forKey:@"first"];
                 }
                 else
                 {
                     strProfileComplete=@"";
                     //                     UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     //                     [alert show];
                     [constant alertViewWithMessage:[response valueForKey:@"message"]withView:self];
                     //  [[NSUserDefaults standardUserDefaults]setObject:@"NotOnSignup" forKey:@"first"];
                 }
                 [self performSelector:@selector(getUserData) withObject:nil afterDelay:1];
                 
             }
             else  if ([str isEqualToString:@"1"])
             {
                 strProfileComplete=@"";
                 //                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 //                 [alert show];
                 [constant alertViewWithMessage:[response valueForKey:@"message"]withView:self];
             }
             else  if ([str isEqualToString:@"10"])
             {
                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 alert.tag = 1234;
                 [alert show];
                 
             }
             else if ([response valueForKey:@"Failure"] )
             {
                 strProfileComplete=@"";
             }
         }
         else
         {
             strProfileComplete=@"";
             [appdelegateInstance hideHUD];
             //             UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"upitch" message:@"LinkedIn is not connecting. Please manually enter the mandatory fields below." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
             //             [alert show];
             [constant alertViewWithMessage:@"LinkedIn is not connecting. Please manually enter the mandatory fields below."withView:self];
             NSLog(@"Error returned:%@",[error localizedDescription]);
         }
     }];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
}
-(void)loadInitialdata{
    _client = [self client];
    //NSLog(@"%@",comeFromSring);
    if ([comeFromSring isEqualToString:@"1"]) {
        // other profile
        leftBackIcon.hidden = NO;
        leftMenuIcon.hidden = YES;
        backButton.hidden = NO;
        reportButton.hidden = NO;
        saveButton.hidden = YES;
    }
    else{
        // self profile
        leftBackIcon.hidden = YES;
        leftMenuIcon.hidden = NO;
        backButton.hidden = YES;
        reportButton.hidden = YES;
        importLinkedInView.hidden = NO;
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"view"]);
        
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"view"] isEqualToString:@"seenView"]) {
            // popupLinkedInView.hidden = YES;
        }
        else{
            if (self.comeTag) {
                popupLinkedInView.hidden = NO;
                saveButton.userInteractionEnabled=NO;
            }
            [[NSUserDefaults standardUserDefaults]setObject:@"seenView" forKey:@"view"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
    
    self.navigationController.navigationBar.hidden=YES;
    mainArray = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"", nil];
    
    titleHeaderArray = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"", nil];
    [titleHeaderArray replaceObjectAtIndex:3 withObject:@"Shared Connection"];
    [titleHeaderArray replaceObjectAtIndex:2 withObject:@"Education"];
    [titleHeaderArray replaceObjectAtIndex:1 withObject:@"Experience"];
    
    appdelegateInstance = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self getUserData];
    tableVw.delegate = nil;
    tableVw.dataSource = nil;
    tableVw.hidden =YES;
    
    setFrameBool = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    //[tableVw reloadData];
    [super viewDidAppear:animated];
    
}
-(void)addButtonPressed : (id)sender{
    UIButton*btn = (UIButton*)sender;
    //   CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableVw];//kandhal
    //NSIndexPath *indexPath = [tableVw indexPathForRowAtPoint:buttonPosition];
    AddUserProfileViewController*obj;
    obj=[self.storyboard instantiateViewControllerWithIdentifier:@"addUserData"];
    
    if ([btn tag]==1) {
        obj.headerString = @"1";
        obj.editString  = @"1";
    }
    else if ([btn tag]==2){
        obj.headerString = @"2";
        obj.editString   = @"1";
    }
    [obj setDelegate:self];
    [self.navigationController pushViewController:obj animated:YES];
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
#pragma mark Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([comeFromSring isEqualToString:@"1"]) {
        // other profile
        saveButton.hidden = YES;
    }
    else{
        // self user
        AddUserProfileViewController*obj;
        obj=[self.storyboard instantiateViewControllerWithIdentifier:@"addUserData"];
        
        if (indexPath.section==1) {
            // experience
            obj.headerString = @"1";
            obj.editString  = @"2";
            
            if ([[mainArray objectAtIndex:indexPath.section] isKindOfClass:[NSString class]])
            {
                /*obj.editString  = @"1";
                 obj.professionalString =@"";
                 obj.companyString =@"";
                 obj.fromDateExString =@"";
                 obj.toDateExString =@"";
                 obj.descriptionString =@"";
                 obj.idString =@"";*/
            }
            else{
                
                obj.professionalString = [NSString stringWithFormat:@"%@",[[[mainArray objectAtIndex:indexPath.section] exp_JobTitle] objectAtIndex:indexPath.row]];
                obj.companyString = [NSString stringWithFormat:@"%@",[[[mainArray objectAtIndex:indexPath.section] exp_companyName] objectAtIndex:indexPath.row]];
                obj.strUserTag=[NSString stringWithFormat:@"%@",[[[mainArray objectAtIndex:indexPath.section] arrUserTag] objectAtIndex:indexPath.row]];
                obj.fromDateExString = [NSString stringWithFormat:@"%@",[[[mainArray objectAtIndex:indexPath.section] exp_TimeFrame_From] objectAtIndex:indexPath.row]];
                obj.toDateExString = [NSString stringWithFormat:@"%@",[[[mainArray objectAtIndex:indexPath.section] exp_TimeFrame_To] objectAtIndex:indexPath.row]];
                if ([obj.toDateExString isEqualToString:@""]) {
                    obj.toDateExString=@"Present";
                }
                obj.descriptionString = [NSString stringWithFormat:@"%@",[[[mainArray objectAtIndex:indexPath.section] exp_Desc] objectAtIndex:indexPath.row]];
                obj.idString = [NSString stringWithFormat:@"%@",[[[mainArray objectAtIndex:indexPath.section] experienceIdArray] objectAtIndex:indexPath.row]];
                [obj setDelegate:self];
                [self.navigationController pushViewController:obj animated:YES];
            }
            
        }
        else if (indexPath.section==2) {
            // education
            obj.headerString = @"2";
            obj.editString  = @"2";
            
            if ([[mainArray objectAtIndex:indexPath.section] isKindOfClass:[NSString class]])
            {
                /* obj.editString  = @"1";
                 obj.degreeString =@"";
                 obj.fromDateEduString =@"";
                 obj.toDateEduString =@"";
                 obj.collegeString =@"";
                 obj.idString =@"";*/
            }
            else{
                obj.degreeString = [NSString stringWithFormat:@"%@",[[[mainArray objectAtIndex:indexPath.section] edu_Degree] objectAtIndex:indexPath.row]];
                obj.fromDateEduString = [NSString stringWithFormat:@"%@",[[[mainArray objectAtIndex:indexPath.section] edu_Time_From] objectAtIndex:indexPath.row]];
                obj.toDateEduString = [NSString stringWithFormat:@"%@",[[[mainArray objectAtIndex:indexPath.section] edu_Time_To] objectAtIndex:indexPath.row]];
                obj.collegeString = [NSString stringWithFormat:@"%@",[[[mainArray objectAtIndex:indexPath.section] edu_Name] objectAtIndex:indexPath.row]];
                obj.idString = [NSString stringWithFormat:@"%@",[[[mainArray objectAtIndex:indexPath.section] educationIdArray] objectAtIndex:indexPath.row]];
                [obj setDelegate:self];
                [self.navigationController pushViewController:obj animated:YES];
            }
        }
    }
}
-(void)updateTableData{
    // run the API when data is added
    [toolBar removeFromSuperview];
    reasinTextView.inputAccessoryView=toolBar;
    [self loadInitialdata];
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        static NSString *cellComment;
        if ([comeFromSring isEqualToString:@"1"]) {
            // other profile
            cellComment=@"profileCell2";
        }
        else{
            // self profile
            cellComment=@"profileCell1";
        }
        
        cellObj=(ProfileCellTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellComment];
        if (cellObj==nil)
        {
            NSArray *Objects=[[NSBundle mainBundle] loadNibNamed:@"ProfileCellTableViewCell" owner:nil options:nil];
            for (id SubObject in Objects)
            {
                if ([SubObject isKindOfClass:[UITableViewCell class]]){
                    cellObj=(ProfileCellTableViewCell*)SubObject;
                    break;
                }
            }
        }
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        if (orientation == UIInterfaceOrientationLandscapeLeft ||
            orientation == UIInterfaceOrientationLandscapeRight)
        {
            cellObj.btnPlus.frame=CGRectMake(cellObj.btnPlus.frame.origin.x-7, cellObj.btnPlus.frame.origin.y, cellObj.btnPlus.frame.size.width, cellObj.btnPlus.frame.size.height);
        }
        
        cellObj.hidden = NO;
        // self user
        cellObj.firstNameText.inputAccessoryView=toolBar;
        cellObj.lastNameText.inputAccessoryView=toolBar;
        cellObj.companyNameText.inputAccessoryView=toolBar;
        cellObj.designationNameText.inputAccessoryView=toolBar;
        [cellObj.uploadPhotoButton addTarget:self action:@selector(uploadUserPhoto:) forControlEvents:UIControlEventTouchUpInside];
        cellObj.firstNameText.text =userFirstNameString;
        cellObj.lastNameText.text = userLastNameString;
        cellObj.companyNameText.text = companyNameString;
        cellObj.designationNameText.text = designationNameString;
        if (userIDShowProfile) {
            cellObj.btnReport.hidden=NO;
        }else{
            cellObj.btnReport.hidden=YES;
        }
        
        if ([userImageUrl length]==0)
        {
            [cellObj.userImageViewSelf setImage:[UIImage imageNamed:@"userDefault.jpg"]];
        }
        else
        {
            
            if (imageUser)
            {
                cellObj.userImageViewSelf.image=imageUser;
            }
            else
            {
                [cellObj.userImageViewSelf setImageWithURL:[NSURL URLWithString:userImageUrl] placeholderImage:[UIImage imageNamed:@"userDefault.jpg"] imagesize:CGSizeMake(400, 400)];
            }
        }
        cellObj.userImageViewSelf.layer.cornerRadius = cellObj.userImageViewSelf.frame.size.height/2;
        cellObj.userImageViewSelf.layer.masksToBounds = YES;
        
        // other user
        cellObj.userNamelabel.text = [NSString stringWithFormat:@"%@ %@",userFirstNameString,userLastNameString];
        cellObj.companyNamelabel.text = companyNameString;
        cellObj.designationNamelabel.text = designationNameString;
        if ([userImageUrl length]==0) {
            [cellObj.userImageViewOther setImage:[UIImage imageNamed:@"userDefault.jpg"]];
        }
        else
        {
            [cellObj.userImageViewOther setImageWithURL:[NSURL URLWithString:userImageUrl] placeholderImage:[UIImage imageNamed:@"userDefault.jpg"] imagesize:CGSizeMake(400, 400)];
        }
        cellObj.userImageViewOther.layer.cornerRadius = cellObj.userImageViewOther.frame.size.height/2;
        cellObj.userImageViewOther.layer.masksToBounds = YES;
        
        [cellObj setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cellObj;
    }
    else
    {
        static NSString *SimpleTableIdentifier = @"profileCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                    
                                         reuseIdentifier:SimpleTableIdentifier] ;
        }
        
        //}
        
        UILabel*jobTitle = (UILabel*)[cell viewWithTag:1];
        UILabel*companyName = (UILabel*)[cell viewWithTag:2];
        UILabel*fromDate = (UILabel*)[cell viewWithTag:3];
        UILabel*Description = (UILabel*)[cell viewWithTag:4];
        UIImageView*dividerImageView = (UIImageView*)[cell viewWithTag:10];
        dividerImageView.hidden = YES;
        //thirdImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        companyName.frame = CGRectMake(companyName.frame.origin.x, companyName.frame.origin.y, self.view.frame.size.width-20, companyName.frame.size.height);
        
        
        
        if (indexPath.section == 1)
        {
            NSString*TimeFrameto;
            if (experienceBool)
            {
                jobTitle.text = @"Not available";
                Description.hidden = YES;
                companyName.hidden = YES;
                fromDate.hidden = YES;
            }
            else
            {
                Description.hidden = NO;
                companyName.hidden = NO;
                fromDate.hidden = NO;
                jobTitle.text  =[NSString stringWithFormat:@"%@",[[[mainArray objectAtIndex:indexPath.section] exp_JobTitle] objectAtIndex:indexPath.row]];
                companyName.text  =[NSString stringWithFormat:@"%@",[[[mainArray objectAtIndex:indexPath.section] exp_companyName] objectAtIndex:indexPath.row]];
                TimeFrameto=[[[mainArray objectAtIndex:indexPath.section] exp_TimeFrame_To] objectAtIndex:indexPath.row];
                if (TimeFrameto.length==0)
                {
                    fromDate.text  =[NSString stringWithFormat:@"%@ - Present",[[[mainArray objectAtIndex:indexPath.section] exp_TimeFrame_From] objectAtIndex:indexPath.row]];
                }
                else{
                    
                    fromDate.text  =[NSString stringWithFormat:@"%@ - %@",[[[mainArray objectAtIndex:indexPath.section] exp_TimeFrame_From] objectAtIndex:indexPath.row],[[[mainArray objectAtIndex:indexPath.section] exp_TimeFrame_To] objectAtIndex:indexPath.row]];
                }
                Description.text  =[NSString stringWithFormat:@"%@",[[[mainArray objectAtIndex:indexPath.section] exp_Desc] objectAtIndex:indexPath.row]];
            }
            Description.frame = CGRectMake(9, Description.frame.origin.y, self.view.frame.size.width-20, Description.frame.size.height);
            int labelfontSize;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                labelfontSize =24;
                
            }
            else{
                labelfontSize =13;
            }
            CGSize constraintSize;
            constraintSize.height = MAXFLOAT;
            constraintSize.width = Description.frame.size.width;
            NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  [UIFont fontWithName:@"HelveticaNeue-Light" size:labelfontSize], NSFontAttributeName,
                                                  nil];
            
            CGRect frame = [Description.text boundingRectWithSize:constraintSize
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:attributesDictionary
                                                          context:nil];
            
            CGSize stringSize = frame.size;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                if ([Description.text isEqualToString:@""]) {
                    Description.frame = CGRectMake(9, Description.frame.origin.y, self.view.frame.size.width-20, 0);
                }
                else{
                    Description.frame = CGRectMake(9, Description.frame.origin.y, self.view.frame.size.width-20, stringSize.height);
                }
                if (!experienceBool) {
                    if ([[[mainArray objectAtIndex:indexPath.section] exp_JobTitle] count]-1>indexPath.row) {
                        dividerImageView.frame = CGRectMake(dividerImageView.frame.origin.x, Description.frame.origin.y+Description.frame.size.height+8, self.view.frame.size.width-20, 1.5f);
                        dividerImageView.backgroundColor = [UIColor lightGrayColor];
                        dividerImageView.hidden = NO;
                    }
                }
            }
            else
            {
                if ([Description.text isEqualToString:@""])
                {
                    Description.frame = CGRectMake(9, Description.frame.origin.y, self.view.frame.size.width-20, 0);
                }
                else
                {
                    Description.frame = CGRectMake(9, Description.frame.origin.y, self.view.frame.size.width-20, stringSize.height);
                }
                if (!experienceBool)
                {
                    if ([[[mainArray objectAtIndex:indexPath.section] exp_JobTitle] count]-1>indexPath.row) {
                        dividerImageView.frame = CGRectMake(dividerImageView.frame.origin.x, Description.frame.origin.y+Description.frame.size.height+8, self.view.frame.size.width-20, .5f);
                        dividerImageView.backgroundColor = [UIColor lightGrayColor];
                        dividerImageView.hidden = NO;
                    }
                }
            }
            
            Description.backgroundColor = [UIColor clearColor];
            jobTitle.hidden = NO;
            
        }
        if (indexPath.section == 2) {
            
            if (educationBool) {
                jobTitle.text  =@"Not available";
                companyName.hidden = YES;
                fromDate.hidden = YES;
            }
            else{
                jobTitle.text  =[NSString stringWithFormat:@"%@",[[[mainArray objectAtIndex:indexPath.section] edu_Name] objectAtIndex:indexPath.row]];
                companyName.text  =[NSString stringWithFormat:@"%@",[[[mainArray objectAtIndex:indexPath.section] edu_Degree] objectAtIndex:indexPath.row]];
                fromDate.text  =[NSString stringWithFormat:@"%@ - %@",[[[mainArray objectAtIndex:indexPath.section] edu_Time_From] objectAtIndex:indexPath.row],[[[mainArray objectAtIndex:indexPath.section] edu_Time_To] objectAtIndex:indexPath.row]];
                companyName.hidden = NO;
                fromDate.hidden = NO;
                // }
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                    if ([[[mainArray objectAtIndex:indexPath.section] edu_Name] count]-1>indexPath.row) {
                        dividerImageView.frame = CGRectMake(dividerImageView.frame.origin.x, fromDate.frame.origin.y+fromDate.frame.size.height+8, self.view.frame.size.width-20, 1.5f);
                        dividerImageView.backgroundColor = [UIColor lightGrayColor];
                        dividerImageView.hidden = NO;
                    }
                }
                else{
                    if ([[[mainArray objectAtIndex:indexPath.section] edu_Name] count]-1>indexPath.row) {
                        dividerImageView.frame = CGRectMake(dividerImageView.frame.origin.x, fromDate.frame.origin.y+fromDate.frame.size.height+8, self.view.frame.size.width-20, .5f);
                        dividerImageView.backgroundColor = [UIColor lightGrayColor];
                        dividerImageView.hidden = NO;
                    }
                }
            }
            jobTitle.hidden = NO;
            Description.hidden = YES;
        }
        if (indexPath.section == 3) {
            
            jobTitle.hidden = YES;
            fromDate.hidden = YES;
            companyName.hidden =YES;
            Description.hidden = YES;
            
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if (indexPath.section ==0) {
            ProfileCellTableViewCell *cell = (ProfileCellTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
            if ([cell.reuseIdentifier isEqualToString:@"profileCell2"])
                return 430;
            else
                return 530;
        }
        else if (indexPath.section ==1  )
        {
            UILabel*Description=[[UILabel alloc]init];
            
            
            if ([[mainArray objectAtIndex:indexPath.section] isKindOfClass:[NSString class]])
            {
                Description.text  =@"";
            }
            else
            {
                Description.text  =[NSString stringWithFormat:@"%@",[[[mainArray objectAtIndex:indexPath.section] exp_Desc] objectAtIndex:indexPath.row]];
            }
            
            
            
            
            
            int labelfontSize;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                labelfontSize =24;
                
            }
            else{
                labelfontSize =13;
                
            }
            
            CGSize constraintSize;
            constraintSize.height = MAXFLOAT;
            //constraintSize.width = Description.frame.size.width;
            constraintSize.width = self.view.frame.size.width-20;
            NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  [UIFont fontWithName:@"HelveticaNeue-Light" size:labelfontSize], NSFontAttributeName,
                                                  nil];
            
            CGRect frame;
            CGSize stringSize;
            
            frame = [Description.text boundingRectWithSize:constraintSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:attributesDictionary
                                                   context:nil];
            stringSize = frame.size;
            
            
            if (experienceBool) {
                return 60;
            }
            if ([Description.text isEqualToString:@""]) {
                return stringSize.height +85;
            }
            else{
                return stringSize.height +110;
            }
        }
        else if (indexPath.section ==2) {
            if (educationBool) {
                return 60;
            }
            return 110;
        }
        else if (indexPath.section ==3) {
            return 140;
        }
    }
    if (indexPath.section ==1 )
    {
        UILabel *Description=[[UILabel alloc]initWithFrame:CGRectMake(0,0 , self.view.frame.size.width-20, 20)];
        
        if (experienceBool) {
        }else{
            Description.text  =[NSString stringWithFormat:@"%@",[[[mainArray objectAtIndex:indexPath.section] exp_Desc] objectAtIndex:indexPath.row]];
        }
        int labelfontSize;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            labelfontSize =24;
            
        }
        else{
            labelfontSize =13;
            
        }
        
        CGSize constraintSize;
        constraintSize.height = MAXFLOAT;
        constraintSize.width = Description.frame.size.width;
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIFont fontWithName:@"HelveticaNeue-Light" size:labelfontSize], NSFontAttributeName,
                                              nil];
        
        CGRect frame = [Description.text boundingRectWithSize:constraintSize
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:attributesDictionary
                                                      context:nil];
        
        CGSize stringSize = frame.size;
        if (experienceBool) {
            return 40;
        }
        if ([Description.text isEqualToString:@""]) {
            return stringSize.height +65;
        }
        else{
            return stringSize.height +80;
        }
    }
    
    else if (indexPath.section ==2) {
        if (educationBool) {
            return 40;
        }
        
        return 80;
    }
    else if (indexPath.section ==3) {
        return 100;
    }
    if ([comeFromSring isEqualToString:@"1"]) {
        return 180;
    }
    else{
        return 350;
    }
    return 350;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    //    if (sharedConnectionCount>0)
    //        return 4;
    //    else
    //        return 3;
    
    //    if ( [[[NSUserDefaults standardUserDefaults]valueForKey:@"first"]isEqualToString:@"onsignup"]) {
    //        return 2;
    //    }else
    //    return 3;
    
    return 2;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if (section==0) {
            return 0;
        }
        return 60;
    }
    if (section==0) {
        return 0;
    }
    else
        return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        // experience
        if ([[mainArray objectAtIndex:section] isKindOfClass:[NSString class]])
        {
            experienceBool = YES;
            return 1;
        }
        else{
            experienceBool = NO;
            return  [[[mainArray objectAtIndex:section] exp_JobTitle] count];
        }
    }
    else if (section == 2)
    {
        // education
        if ([[mainArray objectAtIndex:section] isKindOfClass:[NSString class]])
        {
            educationBool = YES;
            return 1;
        }
        else{
            educationBool = NO;
            return  [[[mainArray objectAtIndex:section] edu_Name] count];
        }
    }
    else if (section == 3) {
        return 1;
    }
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    int height ;
    int fontsize;
    UILabel *totalCountLabel=[[UILabel alloc]init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        height = 44;
        fontsize= 23;
    }
    else{
        height = 24;
        fontsize= 20;
    }
    totalCountLabel.frame=CGRectMake(self.view.frame.size.width-100,8,70,height);
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,height+16)];
    headerView.backgroundColor=[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    UILabel *titleLabel=[[UILabel alloc]init];
    
    if (section==3 )
    {
        totalCountLabel.textAlignment = NSTextAlignmentRight;
        totalCountLabel.font  = [UIFont fontWithName:@"Helvetica" size:fontsize];
        totalCountLabel.backgroundColor=[UIColor clearColor];
        totalCountLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        totalCountLabel.textColor=[UIColor blackColor];
        totalCountLabel.text = [NSString stringWithFormat:@"%ld",(long)sharedConnectionCount];
        [headerView addSubview:totalCountLabel];
    }
    else
    {
        UIButton*addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            addButton.frame = CGRectMake(self.view.frame.size.width-60, 5, 50, 50);
        }
        else
        {
            addButton.frame = CGRectMake(self.view.frame.size.width-40, 5, 30, 30);
        }
        
        [addButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([comeFromSring isEqualToString:@"1"]) {
            // other profile
        }
        else{
            // self profile
            addButton.tag = section;
            [headerView addSubview:addButton];
        }
        
    }
    
    titleLabel.frame=CGRectMake(15,8,200,height);
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.text = [NSString stringWithFormat:@"%@",[titleHeaderArray objectAtIndex:section]];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        titleLabel.frame=CGRectMake(15,10,400,40);
        titleLabel.font = [UIFont fontWithName:@"Helvetica" size:28];
    }
    [headerView addSubview:titleLabel];
    
    if (section==0) {
        return nil;
    }
    return headerView;
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
         if (orientation == UIInterfaceOrientationPortrait) {
             [tableVw reloadData];
         }
         else if (orientation == UIInterfaceOrientationLandscapeLeft ||
                  orientation == UIInterfaceOrientationLandscapeRight)
         {
             
             
             //[cellObj.userImageViewSelf
             
             
             [tableVw reloadData];
         }
         lblReason.frame=CGRectMake(reasinTextView.frame.origin.x+2, lblReason.frame.origin.y, lblReason.frame.size.width, lblReason.frame.size.height);
         // do whatever
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}
- (IBAction)chatButtonPressed:(id)sender {
    
    [[NSUserDefaults standardUserDefaults]setObject:@"showChatScreen" forKey:@"directCall"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"userProfile"] isEqualToString:@"clientProfile"]) {
        SWRevealViewController *revealController = self.revealViewController;
        manageJournalistViewController*obj;
        obj=[self.storyboard instantiateViewControllerWithIdentifier:@"manageJournalists"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:obj];
        [revealController pushFrontViewController:navigationController animated:YES];
    }
    else{
        SWRevealViewController *revealController = self.revealViewController;
        viewPitchesViewController_Journalists*obj;
        obj=[self.storyboard instantiateViewControllerWithIdentifier:@"viewPitches"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:obj];
        [revealController pushFrontViewController:navigationController animated:YES];
    }
}

- (IBAction)closeReportView:(id)sender {
    reasinTextView.text=@"";
    lblReason.hidden = NO;
    reasonView.hidden = YES;
    [reasinTextView resignFirstResponder];
}

- (IBAction)doneToolBar:(id)sender {
    [self resignAllKey];
    
}
- (IBAction)closeLinkedInView:(id)sender {
    popupLinkedInView.hidden = YES;
    saveButton.userInteractionEnabled=YES;
}

- (IBAction)uploadUserPhoto:(id)sender {
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    ProfileCellTableViewCell* cellObj1=(ProfileCellTableViewCell*)[tableVw cellForRowAtIndexPath:indexPath];
    NSData *dataOri;
    dataOri=UIImagePNGRepresentation(cellObj1.userImageViewSelf.image);
    
    ImgDummy=[UIImage imageNamed:@"userDefault.jpg"];
    dataDummy = UIImagePNGRepresentation(ImgDummy);
    
    
    if ([dataOri isEqual:dataDummy]) {
        actionSheet1 = [[UIActionSheet alloc] initWithTitle:@"Upload Image" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Upload by Photo Library",@"Upload by Camera",@"Cancel",  nil];
    }else{
        actionSheet1 = [[UIActionSheet alloc] initWithTitle:@"Upload Image" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Upload by Photo Library",@"Upload by Camera",@"Remove Image",@"Cancel",  nil];
    }
    
    actionSheetOpenBool = YES;
    [actionSheet1 showInView:self.view];
}
- (IBAction)importLinkedButtonPressed:(id)sender {
    [self.view endEditing:YES];
    if ([_client validToken])
    {
        [self requestMeWithToken:[[NSUserDefaults standardUserDefaults] valueForKey:LINKEDIN_TOKEN_KEY]];
    }
    else
    {
        popupLinkedInView.hidden = YES;
        saveButton.userInteractionEnabled=YES;
        [_client getAuthorizationCode:^(NSString *code)
         {
             [appdelegateInstance showHUD:@""];
             [_client getAccessToken:code success:^(NSDictionary *accessTokenData)
              {
                  NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
                  [self requestMeWithToken:accessToken];
              }
                             failure:^(NSError *error)
              {
                  
                  NSLog(@"Authorization was cancelled by user");
                  //            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"LinkedIn" message:@"LinkedIn is not connecting.Request token expired." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                  //                            [alert show];
                  [constant alertViewWithMessage:@"LinkedIn is not connecting.Request token expired."withView:self];
                  [appdelegateInstance hideHUD];
                  NSLog(@"Quering accessToken failed %@", error);
              }];
         }
                               cancel:^{
                                   //        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"LinkedIn" message:@"Authorization was cancelled by user." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                   //        [alert show];
                                   [constant alertViewWithMessage:@"Authorization was cancelled by user."withView:self];
                                   [appdelegateInstance hideHUD];
                               }                     failure:^(NSError *error) {
                                   [appdelegateInstance hideHUD];
                                   //        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"LinkedIn" message:@"Authorization failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                   //        [alert show];
                                   [constant alertViewWithMessage:@"Authorization failed."withView:self];
                               }];
    }
}

- (IBAction)saveButtonPressed:(id)sender {
    
    [self.view endEditing:YES];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    ProfileCellTableViewCell* cellObj1=(ProfileCellTableViewCell*)[tableVw cellForRowAtIndexPath:indexPath];
    cellObj.firstNameText.text = [cellObj1.firstNameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    cellObj.lastNameText.text = [cellObj1.lastNameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    cellObj.companyNameText.text = [cellObj1.companyNameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    cellObj.designationNameText.text = [cellObj1.designationNameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([cellObj.firstNameText.text isEqualToString:@""] || cellObj.firstNameText.text.length<=0 ) {
        //        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter first name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //        [alert show];
        [constant alertViewWithMessage:@"Please enter first name."withView:self];
    }
    
    else if (cellObj.firstNameText.text.length>40 ) {
        //        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"First Name cannot exceed 40 characters." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //        [alert show];
        [constant alertViewWithMessage:@"First Name cannot exceed 40 characters."withView:self];
    }
    else if ([cellObj.lastNameText.text isEqualToString:@""] || cellObj.lastNameText.text.length<=0 ) {
        //        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter last name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //        [alert show];
        [constant alertViewWithMessage:@"Please enter last name."withView:self];
    }
    else  if (cellObj.lastNameText.text.length>40 ) {
        //        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Last Name cannot exceed 40 characters." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //        [alert show];
        [constant alertViewWithMessage:@"Last Name cannot exceed 40 characters."withView:self];
    }
    else if ([cellObj.companyNameText.text isEqualToString:@""] || cellObj.companyNameText.text.length<=0  ) {
        //        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter company name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //        [alert show];
        [constant alertViewWithMessage:@"Please enter company name."withView:self];
    }
    else if (cellObj.companyNameText.text.length >100  ) {
        //        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Company Name cannot exceed 100 characters." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //        [alert show];
        [constant alertViewWithMessage:@"Company Name cannot exceed 100 characters."withView:self];
    }
    else if ([cellObj.designationNameText.text isEqualToString:@""] || cellObj.designationNameText.text.length<=0 ) {
        //        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter Job Title" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //        [alert show];
        [constant alertViewWithMessage:@"Please enter Job Title."withView:self];
    }
    else if ( cellObj.designationNameText.text.length >100  ) {
        //        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Job Title cannot exceed 100 characters." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //        [alert show];
        [constant alertViewWithMessage:@"Job Title cannot exceed 100 characters."withView:self];
    }
    
    else
    {
        
        [cellObj.firstNameText resignFirstResponder];
        [cellObj.lastNameText resignFirstResponder];
        [cellObj.companyNameText resignFirstResponder];
        [cellObj.firstNameText resignFirstResponder];
        [appdelegateInstance showHUD:@""];
        
        NSString*strWebService=[[NSString alloc]initWithFormat:@"%@registration_second",AppURL];
        
        NSDictionary *dictParams;
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"] length]<10) {
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"deviceToken"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:
                    cellObj.firstNameText.text,@"first_name",
                    cellObj.lastNameText.text,@"last_name",
                    cellObj.designationNameText.text,@"designation",
                    cellObj.companyNameText.text,@"company",
                    [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",nil];
        NSLog(@"%@",strWebService);
        NSLog(@"%@",dictParams);
        
        AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
        NSMutableURLRequest *request =
        [serializer multipartFormRequestWithMethod:@"POST" URLString:strWebService
                                        parameters:dictParams
                         constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
         {
             // UIImage *image = cellObj1.userImageViewSelf.image;
             UIImage *image = [self imageWithImage:cellObj1.userImageViewSelf.image scaledToSize:CGSizeMake(400,400)];
             NSData *data = UIImageJPEGRepresentation(image, 0.3);
             NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
             ProfileCellTableViewCell* cellObj1=(ProfileCellTableViewCell*)[tableVw cellForRowAtIndexPath:indexPath];
             
             if ([cellObj1.userImageViewSelf.image isEqual:ImgDummy]) {
                 
             }
             else
             {
                 
                 [formData appendPartWithFileData:data
                                             name:@"file1"
                                         fileName:[NSString stringWithFormat:@"%@_userPhoto.jpg",timestamp]
                                         mimeType:@"image/jpeg"];
             }
         } error:Nil];
        [request setTimeoutInterval:30];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        AFHTTPRequestOperation *operation =
        [manager HTTPRequestOperationWithRequest:request
                                         success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"%@",responseObject);
             [appdelegateInstance hideHUD];
             NSString*str = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"error"]];
             if ([str isEqualToString:@"0"])
             {
                 [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"first_name"]] forKey:@"username"];
                 [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@ %@",userFirstNameString,userLastNameString] forKey:@"fullName"];
                 [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:KEY_PROFILE_TAG];
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 
                 
                 if (logoutButton.hidden)
                 {
                     //                 UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     //                 [alert show];
                     [constant alertViewWithMessage:[responseObject valueForKey:@"message"]withView:self];
                 }else
                 {
                     //[[NSUserDefaults standardUserDefaults]setObject:@"loggedin" forKey:@"LoginStatus"];
                     UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     alert.tag=1001;
                     [alert show];
                 }
                 
                 
                 [[NSUserDefaults standardUserDefaults]setObject:@"NotOnSignup" forKey:@"first"];
                 
                 logoutButton.hidden = YES;
                 backButton.hidden = NO;
                 leftMenuIcon.hidden = NO;
                 SWRevealViewController *revealController = [self revealViewController];
                 revealController.panGestureRecognizer.enabled = YES;
                 revealController.tapGestureRecognizer.enabled = YES;
                 [self leftSlider];
                 [[NSUserDefaults standardUserDefaults]setObject:@"loggedin" forKey:@"LoginStatus"];
                 [[NSUserDefaults standardUserDefaults]synchronize];
             }
             else if ([str isEqualToString:@"1"])
             {
                 //             UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 //             [alert show];
                 [constant alertViewWithMessage:[responseObject valueForKey:@"message"]withView:self];
             }else if ([str isEqualToString:@"10"] )
             {
                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 alert.tag = 1234;
                 [alert show];
             }
         } failure:^(AFHTTPRequestOperation *task, NSError *error) {
             NSLog(@"Error :%@",error);
             NSLog(@"%@",operation.responseString);
             [appdelegateInstance hideHUD];
             //         UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Please try again unable to process your request." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
             //         [alert show];
             [constant alertViewWithMessage:@"Please try again unable to process your request."withView:self];
         }];
        [operation start];
    }
}

- (IBAction)logoutAction:(id)sender {
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userid"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userTypeString"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:KEY_PROFILE_TAG];
    [[NSUserDefaults standardUserDefaults]setObject:@"loggedout" forKey:@"LoginStatus"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    UINavigationController *frontNavigationController = (id)self.revealViewController.frontViewController;
    [frontNavigationController.navigationController popToRootViewControllerAnimated:YES];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    actionSheetOpenBool = NO;
    if (buttonIndex == 0)
    {
        //  photo gallery
        UIImagePickerController *picker1 = [[UIImagePickerController alloc] init];
        picker1.delegate = self;
        picker1.allowsEditing = YES;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.allowsEditing=YES;
            imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
            imagePickerController.sourceType = picker1.sourceType;
            imagePickerController.delegate = self;
            
            picker1 = imagePickerController;
            if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
            {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self presentViewController:picker1 animated:YES completion:nil];
                }];
            }
            else
            {
                [self presentViewController:picker1 animated:YES completion:nil];
            }
        }
        else {
            picker1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker1 animated:YES completion:nil];
        }
    }
    if (buttonIndex == 1)
    {
        // camera;
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeCamera])
        {
            
            UIImagePickerController *picker1 = [[UIImagePickerController alloc] init];
            picker1.delegate = self;
            picker1.allowsEditing = YES;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.delegate = self;
                
                picker1 = imagePickerController;
                if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
                {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self presentViewController:picker1 animated:YES completion:nil];
                    }];
                }
                else
                {
                    [self presentViewController:picker1 animated:YES completion:nil];
                }
            }
            else
            {
                picker1.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:picker1 animated:YES completion:nil];
            }
        }else{
            //            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Camera not found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            //            [alert show];
            [constant alertViewWithMessage:@"Camera not found."withView:self];
        }
        
    }
    if (buttonIndex == 2)
    {
        NSString *title =[NSString stringWithFormat:@"%@",[actionSheet buttonTitleAtIndex:buttonIndex]];
        if ([title isEqualToString:@"Remove Image"]) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            ProfileCellTableViewCell* cellObj1=(ProfileCellTableViewCell*)[tableVw cellForRowAtIndexPath:indexPath];
            cellObj1.userImageViewSelf.image=[UIImage imageNamed:@"userDefault.jpg"];
            // userImageView.image=nil;
            //[UIImage imageNamed:@"userDefault.jpg"]
        }
    }
    
    
    
}
#pragma mark UiImagePicker Method
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@",info);
    
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    //    {
    
    //    }
    //    else
    //    {
    //        imageUser = [info objectForKey:UIImagePickerControllerEditedImage];
    //    }
    //image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    imageUser = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    ProfileCellTableViewCell* obj=(ProfileCellTableViewCell*)[tableVw cellForRowAtIndexPath:indexPath];
    
    obj.userImageViewSelf.image = imageUser;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)saveReportReason:(id)sender {
    
    reasinTextView.text = [reasinTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [reasinTextView resignFirstResponder];
    if (reasinTextView.text.length>0) {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:@"Are you sure you want to report this user ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        alert.tag = 100;
        [alert show];
    }
    else{
        //        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please enter some text to report the user" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        //        [alert show];
        [constant alertViewWithMessage:@"Please enter some text to report the user."withView:self];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001)
    {
        WelComeVC *welcome = [self.storyboard instantiateViewControllerWithIdentifier:@"WelComeVC"];
        welcome.userType = [[NSUserDefaults standardUserDefaults]objectForKey:@"userTypeString"];
        [self.navigationController pushViewController:welcome animated:NO]; // change 4/12
        //
        //        SWRevealViewController *revealController = self.revealViewController;
        //
        //        UINavigationController *frontNavigationController = (id)self.revealViewController.frontViewController;
        //
        //        MainViewController_Client*swContrlr = [frontNavigationController.viewControllers firstObject];
        //        NSArray *array = [swContrlr.navigationController viewControllers];
        //        NSLog(@"%lu",(unsigned long)array.count);
        //        [[NSUserDefaults standardUserDefaults]setObject:@"loggedin" forKey:@"LoginStatus"];
        //        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:KEY_PROFILE_TAG];
        //        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"userTypeString"] isEqualToString:@"1"]){
        //            MainViewController_Client*obj;
        //            obj=[self.storyboard instantiateViewControllerWithIdentifier:@"maincontroller_client"];
        //            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:obj];
        //            [revealController pushFrontViewController:navigationController animated:YES];
        //        }else{
        //            PitchFeedJournalist_ViewController*obj;
        //            obj=[self.storyboard instantiateViewControllerWithIdentifier:@"pitchFeedtest"];
        //
        //            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:obj];
        //            [revealController pushFrontViewController:navigationController animated:YES];
        //        }
        
        
    }
    if (alertView.tag == 100)
    {
        if (buttonIndex==0) {
            NSLog(@"Cancel");
        }
        else if (buttonIndex==1) {
            NSLog(@"Ok");
            
            [self reportUserApi];
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
    [reasinTextView resignFirstResponder];
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
    NSDictionary *dictParams;
    strWebService=[[NSString alloc]initWithFormat:@"%@report_users",AppURL];
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:
                [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"from_user",        userIDShowProfile,@"to_user",
                reasinTextView.text,@"reason",nil];
    NSLog(@"%@",strWebService);
    
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
             if (response == nil) {
                 saveButton.hidden = YES;
             }else
             {
                 saveButton.hidden = NO;
             }
             saveButton.hidden = YES;

             [appdelegateInstance hideHUD];
             NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             if ([str isEqualToString:@"0"])
             {
                 
                 reasinTextView.text=@"";
                 lblReason.hidden = NO;
                 //                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 //                 [alert show];
                 [constant alertViewWithMessage:[response valueForKey:@"message"]withView:self];
             }
             else  if ([str isEqualToString:@"1"])
             {
                 //                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 //                 [alert show];
                 [constant alertViewWithMessage:[response valueForKey:@"message"]withView:self];
             }   else if ([str isEqualToString:@"10"] )
             {
                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 alert.tag = 1234;
                 [alert show];
             }
         }
         else
         {
             [appdelegateInstance hideHUD];
             //             UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Please try again unable to process your request." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
             //             [alert show];
             [constant alertViewWithMessage:@"Please try again unable to process your request."withView:self];
             NSLog(@"Error returned:%@",[error localizedDescription]);
         }
     }];
}
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)reportUser:(id)sender {
    reasonView.hidden = NO;
}
- (IBAction)cancelToolBar:(id)sender {
    [self resignAllKey];
}
-(void)resignAllKey{
    [self.view endEditing:YES];
    [reasinTextView resignFirstResponder];
    [cellObj.firstNameText resignFirstResponder];
    [cellObj.lastNameText resignFirstResponder];
    [cellObj.companyNameText resignFirstResponder];
    [cellObj.designationNameText resignFirstResponder];
    tableVw.contentOffset = CGPointMake(0, 0);
}
#pragma mark TextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range      replacementString:(NSString *)string {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    ProfileCellTableViewCell* cellObj1=(ProfileCellTableViewCell*)[tableVw cellForRowAtIndexPath:indexPath];
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if (textField == cellObj1.firstNameText || textField == cellObj1.lastNameText)
    {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz. "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        
        if (newLength<=40) {
            return [string isEqualToString:filtered];
        }else{
            return NO;
        }
        
    }
    else{
        return newLength <= 100;
    }
    // Only characters in the NSCharacterSet you choose will insertable.
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![reasinTextView hasText])
    {
        lblReason.hidden = NO;
    }
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    tableVw.contentOffset = CGPointMake(0, textField.tag*35+25);
    return YES;
}
@end
