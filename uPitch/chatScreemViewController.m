

#import "chatScreemViewController.h"
#import "messageObject.h"
#import "LxReqRespManager.h"
#import "CustomCellManagePitchClient.h"
#import "ProfileViewController.h"
#import "UIImageView+WebCache.h"
#import "PitchDetailsViewController.h"
#import "constant.h"
@interface chatScreemViewController ()

@end

@implementation chatScreemViewController
@synthesize userIdString,chatIdString,rivalImageViewPath,loginImageViewPath,userNameHeaderString,deviceTokenString,deviceToken,strPitchId,requestOutput,messageTextView;

-(void)scrollTable
{
    int  y = dataTableVw.contentSize.height-dataTableVw.frame.size.height;
    if (y>0) {
        [dataTableVw setContentOffset:CGPointMake(0, dataTableVw.contentSize.height-dataTableVw.frame.size.height) animated:NO];
    }
}
-(void)filterArray
{
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"SentTime"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [mainArray sortedArrayUsingDescriptors:sortDescriptors];
    mainArray=[[NSMutableArray alloc]initWithArray:sortedArray];
    
    NSString*dateString1;
    NSString*dateString2;
    
    NSMutableArray*dataArray;
    for (int h=0; h<mainArray.count; h++)
    {
        dateString1 = [NSString stringWithFormat:@"%@",[[mainArray objectAtIndex:h] objectForKey:@"messageTime"]];
        dateString1 = [[dateString1 componentsSeparatedByString:@" "] objectAtIndex:0];
        if ([dateString1 isEqualToString:dateString2])
        {
            [dataArray addObject:[mainArray objectAtIndex:h]];
            
        }
        else
        {
            dataArray = [[NSMutableArray alloc]init];
            [dataArray addObject:[mainArray objectAtIndex:h]];
            dateString2 = dateString1;
            [mainObjectArray addObject:dataArray];
        }
    }
    [self reload];
}
//The date sort function
NSComparisonResult dateSort(NSString *s1, NSString *s2, void *context) {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *d1 = [formatter dateFromString:s1];
    NSDate *d2 = [formatter dateFromString:s2];
    
    return [d1 compare:d2]; // ascending order
    return [d2 compare:d1]; // descending order
}
-(void)increaseCounter{
    filterCounter++;
    NSLog(@"filterCounter: %ld",(long)filterCounter);
    if (filterCounter==2) {
        [self filterArray];
    }
}


-(void)sideView:(id)sender
{
    if (self.revealViewController.frontViewPosition==FrontViewPositionRight)
    {
        NSLog(@"right");
    }
    else
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            bottomView.frame=CGRectMake(bottomView.frame.origin.x,[[UIScreen mainScreen] bounds].size.height-80, bottomView.frame.size.width, bottomView.frame.size.height);
        }
        else{
            bottomView.frame=CGRectMake(bottomView.frame.origin.x,[[UIScreen mainScreen] bounds].size.height-60, bottomView.frame.size.width, bottomView.frame.size.height);
        }
        dataTableVw.frame = CGRectMake(dataTableVw.frame.origin.x, dataTableVw.frame.origin.y, dataTableVw.frame.size.width, tableViewHeight);
        [messageTextView resignFirstResponder];
        [self scrollTable];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [appdelegateInstance showHUD:@""];
    
    if (![APPDELEGATE xmppStream]) {
        [APPDELEGATE setupStream];
    }
    
    [APPDELEGATE startXMPPConnection];
    //highlight off
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortrait)
        {
            tableViewHeight = 863-50;
            
        } else if (orientation == UIInterfaceOrientationLandscapeLeft ||
                   orientation == UIInterfaceOrientationLandscapeRight)
        {
            tableViewHeight = 588-30;
        }
        
        
    }
    else
    {
        // dataTableVw.frame = CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-100);
        dataTableVw.frame = CGRectMake(0,80, self.view.frame.size.width, self.view.frame.size.height-140);
        tableViewHeight = dataTableVw.frame.size.height;
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        bottomView.frame=CGRectMake(bottomView.frame.origin.x,[[UIScreen mainScreen] bounds].size.height-80, bottomView.frame.size.width, bottomView.frame.size.height);
    }
    else{
        bottomView.frame=CGRectMake(bottomView.frame.origin.x,[[UIScreen mainScreen] bounds].size.height-60, bottomView.frame.size.width, bottomView.frame.size.height);
    }
    dataTableVw.frame = CGRectMake(dataTableVw.frame.origin.x, dataTableVw.frame.origin.y, dataTableVw.frame.size.width, tableViewHeight);
    [messageTextView resignFirstResponder];
    [self getChatData];
}
-(void)didConnectedToXmpp
{
    [appdelegateInstance hideHUD];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}
