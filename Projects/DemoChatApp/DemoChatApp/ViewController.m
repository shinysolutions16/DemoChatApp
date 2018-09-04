//
//  ViewController.m
//  DemoChatApp
//
//  Created by Pranshi on 8/31/18.
//  Copyright © 2018 Shiny Solutions. All rights reserved.
//

#import "ViewController.h"
#import "ChatTableViewCell.h"
#import "MessageModal.h"

#define kOFFSET_FOR_KEYBOARD 80.0

@interface ViewController ()
@property (nonatomic) NSMutableArray *allMessages;
//Subview(s)
@property (nonatomic) UIView *viewBar;
@property (nonatomic) UITextField *messageTV;
@property (nonatomic) UIButton *sendButton;
@property (nonatomic) CGPoint kContentOffset;
@end

@implementation ViewController

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@synthesize messageArray;
@synthesize chatArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"viewDidLoad");
    
    [self.callapsingHeaderView setDelegate:self];
    NSLog(@"viewDidLoad - delegate");
    [self.callapsingHeaderView setCollapsingConstraint:self.heightCollapsingHeader];
    NSLog(@"viewDidLoad - height");
    
    [self.callapsingHeaderView addFadingSubview:self.imageLeftArrow fadeBy:0.3];
    
    [self prepareData];
    
    [self createExampleChat];
    
    double screenWidth = self.view.frame.size.width;
    
    UIView *viewB = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, screenWidth+1, 50)];
    viewB.backgroundColor = [UIColor whiteColor];
    viewB.layer.borderWidth = 1.0;
    viewB.layer.borderColor = [Rgb2UIColor(204, 204, 204) CGColor];
    
    self.messageTV = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, screenWidth-80, 30)];
    self.messageTV.layer.cornerRadius = 5.0;
    self.messageTV.clipsToBounds = YES;
    self.messageTV.layer.borderColor = [[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor];
    self.messageTV.layer.borderWidth = 1.0;
    self.messageTV.font = [UIFont systemFontOfSize:16];
    self.messageTV.delegate = self;
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.sendButton.frame = CGRectMake(screenWidth-70, 0, 70, 50);
    [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.messageTV];
    [viewB addSubview:self.sendButton];
    
    self.viewBar = viewB;
    
    [viewB addSubview:self.messageTV];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)canBecomeFirstResponder{
    
    return YES;
}

- (UIView *)inputAccessoryView{
    
    return self.viewBar;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

#pragma mark -
#pragma mark Prepare Message data
-(void) prepareData{
    NSLog(@"prepareData");
    
    MessageModal *messageModal = [[MessageModal alloc] init];
    messageModal.message = @"Hi";
    messageModal.type = @"Sent";
    [self.messageArray addObject:messageModal];
    [self.chatArray addObject:messageModal];
    
    NSLog(@"prepareData %lu", (unsigned long)[self.messageArray count]);
    
    messageModal = [[MessageModal alloc] init];
    messageModal.message = @"Hi";
    messageModal.type = @"Receive";
    [self.messageArray addObject:messageModal];
    [self.chatArray addObject:messageModal];
    
    messageModal = [[MessageModal alloc] init];
    messageModal.message = @"I am Marie Jackson";
    messageModal.type = @"Sent";
    [self.messageArray addObject:messageModal];
    [self.chatArray addObject:messageModal];
    
    messageModal = [[MessageModal alloc] init];
    messageModal.message = @"I am Will smith";
    messageModal.type = @"Receive";
    [self.messageArray addObject:messageModal];
    [self.chatArray addObject:messageModal];
}

#pragma mark --
#pragma mark Message view
-(void) prepareMessageView{
    NSLog(@"prepareMessageView");
    UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableviewChat.frame.size.width, 50)];
    
    UIButton *buttonCamera = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [buttonCamera setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [viewFooter addSubview:buttonCamera];
    
    UITextField *textMessage = [[UITextField alloc] initWithFrame:CGRectMake(50, 10, self.tableviewChat.frame.size.width - 60, 30)];
    [textMessage setBorderStyle:UITextBorderStyleLine];
    [textMessage setPlaceholder:@"Message"];
    UIButton *buttonRecord = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonRecord setImage:[UIImage imageNamed:@"microphone"] forState:UIControlStateNormal];
    [textMessage setRightViewMode:UITextFieldViewModeAlways];
    [textMessage setRightView:buttonRecord];
    [viewFooter addSubview:textMessage];
    
    [self.tableviewChat setTableFooterView:viewFooter];
}

