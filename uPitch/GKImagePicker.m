//
//  GKImagePicker.m
//  GKImagePicker
//
//  Created by Genki Kondo on 9/18/12.
//  Copyright (c) 2012 Genki Kondo. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "GKImagePicker.h"
#import "constant.h"
@interface GKImagePicker () <GKImageCropperDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
- (void)presentImageCropperWithImage:(UIImage *)image;
@end

@implementation GKImagePicker 

@synthesize delegate = _delegate;
@synthesize cropper = _cropper;

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.cropper = [[GKImageCropper alloc] init];
        self.cropper.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - View control

- (void)presentPicker {
    // **********************************************
    // * Show action sheet that will allow image selection from camera or gallery
    // **********************************************
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:(id)self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Image from Camera", @"Image from Gallery",@"Remove Image", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.alpha=0.90;
    actionSheet.tag = 1;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
 
    
    
    //[actionSheet showInView:self.view];
}

- (void)presentImageCropperWithImage:(UIImage *)image {    
    // **********************************************
    // * Show GKImageCropper
    // **********************************************
    self.cropper.image = image;
    [(UIViewController*)self.delegate presentViewController:[[UINavigationController alloc] initWithRootViewController:self.cropper] animated:YES completion:nil];
  //  [(UIViewController *)self.delegate presentModalViewController:[[UINavigationController alloc] initWithRootViewController:self.cropper] animated:YES];
}

#pragma mark - Image picker methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%ld",(long)buttonIndex);
    switch (actionSheet.tag) {
        case 1:
            switch (buttonIndex) {
                case 0:
                    [self showCameraImagePicker];
                    break;
                case 1:
                    [self showGalleryImagePicker];
                    break;
                case 2:
                    [self popView];
                    break;
                case 3:
                    [self cancel];
                    break;

            }
            break;
        default:
            break;
    }
}
-(void)cancel{
    [[NSUserDefaults standardUserDefaults]setObject:@"4" forKey:@"removeImage"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.delegate imagePickerDidFinish:self withImage:nil];
}
-(void)popView{
    [[NSUserDefaults standardUserDefaults]setObject:@"3" forKey:@"removeImage"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.delegate imagePickerDidFinish:self withImage:nil];
}
- (void)showCameraImagePicker {
#if TARGET_IPHONE_SIMULATOR
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Camera not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
    [constant alertViewWithMessage:@"Camera not available."withView:self];
#elif TARGET_OS_IPHONE
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    picker.delegate = self;
//    picker.allowsEditing = NO;
//    [(UIViewController *)self.delegate presentModalViewController:picker animated:YES];
    
    
    UIImagePickerController *picker1 = [[UIImagePickerController alloc] init];
    picker1.delegate = self;
    picker1.allowsEditing = NO;
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
               // [self presentViewController:picker1 animated:YES completion:nil];
                 // [(UIViewController *)self.delegate presentModalViewController:picker1 animated:YES];
                [(UIViewController *)self.delegate presentViewController:picker1 animated:YES completion:nil];
            }];
        }
        else
        {
            [self presentViewController:picker1 animated:YES completion:nil];
        }
    }
    else {
        picker1.sourceType = UIImagePickerControllerSourceTypeCamera;
      //  [self presentViewController:picker1 animated:YES completion:nil];
     //   [(UIViewController *)self.delegate presentModalViewController:picker1 animated:YES];
         [(UIViewController *)self.delegate presentViewController:picker1 animated:YES completion:nil];
    }

    
#endif
}

- (void)showGalleryImagePicker {
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    picker.delegate = self;
//    picker.allowsEditing = NO;
//    [(UIViewController*)self.delegate presentViewController:picker animated:YES completion:nil];
//    
    
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
                //[self presentViewController:picker1 animated:YES completion:nil];
                [(UIViewController*)self.delegate presentViewController:picker1 animated:YES completion:nil];
            }];
        }
        else
        {
           // [self presentViewController:picker1 animated:YES completion:nil];
             [(UIViewController*)self.delegate presentViewController:picker1 animated:YES completion:nil];
        }
    }
    else {
        picker1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
       // [self presentViewController:picker1 animated:YES completion:nil];
         [(UIViewController*)self.delegate presentViewController:picker1 animated:YES completion:nil];
    }

    
    
    
   // [(UIViewController *)self.delegate presentModalViewController:picker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    [picker dismissModalViewControllerAnimated:NO];
    [self presentImageCropperWithImage:image];
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
    //[picker dismissModalViewControllerAnimated:NO];
    [picker dismissViewControllerAnimated:NO completion:nil];
    // Extract image from the picker
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self presentImageCropperWithImage:image];
    }
}

#pragma mark - GKImageCropper delegate methods

- (void)imageCropperDidFinish:(GKImageCropper *)imageCropper withImage:(UIImage *)image {
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"removeImage"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.delegate imagePickerDidFinish:self withImage:image];
}

@end
