//
//  ComposeViewController.m
//  uPitch
//
//  Created by Puneet Rao on 10/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import "ComposeViewController.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LxReqRespManager.h"
#import "AppDelegate.h"
#import "categoryHold.h"
#import "UIImageView+WebCache.h"
#import <AssetsLibrary/AssetsLibrary.h>
//#import "GKImagePicker.h"
#import "constant.h"
#import "manageJournalistViewController.h"

@interface ComposeViewController ()
//<GKImagePickerDelegate> {
//    GKImagePicker *picker;
//}
@property (nonatomic, retain) GKImagePicker *picker;
@end

@implementation ComposeViewController
@synthesize EditNewString,pitchIdString,pitchActiveExpireStatusString,selectedImage;
@synthesize imageCropView;
@synthesize picker = _picker;

-(void)viewWillDisappear:(BOOL)animated{
    [self.view endEditing:YES];
    SWRevealViewController *revealController = [self revealViewController];
    revealController.panGestureRecognizer.enabled = YES;
    revealController.tapGestureRecognizer.enabled = YES;
    [super viewWillDisappear:YES];
}


-(void)PubNubNotification:(NSNotification *) notification
{
    [self getCount];
}
-(void)getCount
{
    
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"totalcount"]integerValue]>0 || [[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]integerValue]>0)
    {
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
   /* if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]integerValue]>0) {
        lblCount.hidden=NO;
        imgCount.hidden=NO;
        NSInteger show=[[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]integerValue]+[[[NSUserDefaults standardUserDefaults] valueForKey:@"MinusCount"] integerValue];
        lblCount.text=[NSString stringWithFormat:@"%ld",(long)show];
        //lblCount.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]];
    }
    else
    {
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"MinusCount"]integerValue]>0)
        {
            lblCount.hidden=NO;
            imgCount.hidden=NO;
            lblCount.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"MinusCount"]];
            
        }
        else
        {
            lblCount.hidden=YES;
            imgCount.hidden=YES;
        }
    }*/
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
    [self getCount];
    viewTwitterLike.hidden=YES;
    aletShow=false;
}


-(void)getImage:(NSData *)Data image:(UIImage *)Image
{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"getImage"] isEqualToString:@"Image"])
    {
        NSLog(@"Reached");
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"getImage"];
        
        data2_Second = UIImagePNGRepresentation(buttonImageTemp1.image);
        if ([data_first isEqual:data2_Second]&& addimageInt!=5001)
        {
            if ( [strUploadingImage isEqualToString:@"uploading"]) {
//                UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please wait while cover image is loading" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                [alert show];
                [constant alertViewWithMessage:@"Please wait while cover image is loading."withView:self];
                
            }else{
//                UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please upload cover image" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                [alert show];
                [constant alertViewWithMessage:@"Please upload cover image."withView:self];
            }
            
            
        }
        else
        {
            UIView*addImageView = (UIView*)[scrollVw viewWithTag:4];
            UIImageView*ImageViewButton = (UIImageView*)[addImageView viewWithTag:addimageInt-4000];
            //NSData *imgData = (NSData*)[[NSUserDefaults standardUserDefaults] objectForKey:@"imagesaved"];
           // UIImage *img = [UIImage imageWithData: imgData];
            //UIImage *img = [UIImage imageWithData: Data];
            [ImageViewButton setImage:Image];
            if (addimageInt == 5001) {
                data2_Second = UIImagePNGRepresentation(ImageViewButton.image);
            }
        }
    }
}
-(void)sideView:(id)sender
{
    if (self.revealViewController.frontViewPosition==FrontViewPositionRight)
    {
        NSLog(@"right");
    }
    else
    {
        [txtViewTwitter resignFirstResponder];
        [pitchTitle resignFirstResponder];
        [pitchSummary resignFirstResponder];
        [pitchDetailIno resignFirstResponder];
        [zipcode resignFirstResponder];
        [websiteUrlTextField resignFirstResponder];
        [socialNetworkTextField resignFirstResponder];
        [popupTextField resignFirstResponder];
        [popupTextView resignFirstResponder];
        NSLog(@"left");
    }
}
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
- (void)viewDidLoad{
    
    txtViewTwitter.text = @"";
    pitchDetailIno.text = @"";
    pitchSummary.text = @"";
    popupTextView.text = @"";
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PubNubNotification:) name:@"pubnubnot" object:nil];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
     arrLocal=[[NSArray alloc]initWithObjects:@"USA",@"Canada",@"North America",nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"resignKeyBoard" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sideView:) name:@"resignKeyBoard" object:nil];
    
    intvalueTwitter=0;
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    timeZoneString = [NSString stringWithFormat:@"%@",currentTimeZone];
    timeZoneString = [[[[timeZoneString componentsSeparatedByString:@"("] objectAtIndex:2] componentsSeparatedByString:@")"] objectAtIndex:0];
    NSLog(@"%@",timeZoneString);
  
    if (IS_IPHONE_5)
    {
        txtViewTwitter.frame=CGRectMake(txtViewTwitter.frame.origin.x+10, txtViewTwitter.frame.origin.y, txtViewTwitter.frame.size.width-20, 200);
    }
    else if (IS_IPHONE_6)
    {
    txtViewTwitter.frame=CGRectMake(txtViewTwitter.frame.origin.x+10, txtViewTwitter.frame.origin.y, txtViewTwitter.frame.size.width-20, 225);
    }
    else if (IS_IPHONE_6_PLUS)
    {
    txtViewTwitter.frame=CGRectMake(txtViewTwitter.frame.origin.x+10, txtViewTwitter.frame.origin.y, txtViewTwitter.frame.size.width-20, 250);
    }
//    borderImageVw.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    borderImageVw.layer.borderWidth=0.8f;
//    borderImageVw.layer.cornerRadius = 8;
//    borderImageVw.layer.masksToBounds = YES;
    
    UIImage *picture = [UIImage imageNamed:@"600x400.png"];
    imgDummy=[UIImage imageNamed:@"600x400.png"];
    
    buttonImageTemp1.image=buttonImageTemp2.image=buttonImageTemp3.image=buttonImageTemp4.image=buttonImageTemp5.image=[UIImage imageNamed:@"600x400.png"];
    imgToLoad=buttonImageTemp1.image;
    data_first = UIImagePNGRepresentation(picture);
    data2_Second = UIImagePNGRepresentation(buttonImageTemp1.image);
    
    [super viewDidLoad];
    tableVw.delegate = nil;
    tableVw.dataSource =nil;
    tableSuperView.hidden =YES;
    appdelegateInstance = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
     [toolBar removeFromSuperview];
    [toolbarTwitterLike removeFromSuperview];
    pitchTitle.inputAccessoryView=toolBar;
     pitchSummary.inputAccessoryView=toolBar;
     pitchDetailIno.inputAccessoryView=toolBar;
     zipcode.inputAccessoryView=toolBar;
     websiteUrlTextField.inputAccessoryView=toolBar;
     socialNetworkTextField.inputAccessoryView=toolBar;
    popupTextField.inputAccessoryView=toolBar;
    popupTextView.inputAccessoryView=toolBar;
    txtViewTwitter.inputAccessoryView=toolBar;
    
//    pitchIdString = @"1";
//    EditNewString = @"Edit";
//    pitchActiveExpireStatusString = @"0";
    
    [self categoryApi];
    localNationalBool = YES;
    [self shiftBottomView];
    socialnetworkLinkArray= [[NSMutableArray alloc]initWithObjects:@"http://www.facebook.com/",@"http://www.twitter.com/",@"http://www.linkedin.com/",@"http://www.instagram.com/",@"http://www.", nil];
    websiteUrlTextField.text = @"http://www.";
    selectedCategoryIdArray= [[NSMutableArray alloc]init];
    selectedCategoryArray = [[NSMutableArray alloc]init];
    expiryDaysArray = [[NSMutableArray alloc]init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        scrollVw.contentSize = CGSizeMake(768, 1290);
    }
    else{
       scrollVw.contentSize = CGSizeMake(self.view.frame.size.width, 1020);
    }