#pragma mark --
#pragma mark Text field delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn");
    return NO;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSLog(@"textFieldShouldBeginEditing");
    CGPoint pointInTable = [textField.superview convertPoint:textField.inputAccessoryView.frame.origin toView:self.tableviewChat];
    NSLog(@"textFieldShouldBeginEditing x:%f y:%f", pointInTable.x, pointInTable.y);
    CGPoint contentOffset = self.tableviewChat.contentOffset;
    self.kContentOffset = contentOffset;
    
    contentOffset.y = (pointInTable.y - textField.inputAccessoryView.frame.size.height);
    
    NSLog(@"contentOffset is: %@", NSStringFromCGPoint(contentOffset));
    
    [self.tableviewChat setContentOffset:contentOffset animated:YES];
    
    return YES;
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldShouldEndEditing");
    [textField resignFirstResponder];
    
    [self.tableviewChat setContentOffset:self.kContentOffset];
    
    if ([textField.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        NSLog(@"textFieldShouldEndEditing");
        UITableViewCell *cell = (UITableViewCell*)textField.superview.superview;
        NSIndexPath *indexPath = [self.tableviewChat indexPathForCell:cell];
        
        [self.tableviewChat scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:TRUE];
    }
    
    return YES;
}

#pragma mark --
#pragma mark Keyboard up and down
//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    NSLog(@"setViewMovedUp");
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

-(void)keyboardWillShow {
    NSLog(@"keyboardWillShow");
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    NSLog(@"keyboardWillHide");
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

#pragma mark -
#pragma mark Tableview data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRowsInSection");
    return self.allMessages.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRowAtIndexPath");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UIView *chatBubble = [self.allMessages objectAtIndex:indexPath.row];
    chatBubble.tag = indexPath.row;
    
    for (int i=0; i<cell.contentView.subviews.count; i++)
    {
        UIView *subV = cell.contentView.subviews[i];
        
        if (subV.tag != chatBubble.tag)
            [subV removeFromSuperview];
        
    }
    
    [cell.contentView addSubview:chatBubble];
    
    cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *bubble = self.allMessages[indexPath.row];
    return bubble.frame.size.height+20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.messageTV resignFirstResponder];
}
/*
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    
    UIButton *buttonCamera = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [buttonCamera setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [viewFooter addSubview:buttonCamera];
    
    UITextField *textMessage = [[UITextField alloc] initWithFrame:CGRectMake(50, 10, tableView.frame.size.width - 60, 30)];
    [textMessage setBorderStyle:UITextBorderStyleLine];
    [textMessage setPlaceholder:@"Message"];
    UIButton *buttonRecord = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonRecord setImage:[UIImage imageNamed:@"microphone"] forState:UIControlStateNormal];
    [textMessage setRightViewMode:UITextFieldViewModeAlways];
    [textMessage setRightView:buttonRecord];
    [viewFooter addSubview:textMessage];
    
    return viewFooter;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50.0;
}
*/
#pragma mark -
#pragma mark Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll");
    [self.callapsingHeaderView collapseWithScroll:scrollView];
}

#pragma mark -
#pragma mark Collapsing Header Delegate

- (void)headerDidCollapseToOffset:(double)offset
{
    NSLog(@"collapse %.4f", offset);
}
- (void)headerDidFinishCollapsing
{
    NSLog(@"collapsed!!!");
}
- (void)headerDidExpandToOffset:(double)offset
{
    NSLog(@"expand %.4f", offset);
}
- (void)headerDidFinishExpanding
{
    NSLog(@"expanded!!!");
}

#pragma mark - Other functions

