//
//  SideMenuViewController.m
//  uPitch
//
//  Created by Puneet Rao on 09/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import "SideMenuViewController.h"
#import "SWRevealViewController.h"
#import "ProfileViewController.h"
#import "ComposeViewController.h"
#import "MainViewController.h"
#import "MainViewController_Client.h"
#import "HirePublicistViewController.h"
#import "ClientSettingViewController.h"
#import "manageJournalistViewController.h"
#import "viewPitchesViewController_Journalists.h"
#import "JournalistsSetting_ViewController.h"
#import "PitchFeedJournalist_ViewController.h"
#import "AnalyticsViewController.h"
@interface SideMenuViewController ()
@end

@implementation SideMenuViewController
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userTypeString"]);
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"userTypeString"] isEqualToString:@"1"])
    {
        // client
        sideMenuBarArray = [[NSMutableArray alloc]initWithObjects:@"PROFILE",@"MANAGE PITCHES",@"MATCHES",@"HIRE PUBLICIST",@"ANALYTICS",@"FILTER / SETTINGS", nil];
        cellImageArray = [[NSMutableArray alloc]initWithObjects:@"PROFILE.png",@"manage_pitches.PNG",@"MAtches1.png",@"hire.png",@"analytics.png",@"FILTER.png", nil];
        
        
//        sideMenuBarArray = [[NSMutableArray alloc]initWithObjects:@"PROFILE",@"MANAGE PITCHES",@"MATCHES",@"ANALYTICS",@"FILTER / SETTINGS", nil];
//        cellImageArray = [[NSMutableArray alloc]initWithObjects:@"PROFILE.png",@"manage_pitches.PNG",@"MAtches1.png",@"analytics.png",@"FILTER.png", nil];
        
    }
    else  if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"userTypeString"] isEqualToString:@"2"])
    {
        // journalist
        sideMenuBarArray = [[NSMutableArray alloc]initWithObjects:@"PROFILE",@"PITCHES FEED",@"LIKED PITCHES",@"FILTER / SETTINGS", nil];
        cellImageArray = [[NSMutableArray alloc]initWithObjects:@"PROFILE.png",@"PITCH_FEED.png",@"MAtches1.png",@"FILTER.png", nil];
    }
     [super viewWillAppear:animated];
     cellHeight = self.view.frame.size.height/(sideMenuBarArray.count+1);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        // cellHeight = 768/sideMenuBarArray.count;
         addYToHeight = 70/sideMenuBarArray.count;
        cellHeight = cellHeight-3;
    }
    else{
        addYToHeight = 50/sideMenuBarArray.count;
    }

    [tableVw reloadData];
    
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
    [super viewWillDisappear:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view.
}
-(void)crossButtonPressed{
    [self.revealViewController revealToggleAnimated:NO];
}
#pragma mark Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self crossButtonPressed];
    NSLog(@"%ld",(long)indexPath.row);
     SWRevealViewController *revealController = self.revealViewController;
    
    UINavigationController *frontNavigationController = (id)self.revealViewController.frontViewController;
    
     MainViewController_Client*swContrlr = [frontNavigationController.viewControllers firstObject];
    NSLog(@"%@ %@",frontNavigationController,swContrlr);
    NSArray *array = [swContrlr.navigationController viewControllers];
    NSLog(@"%lu",(unsigned long)array.count);
// client
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"userTypeString"] isEqualToString:@"1"])
    {
    if (indexPath.row == 1) {
        [[NSUserDefaults standardUserDefaults]setObject:@"clientProfile" forKey:@"userProfile"];
        [[NSUserDefaults standardUserDefaults]synchronize];
            ProfileViewController*obj;
            obj=[self.storyboard instantiateViewControllerWithIdentifier:@"profileController"];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:obj];
            [revealController pushFrontViewController:navigationController animated:YES];
      }
      if (indexPath.row == 2) {
          MainViewController_Client*obj;
          obj=[self.storyboard instantiateViewControllerWithIdentifier:@"maincontroller_client"];
          UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:obj];
          [revealController pushFrontViewController:navigationController animated:YES];
      }
    if (indexPath.row == 3) {
            manageJournalistViewController*obj;
            obj=[self.storyboard instantiateViewControllerWithIdentifier:@"manageJournalists"];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:obj];
            [revealController pushFrontViewController:navigationController animated:YES];
    }
        if (indexPath.row == 4) {
            HirePublicistViewController*obj;
            obj=[self.storyboard instantiateViewControllerWithIdentifier:@"hirePublicist"];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:obj];
            [revealController pushFrontViewController:navigationController animated:YES];
        }
    if (indexPath.row == 5) {
            AnalyticsViewController*obj;
            obj=[self.storyboard instantiateViewControllerWithIdentifier:@"analytics"];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:obj];
            [revealController pushFrontViewController:navigationController animated:YES];
    }

        if (indexPath.row == 6) {
            ClientSettingViewController*obj;
            obj=[self.storyboard instantiateViewControllerWithIdentifier:@"clientFilter"];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:obj];
            [revealController pushFrontViewController:navigationController animated:YES];
        }
      
  
    }
    else{
        if (indexPath.row == 1) {
            
            [[NSUserDefaults standardUserDefaults]setObject:@"journalistProfile" forKey:@"userProfile"];
            [[NSUserDefaults standardUserDefaults]synchronize];
          ProfileViewController*obj;
          obj=[self.storyboard instantiateViewControllerWithIdentifier:@"profileController"];
           UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:obj];
           [revealController pushFrontViewController:navigationController animated:YES];
          
      }
      else  if (indexPath.row == 2) {
          [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"showHud"];
          [[NSUserDefaults standardUserDefaults]synchronize];

            PitchFeedJournalist_ViewController*obj;
            obj=[self.storyboard instantiateViewControllerWithIdentifier:@"pitchFeedtest"];
          
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:obj];
            [revealController pushFrontViewController:navigationController animated:YES];
      }
    else  if (indexPath.row == 3) {
           viewPitchesViewController_Journalists*obj;
           obj=[self.storyboard instantiateViewControllerWithIdentifier:@"viewPitches"];
          UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:obj];
          [revealController pushFrontViewController:navigationController animated:YES];
        }
      else  if (indexPath.row == 4) {
          JournalistsSetting_ViewController*obj;
          obj=[self.storyboard instantiateViewControllerWithIdentifier:@"journalist_Setting"];
          UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:obj];
          [revealController pushFrontViewController:navigationController animated:YES];
      }
    }
    
    
   

    NSLog(@"%ld",(long)indexPath.row);
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                
                                     reuseIdentifier:SimpleTableIdentifier] ;
        tableVw.backgroundColor = [UIColor colorWithRed:50.0f/255.0f green:120.0f/255.0f blue:180.0f/255.0f alpha:1.0f];
