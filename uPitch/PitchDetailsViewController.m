
//  PitchDetailsViewController.m
//  uPitch
//
//  Created by Ashwani on 30/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import "PitchDetailsViewController.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LxReqRespManager.h"
#import "AppDelegate.h"
#import "categoryHold.h"
#import "UIImageView+WebCache.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "GKImagePicker.h"
#import "viewPitchesViewController_Journalists.h"
#import "manageJournalistViewController.h"
#import "constant.h"

@implementation PitchDetailsViewController

@synthesize strPitchId,clientJournalistString;
@synthesize strHideTopIcons;
-(void)leftSlider
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    // [button setBackgroundImage:[UIImage imageNamed:@"menu55.png"] forState:UIControlStateNormal];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        button.frame = CGRectMake(0, 0, 70, 70);
    }
    else{
        button.frame = CGRectMake(0, 0, 50, 55);
    }    [self.view addSubview:button];
    
}
-(void)PubNubNotification:(NSNotification *) notification
{
    [self getCount];
}

-(void)getCount
{
    
    
//    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]integerValue]>0)
//    {
//        lblCount.hidden=NO;
//        imgCount.hidden=NO;
//        NSInteger show=[[[NSUserDefaults standardUserDefaults]valueForKey:@"Count"]integerValue]+[[[NSUserDefaults standardUserDefaults] valueForKey:@"MinusCount"] integerValue];
//        lblCount.text=[NSString stringWithFormat:@"%ld",(long)show];
//        
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
    [self setTopIcon];
}
-(void)setTopIcon
{
    if (strHideTopIcons){
        lblCount.hidden=YES;
        imgCount.hidden=YES;
    }
}


- (void)viewDidLoad 
{
    txtViewDetails.text = @"";
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PubNubNotification:) name:@"pubnubnot" object:nil];
    [self getCount];
     revealController = [self revealViewController];
     indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
       
    fbBtn.hidden=YES;
    twitterBtn.hidden=YES;
    instagramBtn.hidden=YES;
    linkdinBtn.hidden=YES;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        viewSlideShow.frame =CGRectMake((self.view.frame.size.width-770)/2, self.view.frame.origin.y,770, 770*.65);
        viewSlideContainor.frame =CGRectMake((viewSlideShow.frame.size.width-720)/2, viewSlideShow.frame.origin.y+8, 720, 720 *.67);
        scrlHorizontal.frame=CGRectMake(8,40, viewSlideContainor.frame.size.width-16, (viewSlideContainor.frame.size.width-16)*.559);
        imgSlideShow.frame =CGRectMake(0, 0, scrlHorizontal.frame.size.width,scrlHorizontal.frame.size.height);
    }
     else
    {
        viewSlideShow.frame =CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, (viewSlideShow.frame.size.width)*.65);
        viewSlideContainor.frame =CGRectMake(viewSlideShow.frame.origin.x+13, viewSlideShow.frame.origin.y+8, viewSlideShow.frame.size.width-26, (viewSlideShow.frame.size.width-26)*.682);
        scrlHorizontal.frame=CGRectMake(8,40, viewSlideContainor.frame.size.width-16, (viewSlideContainor.frame.size.width-16)*.559);
        imgSlideShow.frame =CGRectMake(0, 0, scrlHorizontal.frame.size.width,scrlHorizontal.frame.size.height);
    }
    
      
    viewSlideContainor.userInteractionEnabled=NO;
    

    
    
    //[self leftSlider];
   // scrlView.frame=CGRectMake(0,60 ,self.view.frame.size.width, self.view.frame.size.height);
   
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        
         scrlView.frame= CGRectMake(0, scrlView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-185);
        if ([clientJournalistString isEqualToString:@"1"]) {
            // client
            scrlView.frame= CGRectMake(0, scrlView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-60);
            notInterestedButton.hidden = interestedButton.hidden = YES;
        }
    }

    else{
    
    
    if ([clientJournalistString isEqualToString:@"1"]) {
        // client
        scrlView.frame= CGRectMake(0, scrlView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-60);
        notInterestedButton.hidden = interestedButton.hidden = YES;
    }
    else{
        // journalist
        scrlView.frame= CGRectMake(0, scrlView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-110);
        notInterestedButton.hidden = interestedButton.hidden = NO;
    }
    }
    
     NSLog(@"%@",[NSValue valueWithCGRect:scrlView.frame]);
    [super viewDidLoad];
    viewCovrageDetails.hidden=YES;
    socialnetworkLinkArray =[NSMutableArray new];
    arrSelectedCategoryId=[NSMutableArray new];
    arrSelectedCategory=[NSMutableArray new];
    viewSlideContainor.layer.borderColor=[[UIColor grayColor]CGColor];
    viewSlideContainor.layer.borderWidth=1;
    
    
   appdelegateInstance = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  //  [appdelegateInstance showHUD:@"test"];
   
   scrlHorizontal.layer.borderColor=[[UIColor grayColor]CGColor];
    scrlHorizontal.layer.borderWidth=0.5;
    
    staticImages =[[NSMutableArray alloc]initWithObjects:@"linkdin.png", nil];
   
  //  [staticImages initWithObjects:@"linkdin.png",@"Icon-120.png",@"600x400.png",@"add2x.png",@"twitter.png", nil];
   
 // imgSlideShow.image=[UIImage imageNamed:[staticImages objectAtIndex:0]];
  
    isProceed=0;
    
        imageCount = [staticImages count];
    
    NSLog(@"%d",isProceed);
     [self setFrame];
    
     UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [imgSlideShow addGestureRecognizer:swipeleft];
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [imgSlideShow addGestureRecognizer:swiperight];
    
        
    
     pageControlOutlet.currentPage=isProceed;
    pageControlOutlet.numberOfPages=imageCount;
    
    [self showPitchDetail];
}
-(void)viewDidAppear:(BOOL)animated
{
    revealController.panGestureRecognizer.enabled = NO;
    revealController.tapGestureRecognizer.enabled = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    revealController.panGestureRecognizer.enabled = YES;
    revealController.tapGestureRecognizer.enabled = YES;
}


