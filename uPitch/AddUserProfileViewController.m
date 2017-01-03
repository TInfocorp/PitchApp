//
//  AddUserProfileViewController.m
//  uPitch
//
//  Created by Puneet Rao on 20/05/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import "AddUserProfileViewController.h"
#import "LxReqRespManager.h"
#import "constant.h"
@interface AddUserProfileViewController ()
@end

@implementation AddUserProfileViewController
@synthesize headerString,editString,degreeString,collegeString,fromDateEduString,toDateEduString,professionalString,companyString,fromDateExString,toDateExString,descriptionString,idString,strUserTag;

- (void)viewDidLoad {
    
    NSLog(@"%@",idString);
    appdelegateInstance = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [toolBar removeFromSuperview];
    degreeName.inputAccessoryView = toolBar;
    educationTime.inputAccessoryView = toolBar;
    collegeName.inputAccessoryView = toolBar;
    
    industryName.inputAccessoryView = toolBar;
    fieldName.inputAccessoryView = toolBar;
    experienceTime.inputAccessoryView = toolBar;
    todate.inputAccessoryView = toolBar;
    companyName.inputAccessoryView = toolBar;
    
    experienceView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    experienceView.layer.borderWidth = 1.0f;
    educationView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    educationView.layer.borderWidth = 1.0f;
    NSLog(@"%@ %@",headerString,editString);
    if ([headerString isEqualToString:@"1"]) {
        experienceView.hidden = NO;
        educationView.hidden  = YES;
        if ([editString isEqualToString:@"1"]) {
            headerTitle.text = @"ADD EXPERIENCE";
            deleteButton.hidden = YES;
            switchOnOff.on = NO;
        }
        else{
            switchOnOff.on = NO;
            headerTitle.text = @"EDIT EXPERIENCE";
             deleteButton.hidden = NO;
            NSLog(@"%@",toDateExString);
            industryName.text = professionalString;
            companyName.text = companyString;
            experienceTime.text = fromDateExString;
            todate.text = toDateExString;
            if ([todate.text isEqualToString:@"Present"]) {
                [checkUncheckImageView setImage:[UIImage imageNamed:@"check.png"]];
                toDateButton.userInteractionEnabled = NO;
                switchOnOff.on = YES;
            }
            fieldName.text = descriptionString;
            if (fieldName.text.length>0) {
                descriptionLabel.hidden = YES;
            }
        }
    }
    else{
        experienceView.hidden = YES;
        educationView.hidden  = NO;
        if ([editString isEqualToString:@"1"]) {
            headerTitle.text = @"ADD EDUCATION";
             deleteButton.hidden = YES;
        }
        else{
            headerTitle.text = @"EDIT EDUCATION";
             deleteButton.hidden = NO;
            
            degreeName.text = degreeString;
            educationTime.text = fromDateEduString;
            toDateEdu.text = toDateEduString;
            collegeName.text = collegeString;
        }
    }
    
//    yearArray = [[NSMutableArray alloc]init];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy"];
//    NSString *year = [formatter stringFromDate:[NSDate date]];
//    NSInteger yearto = (long)[year integerValue];
//    NSLog(@"%ld and %ld",(long)[year integerValue],(long)yearto);
//    
//    for ( int j=1960; j<yearto+1; j++) {
//        [yearArray addObject:[NSString stringWithFormat:@"%d",j]];
//    }
    
    monthArray = [[NSMutableArray alloc]initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec", nil];
    //yearArray = [[NSMutableArray alloc]initWithObjects:@"2014",@"2015", nil];
    monthString = @"";
    yearString = @"";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)saveUserData{
    
    [self resignAllKeys];
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
    if ([editString isEqualToString:@"1"]) {
        // experience and eudcation new entry
        strWebService=[[NSString alloc]initWithFormat:@"%@add_linkedin_fields",AppURL];
    }
    else{
        // experience and education edit entry
        strWebService=[[NSString alloc]initWithFormat:@"%@edit_linkedin_fields",AppURL];
    }
    
    NSDictionary *dictParams;
    if ([headerString isEqualToString:@"1"]) {
        // experience
         if ([editString isEqualToString:@"1"]) {
             // add
             dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"userid"]],@"user_id",industryName.text,@"job_title",companyName.text,@"company_name",experienceTime.text,@"from_date",todate.text,@"to_date",fieldName.text,@"description",@"2",@"linkedin_tag",
                         nil];
         }
         else{
             // edit
             dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"userid"]],@"user_id",industryName.text,@"job_title",companyName.text,@"company_name",experienceTime.text,@"from_date",todate.text,@"to_date",fieldName.text,@"description",@"2",@"linkedin_tag",idString,@"id",
                         nil];

         }
    }
    else{
        // education
        if ([editString isEqualToString:@"1"]) {
            // add
            dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"userid"]],@"user_id",collegeName.text,@"school_name",degreeName.text,@"degree",educationTime.text,@"start_year",toDateEdu.text,@"end_year",@"1",@"linkedin_tag",
                        nil];
        }
        else{
            // edit
            dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"userid"]],@"user_id",collegeName.text,@"school_name",degreeName.text,@"degree",educationTime.text,@"start_year",toDateEdu.text,@"end_year",@"1",@"linkedin_tag",idString,@"id",
                        nil];
        }
       
    }
     NSLog(@"%@",dictParams);
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
             [appdelegateInstance hideHUD];
             NSString*str = [NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             if ([str isEqualToString:@"0"])
             {
//                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:@"Profile updated successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//                  alert.tag = 200;
//                 [alert show];
                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 alert.tag = 200;
                 [alert show];
                 
              }
             else if ([str isEqualToString:@"1"])
             {
//                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100 || alertView.tag == 200) {
        [[self delegate] updateTableData];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (alertView.tag==1234) {
        AppDelegate *appd= (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appd LogoutFromApp:self];
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
- (IBAction)setState:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [datepickerView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.frame.size.width, 190)];
    [UIView commitAnimations];
    BOOL state = [sender isOn];
    NSString *rez = state == YES ? @"YES" : @"NO";
    if ([rez isEqualToString:@"YES"])
    {
        toDateButton.userInteractionEnabled = NO;
        todate.text = @"Present";
        todate.textColor = [UIColor blackColor];
    }
    else
    {
        todate.text = @"";
        monthString =@"";
        yearString = @"";
        todate.textColor = [UIColor blackColor];
        toDateButton.userInteractionEnabled = YES;
    }
}
- (IBAction)unchecCheckAction:(id)sender {
    
    if ([checkUncheckImageView.image isEqual:[UIImage imageNamed:@"uncheck.png"]]) {
        [checkUncheckImageView setImage:[UIImage imageNamed:@"check.png"]];
        toDateButton.userInteractionEnabled = NO;
        todate.text = @"Present";
        todate.textColor = [UIColor lightGrayColor];
    }
    else {
        toDateButton.userInteractionEnabled = YES;
        [checkUncheckImageView setImage:[UIImage imageNamed:@"uncheck.png"]];
         todate.text = @"";
        monthString =@"";
        yearString = @"";
        todate.textColor = [UIColor blackColor];
    }
}
- (IBAction)openDatePicker:(UIButton*)sender {
    
    [self resignAllKeys];
   // monthString = @"";
    //yearString = @"";
    fromToDateInt = [sender tag];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [datepickerView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-190, self.view.frame.size.width, 190)];
    [UIView commitAnimations];
    [monthYearPicker selectRow:0 inComponent:0 animated:YES];
    [monthYearPicker selectRow:0 inComponent:1 animated:YES];
    
    if (fromToDateInt==1||fromToDateInt==3) {
        yearArray = [[NSMutableArray alloc]init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
        NSString *year = [formatter stringFromDate:[NSDate date]];
        NSInteger yearto = (long)[year integerValue];
        
        for ( int j=1960; j<yearto+1; j++) {
            [yearArray addObject:[NSString stringWithFormat:@"%d",j]];
        }
        [monthYearPicker reloadAllComponents];
        monthString = [monthArray objectAtIndex:0];
        yearString = [yearArray objectAtIndex:0];
    }else{
        yearArray = [[NSMutableArray alloc]init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
        NSString *year = [formatter stringFromDate:[NSDate date]];
        NSInteger yearto = (long)[year integerValue];
        for ( int j=(int)yearto ; j>=1960; j--) {
            [yearArray addObject:[NSString stringWithFormat:@"%d",j]];
        }
        [monthYearPicker reloadAllComponents];
        
        monthString = [monthArray objectAtIndex:0];
        yearString = [yearArray objectAtIndex:0];
    }
    
   
}

- (IBAction)popView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveDetail:(id)sender {
    if ([headerString isEqualToString:@"1"]) {
        // for experience
        industryName.text = [industryName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        companyName.text = [companyName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        experienceTime.text = [experienceTime.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        fieldName.text = [fieldName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
         todate.text = [todate.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([industryName.text isEqualToString:@""] || industryName.text.length<=0 ) {
//            UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter Job title" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
            [constant alertViewWithMessage:@"Please enter Job title."withView:self];
        }
        else if ([companyName.text isEqualToString:@""] || companyName.text.length<=0 ) {
//            UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter company name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
            [constant alertViewWithMessage:@"Please enter company name."withView:self];
        }
        else if ([experienceTime.text isEqualToString:@""] || experienceTime.text.length<=0  ) {
//            UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter start date." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
            [constant alertViewWithMessage:@"Please enter start date."withView:self];
        }
        else if ([todate.text isEqualToString:@""] || todate.text.length<=0  ) {
//            UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter end date." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
            [constant alertViewWithMessage:@"Please enter end date."withView:self];
        }
        else if ([fieldName.text isEqualToString:@""] || fieldName.text.length<=0 ) {
//            UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter Job Description" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
            [constant alertViewWithMessage:@"Please enter Job Description."withView:self];
        }
        else{
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"LLL yyyy"];
            fromDateToCompare = [dateFormatter dateFromString:experienceTime.text];
            toDateToCompare = [dateFormatter dateFromString:todate.text];
            if ([fromDateToCompare compare:toDateToCompare] == NSOrderedDescending)
            {
                NSLog(@"NSOrderedDescending %@ %@",fromDateToCompare,toDateToCompare);
                // latter one bigger so run the API
                
//                UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please select correct date." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                [alert show];
                [constant alertViewWithMessage:@"Please select correct date."withView:self];
            }
            else if ([fromDateToCompare compare:toDateToCompare] == NSOrderedAscending)
            {
                NSLog(@"NSOrderedAscending %@ %@",fromDateToCompare,toDateToCompare);
                // former one is bigger so show alert message to choose correct
               [self saveUserData];
            }
            else if ([fromDateToCompare compare:toDateToCompare] == NSOrderedSame)
            {
                NSLog(@"NSOrderedSame %@ %@",fromDateToCompare,toDateToCompare);
                [self saveUserData];
            }
        }
    }
    else{
        // for education
        degreeName.text = [degreeName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        educationTime.text = [educationTime.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        collegeName.text = [collegeName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([degreeName.text isEqualToString:@""] || degreeName.text.length<=0 ) {
//            UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter degree name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
            [constant alertViewWithMessage:@"Please enter degree name."withView:self];
        }
        else if ([educationTime.text isEqualToString:@""] || educationTime.text.length<=0 ) {
//            UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter start date." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
            [constant alertViewWithMessage:@"Please enter start date."withView:self];
        }
        else if ([toDateEdu.text isEqualToString:@""] || toDateEdu.text.length<=0 ) {
//            UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter end date." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
            [constant alertViewWithMessage:@"Please enter end date."withView:self];
        }

        else if ([collegeName.text isEqualToString:@""] || collegeName.text.length<=0  ) {
//            UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter College/University Name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
            [constant alertViewWithMessage:@"Please enter College/University Name."withView:self];
        }
        else{
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"LLL yyyy"];
            fromDateToCompare = [dateFormatter dateFromString:educationTime.text];
            toDateToCompare = [dateFormatter dateFromString:toDateEdu.text];
            if ([fromDateToCompare compare:toDateToCompare] == NSOrderedDescending)
            {
                NSLog(@"NSOrderedDescending %@ %@",fromDateToCompare,toDateToCompare);
                // latter one bigger so run the API
//                UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please select correct date." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                [alert show];
                [constant alertViewWithMessage:@"Please select correct date."withView:self];
            }
            else if ([fromDateToCompare compare:toDateToCompare] == NSOrderedAscending)
            {
                NSLog(@"NSOrderedAscending %@ %@",fromDateToCompare,toDateToCompare);
                // former one is bigger so show alert message to choose correct
               
                [self saveUserData];
            }
            else if ([fromDateToCompare compare:toDateToCompare] == NSOrderedSame)
            {
                NSLog(@"NSOrderedSame %@ %@",fromDateToCompare,toDateToCompare);
            }
            
        }
    }
}
-(void)resignAllKeys{
    
    [degreeName resignFirstResponder];
    [collegeName resignFirstResponder];
    [educationTime resignFirstResponder];
    [toDateEdu resignFirstResponder];
    
    [industryName resignFirstResponder];
    [fieldName resignFirstResponder];
    [companyName resignFirstResponder];
    [experienceTime resignFirstResponder];
    [todate resignFirstResponder];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        scrollView.contentSize = CGSizeMake(768, self.view.frame.size.height-80);
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    else{
     scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-60);
    }
    
}
- (IBAction)deleteButtonPressed:(id)sender {
    // delete
     [self resignAllKeys];
    [self cancelToolbar:nil];
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService=[[NSString alloc]initWithFormat:@"%@delete_linkedin_fields",AppURL];
    NSDictionary *dictParams;
    if ([headerString isEqualToString:@"1"]) {
        // experience
        
        
        dictParams=[[NSDictionary alloc]initWithObjectsAndKeys
                    :[NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"userid"]],@"user_id"
                    ,idString,@"id",
                    @"2",@"linkedin_tag",
                    strUserTag,@"user_tag",
                    nil];
        }
    else{
        // education
         dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"userid"]],@"user_id",idString,@"id",@"1",@"linkedin_tag",nil];
    }
    // NSLog(@"%@",dictParams);
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
             [appdelegateInstance hideHUD];
             NSString*str = [NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             if ([str isEqualToString:@"0"])
             {
                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 alert.tag = 100;
                 [alert show];
             }
             else if ([str isEqualToString:@"1"])
             {
//                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
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
-(void)compareDate{
    
    switch ([fromDateToCompare compare:toDateToCompare]){
        case NSOrderedAscending:
            NSLog(@"NSOrderedAscending");
            break;
        case NSOrderedSame:
            NSLog(@"NSOrderedSame");
            break;
        case NSOrderedDescending:
            NSLog(@"NSOrderedDescending");
            break;
    }
}
#pragma mark tool bar method
- (IBAction)cancelToolbar:(id)sender {
    [self resignAllKeys];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [datepickerView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.frame.size.width, 190)];
    [UIView commitAnimations];
//    experienceTime.text = @"";
//    todate.text = @"";
//    educationTime.text = @"";
//    toDateEdu.text = @"";
}

- (IBAction)doneToolBar:(id)sender {
    
    [self resignAllKeys];
   
    if ([monthString isEqualToString:@""] || [yearString isEqualToString:@""] ) {
        if ([todate.text isEqualToString:@"Present"]) {
            
        }
        else{
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please select date and year" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//        [alert show];
        }
    }
    else{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [datepickerView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.frame.size.width, 190)];
        [UIView commitAnimations];
        if (fromToDateInt == 1) {
            // experience start year
            experienceTime.text=[NSString stringWithFormat:@"%@ %@",monthString,yearString];
        }
        else if (fromToDateInt == 2){
            if ([experienceTime.text isEqualToString:@""]) {
//                UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please enter from date" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//                [alert show];
                [constant alertViewWithMessage:@"Please enter from date."withView:self];
            }
            else{
                // experience end year
            todate.text=[NSString stringWithFormat:@"%@ %@",monthString,yearString];
            }
        }
        else  if (fromToDateInt == 3){
            // education start year
            educationTime.text=[NSString stringWithFormat:@"%@ %@",monthString,yearString];
        }
        else  if (fromToDateInt == 4){
            if ([educationTime.text isEqualToString:@""]) {
//                UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please enter from date" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//                [alert show];
                [constant alertViewWithMessage:@"Please enter from date."withView:self];
            }
            else{
                // education end year
            toDateEdu.text=[NSString stringWithFormat:@"%@ %@",monthString,yearString];
            }
        }
    }
}
#pragma mark TextView delegate
- (void)textViewDidEndEditing:(UITextView *)theTextView
{
    if (![fieldName hasText])
    {
        descriptionLabel.hidden = NO;
    }
    else{
        descriptionLabel.hidden = YES;
    }
}
- (void) textViewDidChange:(UITextView *)textView
{
    if (![fieldName hasText])
    {
        descriptionLabel.hidden = NO;
    }
    else{
        descriptionLabel.hidden = YES;
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [datepickerView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.frame.size.width, 190)];
    [UIView commitAnimations];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationLandscapeLeft ||
            orientation == UIInterfaceOrientationLandscapeRight)
        {
            scrollView.contentSize = CGSizeMake(768, self.view.frame.size.height+200);
            scrollView.contentOffset = CGPointMake(0, 200);
        }
    }
    else{
       
        //scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+100);
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 675);
        // 260
        int y = self.view.frame.size.height-480;
       // scrollView.contentOffset = CGPointMake(0, textView.tag*30);
        scrollView.contentOffset = CGPointMake(0, 230-y);
    }
    
    return YES;
}
#pragma mark TextField Delegate


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range      replacementString:(NSString *)string {
   
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if (textField == industryName || textField == companyName)
    {
        if (newLength<=100) {
            return YES;
        }else{
            return NO;
        }
    }
    
    // Only characters in the NSCharacterSet you choose will insertable.
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [datepickerView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.frame.size.width, 190)];
    [UIView commitAnimations];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
    }
    else{
        NSLog(@"%@",headerTitle.text);
        if ([headerTitle.text isEqualToString:@"ADD EDUCATION"]|| [headerTitle.text isEqualToString:@"EDIT EDUCATION"]) {
            
            int y = self.view.frame.size.height-480;
            NSLog(@"%d",y);
            if (y>0) {
                // iphone 5 and iphone 6
            }
            else{
               // iphone 4
                scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+20);
                 scrollView.contentOffset = CGPointMake(0, 60);
            }
            //scrollView.contentOffset = CGPointMake(0, textField.tag*40);
           
        }
    }
       return YES;
}
#pragma mark Picker Method
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
// Method to define the numberOfRows in a component using the array.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return self.view.frame.size.width/2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component
{
    // NSLog(@"%@ %@ %@ %@",DayArray,hoursArray,minsArray,secsArray);
    if (component==0)
    {
        return [monthArray count];
    }
    else if (component==1)
    {
        return [yearArray count];
    }
    return 0;
}
// Method to show the title of row for a component.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    switch (component)
    {
        case 0:
            return [monthArray objectAtIndex:row];
            break;
        case 1:
            return [yearArray objectAtIndex:row];
            break;
    }
    return nil;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
            monthString=[NSString stringWithFormat:@"%@",[monthArray objectAtIndex:row] ];
            if (fromToDateInt == 1) {
                 experienceTime.text=[NSString stringWithFormat:@"%@ %@",monthString,yearString];
            }
            else  if (fromToDateInt == 2){
                 todate.text=[NSString stringWithFormat:@"%@ %@",monthString,yearString];
            }
            else  if (fromToDateInt == 3){
                educationTime.text=[NSString stringWithFormat:@"%@ %@",monthString,yearString];
            }
            else  if (fromToDateInt == 4){
                toDateEdu.text=[NSString stringWithFormat:@"%@ %@",monthString,yearString];
            }
            break;
        case 1:
            yearString=[NSString stringWithFormat:@"%@",[yearArray objectAtIndex:row] ];
            if (fromToDateInt == 1) {
                experienceTime.text=[NSString stringWithFormat:@"%@ %@",monthString,yearString];
            }
            else  if (fromToDateInt == 2){
                todate.text=[NSString stringWithFormat:@"%@ %@",monthString,yearString];
            }
            else  if (fromToDateInt == 3){
                educationTime.text=[NSString stringWithFormat:@"%@ %@",monthString,yearString];
            }
            else  if (fromToDateInt == 4){
                toDateEdu.text=[NSString stringWithFormat:@"%@ %@",monthString,yearString];
            }
            break;
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
        }
         else if (orientation == UIInterfaceOrientationLandscapeLeft ||
                  orientation == UIInterfaceOrientationLandscapeRight)
         {
             NSLog(@"landscape");
          }
         
         // do whatever
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}
@end