//        cell.backgroundColor = [UIColor colorWithRed:50.0f/255.0f green:120.0f/255.0f blue:180.0f/255.0f alpha:1.0f];
        cell.backgroundColor = [UIColor clearColor];
        tableVw.separatorColor = [UIColor clearColor];
        UIImageView*cellImage ;
        UILabel*cellText;
        UIButton *crossButton;
        
        crossButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [crossButton addTarget:self
                   action:@selector(crossButtonPressed)
         forControlEvents:UIControlEventTouchUpInside];
        [crossButton setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
       
       
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            cellImage = [[UIImageView alloc]init];
             cellImage.frame=CGRectMake(20, cellHeight/2-20, 40, 40);
            if (indexPath.row == 2) {
                 cellImage.frame=CGRectMake(20, cellHeight/2-28, 40, 40);
                
            }
             cellText = [[UILabel alloc]initWithFrame:CGRectMake(100, cellHeight/2-25, 350, 50)];
             crossButton.frame = CGRectMake(20.0, 25.0, 28.0, 28.0);
        }
        else{
            cellImage = [[UIImageView alloc]init];
            cellImage.frame=CGRectMake(20, cellHeight/2-10, 20, 20);
            if (indexPath.row == 2) {
                 cellImage.frame=CGRectMake(20, cellHeight/2-10, 20, 20);
                
            }
             cellText = [[UILabel alloc]initWithFrame:CGRectMake(65, cellHeight/2-20, 200, 45)];
             crossButton.frame = CGRectMake(20.0, 25.0, 18.0, 18.0);
        }
        if (indexPath.row ==0) {
             if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                  cellImage.frame=CGRectMake(20, cellHeight/2, 40, 40);
                 cellText.frame=CGRectMake(100, cellHeight/2, 350, 50);
             }
             else{
                 cellImage.frame=CGRectMake(20, cellHeight/2+12, 20, 20);
                 cellText.frame=CGRectMake(65, cellHeight/2, 200, 45);
             }
            
        }
         cellText.tag=2;
        cellImage.tag=1;
        crossButton.tag = 3;
         [cell.contentView addSubview:crossButton];
         [cell.contentView addSubview:cellText];
         [cell.contentView addSubview:cellImage];
        
    }
    UIImageView*cellImgageView=(UIImageView*)[cell viewWithTag:1];
     UILabel*cellText=(UILabel*)[cell viewWithTag:2];
     UIButton*crossButton=(UIButton*)[cell viewWithTag:3];
    
     crossButton.hidden = YES;
    if (indexPath.row==0) {
         crossButton.hidden = NO;
    }
    if (indexPath.row!=0) {
        
   
    [cellImgageView setImage:[UIImage imageNamed:[cellImageArray objectAtIndex:indexPath.row-1]]];
    cellText.text = [NSString stringWithFormat:@"%@",[sideMenuBarArray objectAtIndex:indexPath.row-1]];
    cellText.textColor = [UIColor whiteColor];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        cellText.font=[UIFont fontWithName:@"Helvetica-Bold" size:25];
    }
    else{
         cellText.font=[UIFont fontWithName:@"Helvetica-Bold" size:15];
    }
    }
    
    //cell.layer.borderColor = [UIColor redColor].CGColor;
   // cell.layer.borderWidth =3.0f;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0) {
         if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        return 70;
         }
         else{
             return 50;
         }
     }
    return cellHeight+addYToHeight;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return sideMenuBarArray.count+1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark orientation Method
- (BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
         if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortrait) {
             NSLog(@"portrait");
             if (sideMenuBarArray.count>0) {
              cellHeight = self.view.frame.size.height/(sideMenuBarArray.count+1);
                  addYToHeight = 70/sideMenuBarArray.count;
                // addYToHeight = cellHeight/sideMenuBarArray.count;
               //  NSLog(@"%f",addYToHeight);
             [tableVw reloadData];
             }
         }
         else if (orientation == UIInterfaceOrientationLandscapeLeft ||
                  orientation == UIInterfaceOrientationLandscapeRight)
         {
             NSLog(@"landscape");
             if (sideMenuBarArray.count>0) {
                 cellHeight = 768.0f/(sideMenuBarArray.count+1);
                 cellHeight = cellHeight - 3;
                  addYToHeight = 70/sideMenuBarArray.count;
               //  addYToHeight = cellHeight/sideMenuBarArray.count;
               //  NSLog(@"%f",addYToHeight);
               //   NSLog(@"landscape %f %f %f",addYToHeight,cellHeight,self.view.frame.size.height);
                 [tableVw reloadData];
             }
             
        }
         
         // do whatever
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
