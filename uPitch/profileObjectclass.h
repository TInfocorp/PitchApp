//
//  profileObjectclass.h
//  uPitch
//
//  Created by Puneet Rao on 17/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface profileObjectclass : NSObject
@property (nonatomic, strong) NSString *headerTitle;

@property (nonatomic, strong) NSMutableArray      *exp_JobTitle;
@property (nonatomic, strong) NSMutableArray      *exp_companyName;
@property (nonatomic, strong) NSMutableArray      *exp_TimeFrame_From;
@property (nonatomic, strong) NSMutableArray      *exp_TimeFrame_To;
@property (nonatomic, strong) NSMutableArray      *exp_Desc;

@property (nonatomic, strong) NSMutableArray      *edu_Name;
@property (nonatomic, strong) NSMutableArray      *edu_Degree;
@property (nonatomic, strong) NSMutableArray      *edu_Time_From;
@property (nonatomic, strong) NSMutableArray      *edu_Time_To;


@property (nonatomic, strong) NSMutableArray      *conn_Name;
@property (nonatomic, strong) NSMutableArray      *conn_Imageurl;

@property (nonatomic, strong) NSMutableArray      *experienceIdArray;
@property (nonatomic, strong) NSMutableArray      *educationIdArray;

//For Checking Manual or Linkedin
@property (nonatomic, strong) NSMutableArray      *arrUserTag;


@end
