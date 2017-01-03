//
//  RegisterPage2.m
//  uPitch
//
//  Created by Puneet Rao on 19/05/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import "RegisterPage2.h"
#import "LxReqRespManager.h"
#import "SWRevealViewController.h"
#import "SideMenuViewController.h"
#import "PitchFeedJournalist_ViewController.h"
#import "constant.h"
@interface RegisterPage2 ()

@end

@implementation RegisterPage2
@synthesize userTypeString,emailString;
- (void)viewDidLoad {
    
     appdelegateInstance = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [toolBar removeFromSuperview];
    firstName.inputAccessoryView = toolBar;
    lastName.inputAccessoryView = toolBar;
    designation.inputAccessoryView = toolBar;
    companyName.inputAccessoryView = toolBar;
    
    userImageView.layer.cornerRadius = userImageView.frame.size.width/2;
    userImageView.layer.masksToBounds = YES;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-60);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        scrollView.contentSize = CGSizeMake(768, 750);
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark TextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
   
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+200);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        scrollView.contentSize = CGSizeMake(768, 750);
    }
    scrollView.contentOffset = CGPointMake(0, textField.tag*40+45);
     NSLog(@"%f",scrollView.contentOffset.y);
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark toolBar delegate


- (IBAction)doneToolBar:(id)sender {
    [self resignKeyBoard];
}

- (IBAction)cancelToolBar:(id)sender {
    [self resignKeyBoard];
}
#pragma mark others delegate
- (IBAction)saveButtonPressed:(id)sender {
    firstName.text = [firstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     lastName.text = [lastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     designation.text = [designation.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     companyName.text = [companyName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([firstName.text isEqualToString:@""] || firstName.text.length<=0 ) {
//        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter first name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [constant alertViewWithMessage:@"Please enter first name."withView:self];
    }
    else if ([lastName.text isEqualToString:@""] || lastName.text.length<=0 ) {
//        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter last name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];

        [constant alertViewWithMessage:@"Please enter last name." withView:self];
    }
    else if ([designation.text isEqualToString:@""] || designation.text.length<=0  ) {
//        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter designation." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [constant alertViewWithMessage:@"Please enter designation."withView:self];
    }
    else if ([companyName.text isEqualToString:@""] || companyName.text.length<=0 ) {
//        UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Please enter company name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [constant alertViewWithMessage:@"Please enter company name."withView:self];
    }
    else{
        [self resignKeyBoard];
        [self signUpAPI];
    }
}
-(void)signUpAPI
{
    [appdelegateInstance showHUD:@""];
   
    NSString*strWebService=[[NSString alloc]initWithFormat:@"%@registration_second",AppURL];
    NSLog(@"%@",strWebService);
    NSDictionary *dictParams;
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"] length]<10) {
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"deviceToken"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@ %@",firstName.text,lastName.text],@"name",designation.text,@"designation",companyName.text,@"company",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"]],@"device_id",emailString,@"email",nil];
    NSLog(@"%@",dictParams);
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request =
    [serializer multipartFormRequestWithMethod:@"POST" URLString:strWebService
                                    parameters:dictParams
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         UIImage *image = userImageView.image;
         NSData *data = UIImageJPEGRepresentation(image, .3);
         NSLog(@"image size %lu",(unsigned long)data.length);
         NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
         
         NSLog(@"time stamp is %@",timestamp);
         [formData appendPartWithFileData:data
                                     name:@"file1"
                                 fileName:[NSString stringWithFormat:@"%@_userPhoto.jpg",timestamp]
                                 mimeType:@"image/jpeg"];
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
         if ([str isEqualToString:@"0"]) {
             if ([str isEqualToString:@"0"])
             {
                 [[NSUserDefaults standardUserDefaults]setObject:[responseObject valueForKey:@"user_id"] forKey:@"userid"];
                 [[NSUserDefaults standardUserDefaults]setObject:@"loggedin" forKey:@"LoginStatus"];
                 [[NSUserDefaults standardUserDefaults]setObject:@"signup2" forKey:@"createAccount"];
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 
                 if ([userTypeString isEqualToString:@"2"])
                 {
                     // journalist
                     [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"userTypeString"];
                     [[NSUserDefaults standardUserDefaults]synchronize];
                     PitchFeedJournalist_ViewController*ctl;
                     ctl=[self.storyboard instantiateViewControllerWithIdentifier:@"pitchFeedtest"];
                     
                     UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:ctl];
                     [navController setViewControllers: @[ctl] animated: YES];
                     SideMenuViewController *rearViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuList"];
                     SWRevealViewController *mainRevealController =[self.storyboard instantiateViewControllerWithIdentifier:@"RevealController"];
                     mainRevealController=[mainRevealController initWithRearViewController:rearViewController frontViewController:navController];
                     [self.navigationController pushViewController:mainRevealController animated:YES];
                 }
                 else{
                     // client
                     SWRevealViewController*revealcontroller;
                     revealcontroller=[self.storyboard instantiateViewControllerWithIdentifier:@"RevealController"];
                     [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"userTypeString"];
                     [[NSUserDefaults standardUserDefaults]synchronize];
                     [self.navigationController pushViewController:revealcontroller animated:YES];
                 }
             }
        }
         if ([str isEqualToString:@"1"]) {
//             UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//             [alert show];
             [constant alertViewWithMessage:[responseObject valueForKey:@"message"]withView:self];

         }
     } failure:^(AFHTTPRequestOperation *task, NSError *error) {
         NSLog(@"Error :%@",error);
         NSLog(@"%@",operation.responseString);
         [appdelegateInstance hideHUD];
     }];
    [operation start];
}
-(void)resignKeyBoard{
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-60);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        scrollView.contentSize = CGSizeMake(768, 750);
    }
    [firstName resignFirstResponder];
    [lastName resignFirstResponder];
    [designation resignFirstResponder];
    [companyName resignFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)userImageTapped:(id)sender {
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"Upload Image" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Upload by Photo Library",@"Upload by Camera",@"Cancel",  nil];
        actionSheetOpenBool = YES;
    [actionSheet showInView:self.view];
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
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Camera not found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
            [constant alertViewWithMessage:@"Camera not found."withView:self];
        }
    }
}
#pragma mark UiImagePicker Method
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image ;
    image = [info objectForKey:UIImagePickerControllerEditedImage];
    userImageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)popView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
