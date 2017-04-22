//
//  LxReqRespManager.m

//
//  Created by Laxmikant Thanvi on 06/08/14.
//  Copyright (c) 2014 CG Technosoft. All rights reserved.
//

#import "LxReqRespManager.h"
//#import "MBProgressHUD.h"

@interface LxReqRespManager ()
{
    
}
@property (nonatomic,strong) id callBackReceiver;
@property (nonatomic,assign) SEL receiverMethod;
@property (nonatomic,strong) NSURL *urlOfImage;
@property (nonatomic,strong) NSIndexPath *imgIndexPath;
@property (nonatomic,strong) id imgContainer;
@end

@implementation LxReqRespManager

@synthesize delegate;
@synthesize urlOfImage;
@synthesize imgIndexPath;

#pragma mark - Block Local Instances

void(^onCallBackForUrlEncodedRequest)(id response,NSError *error);

void(^onCallBackForUrlPostRequest)(id response,NSError *error);

void(^onCallBackForUrlPostImageRequest)(id response,NSError *error);

#pragma mark - LxInstance Intilizer
-(id)initLxReqRespManagerWithDelegate:(id)callBackReceiver

{   self=[super init];
    if (self)
    {
        self.delegate=callBackReceiver;
    }
    return self;
}

-(id)initLxReqRespManagerOnViewController:(id)callBackReceiver
{
    self=[super init];
    if (self)
    {
        self.delegate=callBackReceiver;
    }
    return self;
}

-(id)initLxReqRespManagerWithImageURL:(NSString*)imgUrl WithCallBackReceiver:(id)callBackReceiver OnIndexPath:(NSIndexPath*)indexPath
{
    self=[super init];
    if (self)
    {
        self.delegate=callBackReceiver;
        self.urlOfImage=[NSURL URLWithString:imgUrl];
        self.imgIndexPath=indexPath;
    }
    return self;
}

-(id)initLxReqRespManagerWithImageURL:(NSString*)imgUrl WithContainer:(id)imgContainer
{
    self=[super init];
    if (self)
    {
        self.urlOfImage=[NSURL URLWithString:imgUrl];
        
    }
    return self;
}

#pragma mark - Protocal Based Delegation

-(void)requestAPIWithParamtersEncodedInURL:(NSString*)apiURL
{
    if ([self isInternetReachable])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Network Error" message:@"" delegate:nil cancelButtonTitle:@"Internet not working" otherButtonTitles:nil,@"OK",nil];
        [alert show];
        alert=nil;
    }
    else
    {
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        if (!self.activtyText)
        {
            self.activtyText=@"";
        }
        
        [self showRequestLoadingIndicaterWithTitle:self.activtyText];
        
        [manager GET:apiURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSError *error;
             
             NSLog(@"responseData:%@",responseObject);
             
             id responseData=[NSJSONSerialization
                              JSONObjectWithData:responseObject
                              options:kNilOptions
                              error:&error];
             
             [self.delegate didReceivedAPIResponse:responseData error:nil requestTag:self.requestTag];
             [self dismissRequestLoadingIndicater];
         }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [self.delegate didReceivedAPIResponse:nil error:error requestTag:self.requestTag];
             [self dismissRequestLoadingIndicater];
             
         }];
    }
}

-(void)requestAPIWithURL:(NSString*)apiURL withParameters:(NSDictionary*)paramters
{
         if ([self isInternetReachable])
         {
             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Network Error" message:@"" delegate:nil cancelButtonTitle:@"Internet not working" otherButtonTitles:nil,@"OK",nil];
             [alert show];
             alert=nil;
         }
         else
         {
             AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
             
             manager.responseSerializer = [AFHTTPResponseSerializer serializer];
             
             if (!self.activtyText)
             {
                 self.activtyText=@"";
             }
             
             [self showRequestLoadingIndicaterWithTitle:self.activtyText];
             
             NSLog(@"url:%@ and paramter:%@",apiURL,paramters);
             
             [manager POST:apiURL parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject)
              {
                  NSError *error;
                  id responseData=[NSJSONSerialization
                                   JSONObjectWithData:responseObject
                                   options:kNilOptions
                                   error:&error];
                  [self.delegate didReceivedAPIResponse:responseData error:nil requestTag:self.requestTag];
                  [self dismissRequestLoadingIndicater];
              }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error)
              {
                  [self.delegate didReceivedAPIResponse:nil error:error requestTag:self.requestTag];
                  [self dismissRequestLoadingIndicater];
                  
              }];
         }
}

-(void)requestAPIWithURL:(NSString*)apiURL withParameters:(NSDictionary*)paramters imageData:(NSData*)imgData imageKey:(NSString*)imgKey imageMimeType:(NSString*)imgMIMEType imageFileName:(NSString*)imgFileName
{
    if ([self isInternetReachable])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Network Error" message:@"" delegate:nil cancelButtonTitle:@"Internet not working" otherButtonTitles:nil,@"OK",nil];
        [alert show];
        alert=nil;
    }
    else
    {
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        if (!self.activtyText)
        {
            self.activtyText=@"";
        }
        
        [self showRequestLoadingIndicaterWithTitle:self.activtyText];
        
        [manager POST:apiURL parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
         {
             [formData appendPartWithFileData:imgData name:imgKey fileName:imgFileName mimeType:imgMIMEType];
             
             
         } success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSError *error;
             id responseData=[NSJSONSerialization
                              JSONObjectWithData:responseObject
                              options:kNilOptions
                              error:&error];
             [self.delegate didReceivedAPIResponse:responseData error:nil requestTag:self.requestTag];
             [self dismissRequestLoadingIndicater];
             
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [self.delegate didReceivedAPIResponse:nil error:error requestTag:self.requestTag];
             [self dismissRequestLoadingIndicater];
             
         }];
    }
}

