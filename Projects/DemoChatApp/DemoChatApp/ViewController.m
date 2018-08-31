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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.callapsingHeaderView setDelegate:self];
    [self.callapsingHeaderView setCollapsingConstraint:self.heightCollapsingHeader];
    
    [self.tableviewChat setDelegate:self];
    [self.tableviewChat setDataSource:self];
    
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
    
    NSLog(@"prepareData %lu", (unsigned long)[self.messageArray count]);
    
    messageModal = [[MessageModal alloc] init];
    messageModal.message = @"Hi";
    messageModal.type = @"Receive";
    [self.messageArray addObject:messageModal];
    
    messageModal = [[MessageModal alloc] init];
    messageModal.message = @"I am Marie Jackson";
    messageModal.type = @"Sent";
    [self.messageArray addObject:messageModal];
    
    messageModal = [[MessageModal alloc] init];
    messageModal.message = @"I am Will smith";
    messageModal.type = @"Receive";
    [self.messageArray addObject:messageModal];
    
}

#pragma mark -
#pragma mark Tableview data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRowsInSection %lu", (unsigned long)self.messageArray.count);
    return self.messageArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatTableViewCell *cell = (ChatTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"ChatTableViewCell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChatTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    MessageModal *messageModal = (MessageModal *)[self.messageArray objectAtIndex:indexPath.row];
    if ([messageModal.type isEqualToString:@"Sent"]) {
        UIImageView *labelBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"left_chat.9"]];
        [cell.labelMessage addSubview:labelBackground];
        cell.labelMessage.backgroundColor = [UIColor clearColor];
    } else if ([messageModal.type isEqualToString:@"Receive"]){
        UIImageView *labelBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_chat.9"]];
        [cell.labelMessage addSubview:labelBackground];
        cell.labelMessage.backgroundColor = [UIColor clearColor];
    }
    cell.labelMessage.text   = messageModal.message;
    
    return cell;
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
