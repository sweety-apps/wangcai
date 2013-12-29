//
//  InviteController.h
//  wangcai
//
//  Created by 1528 on 13-12-11.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InviterUpdate.h"

@interface InviteController : UIViewController <InviterUpdateDelegate>
{
    InviterUpdate* _inviterUpdate;
}

@property (assign, nonatomic) IBOutlet UIView *containerView;
@property (assign, nonatomic) IBOutlet UISegmentedControl *segment;

@property (retain, nonatomic) IBOutlet UIView *inviteView;
@property (assign, nonatomic) IBOutlet UITextField *inviteUrlTextField;
@property (assign, nonatomic) IBOutlet UIImageView *qrcodeView;
@property (assign, nonatomic) IBOutlet UILabel *receiveMoneyLabel;
@property (assign, nonatomic) IBOutlet UILabel *inviteCodeLabel;
@property (assign, nonatomic) IBOutlet UIButton *shareButton;

@property (retain, nonatomic) IBOutlet UIView *invitedView;
@property (assign, nonatomic) IBOutlet UITextField *invitedPeopleTextfield;
@property (assign, nonatomic) IBOutlet UILabel *errorMessage;
@property (assign, nonatomic) IBOutlet UIButton *invitedButton;
@property (assign, nonatomic) IBOutlet UILabel *inviterLabel;
@property (retain, nonatomic) IBOutlet UIImageView *errorImage;

@property (retain, nonatomic) NSArray* priorConstraints;

@property (assign, nonatomic) NSUInteger receiveMoney;
@property (copy, nonatomic) NSString* inviteCode;
@property (copy, nonatomic) NSString* invitedPeople;

- (IBAction)copy:(id)sender;
- (IBAction)share:(id)sender;
- (IBAction)switchView:(id)sender;
- (IBAction)clickBack:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)updateInviter:(id)sender;

@end
