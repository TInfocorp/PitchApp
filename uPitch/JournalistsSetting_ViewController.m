
//
//  JournalistsSetting_ViewController.m
//  uPitch
//
//  Created by Puneet Rao on 18/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import "JournalistsSetting_ViewController.h"
#import "LxReqRespManager.h"
#import "viewPitchesViewController_Journalists.h"
#import "Utils.h"
#import "TandCViewController.h"
#import "AccountSettingViewController.h"
#import "constant.h"
@interface JournalistsSetting_ViewController ()
{
    NSArray *arrLocal;
}

@end

@implementation JournalistsSetting_ViewController

-(void)showSetting
{

    
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService=[[NSString alloc]initWithFormat:@"%@showsetting",AppURL];
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
//             emailTextField.text=[[[response valueForKey:@"data"] valueForKey:@"Userlink"] valueForKey:@"email_new"];
//             messageTextView.text=[[[response valueForKey:@"data"] valueForKey:@"Userlink"] valueForKey:@"message"];
//             messageLabel.hidden=YES;
             if ([str isEqualToString:@"0"] )
             {
                 NSString*mediaString = [NSString stringWithFormat:@"%@",[[[response valueForKey:@"data"] valueForKey:@"Userlink"] valueForKey:@"media"]];
                 
                 switchString = [NSString stringWithFormat:@"%@",[[[response valueForKey:@"data"] valueForKey:@"Userlink"] valueForKey:@"notification_setting"]];
                 if ([switchString isEqualToString:@"1"]) {
                     notificationSwitch.on = YES;
                 }
                 else{
                     notificationSwitch.on = NO;
                 }
                 
                 strMessageSwitch = [NSString stringWithFormat:@"%@",[[[response valueForKey:@"data"] valueForKey:@"Userlink"] valueForKey:@"message_notification"]];
                 if ([strMessageSwitch isEqualToString:@"1"]) {
                     swithcMessageNotification.on = YES;
                     [USERDEFAULTS setBool:NO forKey:@"messageNotificaitonOnOff"];
                     [USERDEFAULTS synchronize];
                     
                 }
                 else
                 {
                     [USERDEFAULTS setBool:YES forKey:@"messageNotificaitonOnOff"];
                     [USERDEFAULTS synchronize];
                     swithcMessageNotification.on = NO;
                 }
                 
                 
                 NSArray *idarray = [[[[response valueForKey:@"data"] valueForKey:@"Userlink"] valueForKey:@"cat_id"]   componentsSeparatedByString:@","];
                 if ([[[[response valueForKey:@"data"] valueForKey:@"Userlink"] valueForKey:@"cat_id"] isEqualToString:@""]) {
                     // all id will be set
                 }
                 else{
                     for (int k =0; k<idarray.count; k++) {
                         [selectedCategoryIdArray addObject:[idarray objectAtIndex:k]];
                     } 
                 }
                
                 NSArray *namearray = [[[[response valueForKey:@"data"] valueForKey:@"Userlink"] valueForKey:@"catname"]   componentsSeparatedByString:@","];
                 for (int k =0; k<namearray.count; k++) {
                     [selectedCategoryNameArray addObject:[namearray objectAtIndex:k]];
                 }
                 
                 for (int i=0; i<selectedCategoryIdArray.count; ++i)
                 {
                     NSString *string = [selectedCategoryIdArray objectAtIndex:i];
                     for (int j = i+1; j < selectedCategoryIdArray.count; ++j) {
                         if ([string isEqualToString:[selectedCategoryIdArray objectAtIndex:j]])
                         {
                             [selectedCategoryIdArray removeObjectAtIndex:j];
                             
                         }
                     }
                 }
                 NSLog(@"%@",selectedCategoryIdArray);
                 [self setFrameCategory];
                 
                 if ([mediaString isEqualToString:@"1"])
                 {
                     [localNationalButton setTitle:@"Local" forState:UIControlStateNormal];
                     zipcodeTextField.text = [NSString stringWithFormat:@"%@",[[[response valueForKey:@"data"] valueForKey:@"Userlink"] valueForKey:@"zip_code"]];
                     slider.value =[[[[response valueForKey:@"data"] valueForKey:@"Userlink"] valueForKey:@"miles"] integerValue];
                     sliderValue.text = [NSString stringWithFormat:@"%d miles",(int)slider.value];
                     
                     mediaCoverageView.frame = CGRectMake(mediaCoverageView.frame.origin.x, mediaCoverageView.frame.origin.y, mediaCoverageView.frame.size.width, zipcodeView.frame.origin.y+zipcodeView.frame.size.height);
                     
                     categorySuperView.frame = CGRectMake(categorySuperView.frame.origin.x, mediaCoverageView.frame.origin.y+mediaCoverageView.frame.size.height, categorySuperView.frame.size.width, categorySuperView.frame.size.height);
                     
                      NSLog(@"%@",[NSValue valueWithCGRect:categorySuperView.frame]);
                     [self setScroll];
                 }
                 

                 else{
                     
                     if ([mediaString isEqualToString:@"2"]){
                     [localNationalButton setTitle:@"USA" forState:UIControlStateNormal];
                     }else  if ([mediaString isEqualToString:@"3"]){
                         [localNationalButton setTitle:@"Canada" forState:UIControlStateNormal];
                     }else if ([mediaString isEqualToString:@"4"]){
                         [localNationalButton setTitle:@"North America" forState:UIControlStateNormal];
                     }
                     

                     
                     [self setScroll];

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
                 
//                     UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                     [alert show];
                 [constant alertViewWithMessage:[response valueForKey:@"message"] withView:self];
                 [self setScroll];

             }
             else
             {
                 if (response == nil||response == (id)[NSNull null])
                 {
//                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"upitch" message:@"An unknown error has occurred." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                 [alert show];
                     [constant alertViewWithMessage:@"An unknown error has occurred."withView:self];
                     [self setScroll];

                 }
                 else
                 {
//                     UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                     [alert show];
                     [constant alertViewWithMessage:[response valueForKey:@"message"]withView:self];
                     [self setScroll];

                 }
 
             }
         }
         else
         {
             [appdelegateInstance hideHUD];
             [constant AlertMessageWithString:@"Connectivity levels low. Please try again." andWithView:self.view];
             [self setScroll];
             NSLog(@"Error returned:%@",[error localizedDescription]);
         }
     }];

}
- (IBAction)setState:(id)sender
{
        BOOL state = [sender isOn];
        NSString *rez = state == YES ? @"YES" : @"NO";
        NSLog(@"%@",rez);
        if ([rez isEqualToString:@"YES"])
        {
            switchString = @"1";
        }
        else
        {
            switchString = @"0";
        }
}
-(void)setFrameCategory{
   // yAxis = 10;
    categoryCounter = 0;
    for (int h=0; h<selectedCategoryNameArray.count; h++)
    {
        categoryCounter ++;
        
        if (categoryCounter == 4)
        {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                categoryCounter = 1;
                yAxis=yAxis+60;
                xAxis = 5;
            }
            else
            {
                categoryCounter = 1;
                yAxis=yAxis+40;
                xAxis = 5;
            }
        }
        
        UIButton*filteredCategoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            filteredCategoryButton.frame = CGRectMake(xAxis, yAxis, 768/3-10, 50);
            filteredCategoryButton.titleLabel.font  = [UIFont fontWithName:@"HelveticaNeue-Light" size:23];
            xAxis = 9+xAxis+768/3-10;
        }
        
        else
        {
            filteredCategoryButton.frame = CGRectMake(xAxis, yAxis, self.view.frame.size.width/3-10, 30);
            filteredCategoryButton.titleLabel.font  = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
            xAxis = 9+xAxis+self.view.frame.size.width/3-10;
             NSLog(@"set  frame is %@",[NSValue valueWithCGRect:filteredCategoryButton.frame]);
        }
        
        NSString*btnText;
        btnText=[selectedCategoryNameArray objectAtIndex:h];
        NSUInteger length = [btnText length];
        NSString* strNameCrop;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            if (length>=15)
            {
                strNameCrop=[NSString stringWithFormat:@"%@..",[btnText substringToIndex:15]];
            }
            else
            {
                strNameCrop=btnText;
            }
        }
        else{
            if (length>=11)
            {
                strNameCrop=[NSString stringWithFormat:@"%@..",[btnText substringToIndex:11]];
            }
            else
            {
                strNameCrop=btnText;
            }
        }
        
        
        [filteredCategoryButton setTitle:[NSString stringWithFormat:@"%@",strNameCrop ] forState:UIControlStateNormal];
        
        [filteredCategoryButton setBackgroundImage:[UIImage imageNamed:@"Forma11.png"] forState:UIControlStateNormal];
        
        [filteredCategoryButton addTarget:self action:@selector(DeleteCategory:) forControlEvents:UIControlEventTouchUpInside];
        
        [categoryView addSubview:filteredCategoryButton];
        
        
        categoryView.frame = CGRectMake(categoryView.frame.origin.x, categoryView.frame.origin.y, categoryView.frame.size.width, (selectedCategoryIdArray.count*40)/3);
        
        filteredCategoryButton.tag = h+1;
    }
    if (selectedCategoryNameArray.count>0)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            numberOfCategoryLabel.text = [NSString stringWithFormat:@"%lu selected",(unsigned long)selectedCategoryNameArray.count];
            
            categoryView.frame = CGRectMake(categoryView.frame.origin.x, categoryView.frame.origin.y, categoryView.frame.size.width, (selectedCategoryNameArray.count/3)*60+60);
            
            if (selectedCategoryIdArray.count%3==0)
            {
                
                categoryView.frame = CGRectMake(categoryView.frame.origin.x, categoryView.frame.origin.y, categoryView.frame.size.width, (selectedCategoryNameArray.count/3)*60);
            }
        }
        else
        {
            numberOfCategoryLabel.text = [NSString stringWithFormat:@"%lu selected",(unsigned long)selectedCategoryNameArray.count];
            categoryView.frame = CGRectMake(categoryView.frame.origin.x, categoryView.frame.origin.y, categoryView.frame.size.width, (selectedCategoryNameArray.count/3)*40+40);
            
            if (selectedCategoryIdArray.count%3==0)
            {
                categoryView.frame = CGRectMake(categoryView.frame.origin.x, categoryView.frame.origin.y, categoryView.frame.size.width, (selectedCategoryNameArray.count/3)*40);
            }
            
        }
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            buttonFaturesViewBottom.frame= CGRectMake(buttonFaturesViewBottom.frame.origin.x, categoryView.frame.origin.y+categoryView.frame.size.height+10, buttonFaturesViewBottom.frame.size.width,buttonFaturesViewBottom.frame.size.height);
       
             categorySuperView.frame= CGRectMake(categorySuperView.frame.origin.x, categorySuperView.frame.origin.y, categorySuperView.frame.size.width, buttonFaturesViewBottom.frame.size.height+buttonFaturesViewBottom.frame.origin.y);
            
        }
        else
        {
            buttonFaturesViewBottom.frame= CGRectMake(buttonFaturesViewBottom.frame.origin.x, categoryView.frame.origin.y+categoryView.frame.size.height+10, buttonFaturesViewBottom.frame.size.width,buttonFaturesViewBottom.frame.size.height);
            categorySuperView.frame= CGRectMake(categorySuperView.frame.origin.x, categorySuperView.frame.origin.y, categorySuperView.frame.size.width, buttonFaturesViewBottom.frame.size.height+buttonFaturesViewBottom.frame.origin.y);
        }
       
    }
   [self setScroll];
}
- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PubNubNotification:) name:@"pubnubnot" object:nil];
    [super viewDidLoad];
