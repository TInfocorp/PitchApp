//
//  WelComeVC.m
//  Happz App
//
//  Created by roza on 23/12/14.
//  Copyright (c) 2014 INX. All rights reserved.
//

#import "WelComeVC.h"
#import "constant.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "MainViewController_Client.h"
#import "Utils.h"
#import "PitchFeedJournalist_ViewController.h"
typedef enum ScrollDirection
{
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

@interface WelComeVC ()
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIPageControl *pageControl;
    int intPageCount;
}
@property (nonatomic, assign) CGFloat lastContentOffset;

#pragma mark - Custom Method
- (IBAction)changePage:(id)sender;

@end

@implementation WelComeVC
@synthesize userType;
#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    if ([USERDEFAULTS boolForKey:@"termsandconditions"])
//    {
//        [USERDEFAULTS setBool:NO forKey:@"termsandconditions"];
//        [self intializeOnce];
//
//    }
//    else
//    {
    
      
//        LoginViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//        [self.navigationController pushViewController:controller animated:NO];
//        [self performSegueWithIdentifier:@"LoginViewController" sender:self];
//    }

            [self intializeOnce];

 }

-(void)intializeOnce
{
    intPageCount =0;
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    scrollView.contentSize = CGSizeMake(5*self.view.frame.size.width, scrollView.contentSize.height);
    
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pagination_sel"]];
    pageControl.pageIndicatorTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pagination"]];
    pageControl.numberOfPages = scrollView.contentSize.width/self.view.frame.size.width;
    for (int i=0; i<pageControl.numberOfPages; i++) {
        CGRect rect = CGRectMake(i*self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
         if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Instruction%d",i+1]];
         }else
         {
             imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"InstructionIphone%d",i+1]];

         }
        [scrollView addSubview:imgView];
    }
    scrollView.bounces = YES;

}


#pragma mark - Custom Method
- (void)actionSwipeGesture:(id)sender
{
    NSLog(@"Swipe Gesture Call");
}
- (IBAction)changePage:(id)sender
{
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pagination_sel"]];
}
- (IBAction)skipTuts:(id)sender {
//    LoginViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//    [self.navigationController pushViewController:controller animated:NO];
    SWRevealViewController *revealController = self.revealViewController;
    
    UINavigationController *frontNavigationController = (id)self.revealViewController.frontViewController;
    
    MainViewController_Client*swContrlr = [frontNavigationController.viewControllers firstObject];
    NSArray *array = [swContrlr.navigationController viewControllers];
    NSLog(@"%lu",(unsigned long)array.count);
    [[NSUserDefaults standardUserDefaults]setObject:@"loggedin" forKey:@"LoginStatus"];
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:KEY_PROFILE_TAG];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"userTypeString"] isEqualToString:@"1"]){
        MainViewController_Client*obj;
        obj=[self.storyboard instantiateViewControllerWithIdentifier:@"maincontroller_client"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:obj];
        [revealController pushFrontViewController:navigationController animated:YES];
    }else{
        PitchFeedJournalist_ViewController*obj;
        obj=[self.storyboard instantiateViewControllerWithIdentifier:@"pitchFeedtest"];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:obj];
        [revealController pushFrontViewController:navigationController animated:YES];
    }

}

#pragma mark - UIScrollView Delegate Mathod
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
//    _btnSkip.hidden = NO;

    
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 5) / pageWidth) + 1;
    int pagefor = scrollView.contentOffset.x;
    NSLog(@"Page for is %d",pagefor);
//    if (page ) {
//        _btnSkip.hidden = YES;
//    }
    if (pagefor > scrollView.frame.size.width*4)
    {
        SWRevealViewController *revealController = self.revealViewController;
        
        UINavigationController *frontNavigationController = (id)self.revealViewController.frontViewController;
        
        MainViewController_Client*swContrlr = [frontNavigationController.viewControllers firstObject];
        NSArray *array = [swContrlr.navigationController viewControllers];
        NSLog(@"%lu",(unsigned long)array.count);
        [[NSUserDefaults standardUserDefaults]setObject:@"loggedin" forKey:@"LoginStatus"];
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:KEY_PROFILE_TAG];
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"userTypeString"] isEqualToString:@"1"]){
            MainViewController_Client*obj;
            obj=[self.storyboard instantiateViewControllerWithIdentifier:@"maincontroller_client"];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:obj];
            [revealController pushFrontViewController:navigationController animated:YES];
        }else{
            PitchFeedJournalist_ViewController*obj;
            obj=[self.storyboard instantiateViewControllerWithIdentifier:@"pitchFeedtest"];
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:obj];
            [revealController pushFrontViewController:navigationController animated:YES];
        }


//        LoginViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//        [self.navigationController pushViewController:controller animated:NO];
//        [self performSegueWithIdentifier:@"LoginViewController" sender:self];
    }
    pageControl.currentPage = page;
    
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated. //
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"LoginViewController"]) {
        
        LoginViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        [self.navigationController pushViewController:controller animated:NO];

    }
}


@end