- (void)createExampleChat
{
    
    NSLog(@"createExampleChat");
    NSMutableArray *bubbles = [[NSMutableArray alloc] init];
    
    //Current date and time formatted string
    NSString *dateTimeString = [self getDateTimeStringFromNSDate:[NSDate date]];
    
    //Some custom hardcoded messages
    //Example 1
    /*
     UIView *msg0 = [self createMessageWithScreenWidth:screenWidth Text:@"Hi!" Image:nil DateTime:dateTimeString isReceived:1];
     UIView *msg1 = [self createMessageWithScreenWidth:screenWidth Text:@"Hey, ssup ?" Image:nil DateTime:dateTimeString isReceived:0];
     UIView *msg2 = [self createMessageWithScreenWidth:screenWidth Text:@"Yeah uh huh you know what it iss...." Image:nil DateTime:dateTimeString isReceived:1];
     UIView *msg3 = [self createMessageWithScreenWidth:screenWidth Text:@"Black and yellow black and yellow black and yellow black and yellow" Image:[UIImage imageNamed:@"blackAndYellow.jpeg"] DateTime:dateTimeString isReceived:0];
     */
    
    //Example 2
    UIView *msg0 = [self createMessageWithText:@"Hey! Movie tonight?" Image:nil DateTime:dateTimeString isReceived:1];
    UIView *msg1 = [self createMessageWithText:@"Which?" Image:nil DateTime:dateTimeString isReceived:0];
    UIView *msg2 = [self createMessageWithText:@"Kung fu panda 3" Image:nil DateTime:dateTimeString isReceived:1];
    UIView *msg3 = [self createMessageWithText:@"I'm in." Image:nil DateTime:dateTimeString isReceived:0];
    UIView *msg4 = [self createMessageWithText:@"Great, i'll get the tickets." Image:nil DateTime:dateTimeString isReceived:1];
    UIView *msg5 = [self createMessageWithText:@"Anyways, what about that new job opening you told me about. Can i still apply ?" Image:nil DateTime:dateTimeString isReceived:1];
    UIView *msg6 = [self createMessageWithText:@"Just wondering..." Image:nil DateTime:dateTimeString isReceived:1];
    UIView *msg7 = [self createMessageWithText:@"Yes, you can. Let me refer you to my Manager." Image:nil DateTime:dateTimeString isReceived:0];
    UIView *msg8 = [self createMessageWithText:@"Thanks a lot dude !" Image:nil DateTime:dateTimeString isReceived:1];
    
    [bubbles addObject:msg0];
    [bubbles addObject:msg1];
    [bubbles addObject:msg2];
    [bubbles addObject:msg3];
    [bubbles addObject:msg4];
    [bubbles addObject:msg5];
    [bubbles addObject:msg6];
    [bubbles addObject:msg7];
    [bubbles addObject:msg8];
    
    //Populate data in the chat table
    self.allMessages = bubbles;
    [self.tableviewChat reloadData];
    
    //Scroll the table to bottom
    [self scrollToTheBottom:NO];
}

- (void)scrollToTheBottom:(BOOL)animated
{
    NSLog(@"scrollToTheBottom");
    /*
    if (self.allMessages.count>0)
    {
        
         NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.allMessages.count-1 inSection:0];
        [self.tableviewChat scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
     
    }
    */
    /*
    [self.tableviewChat setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
     */
    if (self.tableviewChat.contentSize.height > self.tableviewChat.frame.size.height) {
        CGPoint offset = CGPointMake(0, self.tableviewChat.contentSize.height - self.tableviewChat.frame.size.height);
        [self.tableviewChat setContentOffset:offset animated:animated];
    }
}

- (NSString*)getDateTimeStringFromNSDate: (NSDate*)date
{
    NSLog(@"getDateTimeStringFromNSDate");
    NSString *dateTimeString = @"";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM, hh:mm a"];
    dateTimeString = [dateFormatter stringFromDate:date];
    
    return dateTimeString;
}

#pragma mark - Message UI creation function(s)