//    mediaCoverageView.userInteractionEnabled = NO;
     //zipcodeTextField.keyboardType=UIKeyboardTypeNumberPad;
    TablePosition=0;
    xAxis = 5;
    selectedCategoryNameArray =[[NSMutableArray alloc]init];
     selectedCategoryIdArray =[[NSMutableArray alloc]init];
    tableVw.delegate = nil;
    tableVw.dataSource = nil;
    saveButton.layer.cornerRadius = 5;
    saveButton.layer.masksToBounds = YES;
    btnDelete.layer.cornerRadius = 5;
    btnDelete.layer.masksToBounds = YES;
    logoutButton.layer.cornerRadius = 5;
    logoutButton.layer.masksToBounds = YES;
    [toolBar removeFromSuperview];
    zipcodeTextField.inputAccessoryView = toolBar;
    emailTextField.inputAccessoryView=toolBar;
    messageTextView.inputAccessoryView=toolBar;
//    arrLocal=[[NSArray alloc]initWithObjects:@"Local",@"USA",@"Canada",@"North America",nil];
    
    //MHT, added as per request
   arrLocal=[[NSArray alloc]initWithObjects:@"USA",@"Canada",@"North America",@"NZ", @"South Africa", @"UK", @"Australia", nil];

    appdelegateInstance = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self categoryApi];
    [self showSetting];
}


