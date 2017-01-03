//
//  Utils.h
//  COFFEENEW
//
//  Created by CG Technosoft on 06/11/14.
//  Copyright (c) 2014 CG Technosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define FB_API_KEY @"741309555955880"
#define LINKED_ID_API_KEY @"75yh2444m1ktd7"
#define LINKED_ID_SECURE_KEY @"p6NennGmBo36en20"
//#define LINKED_ID_API_KEY @"77nghy1miisceg"
//#define LINKED_ID_SECURE_KEY @"ayY4stVB0Lcw5fiG"

#define LINKEDIN_TOKEN_KEY          @"linkedin_token"
#define LINKEDIN_EXPIRATION_KEY     @"linkedin_expiration"
#define LINKEDIN_CREATION_KEY       @"linkedin_token_created_at"

#define KEY_PROFILE_TAG       @"PROFILE_TAG"


#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)



@interface Utils : NSObject

@end
