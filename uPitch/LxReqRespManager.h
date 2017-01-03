//
//  LxReqRespManager.h

//
//  Created by Laxmikant Thanvi on 06/08/14.
//  Copyright (c) 2014 CG Technosoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


//typedef NS_ENUM(NSInteger,REQUESTMETHOD) {
//    REQUESTMETHODGET,
//    REQUESTMETHODGPOST,
//};

//typedef NS_ENUM(NSInteger,RESPONSESTATUS) {
//    RESPONSESTATUSSUCCESS,
//    RESPONSESTATUSFAIL
//};

@protocol LxReqRespManager;

typedef void (^LxCompletionBlock)(id response,NSError *error);

@interface LxReqRespManager : NSObject
{
    __weak id <LxReqRespManager> delegate;
    
}
@property (nonatomic,weak) id <LxReqRespManager> delegate;
@property (nonatomic,assign) NSInteger requestTag;
@property (nonatomic,assign) NSString *activtyText;
@property (nonatomic,assign) NSError *responseFailError;

// initilizer method
-(id)initLxReqRespManagerWithDelegate:(id)callBackReceiver;
//Use this init method with block based operations
-(id)initLxReqRespManagerOnViewController:(id)callBackReceiver;

//Use this init method Image loading
-(id)initLxReqRespManagerWithImageURL:(NSString*)imgUrl WithCallBackReceiver:(id)callBackReceiver OnIndexPath:(NSIndexPath*)indexPath;

-(id)initLxReqRespManagerWithImageURL:(NSString*)imgUrl WithContainer:(id)imgContainer;

-(void)startLoadingOnImageQueue:(dispatch_queue_t)imgQueue;



// ***** Method supporting delegatation callbacks *****

// For GET Request Method
-(void)requestAPIWithParamtersEncodedInURL:(NSString*)apiURL;

// For POST Request Method
-(void)requestAPIWithURL:(NSString*)apiURL withParameters:(NSDictionary*)paramters;

// For POST Request Method With Single Image
-(void)requestAPIWithURL:(NSString*)apiURL withParameters:(NSDictionary*)paramters imageData:(NSData*)imgData imageKey:(NSString*)imgKey imageMimeType:(NSString*)imgMIMEType imageFileName:(NSString*)imgFileName;

// For POST Request Method With Multiple Images
//-(void)requestAPIWithURL:(NSString*)apiURL withParameters:(NSDictionary*)paramters withImageDictionary:(NSDictionary*)dictImages;

// For POST Request Method With Image
//-(void)requestAPIWithURL:(NSString*)apiURL withParameters:(NSDictionary*)paramters;



// ***** Method supporting block based callbacks *****

// For GET Request Method
-(void)requestAPIWithParamtersEncodedInURL:(NSString*)apiURL withCallBackHandler:(LxCompletionBlock)callBack;

// For POST Request Method
-(void)requestAPIWithURL:(NSString*)apiURL withParameters:(NSDictionary*)paramters withCallBackHandler:(LxCompletionBlock)callBack;

// For POST Request Method With Single Image
-(void)requestAPIWithURL:(NSString*)apiURL withParameters:(NSDictionary*)paramters imageData:(NSData*)imgData imageKey:(NSString*)imgKey imageMIMEType:(NSString*)imgMIMEType imageFileName:(NSString*)imgFileName withCallBackHandler:(LxCompletionBlock)callBack;

@end

@protocol LxReqRespManager <NSObject>
@optional
-(void)didReceivedAPIResponse:(id)response error:(NSError*)error    requestTag:(NSInteger)requestTag;
-(void)didReceivedImage:(UIImage*)image atIndex:(NSIndexPath*)indexPath;
-(void)didFailedImageLoadingAtIndex:(NSIndexPath*)indexPath;
@end
