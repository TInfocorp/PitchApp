//
//  MainViewObjectClass.h
//  uPitch
//
//  Created by Puneet Rao on 13/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewObjectClass : NSObject
@property (nonatomic, strong) NSString *pitchId;
@property (nonatomic, strong) NSString *pitchDesc;
@property (nonatomic, strong) NSString *pitchTitle;
@property (nonatomic, strong) NSString *coverImage;
@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSString *strPitchBlock;
@end
