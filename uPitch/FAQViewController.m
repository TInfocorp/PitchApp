//
//  FAQViewController.m
//  upitch
//
//  Created by Puneet Rao on 28/07/15.
//  Copyright (c) 2015 Puneet Rao. All rights reserved.
//

#import "FAQViewController.h"
#import "SWRevealViewController.h"

@interface FAQViewController ()
{
    NSArray *arrQuestions;
    NSArray *arrAnswers;
    NSInteger selectedIndex;
    
}

@end

@implementation FAQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SWRevealViewController *reveal = self.revealViewController;
    reveal.panGestureRecognizer.enabled = NO;
    [self initalize];
    selectedIndex=-1;
}

-(void)initalize
{
    arrQuestions=[[NSArray alloc]initWithObjects:
                  @"How long after loading a pitch will journalists be able to see it in their swipe feed?",
                  @"How will I know if a journalist is interested in my pitch?",
                  @"Can I renew a pitch once it has expired? ",
                  @"Can I edit a pitch once it has been uploaded?",
                  @"Can I remove a pitch once it has been uploaded?",
                  @"Can I unmatch with someone?",
                  @"Will someone I match with be able to see my personal contact information?",
                  @"Will my matches/chats remain open even after the pitch expires?",
                  @"Is it safe to give out personal contact information?",
                  @"Is there a way to go back if I accidently swiped left on a pitch I am interested in?",
                  @"How long does it take to be approved for a PR Professional upgrade?",
                  @"What payment methods are accepted for the Hire upitch to Write a Professionally Written Pitch option?",
                  @"How do I report a spam or bot user?",
                  @"If I set my pitch to a local area, do I physically need to be in that geographical area?",
                  @"What can I do if my pitch is not getting journalist matches?",
                  @"Is there a keyword search option?",
                  @"How do I change my password?",
                  @"How do I turn off notifications?",
                  @"How do I change my email address?",
                  @"Who should be pitching to journalists on upitch?",
                  @"What types of media outlets does upitch want to participate in viewing pitches?",
                  @"How many filters can I search through at a time?",
                  @"Am I able to sign up for upitch without the app?",
                  @"Is there another way to upload a pitch if I don’t have the app?",
                  @"If I submit my pitch on the website version of upitch, will it be available to all journalists on the app?",
                  @"How do I know what pictures to use for a pitch?",
                  @"How do I know what to write in my pitch?",
                  nil];
    
    arrAnswers=[[NSArray alloc]initWithObjects:
                @"Pitches will be live for journalists to consider, in real time,immediately after you’ve uploaded it.",
                @"If a journalist is interested in your story idea, you will receive a push notification from upitch that reads, \"Congrats! A new journalist is interested in your pitch.\" You will then be able to IM that journalist directly though the app.",
                @"Yes, although we strongly recommend rewriting a new pitch if the original version didn’t gain interest from any journalists. You may want to consider reworking a new angle. If we see someone abusing this and reusing the same pitch multiple times, we reserve the right to delete the pitch and warn the user before blocking him/her.",
                @"Yes, you can edit live pitches at anytime.",
                @"Yes, you can delete a pitch at anytime.",
                @"Yes, simply hit \"End Chat\" in the chat box.",
                @"No, your information is private.",
                @"Matches and chats will remain open until one of the parties has closed it, even after the pitch has expired.",
                @"Giving out personal information is up to the discretion of the user. We recommend using the in-app chat feature as much as possible.",
                @"Yes. Simply hit the undo button directly next to the X.",
                @"If approved, the upgrade can take anywhere between 24-48 hours. The upgrade is for PR professionals from large companies, or PR firms only.",
                @"Accepted payment methods are Visa, Mastercard, Amex, and Paypal.",
                @"There is a Report Abuse button in the profile section.",
                @"No. You do not have to be in the geographical area your pitch is set to, but the story you are pitching should be relevant to that geographical region.",
                @"We would recommend retooling to pitch in a way that might be more compelling and newsworthy to journalists. This can include making your pitch more detailed, more to the point, using different pictures, or writing a different pitch headline. We also recommend trying the “Hire a Publicist” feature, which will allow you to have a professionally written pitch done for you.",
                @"There is no keyword search option at this time; just media categories. But it is currently in development along with other exciting features.",
                @"Filter/setting>account settings>choose new passwords.",
                @"You can turn off notifications in the filters/settings tab.",
                @"Filter/setting>account settings>choose new email address.",
                @"Anyone who feels they have a newsworthy or interesting story to share can use upitch to pitch their story to journalists. Examples might include: an upcoming event, a new product launch, a story with human interest value, a news tip, an important announcement, a press release or official statement and the like.",
                @"We welcome journalists and media outlets from all media categories or \"beats\" who are looking for stories to cover. Broadcast, print, online/digital, bloggers and social media personalities are all encouraged to look for stories on upitch.",
                @"Journalists can search as many filters as they choose.",
                @"Yes. You are able to signup through the website at http://www.upitchapp.com.",
                @"We understand that typing out your pitch on a smartphone or tablet can be a hassle for some. That’s why we also developed a website that you can use to upload your pitches. Please visit www.upitchapp.com",
                @"Yes. Regardless of what platform you use to upload your pitch, all journalists will be able to see it.",
                @"Choose appropriate pictures that will best help in telling your story. A picture can be worth a thousand words so it is important use pictures that, both, pertain to your story, and are visually and emotionally compelling to the viewer.",
                @"Our format of a headline, summary and a 400 character body guides you towards making your pitch concise, to the point and filled with only the most relevant facts(essentially an elevator pitch). Find a creative and impactful way of getting your point across within this format. If a journalist has initial interest, they will swipe right and ask to learn more.",
                nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)popView:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (selectedIndex==indexPath.row) {
        selectedIndex=-1;
    }else{
        selectedIndex=indexPath.row;
    }
    [tblView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    static NSString *SimpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                
                                     reuseIdentifier:SimpleTableIdentifier] ;
        
        
    }
    
    UIView *vw=(UILabel*)[cell.contentView viewWithTag:110];
    UILabel*lblQues=(UILabel*)[cell.contentView viewWithTag:101];
    UILabel*lblAnswer=(UILabel*)[cell.contentView viewWithTag:102];
    UIImageView*imgSideArrow=(UIImageView*)[cell.contentView viewWithTag:103];
    UIImageView*imgDownarrow=(UIImageView*)[cell.contentView viewWithTag:104];
    vw.layer.cornerRadius=5;
    vw.layer.masksToBounds=YES;
    lblAnswer.numberOfLines=0;
    lblAnswer.lineBreakMode=NSLineBreakByWordWrapping;
    lblQues.numberOfLines=0;
    lblQues.lineBreakMode=NSLineBreakByWordWrapping;
    
    
    vw.frame=CGRectMake(10, 2, self.view.frame.size.width-20,vw.frame.size.height);
    lblQues.frame=CGRectMake(10, 5,vw.frame.size.width-40,lblQues.frame.size.height);
    imgSideArrow.hidden=NO;
    imgDownarrow.hidden=NO;
    lblAnswer.hidden=NO;
    
    NSMutableAttributedString *stringText;
    NSString *str;
    
    stringText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Ques: %@",[arrQuestions objectAtIndex:indexPath.row]]];
    str=[NSString stringWithFormat:@"Ques: %@",[arrQuestions objectAtIndex:indexPath.row]];
    NSRange range = [str rangeOfString:@"Ques:"];
   
    
    
    NSMutableAttributedString *stringText1;
    NSString *str2;
    stringText1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Ans: %@",[arrAnswers objectAtIndex:indexPath.row]]];
    str2=[NSString stringWithFormat:@"Ans: %@",[arrAnswers objectAtIndex:indexPath.row]];
    NSRange range1 = [str2 rangeOfString:@"Ans:"];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [stringText addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:18.0] range:range];
        [stringText1 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:18.0] range:range1];
    }
    else
    {
    [stringText addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:15.0] range:range];
    [stringText1 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:15.0] range:range1];
    }
    [stringText addAttribute: NSForegroundColorAttributeName value: [UIColor blackColor] range: range];
    [stringText1 addAttribute: NSForegroundColorAttributeName value: [UIColor blackColor] range: range];
    if (selectedIndex==indexPath.row)
    {
        lblAnswer.hidden=NO;
        lblQues.attributedText=stringText;
        lblAnswer.attributedText=stringText1;
        [lblQues sizeToFit];
        lblAnswer.frame=CGRectMake(10,lblQues.frame.size.height+10,vw.frame.size.width-20,lblAnswer.frame.size.height);
        [lblAnswer sizeToFit];
        imgSideArrow.hidden=YES;
        vw.frame=CGRectMake(10, vw.frame.origin.y, self.view.frame.size.width-20, lblAnswer.frame.size.height+lblQues.frame.size.height+15);
        vw.frame=CGRectMake(10,vw.frame.origin.y, self.view.frame.size.width-20,vw.frame.size.height);
       
    }
    else
    {
        lblAnswer.hidden=YES;
        lblQues.attributedText=stringText;
        [lblQues sizeToFit];
        imgDownarrow.hidden=YES;
        vw.frame=CGRectMake(10,vw.frame.origin.y, self.view.frame.size.width-20, 70);
    }

    
    imgSideArrow.frame=CGRectMake(vw.frame.size.width-25, lblQues.frame.size.height/2-2, imgSideArrow.frame.size.width,imgSideArrow.frame.size.height);
    imgDownarrow.frame=CGRectMake(vw.frame.size.width-25, lblQues.frame.size.height/2-2, imgDownarrow.frame.size.width, imgDownarrow.frame.size.height);
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
  
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{  UITableViewCell *Cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (selectedIndex==indexPath.row) {
        
        UIView *vw=(UIView*)[Cell.contentView viewWithTag:110];
        UILabel *lblQues=(UILabel*)[Cell.contentView viewWithTag:101];
        UILabel *lblAns=(UILabel*)[Cell.contentView viewWithTag:102];
        
        vw.frame=CGRectMake(10, 2, self.view.frame.size.width-20,vw.frame.size.height);
        lblQues.frame=CGRectMake(10, 5,vw.frame.size.width-50,lblQues.frame.size.height);
        lblAns.frame=CGRectMake(10,lblQues.frame.size.height+5,vw.frame.size.width-20,lblAns.frame.size.height);
        
        lblQues.text=[NSString stringWithFormat:@"Ques: %@",[arrQuestions objectAtIndex:indexPath.row]];
        lblAns.text=[NSString stringWithFormat:@"Ans: %@",[arrAnswers objectAtIndex:indexPath.row]];
        
        [lblAns sizeToFit];
        [lblQues sizeToFit];
        
        if (indexPath.row==5) {
             return 30+lblAns.frame.size.height+lblQues.frame.size.height+10;
        }
        return 30+lblAns.frame.size.height+lblQues.frame.size.height;
    }
    return 75;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrAnswers.count;
}


@end
