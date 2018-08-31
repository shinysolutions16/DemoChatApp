//
//  ChatTableViewCell.h
//  DemoChatApp
//
//  Created by Pranshi on 8/31/18.
//  Copyright © 2018 Shiny Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelMessage;
@property (weak, nonatomic) IBOutlet UIButton *left_chat;
@property (weak, nonatomic) IBOutlet UIButton *right_chat;

@end