//     [self showPitchDetail];
    
    submitButton.backgroundColor = [UIColor orangeColor];
    submitButton.layer.cornerRadius = 8;
    submitButton.layer.masksToBounds = YES;
}
-(void)showPitchDetail
{
   [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService=[[NSString alloc]initWithFormat:@"%@showpitchdetail",AppURL];
    NSLog(@"%@",strWebService);
    NSDictionary *dictParams;
    
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:pitchIdString,@"pitch_id1",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",
                nil];
    
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
            
             NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             if ([str isEqualToString:@"0"] )
             {
                 NSLog(@"%@",[[[response valueForKey:@"data"] valueForKey:@"image1_new"] objectAtIndex:0]);
                 pitchTitle.text = [NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"title"] objectAtIndex:0]];
                 pitchSummary.text = [NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"summary"] objectAtIndex:0]];
                  pitchDetailIno.text = [NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"description"] objectAtIndex:0]];
                 
                  pitchCreatedDate = [NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"created"] objectAtIndex:0]];
                 
                 pitchDetailLabel.hidden = YES;
                 pitchSummaryLabel.hidden = YES;
                 
                 NSString *mediaString = [NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"media_coverage"] objectAtIndex:0]];
                 
                 
                 if ([mediaString isEqualToString:@"1"]) {
                     [localNationalButton setTitle:@"Local" forState:UIControlStateNormal];
                     zipcode.text = [NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"zip_code"] objectAtIndex:0]];
                     localNationalBool = NO;
                 }else if ([mediaString isEqualToString:@"2"])
                 {
                     [localNationalButton setTitle:@"USA" forState:UIControlStateNormal];
                     localNationalBool = YES;
                 }else  if ([mediaString isEqualToString:@"3"]){
                     [localNationalButton setTitle:@"Canada" forState:UIControlStateNormal];
                      localNationalBool = YES;
                 }else if ([mediaString isEqualToString:@"4"]){
                     [localNationalButton setTitle:@"North America" forState:UIControlStateNormal];
                      localNationalBool = YES;
                 }

                 

                 [self shiftBottomView];
                 
                 NSArray *idarray = [[[[response valueForKey:@"data"] valueForKey:@"categoryids"]  objectAtIndex:0] componentsSeparatedByString:@","];
                 for (int k =0; k<idarray.count; k++) {
                     [selectedCategoryIdArray addObject:[idarray objectAtIndex:k]];
                 }
                 NSLog(@"%@",selectedCategoryIdArray);
                 NSArray *namearray = [[[[response valueForKey:@"data"] valueForKey:@"catgoryname"] objectAtIndex:0] componentsSeparatedByString:@","];
                 for (int k =0; k<namearray.count; k++) {
                     [selectedCategoryArray addObject:[namearray objectAtIndex:k]];
                 }
                 NSLog(@"%@",selectedCategoryArray);
                  int x=5;
                 for (int g=0; g<selectedCategoryArray.count; g++) {
                     UIButton*filteredCategoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
                     
                     UILabel*textLabel = [[UILabel alloc]init];
                    
                    textLabel.text =[NSString stringWithFormat:@"%@",[selectedCategoryArray objectAtIndex:g]];
                     
                     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                     {
                         filteredCategoryButton.frame = CGRectMake(x, 2, 768/2-10, 55);
                         filteredCategoryButton.titleLabel.font  = [UIFont fontWithName:@"Helvetica" size:23];
                          textLabel.font  = [UIFont fontWithName:@"Helvetica" size:23];
                          textLabel.frame = CGRectMake(filteredCategoryButton.frame.origin.x+5, filteredCategoryButton.frame.origin.y+5, filteredCategoryButton.frame.size.width-50, filteredCategoryButton.frame.size.height-10);
                     }
                     else{
                         int height = 35;
                         if (self.view.frame.size.width>320) {
                             height = 35;
                         }
                         //filteredCategoryButton.frame = CGRectMake(x, 3, self.view.frame.size.width/3-10, height);
                          filteredCategoryButton.frame = CGRectMake(x, 3, self.view.frame.size.width/2-10, height);
                         filteredCategoryButton.titleLabel.font  = [UIFont fontWithName:@"Helvetica" size:11];
                         textLabel.font  = [UIFont fontWithName:@"Helvetica" size:15];
                          textLabel.frame = CGRectMake(filteredCategoryButton.frame.origin.x+5, filteredCategoryButton.frame.origin.y+5, filteredCategoryButton.frame.size.width-25, filteredCategoryButton.frame.size.height-10);
                     }

                    
                     textLabel.textAlignment = NSTextAlignmentCenter;
                     textLabel.textColor = [UIColor whiteColor];
                    // [filteredCategoryButton setTitle:[NSString stringWithFormat:@"%@",[selectedCategoryArray objectAtIndex:g] ] forState:UIControlStateNormal];
                     [filteredCategoryButton setBackgroundImage:[UIImage imageNamed:@"Forma11.png"] forState:UIControlStateNormal];
                     [filteredCategoryButton addTarget:self action:@selector(DeleteCategory:) forControlEvents:UIControlEventTouchUpInside];
                     
                    [selectedCategoryVw addSubview:filteredCategoryButton];
                     [selectedCategoryVw addSubview:textLabel];
                    // selectedCategoryVw.layer.borderColor = [UIColor redColor].CGColor;
                    // selectedCategoryVw.layer.borderWidth = 3.0f;
                          //[categoryBottomSubView addSubview:filteredCategoryButton];
                     filteredCategoryButton.tag = g+1;
                     textLabel.tag = filteredCategoryButton.tag+10;
                     x = x+filteredCategoryButton.frame.size.width+10;
                 }
                 
                // selectedCategoryArray
                 
                 
                 
                 [socialnetworkLinkArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"media_url_facebook"] objectAtIndex:0]]];
                 [socialnetworkLinkArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"media_url_twitter"] objectAtIndex:0]]];
                 [socialnetworkLinkArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"media_url_linkedin"] objectAtIndex:0]]];
                 [socialnetworkLinkArray replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"media_url_instagram"] objectAtIndex:0]]];
                 [socialnetworkLinkArray replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"media_url_website"] objectAtIndex:0]]];
                 
                 websiteUrlTextField.text =  [NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"media_url_website"] objectAtIndex:0]];
                 
                 
                 [expiresButton setTitle:[NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"expiry_days"] objectAtIndex:0]] forState:UIControlStateNormal];
                 
                 
                 NSURL*Url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[response valueForKey:@"data"] valueForKey:@"image1_new"] objectAtIndex:0]]];
                //[buttonImageTemp1 setImageWithURL:Url1 placeholderImage:[UIImage imageNamed:@"600x400.png"] imagesize:CGSizeMake(buttonImageTemp1.frame.size.width, buttonImageTemp1.frame.size.height)];
                 
                [buttonImageTemp1 setImageWithURL1:Url1 placeholderImage:[UIImage imageNamed:@"600x400.png"] imagesize:CGSizeMake(buttonImageTemp1.frame.size.width, buttonImageTemp1.frame.size.height)];
                 
                 NSURL*Url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[response valueForKey:@"data"] valueForKey:@"image2_new"] objectAtIndex:0]]];
                 if (![[[[response valueForKey:@"data"] valueForKey:@"image2_new"] objectAtIndex:0] isEqualToString:@""] ) {
                     strUploadingImage=@"uploading";
                     [buttonImageTemp2 setImageWithURL1:Url2 placeholderImage:[UIImage imageNamed:@"600x400.png"] imagesize:CGSizeMake(buttonImageTemp2.frame.size.width, buttonImageTemp2.frame.size.height)];
                 }
                 
                 
                 NSURL*Url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[response valueForKey:@"data"] valueForKey:@"image3_new"] objectAtIndex:0]]];
                 if (![[[[response valueForKey:@"data"] valueForKey:@"image3_new"] objectAtIndex:0] isEqualToString:@""] ) {
                 [buttonImageTemp3 setImageWithURL1:Url3 placeholderImage:[UIImage imageNamed:@"600x400.png"] imagesize:CGSizeMake(buttonImageTemp3.frame.size.width, buttonImageTemp3.frame.size.height)];
                 }
                 
                 NSURL*Url4 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[response valueForKey:@"data"] valueForKey:@"image4_new"] objectAtIndex:0]]];
                 if (![[[[response valueForKey:@"data"] valueForKey:@"image4_new"] objectAtIndex:0] isEqualToString:@""] ) {
                 [buttonImageTemp4 setImageWithURL1:Url4 placeholderImage:[UIImage imageNamed:@"600x400.png"] imagesize:CGSizeMake(buttonImageTemp4.frame.size.width, buttonImageTemp4.frame.size.height)];
                 }
                 
                 NSURL*Url5 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[response valueForKey:@"data"] valueForKey:@"image5_new"] objectAtIndex:0]]];
                  if (![[[[response valueForKey:@"data"] valueForKey:@"image5_new"] objectAtIndex:0] isEqualToString:@""] ) {
                 [buttonImageTemp5 setImageWithURL1:Url5 placeholderImage:[UIImage imageNamed:@"600x400.png"] imagesize:CGSizeMake(buttonImageTemp5.frame.size.width, buttonImageTemp5.frame.size.height)];
                  }
                 
                 tableVw.delegate = self;
                 tableVw.dataSource = self;
                 [tableVw reloadData];
                
                 [self performSelector:@selector(setimage) withObject:nil afterDelay:2.0];
                 
             }
             else if ([str isEqualToString:@"10"] )
             {
                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 alert.tag = 1234;
                 [alert show];
             }
             else if ([str isEqualToString:@"11"] )
             {
//                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//                 [alert show];
                 [constant alertViewWithMessage:[response valueForKey:@"message"]withView:self];
             }
             else if ([response valueForKey:@"Failure"] )
             {
//                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"Failure"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                 [alert show];
                 [constant alertViewWithMessage:[response valueForKey:@"Failure"]withView:self];
             }else{
//                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Please try again unable to process your request." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                 [alert show];
                 [constant alertViewWithMessage:@"Please try again unable to process your request."withView:self];
                
             }
             
             
              [appdelegateInstance hideHUD];
         }
         else
         {
             [appdelegateInstance hideHUD];
             [constant AlertMessageWithString:@"Connectivity levels low. Please try again." andWithView:self.view];
             NSLog(@"Error returned:%@",[error localizedDescription]);
         }
     }];
}
-(void)setdata{
    if ([data_first isEqual:data2_Second]) {
        data2_Second = UIImagePNGRepresentation(buttonImageTemp1.image);
    }
    else
    {
         _timer = nil;
         [_timer invalidate];
    }
}
-(void)setimage{
    
     //[addImageButton1 setBackgroundImage:buttonImageTemp1.image forState:UIControlStateNormal];
//     [addImageButton2 setBackgroundImage:buttonImageTemp2.image forState:UIControlStateNormal];
//    [addImageButton3 setBackgroundImage:buttonImageTemp3.image forState:UIControlStateNormal];
//    [addImageButton4 setBackgroundImage:buttonImageTemp4.image forState:UIControlStateNormal];
//    [addImageButton5 setBackgroundImage:buttonImageTemp5.image forState:UIControlStateNormal];
    data2_Second = UIImagePNGRepresentation(buttonImageTemp1.image);
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                              target:self
                                            selector:@selector(setdata)
                                            userInfo:nil
                                             repeats:YES];
    
   // [self performSelector:@selector(setdata) withObject:nil afterDelay:5];
    //[self setdata];
    imageCounter = 5;
}
-(void)shiftBottomView{
    if (localNationalBool) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
             mediaCoverageView.frame = CGRectMake(mediaCoverageView.frame.origin.x, mediaCoverageView.frame.origin.y, mediaCoverageView.frame.size.width, 60);
        }
        else{
        mediaCoverageView.frame = CGRectMake(mediaCoverageView.frame.origin.x, mediaCoverageView.frame.origin.y, mediaCoverageView.frame.size.width, 50);
        }
    }
    else{
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
             mediaCoverageView.frame = CGRectMake(mediaCoverageView.frame.origin.x, mediaCoverageView.frame.origin.y, mediaCoverageView.frame.size.width, 130);
        }
        else{
             mediaCoverageView.frame = CGRectMake(mediaCoverageView.frame.origin.x, mediaCoverageView.frame.origin.y, mediaCoverageView.frame.size.width, 100);
        }
        
    }
    bottomViewOfMediaCoverage.frame = CGRectMake(bottomViewOfMediaCoverage.frame.origin.x, mediaCoverageView.frame.origin.y+mediaCoverageView.frame.size.height+2, bottomViewOfMediaCoverage.frame.size.width, bottomViewOfMediaCoverage.frame.size.height);
}