- (void)viewDidLoad
{
    lblPitchTitle.text=[NSString stringWithFormat:@"\"%@\"", self.strShowPitchName];
    UITapGestureRecognizer *tapOn=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titlePressed:)];
    [vwTitleName addGestureRecognizer:tapOn];
    
    self.messageTextView.text = @"";
    //[self testChannelStatus];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    SWRevealViewController *reveal = self.revealViewController;
    reveal.panGestureRecognizer.enabled = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"resignKeyBoard" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sideView:) name:@"resignKeyBoard" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PubNubNotification:) name:@"pubnubnot" object:nil];
    
    appdelegateInstance = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    sendButton.userInteractionEnabled = NO;
    [sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    userNameHeader.text = userNameHeaderString;
    NSURL*Url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",rivalImageViewPath]];
    rivalImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
    [self.view addSubview:rivalImageView];
    rivalImageView.hidden = YES;
    [rivalImageView setImageWithURL:Url1 placeholderImage:[UIImage imageNamed:@"userDefault.jpg"] imagesize:CGSizeMake(90, 90)];
    
    NSURL*Url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",loginImageViewPath]];
    loginImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
    [self.view addSubview:loginImageView];
    loginImageView.hidden = YES;
    [loginImageView setImageWithURL:Url2 placeholderImage:[UIImage imageNamed:@"userDefault.jpg"] imagesize:CGSizeMake(90, 90)];
    
    NSLog(@"chat id is: %@",chatIdString);
    increaseBoolChannel1 = YES;
    increaseBoolChannel2 = YES;
    
    // database code goes here
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"uPitchDb.sqlite"]];
    
    
    dataTableVw.hidden = YES;
    dataTableVw.delegate = nil;
    dataTableVw.dataSource = nil;
    filterCounter =0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myNotificationMethod:) name:UIKeyboardWillShowNotification object:nil];
    
    borderImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    borderImageView.layer.borderWidth = 1.0f;
    borderImageView.layer.cornerRadius = 8;
    borderImageView.layer.masksToBounds = YES;
    borderImageView.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    ;
    //    [self performSelector:@selector(scrollTable) withObject:nil afterDelay:0.9];
    [super viewDidLoad];
}
-(void)getChatData
{
    mainArray  = [[NSMutableArray alloc]init];
    dateArray  = [[NSMutableArray alloc]init];
    mainObjectArray = [[NSMutableArray alloc]init];
    Database *objDatabase = [Database sharedObject];
    from = _myXmppID;
    to = _oppennetXmppID;
    NSLog(@"my xmmp %@ opennet%@",from,to);
    
    
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM latestMessageMaster WHERE (opponentXMPPID = '%@' AND lastMessageFromUser= '%@') OR (opponentXMPPID = '%@' AND lastMessageFromUser= '%@')", from.uppercaseString, to.uppercaseString,to.uppercaseString,from.uppercaseString];
    mainArray =[[objDatabase executeSelectQuery:selectQuery] mutableCopy];
    
    [self filterArray];
    NSString *strUpdateQuery = [NSString stringWithFormat:@"update latestMessageMaster set isRead = '1' where (opponentXMPPID = '%@' AND lastMessageFromUser= '%@') OR (opponentXMPPID = '%@' AND lastMessageFromUser= '%@')",from.uppercaseString,to.uppercaseString,to.uppercaseString,from.uppercaseString];
    
    BOOL isUpdated = [objDatabase updateData:strUpdateQuery];
    if (isUpdated) {
        NSLog(@"Table Update successfully");
    }
}