-(void)setScroll
{
    scrollVw.contentSize = CGSizeMake(self.view.frame.size.width,vwNotificationSetting.frame.size.height +mediaCoverageView.frame.size.height+categorySuperView.frame.size.height);
}

-(void)dismissKeyboard {
    [zipcodeTextField resignFirstResponder];
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
    [self getCount];
    self.navigationController.navigationBarHidden = YES;
    [self leftSlider];
    [super viewWillAppear:animated];

    submitButton.layer.cornerRadius = 5;
    submitButton.layer.masksToBounds = YES;
    [self setBorderImageView:emailImageView];
    [self setBorderImageView:textViewImageView];
}

-(void)setBorderImageView:(UIImageView *)imgView
{
    imgView.layer.borderColor = [UIColor colorWithRed:75.0f/255.0f green:190.0f/255.0f blue:255.0f/255.0f alpha:1.0].CGColor;
    imgView.layer.borderWidth=1.2f;
    imgView.layer.cornerRadius = 5;
    imgView.layer.masksToBounds = YES;
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
   // [button setBackgroundImage:[UIImage imageNamed:@"menu55.png"] forState:UIControlStateNormal];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        button.frame = CGRectMake(10, 10, 70, 70);
    }
    else{
        button.frame = CGRectMake(2, 10, 50, 55);
    }    [self.view addSubview:button];
}