-(void)swipeleft
{
  
    if (isProceed <= imageCount-2 ) 
    {
         if ([[staticImages objectAtIndex:isProceed] isKindOfClass:[UIImage class]]) {
        isProceed=isProceed+1; 
         pageControlOutlet.currentPage=isProceed;
        
        imgSlideShow.image=[staticImages objectAtIndex:isProceed];
        
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.4]; //Animate for a duration of 1.0 seconds
        [animation setType:kCATransitionPush]; //New image will push the old image off
        [animation setSubtype:kCATransitionFromRight]; //Current image will slide off to the left, new image slides in from the right
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]]; 
        [[imgSlideShow layer] addAnimation:animation forKey:nil];
         }
        
        
    }

   
}

-(void)swiperight
{

    if (! isProceed==0) 
    {
        if ([[staticImages objectAtIndex:isProceed] isKindOfClass:[UIImage class]]) {
        isProceed=isProceed-1; 
         pageControlOutlet.currentPage=isProceed;
        
        imgSlideShow.image=[staticImages objectAtIndex:isProceed];
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.4]; //Animate for a duration of 1.0 seconds
        [animation setType:kCATransitionPush]; //New image will push the old image off
        [animation setSubtype:kCATransitionFromLeft]; //Current image will slide off to the left, new image slides in from the right
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]]; 
        [[imgSlideShow layer] addAnimation:animation forKey:nil];
        }
    }

}



-(void)setFrame
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        viewSlideShow.frame =CGRectMake((self.view.frame.size.width-770)/2, self.view.frame.origin.y,770, 770*.65);
        
        
        viewSlideContainor.frame =CGRectMake((viewSlideShow.frame.size.width-720)/2, viewSlideShow.frame.origin.y+8, 720, 720 *.67);
        
        scrlHorizontal.frame=CGRectMake(8,40, viewSlideContainor.frame.size.width-16, (viewSlideContainor.frame.size.width-16)*.559);
      
        
        imgSlideShow.frame =CGRectMake(0, 0, scrlHorizontal.frame.size.width,scrlHorizontal.frame.size.height);
        
        viewCatagories.frame= CGRectMake(0,viewSlideShow.frame.origin.y+viewSlideShow.frame.size.height,self.view.frame.size.width , (self.view.frame.size.width) * 0.1);
        
        txtViewDetails.frame= CGRectMake(10,30,self.view.frame.size.width-1 , 10);
        NSLog(@"%@", [NSValue valueWithCGRect:txtViewDetails.frame]);
       
        
        CGFloat fixedWidth = txtViewDetails.frame.size.width;
        CGSize newSize = [txtViewDetails sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
        CGRect newFrame = txtViewDetails.frame;
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
        txtViewDetails.frame = newFrame;
              
        viewPitchDetails.frame= CGRectMake(0,viewCatagories.frame.origin.y+viewCatagories.frame.size.height,self.view.frame.size.width , (txtViewDetails.frame.size.height)+60);
        viewPitchDetails.hidden = NO;
        //viewCovrageDetails.backgroundColor = [UIColor redColor];
        
        viewMediaCovarage.frame= CGRectMake(0,viewPitchDetails.frame.origin.y+viewPitchDetails.frame.size.height,self.view.frame.size.width , (self.view.frame.size.width) * 0.1);
        
        viewUrl.frame= CGRectMake(0,viewMediaCovarage.frame.origin.y+viewMediaCovarage.frame.size.height,self.view.frame.size.width , (self.view.frame.size.width) * 0.1);
        
        viewSocialShare.frame= CGRectMake(0,viewUrl.frame.origin.y+viewUrl.frame.size.height,self.view.frame.size.width , (self.view.frame.size.width) * 0.132);
        
        scrlView.contentSize = CGSizeMake(self.view.frame.size.width,viewSocialShare.frame.origin.y+viewSocialShare.frame.size.height+20);
  
    }
    
    else
    {
        
    viewSlideShow.frame =CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, (viewSlideShow.frame.size.width)*.77);
    
    
    viewSlideContainor.frame =CGRectMake(viewSlideShow.frame.origin.x+13, viewSlideShow.frame.origin.y+8, viewSlideShow.frame.size.width-26, (viewSlideShow.frame.size.width-26)*.78);
        NSLog(@"%@",[NSValue valueWithCGRect:viewSlideContainor.frame]);
     scrlHorizontal.frame=CGRectMake(8,40, viewSlideContainor.frame.size.width-16, (viewSlideContainor.frame.size.width-16)*.66);
    
    imgSlideShow.frame =CGRectMake(0, 0, scrlHorizontal.frame.size.width,scrlHorizontal.frame.size.height);

   // viewCatagories.frame= CGRectMake(0,viewSlideShow.frame.origin.y+viewSlideShow.frame.size.height,self.view.frame.size.width , (self.view.frame.size.width) * 0.15);
    viewCatagories.frame= CGRectMake(0,viewSlideShow.frame.origin.y+viewSlideShow.frame.size.height,self.view.frame.size.width , (self.view.frame.size.width) * 0.15);
    
    txtViewDetails.frame= CGRectMake(4,30,self.view.frame.size.width-1 , 10);
    
    
    CGFloat fixedWidth = txtViewDetails.frame.size.width;
    CGSize newSize = [txtViewDetails sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = txtViewDetails.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    txtViewDetails.frame = newFrame;
      
    viewPitchDetails.frame= CGRectMake(0,viewCatagories.frame.origin.y+viewCatagories.frame.size.height,self.view.frame.size.width , (txtViewDetails.frame.size.height)+40);

        

    viewMediaCovarage.frame= CGRectMake(0,viewPitchDetails.frame.origin.y+viewPitchDetails.frame.size.height,self.view.frame.size.width , (self.view.frame.size.width) * 0.12);
    
   viewUrl.frame= CGRectMake(0,viewMediaCovarage.frame.origin.y+viewMediaCovarage.frame.size.height,self.view.frame.size.width , (self.view.frame.size.width) * 0.143);
    
    viewSocialShare.frame= CGRectMake(0,viewUrl.frame.origin.y+viewUrl.frame.size.height,self.view.frame.size.width , (self.view.frame.size.width) * 0.21);
    
     scrlView.contentSize = CGSizeMake(self.view.frame.size.width,viewSocialShare.frame.origin.y+viewSocialShare.frame.size.height+20);
   
    
    NSLog(@"%@", [NSValue valueWithCGRect:scrlView.frame]);
    
       NSLog(@"%@",[NSValue valueWithCGRect:scrlHorizontal.frame]);
    }
}




