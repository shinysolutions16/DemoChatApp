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

@interface ViewController ()

@end

@implementation ViewController

@synthesize messageArray;
@synthesize chatArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.callapsingHeaderView setDelegate:self];
    [self.callapsingHeaderView setCollapsingConstraint:self.heightCollapsingHeader];
    
    dataArray = [[NSMutableArray alloc] initWithObjects:@"hi", @"hi", nil];
    
    [self prepareData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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

#pragma mark -
#pragma mark Tableview data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRowsInSection");
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRowAtIndexPath");
    ChatTableViewCell *cell = (ChatTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"ChatTableViewCell" forIndexPath:indexPath];
    
    NSLog(@"cellForRowAtIndexPath - indexpath");
    MessageModal *messageModal = (MessageModal *) [self.chatArray objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        [cell.right_chat setHidden:YES];
        [cell.left_chat setHidden:NO];
        [cell.left_chat setTitle:@"TEST" forState:UIControlStateNormal];
    }else {
        [cell.right_chat setHidden:NO];
        [cell.left_chat setHidden:YES];
        [cell.right_chat setTitle:@"TEST" forState:UIControlStateNormal];
    }
    NSLog(@"cellForRowAtIndexPath - background");
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
}

#pragma mark -
#pragma mark Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
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

@end