#pragma mark TextView delegate
- (void)textViewDidEndEditing:(UITextView *)theTextView
{
    if (![messageTextView hasText])
    {
        messageLabel.hidden = NO;
    }
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView{

    scrollVw.contentOffset = CGPointMake(0,mediaCoverageView.frame.origin.y+mediaCoverageView.frame.size.height+categoryView.frame.size.height+  textView.frame.origin.y);
}

- (void) textViewDidChange:(UITextView *)textView
{
    
    if(![messageTextView hasText]) {
        messageLabel.hidden = NO;
    }
    else{
        messageLabel.hidden = YES;
    }
}

#pragma mark TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // Place Scroll Code here
    
//    CGPoint point = textField.frame.origin ;
//    scrollVw.contentOffset = point;
     //scrollVw.contentOffset = CGPointMake(0,0);
    
    
    scrollVw.contentOffset = CGPointMake(0,mediaCoverageView.frame.origin.y+mediaCoverageView.frame.size.height+categoryView.frame.size.height+  textField.frame.origin.y);
    
   // scrollVw.contentOffset = CGPointMake(0,textField.frame.origin.y);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string 
{
    // Prevent crashing undo bug – see note below.
    
    if (textField==zipcodeTextField)
    {
       NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
        
        zipcodeTextField.keyboardType=UIKeyboardTypeNumberPad;
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        //if (zipcode.text.length<8) {
        NSLog(@"%lu",[textField.text length] + [string length] - range.length);
        if (([textField.text length] + [string length] - range.length)<12) 
        {
            return [string isEqualToString:filtered];
        }
    }else if (textField==emailTextField){
        return 200;
    }
   return 0;
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
    
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
              NSLog(@"response of get request:%@",response);
             [appdelegateInstance hideHUD];
             NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             if ([str isEqualToString:@"0"] )
             {
                 categoryNameArray=[[NSMutableArray alloc]init];
                  categoryIdArray=[[NSMutableArray alloc]init];
                 for (int k=0; k<[[response valueForKey:@"data"] count]; k++) {
                     [categoryNameArray addObject:[[[[response valueForKey:@"data"] valueForKey:@"Category"] valueForKey:@"cat_name"] objectAtIndex:k]];
                     [categoryIdArray addObject:[[[[response valueForKey:@"data"] valueForKey:@"Category"] valueForKey:@"id"] objectAtIndex:k]];
                     
                   }
                    tableVw.delegate = self;
                     tableVw.dataSource = self;
                     [tableVw reloadData];
                 NSLog(@"%@",categoryIdArray);
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
         }
         else
         {
             [appdelegateInstance hideHUD];
             [constant AlertMessageWithString:@"Connectivity levels low. Please try again." andWithView:self.view];
             NSLog(@"Error returned:%@",[error localizedDescription]);
         }
     }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ToolBar method

-(void)ResignKeyboard
{
    [emailTextField resignFirstResponder];
    [messageTextView resignFirstResponder];
}
-(IBAction)cancelToolBar:(id)sender
{
    [zipcodeTextField resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self.view setFrame:CGRectMake(0, 0 ,self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}
-(IBAction)Done
{
    [zipcodeTextField resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self.view setFrame:CGRectMake(0, 0 ,self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}

-(IBAction)changeSlider:(id)sender
{
    
    sliderValue .text= [[NSString alloc] initWithFormat:@"%d Miles", (int)slider.value];
}

-(void)setFrame
{
    if ([localNationalButton.titleLabel.text isEqualToString:@"Local"]) 
    {
        
        mediaCoverageView.frame = CGRectMake(mediaCoverageView.frame.origin.x, mediaCoverageView.frame.origin.y, mediaCoverageView.frame.size.width, 200);
        categorySuperView.frame = CGRectMake(categorySuperView.frame.origin.x, mediaCoverageView.frame.origin.y+mediaCoverageView.frame.size.height, categorySuperView.frame.size.width, categorySuperView.frame.size.height);
        
        [localNationalButton setTitle:@"Local" forState:UIControlStateNormal];

    }
    else
    {
        mediaCoverageView.frame = CGRectMake(mediaCoverageView.frame.origin.x, mediaCoverageView.frame.origin.y, mediaCoverageView.frame.size.width, 50);
        categorySuperView.frame = CGRectMake(categorySuperView.frame.origin.x, mediaCoverageView.frame.origin.y+mediaCoverageView.frame.size.height, categorySuperView.frame.size.width, categorySuperView.frame.size.height);
        [localNationalButton setTitle:@"Select" forState:UIControlStateNormal];
    }
}
#pragma mark TableView Method


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [zipcodeTextField resignFirstResponder];
    if (buttonTag == 1)
    {
//        if (indexPath.row ==0)
//        {
//            mediaCoverageView.frame = CGRectMake(mediaCoverageView.frame.origin.x, mediaCoverageView.frame.origin.y, mediaCoverageView.frame.size.width, zipcodeView.frame.origin.y+zipcodeView.frame.size.height);
//            
//            categorySuperView.frame = CGRectMake(categorySuperView.frame.origin.x, mediaCoverageView.frame.origin.y+mediaCoverageView.frame.size.height, categorySuperView.frame.size.width, categorySuperView.frame.size.height);
//            
//            [localNationalButton setTitle:@"Local" forState:UIControlStateNormal];
//        }
//        else{
        
            mediaCoverageView.frame = CGRectMake(mediaCoverageView.frame.origin.x, mediaCoverageView.frame.origin.y, mediaCoverageView.frame.size.width, zipcodeTopView.frame.size.height);
            categorySuperView.frame = CGRectMake(categorySuperView.frame.origin.x, mediaCoverageView.frame.origin.y+mediaCoverageView.frame.size.height+1, categorySuperView.frame.size.width, categorySuperView.frame.size.height);
           // localNationalButton.titleLabel.text=[NSString stringWithFormat:@"%@",[arrLocal objectAtIndex:indexPath.row]];
            [localNationalButton setTitle:[NSString stringWithFormat:@"%@",[arrLocal objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
            [zipcodeTextField resignFirstResponder];
//        }

        [self setScroll];
         tableSuperView.hidden = YES;
    }
    
    else if (buttonTag == 2)
    {
        if ([selectedCategoryNameArray containsObject:[NSString stringWithFormat:@"%@",[categoryNameArray objectAtIndex:indexPath.row]]]) {
                 
//            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:@"You have already selected this category" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
            [constant alertViewWithMessage:@"You have already selected this category."withView:self];
        }
        else
        {
            categoryCounter ++;
            
            [selectedCategoryNameArray addObject:[NSString stringWithFormat:@"%@",[categoryNameArray objectAtIndex:indexPath.row] ]];
            
            [selectedCategoryIdArray addObject:[NSString stringWithFormat:@"%@",[categoryIdArray objectAtIndex:indexPath.row] ]];
            NSLog(@"%ld",(long)yAxis);
            if (categoryCounter == 4) 
            {
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                {
                categoryCounter = 1;
                yAxis=yAxis+60;
                xAxis = 5;
                }
                else
                {
                categoryCounter = 1;
                yAxis=yAxis+40;
                xAxis = 5;
                }
            }
            
            UIButton*filteredCategoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
             NSLog(@"%ld",(long)yAxis);
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                filteredCategoryButton.frame = CGRectMake(xAxis, yAxis, 768/3-10, 50);
                filteredCategoryButton.titleLabel.font  = [UIFont fontWithName:@"HelveticaNeue-Light" size:23];
                 xAxis = 9+xAxis+768/3-10;
                NSLog(@"frame is %@",[NSValue valueWithCGRect:filteredCategoryButton.frame]);
            }
            
            else
            {
                filteredCategoryButton.frame = CGRectMake(xAxis, yAxis, self.view.frame.size.width/3-10, 30);
                NSLog(@"frame is %@",[NSValue valueWithCGRect:filteredCategoryButton.frame]);
                filteredCategoryButton.titleLabel.font  = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                 xAxis = 9+xAxis+self.view.frame.size.width/3-10;
            }
            
            NSString*btnText;
            btnText  = [NSString stringWithFormat:@"%@",[categoryNameArray objectAtIndex:indexPath.row]];
            NSLog(@"%@",btnText);
            if (categoryNameArray.count>0)
            {
                
         //   btnText=[categoryNameArray objectAtIndex:indexPath.row];
            NSUInteger length = [btnText length];
            NSString* strNameCrop;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                if (length>=15)
                {
                    strNameCrop=[NSString stringWithFormat:@"%@..",[btnText substringToIndex:15]];
                }
                else
                {
                    strNameCrop=btnText;
                }
            }
            else{
                if (length>=9)
                {
                    strNameCrop=[NSString stringWithFormat:@"%@..",[btnText substringToIndex:9]];
                }
                else
                {
                    strNameCrop=btnText;
                }
            }

            [filteredCategoryButton setTitle:[NSString stringWithFormat:@"%@",strNameCrop ] forState:UIControlStateNormal];
            }
            
            [filteredCategoryButton setBackgroundImage:[UIImage imageNamed:@"Forma11.png"] forState:UIControlStateNormal];
            
            [filteredCategoryButton addTarget:self action:@selector(DeleteCategory:) forControlEvents:UIControlEventTouchUpInside];
            
            [categoryView addSubview:filteredCategoryButton];
            
            
            categoryView.frame = CGRectMake(categoryView.frame.origin.x, categoryView.frame.origin.y, categoryView.frame.size.width, (selectedCategoryIdArray.count*40)/3);
            NSLog(@"category view frame is %@",[NSValue valueWithCGRect:categoryView.frame]);
            filteredCategoryButton.tag = selectedCategoryIdArray.count;
            
        }
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            numberOfCategoryLabel.text = [NSString stringWithFormat:@"%lu selected",(unsigned long)selectedCategoryNameArray.count];
            
            categoryView.frame = CGRectMake(categoryView.frame.origin.x, categoryView.frame.origin.y, categoryView.frame.size.width, (selectedCategoryNameArray.count/3)*60+60);
            
            if (selectedCategoryIdArray.count%3==0) 
            {
                
                categoryView.frame = CGRectMake(categoryView.frame.origin.x, categoryView.frame.origin.y, categoryView.frame.size.width, (selectedCategoryNameArray.count/3)*60);
               // categoryView.backgroundColor = [UIColor redColor];
            }
        }
        else
        {
            numberOfCategoryLabel.text = [NSString stringWithFormat:@"%lu selected",(unsigned long)selectedCategoryNameArray.count];
            categoryView.frame = CGRectMake(categoryView.frame.origin.x, categoryView.frame.origin.y, categoryView.frame.size.width, (selectedCategoryNameArray.count/3)*40+40);
            NSLog(@"%lu",(unsigned long)selectedCategoryIdArray.count);
            if (selectedCategoryIdArray.count%3==0) 
            {
                
                categoryView.frame = CGRectMake(categoryView.frame.origin.x, categoryView.frame.origin.y, categoryView.frame.size.width, (selectedCategoryNameArray.count/3)*40);
            }
        
        }
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
             buttonFaturesViewBottom.frame= CGRectMake(buttonFaturesViewBottom.frame.origin.x, categoryView.frame.origin.y+categoryView.frame.size.height+10, buttonFaturesViewBottom.frame.size.width,buttonFaturesViewBottom.frame.size.height);
            categorySuperView.frame= CGRectMake(categorySuperView.frame.origin.x, categorySuperView.frame.origin.y, categorySuperView.frame.size.width, buttonFaturesViewBottom.frame.size.height+buttonFaturesViewBottom.frame.origin.y);
        }
        else
        {
        buttonFaturesViewBottom.frame= CGRectMake(buttonFaturesViewBottom.frame.origin.x, categoryView.frame.origin.y+categoryView.frame.size.height+10, buttonFaturesViewBottom.frame.size.width,buttonFaturesViewBottom.frame.size.height);
        categorySuperView.frame= CGRectMake(categorySuperView.frame.origin.x, categorySuperView.frame.origin.y, categorySuperView.frame.size.width, buttonFaturesViewBottom.frame.size.height+buttonFaturesViewBottom.frame.origin.y);
           
        }
         [self setScroll];
    }
    
    
    [tableVw reloadData];
}


-(void)DeleteCategory : (UIButton*)sender{
    
    UIButton*deleteButton = (UIButton*)[categoryView viewWithTag:[sender tag]];
    [deleteButton removeFromSuperview];
    [selectedCategoryIdArray removeObjectAtIndex:[sender tag]-1];
    [selectedCategoryNameArray removeObjectAtIndex:[sender tag]-1];
    [tableVw reloadData];
    numberOfCategoryLabel.text = [NSString stringWithFormat:@"%lu selected",(unsigned long)selectedCategoryNameArray.count];
    [self reframeTheCategory];

    
}



-(void)reframeTheCategory
{
   
    
    int x = 0;
    int y=0;
    int counter=0;
    int tagvalue=0;
     NSLog(@"%ld",(long)yAxis);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        NSInteger localy = selectedCategoryNameArray.count/3;
        
        yAxis = localy*60 ;
        
        if (selectedCategoryNameArray.count%3==0) 
        {
            xAxis = 5;
            categoryCounter = 0;
        }
        
        if (selectedCategoryNameArray.count%3==1) 
        {
            xAxis = 14+768/3-10;
            categoryCounter = 1;
        }
        
        if (selectedCategoryNameArray.count%3==2) 
        {
            xAxis = 14+2*(768/3)-10;
            categoryCounter = 2;
        }
 
        
    }
    else
    {
        NSInteger localy = selectedCategoryNameArray.count/3;
        yAxis = localy*40 ;
        
        if (selectedCategoryNameArray.count%3==0) {
            xAxis = 5;
            categoryCounter = 0;
        }
        
        if (selectedCategoryNameArray.count%3==1) 
        {
            xAxis = 14+self.view.frame.size.width/3-10;
            categoryCounter = 1;
        }
        
        if (selectedCategoryNameArray.count%3==2) 
        {
            xAxis = 14+2*(self.view.frame.size.width/3)-10;
            categoryCounter = 2;
        }
    }
    
    x=5;
    y=0;
    counter=0;
    tagvalue = 1;

        
    for (int h=0; h<selectedCategoryNameArray.count+1; h++) {
        UIButton*deleteButton = (UIButton*)[categoryView viewWithTag:h+1];
        if ([deleteButton isKindOfClass:[UIButton class]]) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                deleteButton.frame = CGRectMake(x, y, 768/3-10, 50);
            }
            else
            {
                deleteButton.frame = CGRectMake(x, y, self.view.frame.size.width/3-10, 30);
            }
             NSLog(@"delete frame is %@",[NSValue valueWithCGRect:deleteButton.frame]);
            counter++;
             x = x+deleteButton.frame.size.width+10;
            if (counter==3) {
                counter = 0;
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                {
                    y=y+60;
                    x = 5;
                }
                else
                {
                    y=y+40;
                    x = 5;
                }
                
            }
            deleteButton.tag = tagvalue;
            tagvalue++;
           
        }
        else{
            NSLog(@"no button found");
        }
       
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
     categoryView.frame = CGRectMake(categoryView.frame.origin.x, categoryView.frame.origin.y, categoryView.frame.size.width, (selectedCategoryNameArray.count/3)*60+60);
        
        if (selectedCategoryIdArray.count%3==0) 
        {
            
            categoryView.frame = CGRectMake(categoryView.frame.origin.x, categoryView.frame.origin.y, categoryView.frame.size.width, (selectedCategoryNameArray.count/3)*60);
        }
        
        buttonFaturesViewBottom.frame= CGRectMake(buttonFaturesViewBottom.frame.origin.x, categoryView.frame.origin.y+categoryView.frame.size.height+10, buttonFaturesViewBottom.frame.size.width,buttonFaturesViewBottom.frame.size.height);
        categorySuperView.frame= CGRectMake(categorySuperView.frame.origin.x, categorySuperView.frame.origin.y, categorySuperView.frame.size.width, buttonFaturesViewBottom.frame.size.height+buttonFaturesViewBottom.frame.origin.y);
       // categorySuperView.backgroundColor = [UIColor redColor];

    }
    else
    {
      categoryView.frame = CGRectMake(categoryView.frame.origin.x, categoryView.frame.origin.y, categoryView.frame.size.width, (selectedCategoryNameArray.count/3)*40+40);
        
        if (selectedCategoryIdArray.count%3==0) {
            
            categoryView.frame = CGRectMake(categoryView.frame.origin.x, categoryView.frame.origin.y, categoryView.frame.size.width, (selectedCategoryNameArray.count/3)*40);
        }
        
        
        
        buttonFaturesViewBottom.frame= CGRectMake(buttonFaturesViewBottom.frame.origin.x, categoryView.frame.origin.y+categoryView.frame.size.height+10, buttonFaturesViewBottom.frame.size.width,buttonFaturesViewBottom.frame.size.height);
        categorySuperView.frame= CGRectMake(categorySuperView.frame.origin.x, categorySuperView.frame.origin.y, categorySuperView.frame.size.width, buttonFaturesViewBottom.frame.size.height+buttonFaturesViewBottom.frame.origin.y);
        
       // NSLog(@"Category %@ \n ContactView%@\n LogOutView%@ CategoriesView%@",[NSValue valueWithCGRect:categoryView.frame],[NSValue valueWithCGRect:contactView.frame],[NSValue valueWithCGRect:buttonFaturesViewBottom.frame],[NSValue valueWithCGRect:categorySuperView.frame]);

    }
    
    [self setScroll];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortrait) {
        if (selectedCategoryIdArray.count==0) {
            scrollVw.scrollEnabled = YES;
        }
        else{
            scrollVw.scrollEnabled = YES;
        }
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
    tableView.separatorColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    if (buttonTag == 1)
    {
        cell.textLabel.text=[arrLocal objectAtIndex:indexPath.row];
//        if (indexPath.row == 0) {
//            cell.textLabel.text = @"Local";
//        }
//        else if (indexPath.row == 1) {
//            cell.textLabel.text = @"USA";
//        }
//        else if (indexPath.row == 2) {
//            cell.textLabel.text = @"CANADA";
//        }
//
//        else if (indexPath.row == 3) {
//            cell.textLabel.text = @"North america(Canada+USA)";
//        }
    }
    else  if (buttonTag == 2)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[categoryNameArray objectAtIndex:indexPath.row]];
        
    }
    if ([selectedCategoryNameArray containsObject:[NSString stringWithFormat:@"%@",[categoryNameArray objectAtIndex:indexPath.row]]]) {
        
        cell.textLabel.textColor=[UIColor colorWithRed:175.0f/255.0f green:120.0f/255.0f blue:80.0f/255.0f alpha:1.0f];
    }
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:27.0f];
    }
    else{
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f];
    }
    
      
    if (TablePosition==2) 
        
    {
             if ([selectedCategoryNameArray containsObject:[NSString stringWithFormat:@"%@",[categoryNameArray objectAtIndex:indexPath.row]]]) 
        {
            cell.textLabel.textColor=[UIColor colorWithRed:175.0f/255.0f green:120.0f/255.0f blue:80.0f/255.0f alpha:1.0f];
        }
        else{
            cell.textLabel.textColor = [UIColor whiteColor];
        }
   }
    else
    {
     cell.textLabel.textColor = [UIColor whiteColor];   
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
    if (buttonTag == 1) {
         return arrLocal.count;
    }
   else if (buttonTag == 2) {
        return categoryNameArray.count;
    }
    return 0;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)AccountSettingPressed:(id)sender {
    AccountSettingViewController *obj;
    obj=[self.storyboard instantiateViewControllerWithIdentifier:@"AccountSetting"];
    [self.navigationController pushViewController:obj animated:YES];
}

