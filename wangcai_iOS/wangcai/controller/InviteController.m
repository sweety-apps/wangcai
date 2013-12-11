//
//  InviteController.m
//  wangcai
//
//  Created by 1528 on 13-12-11.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "InviteController.h"

@interface InviteController ()

@end

@implementation InviteController
@synthesize _myInviteLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self->_inviteCode = @"inviteCode";
        
        self.title = @"邀请送红包";
        
        UIView* view = [[[NSBundle mainBundle] loadNibNamed:nibNameOrNil owner:self options:nil] firstObject];
        self.view = view;
        [view release];
        
        [self->_myInviteLabel setText:self->_inviteCode];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self->_inviteCode release];
    [super dealloc];
}

- (IBAction) copyToClip:(id)sender {
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self->_inviteCode;
}

@end
