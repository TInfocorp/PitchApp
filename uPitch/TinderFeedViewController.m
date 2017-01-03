//
//  TinderFeedViewController.m
//  uPitch
//
//  Created by Ashwani on 22/04/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import "TinderFeedViewController.h"

@interface TinderFeedViewController ()

@end

@implementation TinderFeedViewController

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [super viewDidLoad];
    
    // You can customize MDCSwipeToChooseView using MDCSwipeToChooseViewOptions.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.likedText = @"Keep";
    options.likedColor = [UIColor blueColor];
    options.nopeText = @"Delete";
    options.onPan = ^(MDCPanState *state){
        if (state.thresholdRatio == 1.f && state.direction == MDCSwipeDirectionLeft) {
            NSLog(@"Let go now to delete the photo!");
        }
    };
    
    UIView*bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, viewMain.frame.size.height-75, 300, 65)];
   
    
    
    UIButton*crossButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [crossButton setBackgroundImage:[UIImage imageNamed:@"Forma_new"] forState:UIControlStateNormal];
    crossButton.tag = 3000;
    [crossButton addTarget:self action:@selector(crossAcceptPressed:) forControlEvents:UIControlEventTouchUpInside];
    crossButton.frame = CGRectMake(5, 0, 91, 62);
    [bottomView addSubview:crossButton];
    
    UIButton*checkedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkedButton setBackgroundImage:[UIImage imageNamed:@"Forma_new1"] forState:UIControlStateNormal];
    checkedButton.tag = 4000;
    checkedButton.frame = CGRectMake(bottomView.frame.size.width-96, 0, 91, 62);
    [checkedButton addTarget:self action:@selector(crossAcceptPressed:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:checkedButton];
    
    int remainingWidth = bottomView.frame.size.width - 192;
    // NSLog(@"%d",remainingWidth);
    int space = remainingWidth-108;
    int xCord = space/3;
    
    UIButton*undoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [undoButton setBackgroundImage:[UIImage imageNamed:@"Forma 11_new"] forState:UIControlStateNormal];
    [undoButton addTarget:self
                   action:@selector(undoAction:)
         forControlEvents:UIControlEventTouchUpInside];
    undoButton.tag = 2000;
    undoButton.frame = CGRectMake(crossButton.frame.origin.x+crossButton.frame.size.width+xCord, 4, 54, 54);
    [bottomView addSubview:undoButton];
    
    
    UIButton*detailCircleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailCircleButton setBackgroundImage:[UIImage imageNamed:@"Forma 12_new"] forState:UIControlStateNormal];
    [detailCircleButton addTarget:self
                           action:@selector(detailButtonPressed:)
                 forControlEvents:UIControlEventTouchUpInside];
    detailCircleButton.tag = 5000;
    detailCircleButton.frame = CGRectMake(undoButton.frame.origin.x+undoButton.frame.size.width+xCord, 4, 54, 54);
    [bottomView addSubview:detailCircleButton];

    
    
    
    MDCSwipeToChooseView *view = [[MDCSwipeToChooseView alloc] initWithFrame:viewMain.bounds
                                                                     options:options];
    view.imageView.frame= CGRectMake(10, 50, 300, 200);
    
    
    
//    view.imageView.image = [UIImage imageNamed:@"600x400.png"];
//    view.imageView.image = [UIImage imageNamed:@"Default.png"];
    
    [view addSubview:bottomView];
    [viewMain addSubview:view];
   // [view addSubview:viewMain];
    
     
    
    // Do any additional setup after loading the view.
}


#pragma mark - MDCSwipeToChooseDelegate Callbacks

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"Couldn't decide, huh?");
}

// Sent before a choice is made. Cancel the choice by returning `NO`. Otherwise return `YES`.
- (BOOL)view:(UIView *)view shouldBeChosenWithDirection:(MDCSwipeDirection)direction {
    if (direction == MDCSwipeDirectionLeft) {
        return YES;
    } else {
        // Snap the view back and cancel the choice.
        [UIView animateWithDuration:0.16 animations:^{
            view.transform = CGAffineTransformIdentity;
            view.center = [view superview].center;
        }];
        return NO;
    }
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    if (direction == MDCSwipeDirectionLeft) {
        NSLog(@"Photo deleted!");
    } else {
        NSLog(@"Photo saved!");
    }
}

- (void)didReceiveMemoryWarning 
{
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