- (IBAction)btnFbShare:(id)sender 
{
    
    NSLog(@"bgfcjudbvjuhberjvbrn");
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[socialnetworkLinkArray objectAtIndex:0]]];  
    [[UIApplication sharedApplication] openURL:url]; 
}

- (IBAction)btnTwitterShare:(id)sender 
{
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[socialnetworkLinkArray objectAtIndex:1]]]; 
    [[UIApplication sharedApplication] openURL:url]; 
}

- (IBAction)BTNLinkdinShare:(id)sender 
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[socialnetworkLinkArray objectAtIndex:2]]]; 
    [[UIApplication sharedApplication] openURL:url]; 
}


        
       
  


- (IBAction)btnLeft:(id)sender 
{
    
    if (! isProceed==0) 
    {
       
        if ([[staticImages objectAtIndex:isProceed] isKindOfClass:[UIImage class]]) {
                   isProceed=isProceed-1;
                   pageControlOutlet.currentPage=isProceed;

            imgSlideShow.image=[staticImages objectAtIndex:isProceed];
            CATransition *animation = [CATransition animation];
            [animation setDuration:0.4]; //Animate for a duration of 1.0 seconds
            [animation setType:kCATransitionPush]; //New image will push the old image off
            [animation setSubtype:kCATransitionFromLeft]; //Current image will slide off to the left, new image slides in from the right
            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            [[imgSlideShow layer] addAnimation:animation forKey:nil];
        }
       
    }
       
        
   
}

- (IBAction)btnRight:(id)sender 
{
    
    
    if (isProceed <= imageCount-2 ) 
    {
         if ([[staticImages objectAtIndex:isProceed] isKindOfClass:[UIImage class]]) {
        isProceed=isProceed+1; 
         pageControlOutlet.currentPage=isProceed;
        
        imgSlideShow.image=[staticImages objectAtIndex:isProceed];
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.4]; //Animate for a duration of 1.0 seconds
        [animation setType:kCATransitionPush]; //New image will push the old image off
        [animation setSubtype:kCATransitionFromRight]; //Current image will slide off to the left, new image slides in from the right
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]]; 
        [[imgSlideShow layer] addAnimation:animation forKey:nil];
         }
        
    }
}

- (IBAction)btnInstagramShare:(id)sender 
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[socialnetworkLinkArray objectAtIndex:3]]]; 
    [[UIApplication sharedApplication] openURL:url]; 
}


# pragma mark API REQUEST

-(void)showPitchDetail
{
    
    [appdelegateInstance showHUD:@""];
    
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    
    NSString*strWebService=[[NSString alloc]initWithFormat:@"%@showpitchdetail",AppURL];
    
    NSLog(@"%@",strWebService);
    
    NSDictionary *dictParams;
    
   
    //strPitchId=@"8";
    
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:
                strPitchId,@"pitch_id1",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",
                nil];
    
    NSLog(@"Params : %@",dictParams);
    
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
        [appdelegateInstance hideHUD];
             
             //NSString*str=[response valueForKey:@"error"];
             NSLog(@"hrfgth %@",[response valueForKey:@"error"]);
             strShowError =[NSString stringWithFormat:@"%@",[response valueForKey:@"message"]];
             
             if ([[NSString stringWithFormat: @"%@", [response valueForKey:@"error"]] isEqualToString:@"0"] )
             {
                 NSLog(@"%@",[[[response valueForKey:@"data"] valueForKey:@"image1_new"] objectAtIndex:0]);
                 
                lblHeader.text = [NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"title"] objectAtIndex:0]];

                 txtViewDetails.text = [NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"description"] objectAtIndex:0]];
                 
                    [self setFrame];

                
                 NSString*mediaString = [NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"media_coverage"] objectAtIndex:0]];