-(void)categoryApi
{
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
        NSString*strWebService=[[NSString alloc]initWithFormat:@"%@showcategory",AppURL];
        NSLog(@"%@",strWebService);
    NSMutableDictionary *dictParams;
    dictParams=[[NSMutableDictionary alloc]init];
    [dictParams setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"] forKey:@"user_id"];
    
//        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"Token"]],@"Token",
//                    nil];

   
        [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
         {
             if (!error)
             {
                 NSLog(@"response of get request:%@",response);
                 //[appdelegateInstance hideHUD];
                 NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
                 if ([str isEqualToString:@"0"] )
                 {
                     categoryMainArray=[[NSMutableArray alloc]init];
                     for (int k=0; k<[[response valueForKey:@"data"] count]; k++) {
                         categoryHold* objectClass = [[categoryHold alloc] init];
                         objectClass.categoryName=[[[[response valueForKey:@"data"] valueForKey:@"Category"] valueForKey:@"cat_name"] objectAtIndex:k] ;
                         objectClass.categoryId=[[[[response valueForKey:@"data"] valueForKey:@"Category"] valueForKey:@"id"] objectAtIndex:k] ;
                         [categoryMainArray addObject:objectClass];
                     }
                     
                     
                    for (int m=0; m< [[response valueForKey:@"max_expiry_day"] count]; m++) 
                    {
                         
                         
                        // NSString*str = [[[response valueForKey:@"max_expiry_day"]  objectAtIndex:m] valueForKey:@"days"];
                        
                        NSString*str = [[[[response valueForKey:@"max_expiry_day"] valueForKey:@"Setting"] valueForKey:@"days"] objectAtIndex:m];
                         
                         [expiryDaysArray addObject:str];
                         
                     } 
                     
                   // NSString*str = [NSString stringWithFormat:@"%ld",(long)[[response valueForKey:@"max_expiry_day"] integerValue]];
//                     maxExpireDays = [str integerValue];
//                     NSLog(@"%ld",(long)maxExpireDays);
//                     
//                     
//                     
//                     
//                     for (int k=0; k<maxExpireDays; k++) {
//                         [expiryDaysArray addObject:[NSString stringWithFormat:@"%d",k+1]];
//                     }
                     
                     
                     if ([EditNewString isEqualToString:@"Edit"])
                     {
                         [self showPitchDetail];
                         headerTitle.text =@"EDIT PITCH";
                     }
                     else
                     {
                         [appdelegateInstance hideHUD];
                         tableVw.delegate = self;
                         tableVw.dataSource = self;
                         [tableVw reloadData];
                         headerTitle.text =@"COMPOSE PITCH";
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
                     [appdelegateInstance hideHUD];
//                         UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"Failure"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                         [alert show];
                     [constant alertViewWithMessage:[response valueForKey:@"Failure"]withView:self];
                 }
                 else
                 {
                    [appdelegateInstance hideHUD];
//                    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Please try again unable to process your request." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                     [alert show];
                     [constant alertViewWithMessage:@"Please try again unable to process your request."withView:self];
                     NSLog(@"Error returned:%@",[error localizedDescription]);

                 }
             }
             else
             {
                 [appdelegateInstance hideHUD];
                 [constant AlertMessageWithString:@"Connectivity levels low. Please try again." andWithView:self.view];
                 NSLog(@"Error returned:%@",[error localizedDescription]);
             }
         }];
}
#pragma mark TextField Method

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    
    if (textField==zipcode)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        //if (zipcode.text.length<8) {
       // NSLog(@"%u",[textField.text length] + [string length] - range.length);
        if (([textField.text length] + [string length] - range.length)<12) {
            return [string isEqualToString:filtered];
        }
        
        //}
       
    }
    else if (textField==pitchTitle || textField == popupTextField)
    {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
            NSUInteger remainingint = 50- newLength;
        if (remainingint<=50) {
            toolbarCance.title = [NSString stringWithFormat:@"%lu Left",(unsigned long)remainingint];
            pitchTitle.text  = textField.text;
            pitchTitle.text = [NSString stringWithFormat:@"%@%@",pitchTitle.text,string];
        }
        
        if (string.length==0) {
            NSString *newString = [pitchTitle.text substringToIndex:[pitchTitle.text length]-1];
            
            pitchTitle.text=newString;
            
        }
        if (newLength==0) {
            pitchTitle.placeholder =@"Describe your pitch in 1 phrase (50 Characters)";
        }
        return (newLength > 50) ? NO : YES;
    }
    else{
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 150) ? NO : YES;
    }
    return 0;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == websiteUrlTextField) {
         [socialnetworkLinkArray replaceObjectAtIndex:4 withObject:websiteUrlTextField.text];
    }
   
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField== zipcode  ) {
        [scrollVw setContentOffset:CGPointMake(0,350) animated:NO];
    }
    else if (textField == websiteUrlTextField)
    {
         [scrollVw setContentOffset:CGPointMake(0,420) animated:NO];
          if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
              UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
              if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortrait) {
               [scrollVw setContentOffset:CGPointMake(0,300) animated:NO];
              }
              else{
                  if ([localNationalButton.titleLabel.text isEqualToString:@"Local"]) {
                      [scrollVw setContentOffset:CGPointMake(0,650) animated:NO];
                  }
                  else{
                      [scrollVw setContentOffset:CGPointMake(0,590) animated:NO];
                  }
                  
              }
          }
    }
       return YES;
}
#pragma mark TextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger newLength;
    newLength = (txtViewTwitter.text.length - range.length) + text.length;
    NSLog(@"%lu",(unsigned long)newLength);
    
    if (intvalueTwitter==1)
    {
        maxlimit = 50;
       // pitchTitle.text=txtViewTwitter.text;

    }
    if (intvalueTwitter==2)
    {
        maxlimit = 200;
    }
    if (intvalueTwitter==3)
    {
        maxlimit = 400;
       // pitchDetailIno.text=txtViewTwitter.text;
    }
    
    
    
    if(newLength <= maxlimit)
    {
        NSUInteger remainingint = maxlimit- newLength;
        NSLog(@"%lu",(unsigned long)remainingint);
        toolbarCance.title = [NSString stringWithFormat:@"%lu Left",(unsigned long)remainingint];
        aletShow=false;
    }
    else
    {
        if (aletShow==true)
        {
          
        }
        else
        {
        aletShow=true;
        }
    
    }
     if (aletShow==YES)
    {
        return NO;
    }
    else{
        
    return YES;
    }

}



- (void)textViewDidBeginEditing:(UITextView *)textView
{

}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView == pitchDetailIno) {
        
        [scrollVw setContentOffset:CGPointMake(0,140) animated:NO];
    }
    if (textView==txtViewTwitter)
    {
        txtViewTwitter.inputAccessoryView=toolBar;
    }
    return YES;
}


- (void)textViewDidEndEditing:(UITextView *)theTextView
{
       if (![pitchSummary hasText])
    {
        pitchSummaryLabel.hidden = NO;
    }
    if (![pitchDetailIno hasText])
    {
        pitchDetailLabel.hidden = NO;
    }
}

- (void) textViewDidChange:(UITextView *)textView
{
    if(![pitchSummary hasText])
    {
        pitchSummaryLabel.hidden = NO;
    }
    else
    {
        pitchSummaryLabel.hidden = YES;
    }
    
    if(![pitchDetailIno hasText])
    {
        pitchDetailLabel.hidden = NO;
    }
    else{
        pitchDetailLabel.hidden = YES;
    }
}



