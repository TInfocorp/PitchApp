//
//  SideMenuViewController.h
//  uPitch
//
//  Created by Puneet Rao on 09/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray*sideMenuBarArray,*cellImageArray;
    __weak IBOutlet UITableView *tableVw;
    float cellHeight;
    float addYToHeight;
}
@end