//                 if ([mediaString isEqualToString:@"1"]) 
//                 {
//                     lblMediaCovrage.text=@"Local";
//                 }
//                 else
//                 {
//                     lblMediaCovrage.text=@"National";
//                 }
                 NSLog(@"%@",mediaString);
                 if ([mediaString isEqualToString:@"1"]) {
                     lblMediaCovrage.text=@"Local";
                 }else if ([mediaString isEqualToString:@"2"])
                 {
                      lblMediaCovrage.text=@"USA";
                 }else  if ([mediaString isEqualToString:@"3"]){
                      lblMediaCovrage.text=@"Canada";
                 }else if ([mediaString isEqualToString:@"4"]){
                    lblMediaCovrage.text=@"North America";
                 }

                 
                
                 NSArray *idarray = [[[[response valueForKey:@"data"] valueForKey:@"categoryids"]  objectAtIndex:0] componentsSeparatedByString:@","];
                 
                for (int k =0; k<idarray.count; k++) 
                 { 
                     [arrSelectedCategoryId addObject:[idarray objectAtIndex:k]];
                 }
                NSArray *namearray = [[[[response valueForKey:@"data"] valueForKey:@"catgoryname"] objectAtIndex:0] componentsSeparatedByString:@","];
                 for (int k =0; k<namearray.count; k++) 
                 {
                     [arrSelectedCategory addObject:[namearray objectAtIndex:k]];
                 }
                 
                 [self setCataImages];
                 
                 [socialnetworkLinkArray addObject:[NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"media_url_facebook"] objectAtIndex:0]]];
                [socialnetworkLinkArray addObject:[NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"media_url_twitter"] objectAtIndex:0]]];
                [socialnetworkLinkArray addObject:[NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"media_url_linkedin"] objectAtIndex:0]]];
                 [socialnetworkLinkArray addObject:[NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"media_url_instagram"] objectAtIndex:0]]];
                 [socialnetworkLinkArray addObject:[NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"media_url_website"] objectAtIndex:0]]];
                 
                 [self sharingValidation];
                 
    lblUrl.text =  [NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"media_url_website"] objectAtIndex:0]];
                 
                 if ([lblUrl.text isEqualToString:@"http://www."]||[lblUrl.text isEqualToString:@""]) {
                     
                     viewUrl.hidden=YES;
                 }
                 else
                 {
                     viewUrl.hidden=NO;
                     
                 }  
                
                 NSURL*Url1;
                  NSURL*Url2;
                  NSURL*Url3;
                  NSURL*Url4;
                  NSURL*Url5;
                 
                 staticImages = [[NSMutableArray alloc]init];
                                 
                 if(![[[[response valueForKey:@"data"] valueForKey:@"image1_new"] objectAtIndex:0] isEqual:@""])
                 {
                     NSLog(@"%@",[NSString stringWithFormat:@"%@",[[[response valueForKey:@"data"] valueForKey:@"image1_new"] objectAtIndex:0]]);
                     NSString *str=[NSString stringWithFormat:@"%@",[[[response valueForKey:@"data"] valueForKey:@"image1_new"] objectAtIndex:0]];
                     
                    NSString *newString =[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                     NSLog(@"%@",newString);
                    Url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",newString]];
                     [staticImages addObject:Url1];
                 }
                 if(![[[[response valueForKey:@"data"] valueForKey:@"image2_new"] objectAtIndex:0] isEqual:@""])
                 {
                     Url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[response valueForKey:@"data"] valueForKey:@"image2_new"] objectAtIndex:0]]];
                     [staticImages addObject:Url2];
                 } 
                 if(![[[[response valueForKey:@"data"] valueForKey:@"image3_new"] objectAtIndex:0] isEqual:@""])
                 {
                     Url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[response valueForKey:@"data"] valueForKey:@"image3_new"] objectAtIndex:0]]];
                     [staticImages addObject:Url3];
                 }
                 if(![[[[response valueForKey:@"data"] valueForKey:@"image4_new"] objectAtIndex:0] isEqual:@""])
                 {
                     Url4 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[response valueForKey:@"data"] valueForKey:@"image4_new"] objectAtIndex:0]]];
                     [staticImages addObject:Url4];
                 }
                 if(![[[[response valueForKey:@"data"] valueForKey:@"image5_new"] objectAtIndex:0] isEqual:@""])
                 {
                    Url5 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[response valueForKey:@"data"] valueForKey:@"image5_new"] objectAtIndex:0]]];
                     [staticImages addObject:Url5];
                 }
                                  
                               
     //  staticImages = [[NSMutableArray alloc]initWithObjects:Url1,Url2,Url3,Url4,Url5,nil];
                 
                 
                 if (staticImages.count==1) 
                 {
                     [rightBtn setUserInteractionEnabled:NO];
                     [LeftBtn setUserInteractionEnabled:NO];
                     rightBtn.hidden=YES;
                     LeftBtn.hidden=YES;
                     rightArrow.hidden=YES;
                     leftArrow.hidden=YES;
                 }
                 else
                 {
                     [rightBtn setUserInteractionEnabled:YES];
                     [LeftBtn setUserInteractionEnabled:YES];
                     rightBtn.hidden=NO;
                     LeftBtn.hidden=NO;
                     rightArrow.hidden=NO;
                     leftArrow.hidden=NO;
                 }
               
                 
                 
               //[imgSlideShow setImageWithURL:[staticImages objectAtIndex:0]];
                 
                 
                 [imgSlideShow setImageWithURL:[staticImages objectAtIndex:0] placeholderImage:[UIImage imageNamed:@"600x4001.png"] imagesize:CGSizeMake(imgSlideShow.frame.size.width, imgSlideShow.frame.size.height)];
                 
                 
                 imageCount = [staticImages count];
                
                 if (imageCount==1) {
                     pageControlOutlet.hidden=YES;
                 }
                 else
                 {
                 pageControlOutlet.numberOfPages=imageCount;
                 }
                 //[appdelegateInstance showHUD:@"Loading Images"];
                if (staticImages.count>1)
                 {
                     [indicator startAnimating];
                     // [indicator setCenter:viewIndicator.center];
                     [viewIndicator addSubview:indicator];
                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                     [self setImages];
                     dispatch_async(dispatch_get_main_queue(), ^{ // 2
                         [self performSelector:@selector(hideIndicator) withObject:self afterDelay:1.0 ];
                         // 3
                     });
                 });
                 }
                else
                {
                    [imgSlideShow setImageWithURL1:[staticImages objectAtIndex:0] placeholderImage:[UIImage imageNamed:@"600x4001.png"] imagesize:CGSizeMake(imgSlideShow.frame.size.width, imgSlideShow.frame.size.height)];
                }
             }
             else if ([[NSString stringWithFormat: @"%@", [response valueForKey:@"error"]] isEqualToString:@"10"] )
             {
                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 alert.tag = 1234;
                 [alert show];
             }
             
             else
             {
                 NSLog(@"clientJournalistStrin  %@",clientJournalistString);
                 if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"userTypeString"] isEqualToString:@"2"])
                 {
                 [appdelegateInstance hideHUD];
//                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:strShowError delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                 [alert show];
                     [constant alertViewWithMessage:strShowError withView:self];
                      scrlView.frame= CGRectMake(0, scrlView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-60);
                     notInterestedButton.hidden = interestedButton.hidden = YES;
                
                 }
                  else
                  {
                      NSLog(@"%@",[[[response valueForKey:@"data"] valueForKey:@"image1_new"] objectAtIndex:0]);
                      
                      lblHeader.text = [NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"title"] objectAtIndex:0]];
                      
                      txtViewDetails.text = [NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"description"] objectAtIndex:0]];
                      
                      [self setFrame];
                      
                      
                      NSString*mediaString = [NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"media_coverage"] objectAtIndex:0]];
