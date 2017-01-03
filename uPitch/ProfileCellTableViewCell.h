//
//  ProfileCellTableViewCell.h
//  uPitch
//
//  Created by Puneet Rao on 16/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileCellTableViewCell : UITableViewCell
{
    
}
@property(nonatomic,strong)IBOutlet UITextField*firstNameText;
@property(nonatomic,strong)IBOutlet UITextField*lastNameText;
@property(nonatomic,strong)IBOutlet UITextField*companyNameText;
@property(nonatomic,strong)IBOutlet UITextField*designationNameText;
@property(nonatomic,strong)IBOutlet UIButton*uploadPhotoButton;
@property(nonatomic,strong)IBOutlet UIImageView*userImageViewSelf;
@property (weak, nonatomic) IBOutlet UIButton *btnPlus;

@property(nonatomic,strong)IBOutlet UIImageView*userImageViewOther;
@property(nonatomic,strong)IBOutlet UILabel*userNamelabel;
@property(nonatomic,strong)IBOutlet UILabel*companyNamelabel;
@property(nonatomic,strong)IBOutlet UILabel*designationNamelabel;
@property (weak, nonatomic) IBOutlet UIButton *btnReport;
@end
