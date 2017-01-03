//
//  TandCViewController.m
//  uPitch
//
//  Created by Puneet Rao on 28/05/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import "TandCViewController.h"

@interface TandCViewController ()

@end

@implementation TandCViewController
@synthesize strComeFrom;

- (void)viewDidLoad {
    NSString *htmlFile;
    
    if ([strComeFrom isEqualToString:@"1"]) {
        lblTitle.text=@"Terms And Conditions";
        htmlFile= [[NSBundle mainBundle] pathForResource:@"terms" ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [webView loadHTMLString:htmlString baseURL:nil];
    }else{
        lblTitle.text=@"Privacy Policy";
        htmlFile= [[NSBundle mainBundle] pathForResource:@"policy" ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [webView loadHTMLString:htmlString baseURL:nil];
    }
   
    
    [super viewDidLoad];
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)popView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