//                      if ([mediaString isEqualToString:@"1"])
//                      {
//                          lblMediaCovrage.text=@"Local";
//                      }
//                      else
//                      {
//                          lblMediaCovrage.text=@"National";
//                      }
                      
                      
                      if ([mediaString isEqualToString:@"1"]) {
                          lblMediaCovrage.text=@"Local";
                      }else if ([mediaString isEqualToString:@"2"])
                      {
                          lblMediaCovrage.text=@"USA";
                      }else  if ([mediaString isEqualToString:@"3"]){
                          lblMediaCovrage.text=@"Canada";
                      }else if ([mediaString isEqualToString:@"4"]){
                          lblMediaCovrage.text=@"North America";
                      }
                      
                      NSArray *idarray = [[[[response valueForKey:@"data"] valueForKey:@"categoryids"]  objectAtIndex:0] componentsSeparatedByString:@","];
                      
                      for (int k =0; k<idarray.count; k++)
                      {
                          [arrSelectedCategoryId addObject:[idarray objectAtIndex:k]];
                      }
                      NSArray *namearray = [[[[response valueForKey:@"data"] valueForKey:@"catgoryname"] objectAtIndex:0] componentsSeparatedByString:@","];
                      for (int k =0; k<namearray.count; k++)
                      {
                          [arrSelectedCategory addObject:[namearray objectAtIndex:k]];
                      }
                      
                      [self setCataImages];
                      
                      [socialnetworkLinkArray addObject:[NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"media_url_facebook"] objectAtIndex:0]]];
                      [socialnetworkLinkArray addObject:[NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"media_url_twitter"] objectAtIndex:0]]];
                      [socialnetworkLinkArray addObject:[NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"media_url_linkedin"] objectAtIndex:0]]];
                      [socialnetworkLinkArray addObject:[NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"media_url_instagram"] objectAtIndex:0]]];
                      [socialnetworkLinkArray addObject:[NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"media_url_website"] objectAtIndex:0]]];
                      
                      [self sharingValidation];
                      
                      lblUrl.text =  [NSString stringWithFormat:@"%@",[[[[response valueForKey:@"data"] valueForKey:@"Pitch"] valueForKey:@"media_url_website"] objectAtIndex:0]];
                      
                      if ([lblUrl.text isEqualToString:@"http://www."]||[lblUrl.text isEqualToString:@""]) {
                          
                          viewUrl.hidden=YES;
                      }
                      else
                      {
                          viewUrl.hidden=NO;
                          
                      }
                      
                      NSURL*Url1;
                      NSURL*Url2;
                      NSURL*Url3;
                      NSURL*Url4;
                      NSURL*Url5;
                      
                      
                      if(![[[[response valueForKey:@"data"] valueForKey:@"image1_new"] objectAtIndex:0] isEqual:@""])
                      {
                          Url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[response valueForKey:@"data"] valueForKey:@"image1_new"] objectAtIndex:0]]];
                          [staticImages addObject:Url1];
                      }
                      if(![[[[response valueForKey:@"data"] valueForKey:@"image2_new"] objectAtIndex:0] isEqual:@""])
                      {
                          Url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[response valueForKey:@"data"] valueForKey:@"image2_new"] objectAtIndex:0]]];
                          [staticImages addObject:Url2];
                      } 
                      if(![[[[response valueForKey:@"data"] valueForKey:@"image3_new"] objectAtIndex:0] isEqual:@""])
                      {
                          Url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[response valueForKey:@"data"] valueForKey:@"image3_new"] objectAtIndex:0]]];
                          [staticImages addObject:Url3];
                      }
                      if(![[[[response valueForKey:@"data"] valueForKey:@"image4_new"] objectAtIndex:0] isEqual:@""])
                      {
                          Url4 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[response valueForKey:@"data"] valueForKey:@"image4_new"] objectAtIndex:0]]];
                          [staticImages addObject:Url4];
                      }
                      if(![[[[response valueForKey:@"data"] valueForKey:@"image5_new"] objectAtIndex:0] isEqual:@""])
                      {
                          Url5 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[response valueForKey:@"data"] valueForKey:@"image5_new"] objectAtIndex:0]]];
                          [staticImages addObject:Url5];
                      }
                      
                      
                      staticImages = [[NSMutableArray alloc]initWithObjects:Url1,Url2,Url3,Url4,Url5,nil];
                      
                      if (staticImages.count==1) 
                      {
                          [rightBtn setUserInteractionEnabled:NO];
                          [LeftBtn setUserInteractionEnabled:NO];
                          rightArrow.hidden=YES;
                          leftArrow.hidden=YES;
                      }
                      else
                      {
                          [rightBtn setUserInteractionEnabled:YES];
                          [LeftBtn setUserInteractionEnabled:YES];
                          rightArrow.hidden=NO;
                          leftArrow.hidden=NO;
                      }                      
                      
                     // [imgSlideShow setImageWithURL:[staticImages objectAtIndex:0]];

                      [imgSlideShow setImageWithURL:[staticImages objectAtIndex:0] placeholderImage:[UIImage imageNamed:@"600x4001.png"] imagesize:CGSizeMake(imgSlideShow.frame.size.width, imgSlideShow.frame.size.height)];
                      
                      imageCount = [staticImages count];
                      //[appdelegateInstance showHUD:@"Loading Images"];
                      if (imageCount==1) {
                          pageControlOutlet.hidden=YES;
                      }
                      else
                      {
                          pageControlOutlet.numberOfPages=imageCount;
                      }
                      
                     
                      
                      if (staticImages.count>1)
                      {
         
                          [indicator startAnimating];
                          // [indicator setCenter:viewIndicator.center];
                        
                          [viewIndicator addSubview:indicator];
                      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                            [self setImages];
                          dispatch_async(dispatch_get_main_queue(), ^{ // 2
                              [self performSelector:@selector(hideIndicator) withObject:self afterDelay:1.0 ];
                              // 3
                          });
                      });
                      }
                      else
                      {
                          [imgSlideShow setImageWithURL1:[staticImages objectAtIndex:0] placeholderImage:[UIImage imageNamed:@"600x4001.png"] imagesize:CGSizeMake(imgSlideShow.frame.size.width, imgSlideShow.frame.size.height)];
                      }
                  }

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


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1234) {
        AppDelegate *appd= (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appd LogoutFromApp:self];
    }
    else
    {
        if (buttonIndex == 0)
        {
           [self.navigationController popViewControllerAnimated:YES];
        }
    }
  }


