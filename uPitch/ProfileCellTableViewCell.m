//
//  ProfileCellTableViewCell.m
//  uPitch
//
//  Created by Puneet Rao on 16/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import "ProfileCellTableViewCell.h"

@implementation ProfileCellTableViewCell
@synthesize firstNameText,lastNameText,companyNameText,designationNameText,uploadPhotoButton,userImageViewSelf,userImageViewOther,userNamelabel,companyNamelabel,designationNamelabel,btnReport;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