#pragma mark ToolBar method
-(IBAction)cancelToolBar:(id)sender
{
    NSRange top1 = NSMakeRange(0, 0);
    [pitchSummary scrollRangeToVisible:top1];
    NSRange top2 = NSMakeRange(0, 0);
    [pitchDetailIno scrollRangeToVisible:top2];
    
    [pitchTitle resignFirstResponder];
     [pitchSummary resignFirstResponder];
     [pitchDetailIno resignFirstResponder];
     [zipcode resignFirstResponder];
    [websiteUrlTextField resignFirstResponder];
     [socialNetworkTextField resignFirstResponder];
    [popupTextField resignFirstResponder];
    [popupTextView resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self.view setFrame:CGRectMake(0, 0 ,self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}
-(IBAction)Done
{
    NSRange top1 = NSMakeRange(0, 0);
    [pitchSummary scrollRangeToVisible:top1];
    NSRange top2 = NSMakeRange(0, 0);
    [pitchDetailIno scrollRangeToVisible:top2];
    [pitchTitle resignFirstResponder];
    [pitchSummary resignFirstResponder];
    [pitchDetailIno resignFirstResponder];
     [zipcode resignFirstResponder];
     [websiteUrlTextField resignFirstResponder];
    [socialNetworkTextField resignFirstResponder];
    [popupTextField resignFirstResponder];
    [popupTextView resignFirstResponder];
    [txtViewTwitter resignFirstResponder];
    viewTwitterLike.hidden=YES;
    socialNetworkView.hidden = YES;
    
    if (intvalueTwitter==1)
    {
        pitchTitle.text=@"";
    pitchTitle.text=txtViewTwitter.text;
    }
    if (intvalueTwitter==2)
    {
        pitchSummary.text=@"";
        pitchSummary.text=txtViewTwitter.text;
        NSRange top = NSMakeRange(0, 1);
        [pitchSummary scrollRangeToVisible:top];
        if (txtViewTwitter.text.length>0)
        {
            pitchSummaryLabel.hidden=YES;
        }
        else
        {
          pitchSummaryLabel.hidden=NO;
        }
    }
    if (intvalueTwitter==3)
    {
        pitchDetailIno.text=@"";
        pitchDetailIno.text=txtViewTwitter.text;
        NSRange top = NSMakeRange(0, 1);
        [pitchDetailIno scrollRangeToVisible:top];
        if (txtViewTwitter.text.length>0)
        {
            pitchDetailLabel.hidden=YES;
        }
        else
        {
         pitchDetailLabel.hidden=NO;
        }
    }
    if (socialNetworkTextField.text.length>0) {
        [socialnetworkLinkArray replaceObjectAtIndex:tagOfSocialNetwork-1 withObject:socialNetworkTextField.text];
        socialNetworkView.hidden = YES;
        [socialNetworkTextField resignFirstResponder];
    }
//    else{
//        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter some text." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
//    }
    intvalueTwitter=0;
     toolbarCance.title=@"Cancel";
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self.view setFrame:CGRectMake(0, 0 ,self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
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
#pragma mark Others Method
- (IBAction)shareButtonPressed:(id)sender {
    [pitchTitle resignFirstResponder];
    [pitchSummary resignFirstResponder];
    [pitchDetailIno resignFirstResponder];
    [zipcode resignFirstResponder];
    [websiteUrlTextField resignFirstResponder];
    [socialNetworkTextField resignFirstResponder];
    socialNetworkView.hidden = NO;
    //socialNetworkTextField.text = @"";
    UIButton *btn = (UIButton*)sender;
    
    tagOfSocialNetwork = btn.tag;
    if (btn.tag==1) {
        // facebook
        socialNetworkLabelInView.text = @"Facebook link";
        socialNetworkTextField.text = [NSString stringWithFormat:@"%@",[socialnetworkLinkArray objectAtIndex:0]];
    }
    if (btn.tag==2) {
        // twitter
        socialNetworkLabelInView.text = @"Twitter link";
         socialNetworkTextField.text = [NSString stringWithFormat:@"%@",[socialnetworkLinkArray objectAtIndex:1]];
    }
    if (btn.tag==3) {
        // linkedin
        socialNetworkLabelInView.text = @"Linkedin link";
         socialNetworkTextField.text = [NSString stringWithFormat:@"%@",[socialnetworkLinkArray objectAtIndex:2]];
    }
    if (btn.tag==4) {
        // instagram
        socialNetworkLabelInView.text = @"Instagram link";
         socialNetworkTextField.text = [NSString stringWithFormat:@"%@",[socialnetworkLinkArray objectAtIndex:3]];
    }
}

- (IBAction)addimageButtonPressed:(UIButton*)sender {
    UIView*addImageView = (UIView*)[scrollVw viewWithTag:4];
    [self resignKeyBoard];
    if ([sender tag]==5001) {
        CoverImageBool = YES;
        UIImageView*ImageViewButton = (UIImageView*)[addImageView viewWithTag:1001];
        if(!ImageViewButton.userInteractionEnabled)
        {
            strUploadingImage=@"uploading";
            return;
        }
        else{
            strUploadingImage=@"notuploading";
        }
    }
    if ([sender tag]==5002) {
        UIImageView*ImageViewButton = (UIImageView*)[addImageView viewWithTag:1002];
        if(!ImageViewButton.userInteractionEnabled)
        {
            return;
        }
    }
    if ([sender tag]==5003) {
        UIImageView*ImageViewButton = (UIImageView*)[addImageView viewWithTag:1003];
        if(!ImageViewButton.userInteractionEnabled)
        {
            return;
        }
    }
    if ([sender tag]==5004) {
        UIImageView*ImageViewButton = (UIImageView*)[addImageView viewWithTag:1004];
        if(!ImageViewButton.userInteractionEnabled)
        {
            return;
        }
    }
    if ([sender tag]==5005) {
        UIImageView*ImageViewButton = (UIImageView*)[addImageView viewWithTag:1005];
        if(!ImageViewButton.userInteractionEnabled)
        {
            return;
        }
    }
    
    
    [self uploadImage:[sender tag]-4000];
    addimageInt = [sender tag];
}

- (IBAction)textBoxButtonPressed:(UIButton*)sender {
    if ([sender tag]==1)
    {
        intvalueTwitter=1;
        lblTwitterView.text = @"Title";
        viewTwitterLike.hidden=NO;
        txtViewTwitter.text = pitchTitle.text;
        NSInteger remaininglength = 50-txtViewTwitter.text.length;
        toolbarCance.title = [NSString stringWithFormat:@"%lu Left",(unsigned long)remaininglength];
       
        [txtViewTwitter becomeFirstResponder];
        }
    
    if ([sender tag]==2)
    {
        intvalueTwitter=2;
        lblTwitterView.text = @"Pitch Summary";
        viewTwitterLike.hidden=NO;
         maxlimit = 200;
       txtViewTwitter.text = pitchSummary.text;
        NSInteger remaininglength = 200-txtViewTwitter.text.length;
        toolbarCance.title = [NSString stringWithFormat:@"%lu Left",(unsigned long)remaininglength];
        
//        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
//        [btn setImage:[UIImage imageNamed:@"600x400.png"] forState:UIControlStateNormal
//         ];
//        [toolBarDone setCustomView:btn]
//        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithImage:@"600x400.png" style:UIBarButtonItemst target:self action:@selector(myAction)];
        //[toolBarDone setImage:[UIImage imageNamed:@"600x400.png"]];
        //[toolBarDone setTintColor:[UIColor clearColor]];
        [txtViewTwitter becomeFirstResponder];
      //  blackTransparentVw.frame = CGRectMake(blackTransparentVw.frame.origin.x, blackTransparentVw.frame.origin.y, blackTransparentVw.frame.size.width, 200);
       // remainingLabel.frame = CGRectMake(remainingLabel.frame.origin.x, 185, remainingLabel.frame.size.width, remainingLabel.frame.size.height);
    }
    if ([sender tag]==3)
    {
        intvalueTwitter=3;
        lblTwitterView.text = @"Pitch Description";
        viewTwitterLike.hidden=NO;
         maxlimit = 400;
       txtViewTwitter.text = pitchDetailIno.text;
        NSInteger remaininglength = 400-txtViewTwitter.text.length;
        toolbarCance.title = [NSString stringWithFormat:@"%lu Left",(unsigned long)remaininglength];
        [txtViewTwitter becomeFirstResponder];
    }
}


-(void)resignKeyBoard{
    [pitchTitle resignFirstResponder];
    [pitchSummary resignFirstResponder];
    [pitchDetailIno resignFirstResponder];
    [websiteUrlTextField resignFirstResponder];
    [socialNetworkTextField resignFirstResponder];
     [zipcode resignFirstResponder];
}
- (IBAction)selectCategoryAction:(UIButton*)sender {
    
    tableViewOpenBool =YES;
    testView.hidden = NO;
    
    [self resignKeyBoard];
    NSLog(@"%ld",(long)[sender tag]);
    tagOfTableToShow = [sender tag];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if (tagOfTableToShow == 123) {
            // local and national
            if ([localNationalButton.titleLabel.text isEqualToString:@"Local"]) {
                 tableVw.frame = CGRectMake(localNationalButton.frame.origin.x, mediaCoverageView.frame.origin.y+80-scrollVw.contentOffset.y,localNationalButton.frame.size.width, 160);
            }
            else{
             tableVw.frame = CGRectMake(localNationalButton.frame.origin.x, mediaCoverageView.frame.origin.y+mediaCoverageView.frame.size.height+20-scrollVw.contentOffset.y, localNationalButton.frame.size.width, 160);
            }
        }
        else if (tagOfTableToShow == 321) {
            // catgories
             tableVw.frame = CGRectMake(selectCategoryButton.frame.origin.x-20, 160+bottomViewOfMediaCoverage.frame.origin.y-scrollVw.contentOffset.y, 300, 300);
        }
        else if (tagOfTableToShow == 111) {
            // Expiry day
            tableVw.frame = CGRectMake(expiresButton.frame.origin.x+20, expiresinView.frame.origin.y+80+bottomViewOfMediaCoverage.frame.origin.y-scrollVw.contentOffset.y, 55, 200);
        }
    }
    else{
        if (tagOfTableToShow == 123) {
            // local and national
            if ([localNationalButton.titleLabel.text isEqualToString:@"Local"]) {
                tableVw.frame = CGRectMake(localNationalButton.frame.origin.x, mediaCoverageView.frame.origin.y+50-scrollVw.contentOffset.y, localNationalButton.frame.size.width, 160);
                if ((tableVw.frame.origin.y+tableVw.frame.size.height)>self.view.frame.size.height) {
                     tableVw.frame = CGRectMake(localNationalButton.frame.origin.x, mediaCoverageView.frame.origin.y+40-scrollVw.contentOffset.y-120, localNationalButton.frame.size.width, 160);
                }
            }
            else{
                tableVw.frame = CGRectMake(localNationalButton.frame.origin.x, mediaCoverageView.frame.origin.y+mediaCoverageView.frame.size.height-scrollVw.contentOffset.y, localNationalButton.frame.size.width, 160);
                if ((tableVw.frame.origin.y+tableVw.frame.size.height+60)>self.view.frame.size.height) {
                     tableVw.frame = CGRectMake(localNationalButton.frame.origin.x, mediaCoverageView.frame.origin.y+mediaCoverageView.frame.size.height-scrollVw.contentOffset.y-210, localNationalButton.frame.size.width, 160);
                }
            }
            if ((tableVw.frame.origin.y+tableVw.frame.size.height)>self.view.frame.size.height) {
                
            }
        }
        else if (tagOfTableToShow == 321) {
            // catgories
            tableVw.frame = CGRectMake(selectCategoryButton.frame.origin.x, 170+bottomViewOfMediaCoverage.frame.origin.y-scrollVw.contentOffset.y, 200, 200);
        }
        else if (tagOfTableToShow == 111) {
            // Expiry day
            tableVw.frame = CGRectMake(expiresButton.frame.origin.x+10, expiresinView.frame.origin.y+50+bottomViewOfMediaCoverage.frame.origin.y-scrollVw.contentOffset.y, 55, 200);
            if ((tableVw.frame.origin.y+tableVw.frame.size.height+50)>self.view.frame.size.height) {
                tableVw.frame = CGRectMake(expiresButton.frame.origin.x+10, expiresinView.frame.origin.y+40+bottomViewOfMediaCoverage.frame.origin.y-scrollVw.contentOffset.y-240, 55, 200);
            }
        }

  }
     tableVw.separatorColor = [UIColor clearColor];
     [tableSuperView addSubview:tableVw];
    tableSuperView.hidden = NO;
   
     [tableVw reloadData];
}

- (IBAction)resignTableVw:(id)sender {
     tableSuperView.hidden = YES;
    testView.hidden = YES;
    tableViewOpenBool = NO;
}

- (IBAction)resignAllKeys:(id)sender {
    //[self resignKeyBoard];
}
#pragma mark RunAPI method
- (BOOL) validateUrl: (NSString *) candidate {
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    NSLog(@"%d",[urlTest evaluateWithObject:candidate]);
    return [urlTest evaluateWithObject:candidate];
}
- (IBAction)submit:(id)sender {
    
      if (websiteUrlTextField.text.length>0) {
           if ([websiteUrlTextField.text hasPrefix:@"http://"] || [websiteUrlTextField.text hasPrefix:@"https://"])
           {
           }
           else{
               websiteUrlTextField.text = [NSString stringWithFormat:@"http://%@",websiteUrlTextField.text];
               [socialnetworkLinkArray replaceObjectAtIndex:4 withObject:websiteUrlTextField.text];
           }
        NSLog(@"%@",websiteUrlTextField.text);
    }
    
    pitchTitle.text = [pitchTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    pitchSummary.text = [pitchSummary.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    pitchDetailIno.text = [pitchDetailIno.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    if (![localNationalButton.titleLabel.text isEqualToString:@"Local"]) {
        zipcode.text = @"";
    }
    
    NSLog(@"%@",socialnetworkLinkArray);
    if ([pitchTitle.text isEqualToString:@""] || pitchTitle.text.length<=0 ) {
//        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter Pitch title" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [constant alertViewWithMessage:@"Please enter Pitch title."withView:self];
    }
   else if ([pitchSummary.text isEqualToString:@""] || pitchSummary.text.length<=0 ) {
//        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter Pitch summary" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
       [constant alertViewWithMessage:@"Please enter Pitch summary."withView:self];
    }
   else if ([pitchDetailIno.text isEqualToString:@""] || pitchDetailIno.text.length<=0 ) {
//       UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter Pitch info" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//       [alert show];
       [constant alertViewWithMessage:@"Please enter Pitch info." withView:self];
   }
  
   else if ([data_first isEqual:data2_Second]){
       
       if ( [strUploadingImage isEqualToString:@"uploading"]) {
//            UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please wait while cover image is loading" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
           [constant alertViewWithMessage:@"Please wait while cover image is loading."withView:self];
       }else{
//       UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please select cover image" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
           [constant alertViewWithMessage:@"Please select cover image."withView:self];
       }
       
       
      
   }

   else if ([localNationalButton.titleLabel.text isEqualToString: @"Select"]){
//       UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please select media coverage" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//       [alert show];
       [constant alertViewWithMessage:@"Please select media coverage."withView:self];
   }
   else if ([localNationalButton.titleLabel.text isEqualToString: @"Local"]&& [zipcode.text isEqualToString:@""]){
//       UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter zipcode" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//       [alert show];
       [constant alertViewWithMessage:@"Please enter zipcode."withView:self];
   }
   else if ([localNationalButton.titleLabel.text isEqualToString: @"Local"]&& zipcode.text.length<=3){
//       UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter valid zipcode" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//       [alert show];
       [constant alertViewWithMessage:@"Please enter valid zipcode."withView:self];
   }
 else if ([expiresButton.titleLabel.text isEqualToString: @"Select"]){
//     UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please select expiry time" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//     [alert show];
     [constant alertViewWithMessage:@"Please select expiry time."withView:self];
 }
 else if (selectedCategoryArray.count == 0){
//     UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please select atleast one category" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//     [alert show];
     [constant alertViewWithMessage:@"Please select atleast one category."withView:self];
 }
 else{
     if ([pitchActiveExpireStatusString isEqualToString:@"0"]) {
         
         [appdelegateInstance showHUD:@""];
         [self savePitchApi];

        }
     else{
//         UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"You can not create a new pitch untill any pitch is active" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//         [alert show];
         [constant alertViewWithMessage:@"You can not create a new pitch untill any pitch is active."withView:self];
     }
 }
}
-(void)savePitchApi{
    [appdelegateInstance showHUD:@""];
    
    NSString*strWebService=[[NSString alloc]initWithFormat:@"%@savepitch",AppURL];
    NSLog(@"%@",strWebService);
    
    NSString*categoryIdString;
    for (NSObject * obj in selectedCategoryIdArray)
    {
        categoryIdString = [selectedCategoryIdArray componentsJoinedByString:@","];
        NSLog(@"%@",obj);
    }
    NSLog(@"%@",categoryIdString);
    NSDictionary *dictParams;
    
    NSString *strMedia;
//    if ([localNationalButton.titleLabel.text isEqualToString:@"Local"]) {
//        strMedia=@"1";
//    }else
    if ([localNationalButton.titleLabel.text isEqualToString:@"USA"]) {
        strMedia=@"2";
    }else if ([localNationalButton.titleLabel.text isEqualToString:@"Canada"]) {
        strMedia=@"3";
    }
    else if ([localNationalButton.titleLabel.text isEqualToString:@"North America"]) {
        strMedia=@"4";
    }

    
    
    if ([EditNewString isEqualToString:@"Edit"])
    {
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:
                    pitchTitle.text,@"title",
                    pitchSummary.text,@"summary",
                    pitchDetailIno.text,@"description",
                    strMedia,@"media_coverage",
                    zipcode.text,@"zip_code",
                    categoryIdString,@"category_id",
                    [socialnetworkLinkArray objectAtIndex:0],@"media_url_facebook",
                    [socialnetworkLinkArray objectAtIndex:2],@"media_url_linkedin",
                    [socialnetworkLinkArray objectAtIndex:1],@"media_url_twitter",[socialnetworkLinkArray objectAtIndex:3],@"media_url_instagram",
                    [socialnetworkLinkArray objectAtIndex:4],@"media_url_website",
                    [NSString stringWithFormat:@"%@",[[expiresButton.titleLabel.text componentsSeparatedByString:@" "] objectAtIndex:0]],@"expiry_days",
                    [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"creator_id",
                    pitchIdString,@"pitch_id1",
                    pitchCreatedDate,@"created",
                    nil];

    }
    else{
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:
                    pitchTitle.text,@"title",
                    pitchSummary.text,@"summary",
                    pitchDetailIno.text,@"description",
                    strMedia,@"media_coverage",
                    zipcode.text,@"zip_code",
                    categoryIdString,@"category_id",
                    [socialnetworkLinkArray objectAtIndex:0],@"media_url_facebook",
                    [socialnetworkLinkArray objectAtIndex:2],@"media_url_linkedin",
                    [socialnetworkLinkArray objectAtIndex:1],@"media_url_twitter",
                    [socialnetworkLinkArray objectAtIndex:3],@"media_url_instagram",
                    [socialnetworkLinkArray objectAtIndex:4],@"media_url_website",
                    [NSString stringWithFormat:@"%@",[[expiresButton.titleLabel.text componentsSeparatedByString:@" "] objectAtIndex:0]],@"expiry_days",
                    [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"creator_id",
                    timeZoneString,@"timezone",
                    nil];

    }
    NSLog(@"%@",dictParams);

    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request =
    [serializer multipartFormRequestWithMethod:@"POST" URLString:strWebService
                                    parameters:dictParams
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         UIImage *image123 = buttonImageTemp1.image;
         NSData *data6 = UIImageJPEGRepresentation(image123, 0.6);
         UIImage *image1 = [self imageWithImage:buttonImageTemp1.image scaledToSize:CGSizeMake(600, 600)];
         NSData *data1 = UIImageJPEGRepresentation(image1,0.4);
         NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
         
         NSLog(@"%@  %@",image123,buttonImageTemp2.image);
         
        // UIImage *picture = [UIImage imageNamed:@"600x400.png"];
      //   NSData *pictureData = UIImageJPEGRepresentation(picture,0.6);
         
         if ([buttonImageTemp1.image isEqual:@"600x400.png"]) 
         {
             
         }
         else
         {
         [formData appendPartWithFileData:data6
                                     name:@"file1"
                                 fileName:[NSString stringWithFormat:@"%@_1.jpg",timestamp]
                                 mimeType:@"image/jpeg"];
             
         [formData appendPartWithFileData:data1
                                         name:@"file6"
                                     fileName:[NSString stringWithFormat:@"%@_1.jpg",timestamp]
                                     mimeType:@"image/jpeg"];
             
             
         }
         
         //UIImage *image2 = buttonImageTemp2.image;
        
         
         if ([buttonImageTemp2.image isEqual:imgDummy])
         {

             
             
         }
         else
         {
         NSData *data2 = UIImageJPEGRepresentation(buttonImageTemp2.image, 0.6);
         [formData appendPartWithFileData:data2
                                     name:@"file2"
                                 fileName:[NSString stringWithFormat:@"%@_2.jpg",timestamp]
                                 mimeType:@"image/jpeg"];
         }
         
         //UIImage *image3 = buttonImageTemp3.image;
       
         
         
         
         if ([buttonImageTemp3.image isEqual:imgDummy])
         {

             
         }
         else
         {
        NSData *data3 = UIImageJPEGRepresentation(buttonImageTemp3.image,0.6);
         [formData appendPartWithFileData:data3
                                     name:@"file3"
                                 fileName:[NSString stringWithFormat:@"%@_3.jpg",timestamp]
                                 mimeType:@"image/jpeg"];
         }
         
        // UIImage *image4 = buttonImageTemp4.image;
        
         
         
         
         if ([buttonImageTemp4.image isEqual:imgDummy])
         {

         }
         else
         {
        NSData *data4 = UIImageJPEGRepresentation(buttonImageTemp4.image,0.6);
         [formData appendPartWithFileData:data4
                                     name:@"file4"
                                 fileName:[NSString stringWithFormat:@"%@_4.jpg",timestamp]
                                 mimeType:@"image/jpeg"];
         }
         
        // UIImage *image5 = buttonImageTemp5.image;
        
         
         
                
         if ([buttonImageTemp5.image isEqual:imgDummy])
         {

             
         }
         else
         {
         NSData *data5 = UIImageJPEGRepresentation(buttonImageTemp5.image, 0.6);
         [formData appendPartWithFileData:data5
                                     name:@"file5"
                                 fileName:[NSString stringWithFormat:@"%@_5.jpg",timestamp]
                                 mimeType:@"image/jpeg"];
         }
         
        // NSLog(@"%lu %lu %lu %lu %lu",(unsigned long)data1.length,(unsigned long)data2.length,(unsigned long)data3.length,(unsigned long)data4.length,(unsigned long)data5.length);
         
     } error:Nil];
    [request setTimeoutInterval:300];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];

    AFHTTPRequestOperation *operation =
    [manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"%@",responseObject);
        
         UIAlertView*alert;
         NSString*str = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"error"]];
         if ([str isEqualToString:@"0"])
         {
             if ([EditNewString isEqualToString:@"Edit"]) {
                 alert= [[UIAlertView alloc]initWithTitle:nil message:@"Pitch updated successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
             }
             else{
                 alert= [[UIAlertView alloc]initWithTitle:nil message:@"Pitch created successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
             }
             alert.tag = 987;
             [alert show];
         }
         else if ([str isEqualToString:@"1"]) {
//              UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//             [alert show];
             [constant alertViewWithMessage:[responseObject valueForKey:@"message"]withView:self];
         }
         else if ([str isEqualToString:@"10"] )
         {
             UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
             alert.tag = 1234;
             [alert show];
         }
         else
         {
//             UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//             [alert show];
             [constant alertViewWithMessage:[responseObject valueForKey:@"message"]withView:self];
             
         }
         [appdelegateInstance hideHUD];
         
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
#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 987) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (alertView.tag==1234) {
        AppDelegate *appd= (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appd LogoutFromApp:self];
    }
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


- (UIImage*)imageWithPanormaImage:(UIImage*)image
{

    
    UIImage *originalImage = image;
    // scaling set to 2.0 makes the image 1/2 the size.
    UIImage *scaledImage =
    [UIImage imageWithCGImage:[originalImage CGImage]
                        scale:(originalImage.scale * 10.0)
                  orientation:(originalImage.imageOrientation)];
    return scaledImage;
}


- (UIImage *) resizeToSize:(CGSize) newSize thenCropWithRect:(CGRect) cropRect image:(UIImage *)ImG {
    CGContextRef                context;
    CGImageRef                  imageRef;
    CGSize                      inputSize;
    UIImage                     *outputImage = nil;
    CGFloat                     scaleFactor, width;
    
    // resize, maintaining aspect ratio:
    
    inputSize = ImG.size;
    scaleFactor = newSize.height / inputSize.height;
    width = roundf( inputSize.width * scaleFactor );
    
    if ( width > newSize.width ) {
        scaleFactor = newSize.width / inputSize.width;
        newSize.height = roundf( inputSize.height * scaleFactor );
    } else {
        newSize.width = width;
    }
    
    UIGraphicsBeginImageContext( newSize );
    
    context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, newSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);

     CGContextDrawImage( context, CGRectMake( 0, 0, newSize.width, newSize.height ), ImG.CGImage);
    outputImage = UIGraphicsGetImageFromCurrentImageContext();
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0, -newSize.height);
    UIGraphicsEndImageContext();
    
    inputSize = newSize;
    
    // constrain crop rect to legitimate bounds
    if ( cropRect.origin.x >= inputSize.width || cropRect.origin.y >= inputSize.height ) return outputImage;
    if ( cropRect.origin.x + cropRect.size.width >= inputSize.width ) cropRect.size.width = inputSize.width - cropRect.origin.x;
    if ( cropRect.origin.y + cropRect.size.height >= inputSize.height ) cropRect.size.height = inputSize.height - cropRect.origin.y;
    
    // crop
    if ( ( imageRef = CGImageCreateWithImageInRect( outputImage.CGImage, cropRect ) ) ) {
        outputImage = [[UIImage alloc] initWithCGImage: imageRef] ;
        CGImageRelease( imageRef );
    }
    
    return outputImage;
}



#pragma mark SocialButton Method
- (IBAction)crossScocialView:(id)sender {
    
    [socialnetworkLinkArray replaceObjectAtIndex:tagOfSocialNetwork-1 withObject:socialNetworkTextField.text];
        socialNetworkView.hidden = YES;
        [socialNetworkTextField resignFirstResponder];
        socialNetworkView.hidden = YES;
    
    [self resignKeyBoard];
}

- (IBAction)saveSocialLink:(id)sender {
    
    if (socialNetworkTextField.text.length>1) {
         [socialnetworkLinkArray replaceObjectAtIndex:tagOfSocialNetwork-1 withObject:socialNetworkTextField.text];
        socialNetworkView.hidden = YES;
        [socialNetworkTextField resignFirstResponder];
    }
    else{
//        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter some text." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [constant alertViewWithMessage:@"Please enter some text."withView:self];
    }
}
- (IBAction)resignKeyBoard:(id)sender {
}

- (IBAction)popToView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDeleteTxtView:(id)sender {
}

- (IBAction)btnDescriptionTwitter:(id)sender {
}
#pragma mark UiImagePicker Method
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@",info);
    UIImage *image ;
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
//    if (image.size.width>=2500) {
//         image = [self imageWithImage:image scaledToSize:CGSizeMake(2000,image.size.height)];
//        if (image.size.height>=2000) {
//            image = [self imageWithImage:image scaledToSize:CGSizeMake(image.size.width,2000)];
//        }
//    }

    CGRect aRect = CGRectMake(0, 0,image.size.width,image.size.height);
    if (image.size.width>=2500)
    {
        image = [self resizeToSize:CGSizeMake(2000,2000) thenCropWithRect:aRect image:image];
    }

     //image= [self imageWithPanormaImage:image];
  //  UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",(long)addimageInt] forKey:@"buttonIndex"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    HFImageEditorViewController *controller;
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
     {
         controller=[self.storyboard instantiateViewControllerWithIdentifier:@"HFViewController_ipad"];
     }
     else {
     controller=[self.storyboard instantiateViewControllerWithIdentifier:@"HFViewController"];
        }
    controller.sourceImage = image;
    controller.previewImage = image;
    controller.delegate=self;
    
    
    
//  ImageCropViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"HF"];
//    controller=[controller initWithImage:image];
//   //controller=[[ImageCropViewController alloc] initWithImage:image];
//    controller.delegate = self;
//    controller.blurredBackground = YES;
//    [[self navigationController] pushViewController:controller animated:YES];
    
    [self.navigationController pushViewController:controller animated:YES];

    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (CoverImageBool==1) {
        CoverImageBool = NO;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)ImageCropViewController:(ImageCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage{
    UIView*addImageView = (UIView*)[scrollVw viewWithTag:4];
    UIImageView*ImageViewButton = (UIImageView*)[addImageView viewWithTag:addimageInt-4000];
    ImageViewButton.image = croppedImage;
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)ImageCropViewControllerDidCancel:(ImageCropViewController *)controller{
    
    //imageView.image = image1;
    [[self navigationController] popViewControllerAnimated:YES];
}

-(void)uploadImage:(NSInteger)tag
{
    NSLog(@"%ld",(long)tag);
    UIView*addImageView = (UIView*)[scrollVw viewWithTag:4];
    UIImageView*ImageViewButton = (UIImageView*)[addImageView viewWithTag:tag];
    //UIImage *picture = [UIImage imageNamed:@"600x400.png"];
   // NSData *pic=UIImagePNGRepresentation(ImageViewButton.image);
    if ([imgDummy isEqual:ImageViewButton.image])
    //if ([pic isEqual:data_first])
        {
        actionSheet1 = [[UIActionSheet alloc] initWithTitle:@"Upload Image" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Upload by Photo Library",@"Upload by Camera",@"Cancel",  nil];
    }else{
    actionSheet1 = [[UIActionSheet alloc] initWithTitle:@"Upload Image" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Upload by Photo Library",@"Upload by Camera",@"Remove Image",@"Cancel",  nil];
}
    actionSheetOpenBool = YES;
    [actionSheet1 showInView:self.view];
   // actionSheet.frame = CGRectMake(0, 0, 100, 100);
}
#pragma mark - GKImagePicker delegate methods

//- (void)imagePickerDidFinish:(GKImagePicker *)imagePicker withImage:(UIImage *)image {
//    //  myImageView.contentMode = UIViewContentModeCenter;
//    
//     if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"removeImage"] isEqualToString:@"1"]) {
//         data2_Second = UIImagePNGRepresentation(buttonImageTemp1.image);
//         if ([data_first isEqual:data2_Second]&& addimageInt!=5001) {
//             UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please upload cover image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//             [alert show];
//         }
//         else{
//             if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"removeImage"] isEqualToString:@"1"]) {
//                 UIView*addImageView = (UIView*)[scrollVw viewWithTag:4];
//                 UIView*subAddImageView = (UIView*)[addImageView viewWithTag:50];
//                 //NSLog(@"%ld",(long)addimageInt);
//                 UIImageView*ImageViewButton = (UIImageView*)[subAddImageView viewWithTag:addimageInt-4000];
//                 NSLog(@"%ld",(long)ImageViewButton.tag);
//                 [ImageViewButton setImage:image];
//                 imageCounter++;
//                 if (addimageInt == 5001) {
//                     data2_Second = UIImagePNGRepresentation(ImageViewButton.image);
//                 }
//             }
//         }
//     }
//       [self dismissViewControllerAnimated:YES completion:nil];
//    
//    NSLog(@"%f %f",image.size.height,image.size.width);
//}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    actionSheetOpenBool = NO;
    if (buttonIndex == 0)
        {
          //  [self.picker showGalleryImagePicker];
         //  photo gallery
                  UIImagePickerController *picker1 = [[UIImagePickerController alloc] init];
                  picker1.delegate = self;
          
                  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
                  {
                      UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
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
   else if (buttonIndex == 1)
    {
       // [self.picker showCameraImagePicker];
        // camera;
              if ([UIImagePickerController isSourceTypeAvailable:
                   UIImagePickerControllerSourceTypeCamera])
              {
      
                  UIImagePickerController *picker1 = [[UIImagePickerController alloc] init];
                  picker1.delegate = self;
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
                  else {
                      picker1.sourceType = UIImagePickerControllerSourceTypeCamera;
                      [self presentViewController:picker1 animated:YES completion:nil];
                  }
              }else{
//                  UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Camera not found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                  [alert show];
                  [constant alertViewWithMessage:@"Camera not found."withView:self];
              }

    }
    if (buttonIndex == 2)
    {
        NSString *title =[NSString stringWithFormat:@"%@",[actionSheet buttonTitleAtIndex:buttonIndex]];
        NSLog(@"Title %@",title);
        if ([title isEqualToString:@"Remove Image"]) {
            UIView*addImageView = (UIView*)[scrollVw viewWithTag:4];
            UIView*subAddImageView = (UIView*)[addImageView viewWithTag:50];
            UIImageView*ImageView = (UIImageView*)[subAddImageView viewWithTag:addimageInt-4000];
            [ImageView setImage:[UIImage imageNamed:@"600x400.png"]];
            if (addimageInt == 5001) {
                data2_Second = UIImagePNGRepresentation(buttonImageTemp1.image);
            }
        }
    }
}
-(void)DeleteCategory : (UIButton*)sender{
    UIButton*deleteButton = (UIButton*)[categoryBottomSubView viewWithTag:[sender tag]];
     UILabel*textLabel = (UILabel*)[categoryBottomSubView viewWithTag:deleteButton.tag+10];
    NSLog(@"%ld",(long)[sender tag]);
    [deleteButton removeFromSuperview];
    [textLabel removeFromSuperview];
    [selectedCategoryArray removeObjectAtIndex:[sender tag]-1];
    [selectedCategoryIdArray removeObjectAtIndex:[sender tag]-1];
    
    [self reframeTheCategory];
}
-(void)reframeTheCategory{
    int x=5;
    int tagvalue = 1;
    for (int h=0; h<selectedCategoryArray.count+1; h++) {
//         UIButton*deleteButton = (UIButton*)[categoryBottomSubView viewWithTag:h+1];
         UIButton*deleteButton = (UIButton*)[selectedCategoryVw viewWithTag:h+1];
        UILabel*textLabel = (UILabel*)[selectedCategoryVw viewWithTag:deleteButton.tag+10];
        if ([deleteButton isKindOfClass:[UIButton class]]) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                 //deleteButton.frame = CGRectMake(x, 2, 768/3-10, 55);
                 deleteButton.frame = CGRectMake(x, 2, 768/2-10, 55);
                 textLabel.frame = CGRectMake(deleteButton.frame.origin.x+5, deleteButton.frame.origin.y+5, deleteButton.frame.size.width-50, deleteButton.frame.size.height-10);
            }
            else{
                int height = 35;
                if (self.view.frame.size.width>320) {
                    height = 35;
                }
               // deleteButton.frame = CGRectMake(x, 3, self.view.frame.size.width/3-10, height);
                deleteButton.frame = CGRectMake(x, 3, self.view.frame.size.width/2-10, height);
                
                 textLabel.frame = CGRectMake(deleteButton.frame.origin.x+5, deleteButton.frame.origin.y+5, deleteButton.frame.size.width-30, deleteButton.frame.size.height-10);
            }
             NSLog(@"%@",[NSValue valueWithCGRect:deleteButton.frame]);
           
         //   textLabel.text = [NSString stringWithFormat:@"%@",[selectedCategoryArray objectAtIndex:index]];
          //  NSLog(@"array is selectedCategoryArray %@",selectedCategoryArray);
            deleteButton.tag = tagvalue;
             textLabel.tag = deleteButton.tag+10;
            tagvalue++;
             x = x+deleteButton.frame.size.width+10;
        }
        else{
        }
       
    }
    [self setLabelText];
    [tableVw reloadData];
}
-(void)setLabelText{
    for (int h=0; h<selectedCategoryArray.count; h++) {
  //  UIButton*deleteButton = (UIButton*)[selectedCategoryVw viewWithTag:h+1];
    UILabel*textLabel = (UILabel*)[scrollVw viewWithTag:h+11];
        textLabel.text = [NSString stringWithFormat:@"%@",[selectedCategoryArray objectAtIndex:h]];
    }
}
#pragma mark TableView Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tagOfTableToShow == 111){
        [self resignTableVw:nil];
        [expiresButton setTitle:[NSString stringWithFormat:@"%@",[expiryDaysArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
    }
    if (tagOfTableToShow == 321){
    if (selectedCategoryArray.count>=2) {
//        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:@"You can not select more than two categories " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [constant alertViewWithMessage:@"You can not select more than two categories."withView:self];
    }
    else
    {
        if ([selectedCategoryArray containsObject:[NSString stringWithFormat:@"%@",[[categoryMainArray objectAtIndex:indexPath.row] categoryName]]]) {
//            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:@"You have already selected this category" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
            [constant alertViewWithMessage:@"You have already selected this category."withView:self];
        }
        else{
        
     [selectedCategoryArray addObject:[NSString stringWithFormat:@"%@",[[categoryMainArray objectAtIndex:indexPath.row] categoryName]]];
            
         [selectedCategoryIdArray addObject:[NSString stringWithFormat:@"%@",[[categoryMainArray objectAtIndex:indexPath.row] categoryId]]];
        
        UIButton*filteredCategoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            UILabel*textLabel = [[UILabel alloc]init];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            filteredCategoryButton.frame = CGRectMake((selectedCategoryArray.count-1)*768/2+5, 2, 768/2-10, 55);
             filteredCategoryButton.titleLabel.font  = [UIFont fontWithName:@"Helvetica" size:23];
            textLabel.font  = [UIFont fontWithName:@"Helvetica" size:23];
        }
        else{
            int height = 35;
            if (self.view.frame.size.width>320) {
                height = 35;
            }
     //   filteredCategoryButton.frame = CGRectMake((selectedCategoryArray.count-1)*self.view.frame.size.width/3+5, 3, self.view.frame.size.width/3-10, height);
            
        filteredCategoryButton.frame = CGRectMake((selectedCategoryArray.count-1)*self.view.frame.size.width/2+5, 3, self.view.frame.size.width/2-10, height);
            
             filteredCategoryButton.titleLabel.font  = [UIFont fontWithName:@"Helvetica" size:11];
            textLabel.font  = [UIFont fontWithName:@"Helvetica" size:15];
        }
            
if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
{
                textLabel.frame = CGRectMake(filteredCategoryButton.frame.origin.x+5, filteredCategoryButton.frame.origin.y+5, filteredCategoryButton.frame.size.width-50, filteredCategoryButton.frame.size.height-10);
}else{
            textLabel.frame = CGRectMake(filteredCategoryButton.frame.origin.x+5, filteredCategoryButton.frame.origin.y+5, filteredCategoryButton.frame.size.width-25, filteredCategoryButton.frame.size.height-10);
        }
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.textColor = [UIColor whiteColor];
            
            
            
            textLabel.text =[NSString stringWithFormat:@"%@",[[categoryMainArray objectAtIndex:indexPath.row] categoryName]];
            
       // [filteredCategoryButton setTitle:[NSString stringWithFormat:@"%@",[[categoryMainArray objectAtIndex:indexPath.row] categoryName]] forState:UIControlStateNormal];
        [filteredCategoryButton setBackgroundImage:[UIImage imageNamed:@"Forma11.png"] forState:UIControlStateNormal];
        [filteredCategoryButton addTarget:self action:@selector(DeleteCategory:) forControlEvents:UIControlEventTouchUpInside];
        
       // [categoryBottomSubView addSubview:filteredCategoryButton];
             [selectedCategoryVw addSubview:filteredCategoryButton];
            [selectedCategoryVw addSubview:textLabel];
        
        filteredCategoryButton.tag = selectedCategoryArray.count;
             textLabel.tag = filteredCategoryButton.tag+10;
        NSLog(@"%@",[NSValue valueWithCGRect:filteredCategoryButton.frame]);
       // filteredCategoryButton.backgroundColor = [UIColor colorWithRed:175.0f/255.0f green:120.0f/255.0f blue:80.0f/255.0f alpha:1.0f];
         }
    }
    [tableView reloadData];
    }
     if (tagOfTableToShow == 123){
//          if (indexPath.row==0) {
//              [localNationalButton setTitle:@"Local" forState:UIControlStateNormal];
//              localNationalBool = NO;
//              localNationalInt = 1;
//          }
//          else{
              [localNationalButton setTitle:[NSString stringWithFormat:@"%@",[arrLocal objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
              localNationalBool = YES;
               localNationalInt = 2;
//          }
         [self shiftBottomView];
         [self resignTableVw:nil];
      }
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                
                                     reuseIdentifier:SimpleTableIdentifier] ;
        
        tableView.backgroundColor=[UIColor colorWithRed:97.0f/255.0f green:97.0f/255.0f blue:97.0f/255.0f alpha:1.0f];
         cell.backgroundColor=[UIColor clearColor];
        
    }
    tableVw.separatorColor = [UIColor clearColor];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:27.0f];
    }
    else{
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f];
    }
    
    if (tagOfTableToShow == 111){
        
         cell.textLabel.text = [NSString stringWithFormat:@"%@",[expiryDaysArray objectAtIndex:indexPath.row]];
         cell.textLabel.textColor = [UIColor whiteColor];
    }
  else if (tagOfTableToShow == 123)
  {
//        if (indexPath.row == 0) {
//            cell.textLabel.text = @"Local";
//        }
//        if (indexPath.row == 1) {
//             cell.textLabel.text = @"National";
//        }
      
      cell.textLabel.text=[arrLocal objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    else
    if (tagOfTableToShow == 321){
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[[categoryMainArray objectAtIndex:indexPath.row] categoryName]];
        if ([selectedCategoryArray containsObject:[NSString stringWithFormat:@"%@",[[categoryMainArray objectAtIndex:indexPath.row] categoryName]]]) {
            cell.textLabel.textColor=[UIColor colorWithRed:175.0f/255.0f green:120.0f/255.0f blue:80.0f/255.0f alpha:1.0f];
        }
        else{
            cell.textLabel.textColor = [UIColor whiteColor];
        }
        
      //  cell.textLabel.textColor = [UIColor redColor];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     if (tagOfTableToShow == 321){
         return categoryMainArray.count;
     }
   else if (tagOfTableToShow == 123){
        return 3;
    }
   else if (tagOfTableToShow == 111){
       return expiryDaysArray.count;
   }
   
    return 0;
}
#pragma mark Orientation Method
- (BOOL)shouldAutorotate {
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskAll;
//}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    NSRange top1 = NSMakeRange(0, 0);
    [pitchSummary scrollRangeToVisible:top1];
    NSRange top2 = NSMakeRange(0, 0);
    [pitchDetailIno scrollRangeToVisible:top2];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
         if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortrait) {
             
           //  NSLog(@"portrait");
             if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
             {
                 for (UIWindow* window in [UIApplication sharedApplication].windows) {
                     NSArray* subviews = window.subviews;
                     if ([subviews count] > 0) {
                         
                         BOOL action = [[subviews objectAtIndex:0] isKindOfClass:[UIActionSheet class]];
                         
                         if (action)
                         {
                             [actionSheet1 removeFromSuperview];
                             actionSheet1=[[UIActionSheet alloc]init];
                           
                            // [self performSelector:@selector(showActionSheet) withObject:nil afterDelay:0.3];
                         }
                     }
                 }

                 if (tagOfTableToShow == 123)
                 {
                     if ([localNationalButton.titleLabel.text isEqualToString:@"Local"]) {
                         tableVw.frame = CGRectMake(localNationalButton.frame.origin.x, mediaCoverageView.frame.origin.y+80-scrollVw.contentOffset.y, localNationalButton.frame.size.width, 160);
                         
                         
                     }
                     else
                     {

                     tableVw.frame = CGRectMake(localNationalButton.frame.origin.x, mediaCoverageView.frame.origin.y+mediaCoverageView.frame.size.height+20-scrollVw.contentOffset.y, localNationalButton.frame.size.width, 160);
                     }
                 }
                 else if (tagOfTableToShow == 321)
                 {
                     
             tableVw.frame = CGRectMake(selectCategoryButton.frame.origin.x-20, 160+bottomViewOfMediaCoverage.frame.origin.y-scrollVw.contentOffset.y, 300, 300);
                     
                 }
                 else if (tagOfTableToShow == 111)
                 {
                     
                          tableVw.frame = CGRectMake(expiresButton.frame.origin.x+20, expiresinView.frame.origin.y+80+bottomViewOfMediaCoverage.frame.origin.y-scrollVw.contentOffset.y, 100, 200);
                 }
             }
             if (actionSheetOpenBool) {
                 [actionSheet1 dismissWithClickedButtonIndex:2 animated:YES];
                 [actionSheet1 showInView:self.view];
             }
        }
         else if (orientation == UIInterfaceOrientationLandscapeLeft ||
                  orientation == UIInterfaceOrientationLandscapeRight)
         {
           //  NSLog(@"landscape");
             if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
             {
                 for (UIWindow* window in [UIApplication sharedApplication].windows) {
                     NSArray* subviews = window.subviews;
                     if ([subviews count] > 0) {
                         
                         BOOL action = [[subviews objectAtIndex:0] isKindOfClass:[UIActionSheet class]];
                         
                         if (action)
                         {
                             [actionSheet1 removeFromSuperview];
                             actionSheet1=[[UIActionSheet alloc]init];
                            // [self performSelector:@selector(showActionSheet) withObject:nil afterDelay:0.3];
                         }

                     }
                 }

                 if (tagOfTableToShow == 123)
                 {
                     if ([localNationalButton.titleLabel.text isEqualToString:@"Local"]) {
                         tableVw.frame = CGRectMake(localNationalButton.frame.origin.x, mediaCoverageView.frame.origin.y+80-scrollVw.contentOffset.y, localNationalButton.frame.size.width, 160);
                     }
                     else{

                     tableVw.frame = CGRectMake(localNationalButton.frame.origin.x, mediaCoverageView.frame.origin.y+mediaCoverageView.frame.size.height+20-scrollVw.contentOffset.y, localNationalButton.frame.size.width, 160);
                     }
                 }
                 else if (tagOfTableToShow == 321) {
                     
                       if (tableViewOpenBool)
                       {
                            scrollVw.contentOffset = CGPointMake(0, 400);
                            tableVw.frame = CGRectMake(selectCategoryButton.frame.origin.x-20, 160+bottomViewOfMediaCoverage.frame.origin.y-scrollVw.contentOffset.y, 300, 300);
                       }
                       else{
                    tableVw.frame = CGRectMake(selectCategoryButton.frame.origin.x-20, 150+bottomViewOfMediaCoverage.frame.origin.y-scrollVw.contentOffset.y, 300, 300);
                       }
                 }
                 else if (tagOfTableToShow == 111) {
                     if (tableViewOpenBool) {
                         scrollVw.contentOffset = CGPointMake(0, 200);
                         tableVw.frame = CGRectMake(expiresButton.frame.origin.x+20, expiresinView.frame.origin.y+80+bottomViewOfMediaCoverage.frame.origin.y-scrollVw.contentOffset.y, 100, 200);
                     }
                     else{
                         tableVw.frame = CGRectMake(expiresButton.frame.origin.x+20, expiresinView.frame.origin.y+80+bottomViewOfMediaCoverage.frame.origin.y-scrollVw.contentOffset.y, 100, 200);
                     }
                 }
             }
             if (actionSheetOpenBool) {
                 [actionSheet1 dismissWithClickedButtonIndex:2 animated:YES];
                 [actionSheet1 showInView:self.view];
             }
        }
         
         // do whatever
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}
- (IBAction)hidepopUpTextView:(id)sender {
    NSRange top1 = NSMakeRange(0, 0);
    [pitchSummary scrollRangeToVisible:top1];
    NSRange top2 = NSMakeRange(0, 0);
    [pitchDetailIno scrollRangeToVisible:top2];
    viewTwitterLike.hidden=YES;
   // textBoxView.hidden = YES;
    [popupTextField resignFirstResponder];
    [txtViewTwitter resignFirstResponder];
    intvalueTwitter=0;
    toolbarCance.title=@"Cancel";
}

-(void)showActionSheet
{
    actionSheet1 = [[UIActionSheet alloc] initWithTitle:@"Upload Image" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Upload by Photo Library",@"Upload by Camera",@"Remove Image",@"Cancel",  nil];
    actionSheetOpenBool = YES;
    [actionSheet1 showInView:self.view];
}

- (IBAction)btnTwitterDone:(id)sender
{
    [pitchTitle resignFirstResponder];
    [txtViewTwitter resignFirstResponder];
    [pitchSummary resignFirstResponder];
    [pitchDetailIno resignFirstResponder];
    [zipcode resignFirstResponder];
    [websiteUrlTextField resignFirstResponder];
    [socialNetworkTextField resignFirstResponder];
    [popupTextField resignFirstResponder];
    [popupTextView resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self.view setFrame:CGRectMake(0, 0 ,self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];

    
}


@end