-(void)requestAPIWithURL:(NSString*)apiURL withParameters:(NSDictionary*)paramters withImageDictionary:(NSDictionary*)dictImages
{
    
}

#pragma mark - Block Based Delegation

-(void)requestAPIWithParamtersEncodedInURL:(NSString*)apiURL withCallBackHandler:(LxCompletionBlock)callBack
{
    if ([self isInternetReachable])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Network Error" message:@"" delegate:nil cancelButtonTitle:@"Internet not working" otherButtonTitles:nil,@"OK",nil];
        [alert show];
        alert=nil;
    }
    else
    {
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        if (!self.activtyText)
        {
            self.activtyText=@"";
        }
        
        [self showRequestLoadingIndicaterWithTitle:self.activtyText];
        
        [manager GET:apiURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSError *error;
             id responseData=[NSJSONSerialization
                              JSONObjectWithData:responseObject
                              options:kNilOptions
                              error:&error];
             
             onCallBackForUrlEncodedRequest=callBack;
             
             [self onReceiveUrlEncodedRequestCallbackWithResponse:responseData error:nil];
             
             [self dismissRequestLoadingIndicater];
             
         }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             onCallBackForUrlEncodedRequest=callBack;
             [self onReceiveUrlEncodedRequestCallbackWithResponse:nil error:error];
             
             [self dismissRequestLoadingIndicater];
             
             
         }];
    }
}

-(void)requestAPIWithURL:(NSString*)apiURL withParameters:(NSDictionary*)paramters withCallBackHandler:(LxCompletionBlock)callBack
{
    if ([self isInternetReachable])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Network Error" message:@"" delegate:nil cancelButtonTitle:@"Internet not working" otherButtonTitles:nil,@"OK",nil];
        [alert show];
        alert=nil;
    }
    else
    {
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 60;
        if (!self.activtyText)
        {
            self.activtyText=@"";
        }
        
        [self showRequestLoadingIndicaterWithTitle:self.activtyText];
        
        [manager POST:apiURL parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSError *error;
             id responseData=[NSJSONSerialization
                              JSONObjectWithData:responseObject
                              options:kNilOptions
                              error:&error];
             onCallBackForUrlPostRequest=callBack;
             [self onReceiveUrlPostRequestCallbackWithResponse:responseData error:nil];
             [self dismissRequestLoadingIndicater];
         }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             onCallBackForUrlPostRequest=callBack;
             [self onReceiveUrlPostRequestCallbackWithResponse:nil error:error];
             [self dismissRequestLoadingIndicater];
             
         }];
    }
}

-(void)requestAPIWithURL:(NSString*)apiURL withParameters:(NSDictionary*)paramters imageData:(NSData*)imgData imageKey:(NSString*)imgKey imageMIMEType:(NSString*)imgMIMEType imageFileName:(NSString*)imgFileName withCallBackHandler:(LxCompletionBlock)callBack
{
    
}

#pragma mark - Supporting Block Handlers

-(void)onReceiveUrlEncodedRequestCallbackWithResponse:(id)response error:(NSError*)error
{
    onCallBackForUrlEncodedRequest(response,error);
}

-(void)onReceiveUrlPostRequestCallbackWithResponse:(id)response error:(NSError*)error
{
    onCallBackForUrlPostRequest(response,error);
}

-(void)onReceiveUrlPostImageRequestCallbackWithResponse:(id)response error:(NSError*)error
{
    onCallBackForUrlPostImageRequest(response,error);
}

#pragma mark - NetworkCheck And Activity
// check is network available
-(BOOL)isInternetReachable
{
   return [AFNetworkReachabilityManager sharedManager].reachable;
}

// show request progress
-(void)showRequestLoadingIndicaterWithTitle:(NSString*)strProgressStatus
{
   // UIViewController *vc=(UIViewController*)delegate;
//    [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
//    if (strProgressStatus)
//    {
//        hud.labelText = strProgressStatus;
//    }
//    [hud show:YES];
}

-(void)startLoadingOnImageQueue:(dispatch_queue_t)imgQueue
{
   // dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
    
    dispatch_async(imgQueue, ^{
        NSData *imgData=[NSData dataWithContentsOfURL:self.urlOfImage];
        UIImage *imgReceived=[UIImage imageWithData:imgData];
        
        if (!imgReceived)
        {
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
           // callback to did sucess image
            __weak NSIndexPath *indexPath=self.imgIndexPath;
            if (!imgReceived)
            {
                // callback to did fail image method
                [self.delegate didFailedImageLoadingAtIndex:indexPath];
            }
            else
            {
                [self.delegate didReceivedImage:imgReceived atIndex:indexPath];
            }
        });
    });
}

// hide request progress
-(void)dismissRequestLoadingIndicater
{
    //UIViewController *vc=(UIViewController*)delegate;
   // [MBProgressHUD hideHUDForView:vc.view animated:YES];
}

@end
