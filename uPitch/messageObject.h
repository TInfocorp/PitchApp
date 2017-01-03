//
//  messageObject.h
//  PubNub Demonstration
//
//  Created by Puneet Rao on 15/04/15.
//  Copyright (c) 2015 My Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface messageObject : NSObject
@property (nonatomic, strong) NSString *messageSent;
@property (nonatomic, strong) NSString *User1;
@property (nonatomic, strong) NSDate *SentTime;

@property (nonatomic, strong) NSMutableArray *messageSentArray;
@property (nonatomic, strong) NSMutableArray *User1Array;
@property (nonatomic, strong) NSMutableArray *SentTimeArray;
@end