- (UIView*)createMessageWithText: (NSString*)text Image: (UIImage*)image DateTime: (NSString*)dateTimeString isReceived: (BOOL)isReceived
{
    NSLog(@"createMessageWithText");
    //Get screen width
    double screenWidth = self.view.frame.size.width;
    
    CGFloat maxBubbleWidth = screenWidth-50;
    
    UIView *outerView = [[UIView alloc] init];
    
    UIView *chatBubbleView = [[UIView alloc] init];
    chatBubbleView.backgroundColor = [UIColor whiteColor];
    chatBubbleView.layer.masksToBounds = YES;
    chatBubbleView.clipsToBounds = NO;
    chatBubbleView.layer.cornerRadius = 4;
    chatBubbleView.layer.shadowOffset = CGSizeMake(0, 0.7);
    chatBubbleView.layer.shadowRadius = 4;
    chatBubbleView.layer.shadowOpacity = 0.4;
    
    UIView *chatBubbleContentView = [[UIView alloc] init];
    chatBubbleContentView.backgroundColor = [UIColor whiteColor];
    chatBubbleContentView.clipsToBounds = YES;
    
    //Add time
    UILabel *chatTimeLabel;
    if (dateTimeString != nil)
    {
        chatTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 16)];
        chatTimeLabel.font = [UIFont systemFontOfSize:10];
        chatTimeLabel.text = dateTimeString;
        chatTimeLabel.textColor = [UIColor lightGrayColor];
        
        [chatBubbleContentView addSubview:chatTimeLabel];
    }
    
    //Add Image
    UIImageView *chatBubbleImageView;
    if (image != nil)
    {
        chatBubbleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 26, maxBubbleWidth-30, maxBubbleWidth-30)];
        chatBubbleImageView.image = image;
        chatBubbleImageView.contentMode = UIViewContentModeScaleAspectFill;
        chatBubbleImageView.layer.masksToBounds = YES;
        chatBubbleImageView.layer.cornerRadius = 4;
        
        [chatBubbleContentView addSubview:chatBubbleImageView];
    }
    
    //Add Text
    UILabel *chatBubbleLabel;
    if (text != nil)
    {
        UIFont *messageLabelFont = [UIFont systemFontOfSize:16];
        
        CGSize maximumLabelSize;
        if (chatBubbleImageView != nil)
        {
            maximumLabelSize = CGSizeMake(chatBubbleImageView.frame.size.width, 1000);
            
            CGSize expectedLabelSize = [text sizeWithFont:messageLabelFont constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
            
            chatBubbleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 21+chatBubbleImageView.frame.size.height, expectedLabelSize.width, expectedLabelSize.height+10)];
        }
        else
        {
            maximumLabelSize = CGSizeMake(maxBubbleWidth, 1000);
            
            CGSize expectedLabelSize = [text sizeWithFont:messageLabelFont constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
            
            chatBubbleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, expectedLabelSize.width, expectedLabelSize.height)];
        }
        
        chatBubbleLabel.frame = CGRectMake(chatBubbleLabel.frame.origin.x, chatBubbleLabel.frame.origin.y+5, chatBubbleLabel.frame.size.width, chatBubbleLabel.frame.size.height+10);
        
        chatBubbleLabel.text = text;
        chatBubbleLabel.font = messageLabelFont;
        chatBubbleLabel.numberOfLines = 100;
        
        [chatBubbleContentView addSubview:chatBubbleLabel];
    }
    
    [chatBubbleView addSubview:chatBubbleContentView];
    
    CGFloat totalHeight = 0;
    CGFloat decidedWidth = 0;
    for (UIView *subView in chatBubbleContentView.subviews)
    {
        totalHeight += subView.frame.size.height;
        
        CGFloat width = subView.frame.size.width;
        if (decidedWidth < width)
            decidedWidth = width;
    }
    
    chatBubbleContentView.frame = CGRectMake(5, 5, decidedWidth, totalHeight);
    chatBubbleView.frame = CGRectMake(10, 10, chatBubbleContentView.frame.size.width+10, chatBubbleContentView.frame.size.height+10);
    
    outerView.frame = CGRectMake(7, 0, chatBubbleView.frame.size.width, chatBubbleView.frame.size.height);
    
    UIImageView *arrowIV = [[UIImageView alloc] init];
    [outerView addSubview:chatBubbleView];
    arrowIV.image = [UIImage imageNamed:@"chat_arrow"];
    arrowIV.clipsToBounds = NO;
    arrowIV.layer.shadowRadius = 4;
    arrowIV.layer.shadowOpacity = 0.4;
    arrowIV.layer.shadowOffset = CGSizeMake(-7.0, 0.7);
    arrowIV.layer.zPosition = 1;
    arrowIV.frame = CGRectMake(chatBubbleView.frame.origin.x-7, chatBubbleView.frame.size.height-10, 11, 14);
    
    if (isReceived == 0)
    {
        chatBubbleContentView.frame = CGRectMake(5, 5, decidedWidth, totalHeight);
        chatBubbleView.frame = CGRectMake(screenWidth-(chatBubbleContentView.frame.size.width+10)-10, 10, chatBubbleContentView.frame.size.width+10, chatBubbleContentView.frame.size.height+10);
        
        /*
         chatBubbleView.backgroundColor = Rgb2UIColor(191,179,183);
         chatTimeLabel.backgroundColor = Rgb2UIColor(191,179,183);
         chatBubbleLabel.backgroundColor = Rgb2UIColor(191,179,183);
         chatBubbleContentView.backgroundColor = Rgb2UIColor(191,179,183);
         */
        
        arrowIV.transform = CGAffineTransformMakeScale(-1, 1);
        arrowIV.frame = CGRectMake(chatBubbleView.frame.origin.x+chatBubbleView.frame.size.width-4, chatBubbleView.frame.size.height-10, 11, 14);
        
        outerView.frame = CGRectMake(screenWidth-((screenWidth+chatBubbleView.frame.size.width)-chatBubbleView.frame.size.width)-7, 0, chatBubbleView.frame.size.width, chatBubbleView.frame.size.height);
        
        //arrowIV.image = [arrowIV.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        //[arrowIV setTintColor:Rgb2UIColor(191,179,183)];
    }
    
    [outerView addSubview:arrowIV];
    
    return outerView;
}

#pragma mark - Buttons' Actions

- (void)sendAction: (id)selector
{
    UIView *newMsg = [self createMessageWithText:self.messageTV.text Image:nil DateTime:[self getDateTimeStringFromNSDate:[NSDate date]] isReceived:0];
    
    [self.allMessages addObject:newMsg];
    [self.tableviewChat reloadData];
    [self scrollToTheBottom:YES];
    
    [self.messageTV resignFirstResponder];
    self.messageTV.text = @"";
}

@end