- (IBAction)stateMessageChanged:(id)sender
{
    BOOL state = [sender isOn];
    NSString *rez = state == YES ? @"YES" : @"NO";
    NSLog(@"%@",rez);
    if ([rez isEqualToString:@"YES"])
    {
        strMessageSwitch = @"1";
    }
    else
    {
        strMessageSwitch = @"0";
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
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:obj];
    [revealController pushFrontViewController:navigationController animated:YES];
}
#pragma mark Toolbar Methods
- (IBAction)done:(id)sender {
    [self ResignKeyboard];
    [zipcodeTextField resignFirstResponder];
}

- (IBAction)cancel:(id)sender {
    [self ResignKeyboard];
     [zipcodeTextField resignFirstResponder];
}
-(BOOL)validateEmailWithString:(NSString*)email1
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email1];
}
- (IBAction)saveButtonPressed:(id)sender {
    

    [zipcodeTextField resignFirstResponder];
    
    if ([strMessageSwitch isEqualToString:@"1"]) {
        [USERDEFAULTS setBool:NO forKey:@"messageNotificaitonOnOff"];
        [USERDEFAULTS synchronize];
        
    }else
    {
        [USERDEFAULTS setBool:YES forKey:@"messageNotificaitonOnOff"];
        [USERDEFAULTS synchronize];
    }
    if ([localNationalButton.titleLabel.text isEqualToString:@"Select"]) {
//        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Please select media coverage" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [constant alertViewWithMessage:@"Please select media coverage."withView:self];
    }
   else if ([localNationalButton.titleLabel.text isEqualToString:@"Local"] && [zipcodeTextField.text isEqualToString:@""]) {
//        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Please enter zipcode" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
       [constant alertViewWithMessage:@"Please enter zipcode."withView:self];
    }
    else{
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService=[[NSString alloc]initWithFormat:@"%@savesetting",AppURL];
    
    NSDictionary *dictParams;
    dictParams=[[NSDictionary alloc]init];

    NSString*categoryIdString;
        
        if (selectedCategoryIdArray.count==0) {
        }
        else{
            
            for (int i=0; i<selectedCategoryIdArray.count; ++i)
            {
                NSString *string = [selectedCategoryIdArray objectAtIndex:i];
                for (int j = i+1; j < selectedCategoryIdArray.count; ++j) {
                    if ([string isEqualToString:[selectedCategoryIdArray objectAtIndex:j]])
                    {
                        [selectedCategoryIdArray removeObjectAtIndex:j];
                        
                    }
                }
            }
            
            for (NSObject * obj in selectedCategoryIdArray)
            {
                categoryIdString = [selectedCategoryIdArray componentsJoinedByString:@","];
                NSLog(@"%@",obj);
                NSLog(@"%@",categoryIdString);
            }
        }
      if ([localNationalButton.titleLabel.text isEqualToString:@"Local"]) {
          
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:
                    switchString,@"notification_setting",strMessageSwitch,@"message_notification",
                    [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",
                    @"1",@"media",
                zipcodeTextField.text,@"zipcode",
                    sliderValue.text,@"miles",
                    emailTextField.text,@"email",
                    messageTextView.text,@"message",
                    categoryIdString,@"catid",
                    nil];
    }
    else{
        NSString *strMedia;
        if ([localNationalButton.titleLabel.text isEqualToString:@"USA"]) {
            strMedia=@"2";
        }else if ([localNationalButton.titleLabel.text isEqualToString:@"Canada"]) {
            strMedia=@"3";
        }
        else if ([localNationalButton.titleLabel.text isEqualToString:@"North America"]) {
            strMedia=@"4";
        }
        
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:
                    switchString,@"notification_setting",strMessageSwitch,@"message_notification",
                    [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",
                    strMedia,@"media",
                    emailTextField.text,@"email",
                    messageTextView.text,@"message",
                    categoryIdString,@"catid",
                    nil];
    }
        NSLog(@"%@",strWebService);
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
//                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Setting saved successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                 [alert show];
                 [constant alertViewWithMessage:@"Setting saved successfully."withView:self];
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
         }
         else
         {
             [appdelegateInstance hideHUD];
             [constant AlertMessageWithString:@"Connectivity levels low. Please try again." andWithView:self.view];
             NSLog(@"Error returned:%@",[error localizedDescription]);
         }
     }];
    }