-(void) setImages
{
    for(int i = 0; i < [staticImages count]; i++)
    {
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[staticImages objectAtIndex:i]]];
        if ([image isKindOfClass:[UIImage class]])
        {
            [staticImages replaceObjectAtIndex:i withObject: image];
        }
        [imgSlideShow setImage:[staticImages objectAtIndex:0]];
    }
    imgSlideShow.image=[staticImages objectAtIndex:0];
    [imgSlideShow setImage:[staticImages objectAtIndex:0]];
     //[appdelegateInstance hideHUD];
}

-(void) hideIndicator
{
viewSlideContainor.userInteractionEnabled=YES;
viewIndicator.hidden=YES;
[indicator removeFromSuperview];
}

-(void)setCataImages
{
    NSArray *views = [viewCatagories subviews];
    for (UILabel *lbl in views)
    {
        if (lbl.tag==51)
        {
        }
        else
        {
        [lbl removeFromSuperview];
        }
    }
    int x=0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        x=200;
    }
    else
    {
        x=105;
    }
    
    for (int g=0; g<arrSelectedCategory.count; g++) 
    {
        UILabel*lblCat=[[UILabel alloc]init];
        NSString*lblText;
        lblText=[arrSelectedCategory objectAtIndex:g];
        NSUInteger length = [lblText length];
        NSString* strNameCrop;
        if (length>=12) 
        {
            strNameCrop=[NSString stringWithFormat:@"%@..",[lblText substringToIndex:12]];
        }
        else
        {
            strNameCrop=lblText;
        }
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            
            
            int y=(viewCatagories.frame.size.height-40);
            
            lblCat.frame = CGRectMake(x,y/2, (self.view.frame.size.width-250)/2-10, 40);
            
            lblCat.text=strNameCrop;
            
            lblCat.layer.borderColor=[[UIColor colorWithRed:255.0f/255.0f green:160.0f/255.0f blue:60.0f/255.0f alpha:1]CGColor];
            lblCat.layer.borderWidth=2;
            
            
            lblCat.font  = [UIFont fontWithName:@"Helvetica" size:22];
            lblCat.textAlignment=NSTextAlignmentCenter;
            
            x= x+ ((self.view.frame.size.width-250)/2);
           
            NSLog(@"%d",x);
            [viewCatagories addSubview:lblCat];
            
        }
        else
        {
            
            lblCat.frame = CGRectMake(x, 16, (self.view.frame.size.width-105)/2-10, 20);
            lblCat.text=strNameCrop;
            
            lblCat.layer.borderColor=[[UIColor colorWithRed:255.0f/255.0f green:160.0f/255.0f blue:60.0f/255.0f alpha:1]CGColor];
            lblCat.layer.borderWidth=1.5;
            
            
            lblCat.font  = [UIFont fontWithName:@"Helvetica" size:13];
            lblCat.textAlignment=NSTextAlignmentCenter;
            
            x= x+ ((self.view.frame.size.width-105)/2);
            
            NSLog(@"%d",x);
            [viewCatagories addSubview:lblCat];
            
        }
        
    }

}