-(void)dismissKeyboard {
    [messageTextView resignFirstResponder];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        bottomView.frame=CGRectMake(bottomView.frame.origin.x,[[UIScreen mainScreen] bounds].size.height-80, bottomView.frame.size.width, bottomView.frame.size.height);
    }
    else{
        bottomView.frame=CGRectMake(bottomView.frame.origin.x,[[UIScreen mainScreen] bounds].size.height-60, bottomView.frame.size.width, bottomView.frame.size.height);
        
    }
    dataTableVw.frame = CGRectMake(dataTableVw.frame.origin.x, dataTableVw.frame.origin.y, dataTableVw.frame.size.width, tableViewHeight);
    
    
}
-(void)titlePressed:(id)sender
{
    [APPDELEGATE disconnect];
    [self dismissKeyboard];
    PitchDetailsViewController*obj;
    obj=[self.storyboard instantiateViewControllerWithIdentifier:@"pitchDetailJournalist"];
    obj.clientJournalistString = @"1";
    obj.strPitchId = self.strPitchId;
    obj.strHideTopIcons=@"Hide";
    [self.navigationController pushViewController:obj animated:YES];
}
-(void)PubNubNotification:(NSNotification *) notification
{
    appdelegateInstance.viewNotificationPopUp.hidden=YES;
    
}
- (void)showStatusMessage:(NSString *)message {
    
    [self.imageView setHidden:YES];
    [self.requestOutput setText:message];
}