//}

}

- (IBAction)localNatiotnalButtonPressed:(UIButton*)sender {
    
    [zipcodeTextField resignFirstResponder];
    
    buttonTag = [sender tag];
    if (buttonTag==1)
    {
        TablePosition=1;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
         tableVw.frame = CGRectMake(localNationalButton.frame.origin.x, localNationalButton.frame.origin.y+localNationalButton.frame.size.height+60-scrollVw.contentOffset.y+130+45, localNationalButton.frame.size.width,160);
        }
        else
        {
        tableVw.frame = CGRectMake(localNationalButton.frame.origin.x, localNationalButton.frame.origin.y+localNationalButton.frame.size.height+10-scrollVw.contentOffset.y+95+45, localNationalButton.frame.size.width,160);
            tableVw.delegate=self;
            tableVw.dataSource=self;
        }
    }
  else  if (buttonTag==2) {
      
      TablePosition=2;
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
      {
       tableVw.frame = CGRectMake(btnSelectCat.frame.origin.x,mediaCoverageView.frame.size.height+btnSelectCat.frame.origin.y+btnSelectCat.frame.size.height+60-scrollVw.contentOffset.y+130+45, btnSelectCat.frame.size.width, 220);
          if ([localNationalButton.titleLabel.text isEqualToString:@"Local"]) {
              UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
              if (orientation == UIInterfaceOrientationLandscapeLeft ||
                  orientation == UIInterfaceOrientationLandscapeRight)
              {
              tableVw.frame = CGRectMake(btnSelectCat.frame.origin.x,mediaCoverageView.frame.size.height+btnSelectCat.frame.origin.y+btnSelectCat.frame.size.height+60-scrollVw.contentOffset.y-170+45, btnSelectCat.frame.size.width, 220);
              }
          }
      }
      else
      {
          tableVw.frame = CGRectMake(btnSelectCat.frame.origin.x,mediaCoverageView.frame.size.height+btnSelectCat.frame.origin.y+btnSelectCat.frame.size.height+10-scrollVw.contentOffset.y+95+40, btnSelectCat.frame.size.width, 220);
          NSLog(@"%f",tableVw.frame.origin.y+tableVw.frame.size.height);
          if ((tableVw.frame.origin.y+tableVw.frame.size.height)>self.view.frame.size.height-52) {
             tableVw.frame = CGRectMake(btnSelectCat.frame.origin.x,mediaCoverageView.frame.size.height+btnSelectCat.frame.origin.y+btnSelectCat.frame.size.height+10-scrollVw.contentOffset.y+95-270+40, btnSelectCat.frame.size.width, 220);
          }
      }
    }
    
    NSLog(@"%@",[NSValue valueWithCGRect:scrollVw.frame]);
    [self.view addSubview:tableSuperView];
