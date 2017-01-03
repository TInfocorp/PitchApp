//
//  MainViewController.m
//  uPitch
//
//  Created by Puneet Rao on 09/03/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "CustomCellManagePitchClient.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)leftSlider
{
    SWRevealViewController *revealController = [self revealViewController];
    revealController.panGestureRecognizer.enabled = YES;
    revealController.tapGestureRecognizer.enabled = YES;
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"menu56.png"] forState:UIControlStateNormal];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
         button.frame = CGRectMake(0, 0, 70, 70);
    }
    
    else{
       button.frame = CGRectMake(0, 0, 60, 60);
    }
   
    [self.view addSubview:button];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [self leftSlider];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