-(void)reload{
    
    if (mainArray.count==0) {
        dataTableVw.hidden = YES;
    }
    else{
        dataTableVw.delegate = self;
        dataTableVw.dataSource = self;
        [dataTableVw reloadData];
        dataTableVw.hidden = NO;
    }
    [self performSelector:@selector(scrollTable) withObject:nil afterDelay:0.0];
}
- (void)myNotificationMethod:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect  keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        bottomView.frame=CGRectMake(bottomView.frame.origin.x,([[UIScreen mainScreen] bounds].size.height-keyboardFrameBeginRect.size.height)-80, bottomView.frame.size.width, bottomView.frame.size.height);
        [dataTableVw setContentOffset:CGPointMake(0, dataTableVw.contentSize.height-230) animated:NO];
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortrait)
        {
            //dataTableVw.frame = CGRectMake(dataTableVw.frame.origin.x, dataTableVw.frame.origin.y, dataTableVw.frame.size.width,tableViewHeight-300);
            
            dataTableVw.frame = CGRectMake(dataTableVw.frame.origin.x, dataTableVw.frame.origin.y, dataTableVw.frame.size.width, tableViewHeight-keyboardFrameBeginRect.size.height);
            
        }
        else if (orientation == UIInterfaceOrientationLandscapeLeft ||
                 orientation == UIInterfaceOrientationLandscapeRight)
        {
            //dataTableVw.frame = CGRectMake(dataTableVw.frame.origin.x, dataTableVw.frame.origin.y, dataTableVw.frame.size.width, tableViewHeight-370);
            
            dataTableVw.frame = CGRectMake(dataTableVw.frame.origin.x, dataTableVw.frame.origin.y, dataTableVw.frame.size.width, tableViewHeight-keyboardFrameBeginRect.size.height);
        }
        
    }
    else
    {
        bottomView.frame=CGRectMake(bottomView.frame.origin.x,([[UIScreen mainScreen] bounds].size.height-keyboardFrameBeginRect.size.height)-60, bottomView.frame.size.width, bottomView.frame.size.height);
        [dataTableVw setContentOffset:CGPointMake(0, dataTableVw.contentSize.height-100) animated:NO];
        //dataTableVw.frame = CGRectMake(dataTableVw.frame.origin.x, dataTableVw.frame.origin.y, dataTableVw.frame.size.width, tableViewHeight-245);
        dataTableVw.frame = CGRectMake(dataTableVw.frame.origin.x, dataTableVw.frame.origin.y, dataTableVw.frame.size.width, tableViewHeight-keyboardFrameBeginRect.size.height);
        
        
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return mainObjectArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        return 60;
    }
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,40)];
    headerView.backgroundColor=[UIColor clearColor];
    UILabel *dayLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 80,0,160,35)];
    
    dayLabel.textAlignment = NSTextAlignmentCenter;
    //    dayLabel.backgroundColor=[UIColor clearColor];
    dayLabel.backgroundColor=[UIColor grayColor];
    
    dayLabel.textColor=[UIColor colorWithRed:73.0f/255.0f green:79.0f/255.0f blue:78.0f/255.0f alpha:1.0f];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        dayLabel.font = [UIFont fontWithName:@"Helvetica" size:23];
    }else
    {
        dayLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    }
    NSString *strDate =  [NSString stringWithFormat:@"%@",[[[mainObjectArray objectAtIndex:section] objectAtIndex:0] objectForKey:@"messageTime"]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"dd/MM/yy HH:mm:ss.SSS"];
    NSDate *dateForSection =[formatter dateFromString:strDate];
    NSLog(@"%@",dateForSection);
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setTimeZone:[NSTimeZone localTimeZone]];
    [formatter1 setDateFormat:@"dd/MM/yyyy"];
    
    NSString *strDateForHeader = [formatter1 stringFromDate:dateForSection];
    
    dayLabel.text = strDateForHeader;
    
    dayLabel.layer.cornerRadius = dayLabel.frame.size.height/2;
    dayLabel.layer.masksToBounds = YES;
    [headerView addSubview:dayLabel];
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        bottomView.frame=CGRectMake(bottomView.frame.origin.x,[[UIScreen mainScreen] bounds].size.height-80, bottomView.frame.size.width, bottomView.frame.size.height);
    }
    else
    {
        bottomView.frame=CGRectMake(bottomView.frame.origin.x,[[UIScreen mainScreen] bounds].size.height-60, bottomView.frame.size.width, bottomView.frame.size.height);
    }
    dataTableVw.frame = CGRectMake(dataTableVw.frame.origin.x, dataTableVw.frame.origin.y, dataTableVw.frame.size.width, tableViewHeight);
    [messageTextView resignFirstResponder];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictData = [[mainObjectArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    static NSString *SimpleTableIdentifier = @"chatTable";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                
                                     reuseIdentifier:SimpleTableIdentifier] ;
        tableView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor redColor];
        tableView.separatorColor = [UIColor blackColor];
    }
    
    UIImageView*borderImageViewForUser = (UIImageView*)[cell viewWithTag:1];
    UIImageView*userImageView   = (UIImageView*)[cell viewWithTag:2];
    UIImageView*arrowImageView  = (UIImageView*)[cell viewWithTag:3];
    UIView*backgroundView       = (UIView*)[cell viewWithTag:4];
    UILabel*messageText         = (UILabel*)[cell viewWithTag:5];
    UILabel*timesent            = (UILabel*)[cell viewWithTag:6];
    UIButton*customButton       = (UIButton*)[cell viewWithTag:10];
    
    [customButton addTarget:self action:@selector(customButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    borderImageViewForUser.layer.cornerRadius = borderImageViewForUser.frame.size.height/2;
    borderImageViewForUser.layer.masksToBounds = YES;
    borderImageViewForUser.layer.borderColor = [UIColor colorWithRed:236.0f/255.0f green:145.0f/255.0f blue:28.0f/255.0f alpha:1].CGColor;
    borderImageViewForUser.layer.borderWidth = 2.f;
    userImageView.backgroundColor = [UIColor blackColor];
    
    userImageView.layer.cornerRadius = borderImageViewForUser.frame.size.height/2;
    userImageView.layer.masksToBounds = YES;
    backgroundView.layer.cornerRadius = 15;
    backgroundView.layer.masksToBounds = YES;
    backgroundView.backgroundColor = [UIColor colorWithRed:251.0f/255.0f green:236.0f/255.0f blue:205.0f/255.0f alpha:1];
    timesent.textColor = [UIColor colorWithRed:200.0f/255.0f green:175.0f/255.0f blue:135.0f/255.0f alpha:1];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        messageText.frame = CGRectMake(130, messageText.frame.origin.y, self.view.frame.size.width-170, messageText.frame.size.height);
        timesent.frame = CGRectMake(5, timesent.frame.origin.y, timesent.frame.size.width, timesent.frame.size.height);
        
        borderImageViewForUser.frame = CGRectMake(20, borderImageViewForUser.frame.origin.y, borderImageViewForUser.frame.size.width, borderImageViewForUser.frame.size.height);
        
        customButton.frame = CGRectMake(20, customButton.frame.origin.y, customButton.frame.size.width, customButton.frame.size.height);
        
        userImageView.frame = CGRectMake(22, userImageView.frame.origin.y, userImageView.frame.size.width, userImageView.frame.size.height);
        
        backgroundView.frame = CGRectMake(120, backgroundView.frame.origin.y, backgroundView.frame.size.width, backgroundView.frame.size.height);
        arrowImageView.frame = CGRectMake(backgroundView.frame.origin.x-10, backgroundView.frame.origin.y-2, arrowImageView.frame.size.width, arrowImageView.frame.size.height);
    }
    else{
        messageText.frame = CGRectMake(90, messageText.frame.origin.y, self.view.frame.size.width-140, messageText.frame.size.height);
        timesent.frame = CGRectMake(5, timesent.frame.origin.y, timesent.frame.size.width, timesent.frame.size.height);
        borderImageViewForUser.frame = CGRectMake(10, borderImageViewForUser.frame.origin.y, borderImageViewForUser.frame.size.width, borderImageViewForUser.frame.size.height);
        customButton.frame = CGRectMake(10, customButton.frame.origin.y, customButton.frame.size.width, customButton.frame.size.height);
        userImageView.frame = CGRectMake(12, userImageView.frame.origin.y, userImageView.frame.size.width, userImageView.frame.size.height);
        backgroundView.frame = CGRectMake(80, backgroundView.frame.origin.y, backgroundView.frame.size.width, backgroundView.frame.size.height);
        arrowImageView.frame = CGRectMake(backgroundView.frame.origin.x-10, backgroundView.frame.origin.y-2, arrowImageView.frame.size.width, arrowImageView.frame.size.height);
    }
    NSString*str = [dictData objectForKey:@"messageTime"];
    str =[NSString stringWithFormat:@"%@:%@", [[[[str componentsSeparatedByString:@" "] objectAtIndex:1] componentsSeparatedByString:@":"] objectAtIndex:0],[[[[str componentsSeparatedByString:@" "] objectAtIndex:1] componentsSeparatedByString:@":"] objectAtIndex:1]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    //[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSDate *date = [dateFormatter dateFromString:str];
    dateFormatter.dateFormat = @"hh:mm a";
    //[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *pmamDateString = [dateFormatter stringFromDate:date];
    NSLog(@"%@",pmamDateString);
    timesent.text = pmamDateString;
    
    //NSLog(@"message sent time is : %@ and original time is : %@",timesent.text,str);
    messageText.text = [dictData objectForKey:@"lastMessage"];
    
    int labelfontSize;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        labelfontSize =24;
    }
    else{
        labelfontSize =13;
    }
    CGSize constraintSize;
    constraintSize.height = MAXFLOAT;
    constraintSize.width = MAXFLOAT;
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Light" size:labelfontSize], NSFontAttributeName,nil];
    CGRect frame = [messageText.text boundingRectWithSize:constraintSize
                                                  options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary context:nil];
    
    CGSize stringSize = frame.size;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if (stringSize.width>self.view.frame.size.width-170) {
            stringSize.width= self.view.frame.size.width-170;
            constraintSize.width = stringSize.width;
            frame = [messageText.text boundingRectWithSize:constraintSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary context:nil];
            stringSize = frame.size;
        }
    }
    else{
        if (stringSize.width>self.view.frame.size.width-140) {
            stringSize.width= self.view.frame.size.width-140;
            constraintSize.width = stringSize.width;
            frame = [messageText.text boundingRectWithSize:constraintSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary context:nil];
            stringSize = frame.size;
            
        }
    }
    if ([[dictData objectForKey:USERTYPE] isEqualToString:@"2"])
    {
        [arrowImageView setImage:[UIImage imageNamed:@"Rounded Rectangle 5 copy 21.png"]];
        messageText.frame = CGRectMake(messageText.frame.origin.x, messageText.frame.origin.y, stringSize.width+20, stringSize.height+3);
        backgroundView.frame = CGRectMake(messageText.frame.origin.x-10, messageText.frame.origin.y-10, messageText.frame.size.width+20, stringSize.height+20);
        arrowImageView.frame = CGRectMake(backgroundView.frame.origin.x-10, backgroundView.frame.origin.y-2, arrowImageView.frame.size.width, arrowImageView.frame.size.height);
        borderImageViewForUser.frame = CGRectMake(borderImageViewForUser.frame.origin.x, borderImageViewForUser.frame.origin.y, borderImageViewForUser.frame.size.width, borderImageViewForUser.frame.size.height);
        customButton.frame = CGRectMake(customButton.frame.origin.x, customButton.frame.origin.y, customButton.frame.size.width, customButton.frame.size.height);
        userImageView.frame = CGRectMake(userImageView.frame.origin.x, userImageView.frame.origin.y, userImageView.frame.size.width, userImageView.frame.size.height);
        
        [userImageView setImage:rivalImageView.image];
        
        timesent.frame = CGRectMake(timesent.frame.origin.x, borderImageViewForUser.frame.origin.y+borderImageViewForUser.frame.size.height+3, timesent.frame.size.width, timesent.frame.size.height);
    }
    else{
        [arrowImageView setImage:[UIImage imageNamed:@"Rounded Rectangle 5 copy 2.png"]];
        borderImageViewForUser.layer.borderColor = [UIColor colorWithRed:63.0f/255.0f green:156.0f/255.0f blue:220.0f/255.0f alpha:1].CGColor;
        borderImageViewForUser.layer.borderWidth = 2.f;
        backgroundView.backgroundColor = [UIColor colorWithRed:206.0f/255.0f green:240.0f/255.0f blue:255.0f/255.0f alpha:1];
        timesent.textColor = [UIColor colorWithRed:123.0f/255.0f green:160.0f/255.0f blue:180.0f/255.0f alpha:1];
        
        borderImageViewForUser.frame = CGRectMake(self.view.frame.size.width-borderImageViewForUser.frame.size.width-20, borderImageViewForUser.frame.origin.y, borderImageViewForUser.frame.size.width, borderImageViewForUser.frame.size.height);
        
        customButton.frame = CGRectMake(borderImageViewForUser.frame.origin.x, borderImageViewForUser.frame.origin.y, customButton.frame.size.width, customButton.frame.size.height);
        
        userImageView.frame = CGRectMake(borderImageViewForUser.frame.origin.x+2, userImageView.frame.origin.y, userImageView.frame.size.width, userImageView.frame.size.height);
        [userImageView setImage:loginImageView.image];
        
        messageText.frame = CGRectMake(borderImageViewForUser.frame.origin.x-stringSize.width-40, messageText.frame.origin.y, stringSize.width+20, stringSize.height+3);
        
        backgroundView.frame = CGRectMake(messageText.frame.origin.x-10, messageText.frame.origin.y-10, messageText.frame.size.width+20, stringSize.height+20);
        
        arrowImageView.frame = CGRectMake(backgroundView.frame.origin.x+backgroundView.frame.size.width-20, backgroundView.frame.origin.y-2, arrowImageView.frame.size.width, arrowImageView.frame.size.height);
        timesent.frame = CGRectMake(borderImageViewForUser.frame.origin.x-5, borderImageViewForUser.frame.origin.y+borderImageViewForUser.frame.size.height+3, timesent.frame.size.width, timesent.frame.size.height);
        
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int labelfontSize;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        labelfontSize =24;
    }
    else{
        labelfontSize =13;
        
    }
    CGSize constraintSize;
    constraintSize.height = MAXFLOAT;
    constraintSize.width = MAXFLOAT;
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:@"HelveticaNeue-Light" size:labelfontSize], NSFontAttributeName,
                                          nil];
    NSString*messageStr;
    if ([[[[mainObjectArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"lastMessage"] isKindOfClass:[NSString class]])
    {
        messageStr = [[[mainObjectArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"lastMessage"];
    }
    
    CGRect frame = [messageStr boundingRectWithSize:constraintSize
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:attributesDictionary
                                            context:nil];
    
    
    CGSize stringSize = frame.size;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if (stringSize.width>self.view.frame.size.width-170) {
            stringSize.width= self.view.frame.size.width-170;
            constraintSize.width = stringSize.width;
            frame = [messageStr boundingRectWithSize:constraintSize
                                             options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary context:nil];
            stringSize = frame.size;
        }
    }
    else{
        if (stringSize.width>self.view.frame.size.width-140) {
            stringSize.width= self.view.frame.size.width-140;
            constraintSize.width = stringSize.width;
            frame = [messageStr boundingRectWithSize:constraintSize
                                             options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary context:nil];
            stringSize = frame.size;
            
        }
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if (stringSize.height<70) {
            stringSize.height = 70;
        }
        return stringSize.height+80;
    }
    else{
        if (stringSize.height<60) {
            stringSize.height = 60;
        }
        return stringSize.height+45;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[mainObjectArray objectAtIndex:section] count];
}

#pragma mark Others Delegate
-(void)customButtonPressed :(id)sender
{
    [APPDELEGATE disconnect];
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:dataTableVw];
    NSIndexPath *indexPath = [dataTableVw indexPathForRowAtPoint:buttonPosition];
    NSLog(@"%ld %ld",(long)indexPath.row,(long)indexPath.section);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        bottomView.frame=CGRectMake(bottomView.frame.origin.x,[[UIScreen mainScreen] bounds].size.height-80, bottomView.frame.size.width, bottomView.frame.size.height);
    }
    else{
        bottomView.frame=CGRectMake(bottomView.frame.origin.x,[[UIScreen mainScreen] bounds].size.height-60, bottomView.frame.size.width, bottomView.frame.size.height);
    }
    dataTableVw.frame = CGRectMake(dataTableVw.frame.origin.x, dataTableVw.frame.origin.y, dataTableVw.frame.size.width, tableViewHeight);
    [messageTextView resignFirstResponder];
    
    ProfileViewController*obj;
    obj=[self.storyboard instantiateViewControllerWithIdentifier:@"profileController"];
    
    if ([[[[mainObjectArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:USERTYPE] isEqualToString:@"1"])
    {
        // self user
        //obj.userIDShowProfile = userIdString;
    }
    else{
        // userIdString
        obj.userIDShowProfile = userIdString;
    }
    obj.comeFromSring =@"1";
    [self.navigationController pushViewController:obj animated:YES];
}
- (void) textViewDidChange:(UITextView *)textView
{
    NSString *str=[messageTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (str.length>0)
    {
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sendButton.userInteractionEnabled = YES;
    }
    else{
        [sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        sendButton.userInteractionEnabled = NO;
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}
- (IBAction)sendAction:(id)sender {
    
    messageTextView.text = [messageTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([messageTextView.text isEqualToString:@""] || messageTextView.text.length<=0 ) {
        
    }
    else{
        
        
        if (![APPDELEGATE xmppStream]) {
            [APPDELEGATE setupStream];
        }
        
        [APPDELEGATE startXMPPConnection];
        
        if ([messageTextView.text isEqualToString:@""])
        {
            [sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            sendButton.userInteractionEnabled = NO;
        }else
        {
            [self dismissKeyboard];
            [constant alertViewWithMessage:@"Connecitvity is low." withView:self];
        }
        
    }
}

-(void)messageSend
{
    [[APPDELEGATE xmppMessenger] setTargetJID:[XMPPJID jidWithString:[_oppennetXmppID.lowercaseString stringByAppendingFormat:@"@%@",IPAddress]]];
    [[APPDELEGATE xmppMessenger] sendMessage:messageTextView.text];
    messageTextView.text = @"";
    [self getChatData];
}
- (IBAction)popView:(id)sender
{
    Database *objDatabase = [Database sharedObject];

    from = _myXmppID;
    to = _oppennetXmppID;
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"yy/MM/dd HH:mm:ss.SSS"];
    NSDate *date =[formatter dateFromString:[[mainArray lastObject] objectForKey:@"messageTime"]];
    
    NSDateFormatter *formatter1=[[NSDateFormatter alloc]init];
    [formatter1 setTimeZone:[NSTimeZone localTimeZone]];
    [formatter1 setDateFormat:@"yy/MM/dd HH:mm:ss.SSS"];
    NSString *strDateTime = [formatter1 stringFromDate:date];
    NSString *strFinalOpponentName = @"";
    NSDictionary *dicTemp;
    dicTemp = [NSDictionary dictionaryWithObjectsAndKeys:[[mainArray lastObject] objectForKey:@"lastMessage"], @"lastMessage",
               from.uppercaseString, @"lastMessageFromUser",
               strDateTime, @"messageTime",
               to.uppercaseString, @"opponentXMPPID",
               strFinalOpponentName,@"opponentDisplayName",
               @"1",@"isRead",@"2",@"userType",
               nil];
    
    int tID1 = (int)[objDatabase insertToTable:@"lastMessageMaster" withValues:dicTemp];
    NSLog(@"%d",tID1);
    
    NSString *strUpdateQuery = [NSString stringWithFormat:@"update lastMessageMaster set isRead = '1' where (opponentXMPPID = '%@' AND lastMessageFromUser= '%@') OR (opponentXMPPID = '%@' AND lastMessageFromUser= '%@')",from.uppercaseString,to.uppercaseString,to.uppercaseString,from.uppercaseString];
    
    BOOL isUpdated = [objDatabase updateData:strUpdateQuery];
    if (isUpdated) {
        NSLog(@"Table Update successfully");
    }

    
    [APPDELEGATE disconnect];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)endChat:(id)sender
{
    
    [messageTextView resignFirstResponder];
    [self dismissAndSetFrame];
    
    UIAlertView*alert= [[UIAlertView alloc]initWithTitle:nil message:@"Are you sure you would like to end your chat session?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    alert.tag = 1200;
    [alert show];
}
-(void)dismissAndSetFrame
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        bottomView.frame=CGRectMake(bottomView.frame.origin.x,[[UIScreen mainScreen] bounds].size.height-80, bottomView.frame.size.width, bottomView.frame.size.height);
    }
    else{
        bottomView.frame=CGRectMake(bottomView.frame.origin.x,[[UIScreen mainScreen] bounds].size.height-60, bottomView.frame.size.width, bottomView.frame.size.height);
        
    }
    dataTableVw.frame = CGRectMake(dataTableVw.frame.origin.x, dataTableVw.frame.origin.y, dataTableVw.frame.size.width, tableViewHeight);
}
-(void)runAPIEndChat
{
    
    [appdelegateInstance showHUD:@""];
    LxReqRespManager *rrManager=[[LxReqRespManager alloc]initLxReqRespManagerWithDelegate:self];
    NSString*strWebService;
    NSLog(@"%@",strWebService);
    NSDictionary *dictParams;
    dictParams=[[NSDictionary alloc]initWithObjectsAndKeys:
                [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"],@"user_id",
                userIdString,@"to_user_id",
                strPitchId,@"pitch_id",
                nil];
    if ([[USERDEFAULTS objectForKey:@"userTypeString"] isEqualToString:@"1"])
    {
        strWebService = [[NSString alloc]initWithFormat:@"%@end_chat_pitcher",AppURL];
    }else
    {
        strWebService = [[NSString alloc]initWithFormat:@"%@end_chat_jounalist",AppURL];
        
    }
    NSLog(@"%@",dictParams);
    
    [rrManager requestAPIWithURL:strWebService withParameters:dictParams withCallBackHandler:^(id response, NSError *error)
     {
         if (!error)
         {
             NSLog(@"response of get request:%@",response);
             [appdelegateInstance hideHUD];
             NSString*str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
             if ([str isEqualToString:@"0"] )
             {
                 [APPDELEGATE disconnect];
                 [self.navigationController popViewControllerAnimated:YES];
                 [self deleteChat];
                 
                 
             }
             else if ([str isEqualToString:@"1"])
             {
                 
             }
             else if ([str isEqualToString:@"10"] )
             {
                 UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                 alert.tag = 1234;
                 [alert show];
             }
         }
         else
         {
             [messageTextView becomeFirstResponder];
             
             [appdelegateInstance hideHUD];
             
             [constant AlertMessageWithString:@"Connectivity levels low. Please try again." andWithView:self.view];

//             [constant alertViewWithMessage:@"Connectivity levels low. Please try again."withView:self];
             NSLog(@"Error returned:%@",[error localizedDescription]);
         }
     }];
}
-(void)deleteChat
{
    
    NSString *strQuery = [NSString stringWithFormat:@"delete from latestMessageMaster WHERE (opponentXMPPID = '%@' AND lastMessageFromUser= '%@') OR (opponentXMPPID = '%@' AND lastMessageFromUser= '%@')", from.uppercaseString, to.uppercaseString,to.uppercaseString,from.uppercaseString];
    
    BOOL isDelete = [[Database sharedObject] deleteData:strQuery];
    
    if (isDelete)
    {
        NSLog(@"Delete the chat history");
    }
    else {
        NSLog(@"Something went wrong");
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1234) {
        AppDelegate *appd= (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appd LogoutFromApp:self];
    }
    if (alertView.tag==1200) {
        if (buttonIndex==0) {
            //            [messageTextView resignFirstResponder];
            //
            //            [self dismissAndSetFrame];
            
        }
        else if(buttonIndex==1) {
            [self runAPIEndChat];
            
        }
        
        
        
    }
    
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
             tableViewHeight = 863-50;
             [dataTableVw reloadData];
         }
         else if (orientation == UIInterfaceOrientationLandscapeLeft ||
                  orientation == UIInterfaceOrientationLandscapeRight)
         {
             tableViewHeight = 588-30;
             [dataTableVw reloadData];
         }
         
         // do whatever
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}
@end