//    tableVw.layer.borderColor=[[UIColor redColor]CGColor];
//    tableVw.layer.borderWidth=2;
    
    tableSuperView.hidden = NO;
    
    [tableVw reloadData];
    
}

- (IBAction)resignTableView:(id)sender {
     tableSuperView.hidden = YES;
}
#pragma mark delete and logout action
- (IBAction)help:(id)sender{
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"faqController"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)privacyTerms:(id)sender{
    //Privacy 2
    TandCViewController*obj;
    obj=[self.storyboard instantiateViewControllerWithIdentifier:@"TandC"];
    obj.strComeFrom=@"2";
    [self.navigationController pushViewController:obj animated:YES];

}
- (IBAction)rateUs:(id)sender{
    NSURL * url=[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/upitch-public-relations-journalist/id1028833243?ls=1&mt=8"]];
    [[UIApplication sharedApplication] openURL:url];
}
- (IBAction)logoutAction:(id)sender {
    
    AppDelegate *appd= (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appd LogoutFromApp:self];

}
- (IBAction)btnDeleteAccount:(id)sender
{
    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Are you sure, you want to delete your account ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alert.tag = 100;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    AppDelegate *appd= (AppDelegate *)[UIApplication sharedApplication].delegate;

    if (alertView.tag==100)
    {
        if (buttonIndex==0) {
            NSLog(@"Cancel");
        }
       else if (buttonIndex==1) {
            NSLog(@"OK");
           [self runApi];
        }
    }
    if (alertView.tag == 7005)
    {
        [appd deleteAccount:self];
        [appd deleteAccount:self];

    }
    if (alertView.tag==1234) {
        [appd LogoutFromApp:self];
    }
}
-(void)runApi
{
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
           // delete account
    strWebService=[[NSString alloc]initWithFormat:@"%@deleteaccount",AppURL];
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
                 UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Account deleted successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 alert.tag = 7005;
                 [alert show];
//                 [constant alertViewWithMessage:@"Account deleted successfully."withView:self];
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userid"];
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userTypeString"];
                 [[NSUserDefaults standardUserDefaults]setObject:@"loggedout" forKey:@"LoginStatus"];
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 
//                 AppDelegate *appd= (AppDelegate *)[UIApplication sharedApplication].delegate;
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
         if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortrait) {
             
             NSLog(@"portrait");
             
             if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
             {
                 
                if (TablePosition==1)
                 {
                    tableVw.frame = CGRectMake(localNationalButton.frame.origin.x, localNationalButton.frame.origin.y+localNationalButton.frame.size.height+60-scrollVw.contentOffset.y+130, localNationalButton.frame.size.width,160);
                 }
                 else
                 {
                     tableVw.frame = CGRectMake(btnSelectCat.frame.origin.x,mediaCoverageView.frame.size.height+btnSelectCat.frame.origin.y+btnSelectCat.frame.size.height+60-scrollVw.contentOffset.y+130, btnSelectCat.frame.size.width, 220);

                 }
                 
             }
             

         }
         
         else if (orientation == UIInterfaceOrientationLandscapeLeft ||
                  orientation == UIInterfaceOrientationLandscapeRight)
         {
             NSLog(@"landscape");
             if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
             {
                 if (selectedCategoryIdArray.count==0)
                 {
                     scrollVw.scrollEnabled = YES;
                 }
                 else{
                      scrollVw.scrollEnabled = YES;
                 } 
                 
                 
                 if (TablePosition==1)
                 {
                     tableVw.frame = CGRectMake(localNationalButton.frame.origin.x, localNationalButton.frame.origin.y+localNationalButton.frame.size.height+60-scrollVw.contentOffset.y+130, localNationalButton.frame.size.width,160);
                 }
                 else
                 {
                     tableVw.frame = CGRectMake(btnSelectCat.frame.origin.x,mediaCoverageView.frame.size.height+btnSelectCat.frame.origin.y+btnSelectCat.frame.size.height+60-scrollVw.contentOffset.y+130, btnSelectCat.frame.size.width, 220);
                     if ([localNationalButton.titleLabel.text isEqualToString:@"Local"]) {
                         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
                         if (orientation == UIInterfaceOrientationLandscapeLeft ||
                             orientation == UIInterfaceOrientationLandscapeRight)
                         {
                             tableVw.frame = CGRectMake(btnSelectCat.frame.origin.x,mediaCoverageView.frame.size.height+btnSelectCat.frame.origin.y+btnSelectCat.frame.size.height+60-scrollVw.contentOffset.y-170, btnSelectCat.frame.size.width, 220);
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

- (IBAction)submitAction:(id)sender {
    
    messageTextView.text = [messageTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([emailTextField.text isEqualToString:@""] || emailTextField.text.length<=0 ) {
//        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [constant alertViewWithMessage:@"Please enter email address."withView:self];
    }
    else if (![self validateEmailWithString:emailTextField.text])
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Email format is invalid. It should be in (abc@example.com)format." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
        [constant alertViewWithMessage:@"Email format is invalid. It should be in (abc@example.com)format."withView:self];
    }
    else if ([messageTextView.text isEqualToString:@""] || messageTextView.text.length<=0 ) {
//        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter message." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [constant alertViewWithMessage:@"Please enter message."withView:self];
    }
    else{
        [messageTextView resignFirstResponder];
        [emailTextField resignFirstResponder];
        [self runApiSubmit];
    }
    
}


-(void)runApiSubmit
{
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
   
        strWebService=[[NSString alloc]initWithFormat:@"%@saveservice",AppURL];
  
    NSLog(@"%@",strWebService);
    NSDictionary *dictParams;

        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:
            emailTextField.text,@"email",
            messageTextView.text,@"message",
            @"3",@"record_type",
            [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]],@"user_id",
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

                     UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"Request submitted successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     [alert show];
//                 [constant alertViewWithMessage:@"Request submitted successfully."withView:self];
                    emailTextField.text =@"";
                     messageTextView.text =@"";
                     messageLabel.hidden=NO;
    
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
         }
         else
         {
             
             [appdelegateInstance hideHUD];
             [constant AlertMessageWithString:@"Connectivity levels low. Please try again." andWithView:self.view];

             NSLog(@"Error returned:%@",[error localizedDescription]);
         }
     }];
}


@end