- (IBAction)popView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)bottomButtonPressed:(UIButton*)sender {
    if ([sender tag]==1) {
        acceptDeclineString =@"1";
    }
    else   if ([sender tag]==2) {
        acceptDeclineString =@"2";
        
    }
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
    
        strWebService=[[NSString alloc]initWithFormat:@"%@pitch_selector",AppURL];
    
    NSLog(@"%@",strWebService);
    NSDictionary *dictParams;
    
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:strPitchId,@"pitch_id",acceptDeclineString,@"status",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]],@"user_id",@"1",@"create_from",
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
                     [self.navigationController popViewControllerAnimated:YES];
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
             [constant AlertMessageWithString:@"Connectivity levels low. Please try again." andWithView:self.view];
             NSLog(@"Error returned:%@",[error localizedDescription]);
         }
     }];
    

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


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
         if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortrait) 
         {
             
             [self setFrame];
             [self setCataImages];
             [self sharingValidation];
                        
         }
         
         else if (orientation == UIInterfaceOrientationLandscapeLeft ||
                  orientation == UIInterfaceOrientationLandscapeRight)
         {
             
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
             
             {
                 
                 [self setFrame];
                 [self setCataImages];
                 [self sharingValidation];
             }
        }
         
         // do whatever
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}


-(void) sharingValidation
{
    NSLog(@"%@",[NSValue valueWithCGRect:viewSharingSub.frame]);
    int i=(viewSharingSub.frame.size.width);
    
    
    if (socialnetworkLinkArray.count==1)
    {
        i=(viewSharingSub.frame.size.width)/4;
    }
    else if (socialnetworkLinkArray.count==2)
    {
        i=(viewSharingSub.frame.size.width)/3;
    }
    else if (socialnetworkLinkArray.count==3)
    {
        i=(viewSharingSub.frame.size.width)/2;
    }
    else if (socialnetworkLinkArray.count==4)
    {
        i=(viewSharingSub.frame.size.width)/1;
    }
    
    
    for (int k=0; k< socialnetworkLinkArray.count; k++)
        
    {
        viewSharingSub.frame=CGRectMake((viewSocialShare.frame.size.width-i)/2, viewSharingSub.frame.origin.y, i, viewSocialShare.frame.size.height);
        
    }
    
   // viewSharingSub.backgroundColor=[UIColor redColor];
    NSLog(@"%@",[NSValue valueWithCGRect:viewSharingSub.frame]);
    
    
    int x= 0;
    int y=(viewSharingSub.frame.size.width-100)/4;
    int z=(y-fbBtn.frame.size.width)/2;

    
    for (int k=0; k< socialnetworkLinkArray.count; k++) 
    
    {
       
      
        
        strMatch=[socialnetworkLinkArray objectAtIndex:k];
       
        if ([self myContainsString:strMatch matchString:@"facebook"])
        {
            if ([strMatch isEqualToString:@"http://www.facebook.com/"])
            {}
            else
            {
                
                fbBtn.hidden=NO;
                
                fbBtn.frame = CGRectMake(x+(y-z),fbBtn.frame.origin.y, fbBtn.frame.size.width, fbBtn.frame.size.height);
                x=x+(viewSharingSub.frame.size.width-100)/4;
            }

        }
        else if ([self myContainsString:strMatch matchString:@"twitter"])
        {
            if ([strMatch isEqualToString:@"http://www.twitter.com/"])
            {}
            else
            {
                twitterBtn.hidden=NO;
                twitterBtn.frame = CGRectMake(x+(y-z),twitterBtn.frame.origin.y, twitterBtn.frame.size.width, twitterBtn.frame.size.height);
                x=x+(viewSharingSub.frame.size.width-100)/4;
            }
        }
        
        else if ([self myContainsString:strMatch matchString:@"linkedin"])
        {
            
            if ([strMatch isEqualToString:@"http://www.linkedin.com/"])
            {}
            else
            {
                linkdinBtn.hidden=NO;
                linkdinBtn.frame = CGRectMake(x+(y-z),linkdinBtn.frame.origin.y, linkdinBtn.frame.size.width, linkdinBtn.frame.size.height);
                x=x+(viewSharingSub.frame.size.width-100)/4;
                
            }
            
        }
        else if ([self myContainsString:strMatch matchString:@"instagram"])
        {
            
            if ([strMatch isEqualToString:@"http://www.instagram.com/"])
            {}
            else
            {
                instagramBtn.hidden=NO;
                instagramBtn.frame = CGRectMake(x+(y-z),instagramBtn.frame.origin.y, instagramBtn.frame.size.width, instagramBtn.frame.size.height);
                x=x+(viewSharingSub.frame.size.width-100)/4;
                
            }
        }
        
        /*
        if ([strMatch containsString:@"facebook"])
        {
            
            if ([strMatch isEqualToString:@"http://www.facebook.com/"])
            {}
            else
            {
                
            fbBtn.hidden=NO;
                
            fbBtn.frame = CGRectMake(x+(y-z),fbBtn.frame.origin.y, fbBtn.frame.size.width, fbBtn.frame.size.height);
                x=x+(viewSharingSub.frame.size.width-100)/4;
            }
        }   
        else if ([strMatch containsString:@"twitter"])
        {
            if ([strMatch isEqualToString:@"http://www.twitter.com/"])
            {}
            else
            {
                twitterBtn.hidden=NO;
                twitterBtn.frame = CGRectMake(x+(y-z),twitterBtn.frame.origin.y, twitterBtn.frame.size.width, twitterBtn.frame.size.height);
                x=x+(viewSharingSub.frame.size.width-100)/4;
            }
        }
        
        else if ([strMatch containsString:@"linkedin"])
        {
            
            if ([strMatch isEqualToString:@"http://www.linkedin.com/"])
            {}
            else
            {
                linkdinBtn.hidden=NO;
                linkdinBtn.frame = CGRectMake(x+(y-z),linkdinBtn.frame.origin.y, linkdinBtn.frame.size.width, linkdinBtn.frame.size.height);
                x=x+(viewSharingSub.frame.size.width-100)/4;

            }
             
        }
        else if ([strMatch containsString:@"instagram"])
        {
            
            if ([strMatch isEqualToString:@"http://www.instagram.com/"])
            {}
            else
            {
               instagramBtn.hidden=NO;
                instagramBtn.frame = CGRectMake(x+(y-z),instagramBtn.frame.origin.y, instagramBtn.frame.size.width, instagramBtn.frame.size.height);
                x=x+(viewSharingSub.frame.size.width-100)/4;

            }
        }*/
    }
    
    if (x==0) {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {

        viewSocialShare.frame= CGRectMake(0,viewUrl.frame.origin.y+viewUrl.frame.size.height,0 , 0);
        
        scrlView.contentSize = CGSizeMake(self.view.frame.size.width,viewSocialShare.frame.origin.y+viewSocialShare.frame.size.height+20);
        }
        else
        {
        
        viewSocialShare.frame= CGRectMake(0,viewUrl.frame.origin.y+viewUrl.frame.size.height,0, 0);
        
        scrlView.contentSize = CGSizeMake(self.view.frame.size.width,viewSocialShare.frame.origin.y+viewSocialShare.frame.size.height+20);
        }

    }
 }

