//
//  InviteViewController.h
//  wangcai
//
//  Created by NPHD on 14-5-13.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InviterUpdate.h"

@interface InviteViewController : UIViewController <UITextFieldDelegate, InviterUpdateDelegate> {
    BeeUIStack* _stack;
    InviterUpdate* _inviterUpdate;
}

- (void) setUIStack:(BeeUIStack*) stack;

- (IBAction)clickBack:(id)sender;

@property (nonatomic, retain) IBOutlet UILabel* inputInviteTip;
@property (nonatomic, retain) IBOutlet UITextField* _invitedPeopleTextfield;
@property (nonatomic, retain) IBOutlet UIButton* clearBtn;
@property (retain, nonatomic) IBOutlet UILabel *errorMessage;
@property (retain, nonatomic) IBOutlet UIImageView* errorMsgBkg;
@property (retain, nonatomic) IBOutlet UIButton* invitedButton;

- (IBAction)clickClose:(id)sender;

- (IBAction)updateInviter:(id)sender;

@end