- (BOOL)myContainsString:(NSString*)mainStr matchString:(NSString *)mtcStr {
    NSRange range = [mainStr rangeOfString:mtcStr];
    return range.length != 0;
}


-(void) sharingFrame
{

int x=0;

if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
{
    x=20;
}
else
{
    x=100;
}

for (int g=0; g<arrSelectedCategory.count; g++) 
{
    UILabel*lblCat=[[UILabel alloc]init];
    NSString*lblText;
    lblText=[arrSelectedCategory objectAtIndex:g];
    NSUInteger length = [lblText length];
    NSString* strNameCrop;
    if (length>=12) 
    {
        strNameCrop=[NSString stringWithFormat:@"%@..",[lblText substringToIndex:12]];
    }
    else
    {
        strNameCrop=lblText;
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        int y=(viewCatagories.frame.size.height-40);
        
        lblCat.frame = CGRectMake(x,y/2, (self.view.frame.size.width-250)/3-10, 40);
        
        lblCat.text=strNameCrop;
        
        lblCat.layer.borderColor=[[UIColor colorWithRed:255.0f/255.0f green:180.0f/255.0f blue:10.0f/255.0f alpha:1]CGColor];
        lblCat.layer.borderWidth=2;
        
        
        lblCat.font  = [UIFont fontWithName:@"Helvetica" size:22];
        lblCat.textAlignment=NSTextAlignmentCenter;
        
        x= x+ ((self.view.frame.size.width-250)/2);
        
        NSLog(@"%d",x);
        [viewCatagories addSubview:lblCat];
        
    }
}


}

- (IBAction)chatIconPressed:(id)sender {
   
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"userTypeString"]isEqualToString:@"1"]) {
        [[NSUserDefaults standardUserDefaults]setObject:@"showChatScreen" forKey:@"directCall"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        SWRevealViewController *revealController1 = self.revealViewController;
        manageJournalistViewController*obj;
        obj=[self.storyboard instantiateViewControllerWithIdentifier:@"manageJournalists"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:obj];
        [revealController1 pushFrontViewController:navigationController animated:YES];
    }
    else
    {
    
    [[NSUserDefaults standardUserDefaults]setObject:@"showChatScreen" forKey:@"directCall"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    SWRevealViewController *swrevealController = self.revealViewController;
    viewPitchesViewController_Journalists*obj;
    obj=[self.storyboard instantiateViewControllerWithIdentifier:@"viewPitches"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:obj];
    [swrevealController pushFrontViewController:navigationController animated:YES];
    }
    
}
- (IBAction)btnUrlShare:(id)sender 
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[socialnetworkLinkArray objectAtIndex:4]]]; 
    NSLog(@"%@",url);
    [[UIApplication sharedApplication] openURL:url];   
}
@end
