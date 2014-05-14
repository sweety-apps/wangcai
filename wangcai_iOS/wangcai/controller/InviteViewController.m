//
//  InviteViewController.m
//  wangcai
//
//  Created by NPHD on 14-5-13.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "InviteViewController.h"
#import "MBHUDView.h"
#import "UIGetRedBagAlertView.h"
#import "BaseTaskTableViewController.h"
#import "NSString+FloatFormat.h"

@interface InviteViewController ()

@end

@implementation InviteViewController
@synthesize inputInviteTip;
@synthesize _invitedPeopleTextfield;
@synthesize clearBtn;
@synthesize errorMessage;
@synthesize errorMsgBkg;
@synthesize invitedButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _inviterUpdate = [[InviterUpdate alloc] init];
}

- (void)dealloc {
    [_inviterUpdate release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setUIStack:(BeeUIStack*) stack {
    _stack = stack;
}

- (IBAction)clickBack:(id)sender {
    [_stack popViewControllerAnimated:YES];
}


#pragma mark - Text Field Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.inputInviteTip setHidden:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString* text = textField.text;
    NSUInteger n = text.length;
    if ( n == 0 ) {
        [self.inputInviteTip setHidden:NO];
    } else {
        [self.inputInviteTip setHidden:YES];
    }
    
    if ( n == 0 ) {
        [clearBtn setHidden:YES];
    } else {
        [clearBtn setHidden:NO];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {  // return NO to not change text
    if ([@"\n" isEqualToString:string] ) {
        NSString* text = textField.text;
        NSUInteger n = text.length;
        
        if ( n == 0 ) {
            [clearBtn setHidden:YES];
        } else {
            [clearBtn setHidden:NO];
        }
        
        [_invitedPeopleTextfield resignFirstResponder];
        return NO;
    }
    
    NSString* text = textField.text;
    NSUInteger n = text.length;
    
    if ( n == 0 ) {
        [clearBtn setHidden:YES];
    } else {
        [clearBtn setHidden:NO];
    }
    
    return YES;
}

- (IBAction)clickClose:(id)sender {
    if ( [_invitedPeopleTextfield isEnabled] ) {
        [_invitedPeopleTextfield setText:@""];
        [clearBtn setHidden:YES];
    }
}

- (IBAction)updateInviter:(id)sender
{
    NSString* inviter = _invitedPeopleTextfield.text;
    if (inviter != nil)
    {
        [_inviterUpdate updateInviter: inviter delegate: self];
        [self showLoading];
        
        // 隐藏错误信息
        [errorMessage setHidden:YES];
        [errorMsgBkg setHidden:YES];
    }
}

- (void)showLoading
{
    [MBHUDView hudWithBody: @"请等待..." type:MBAlertViewHUDTypeActivityIndicator hidesAfter: -1 show: YES];
}

- (void)hideLoading
{
    [MBHUDView dismissCurrentHUD];
}

- (void)updateErrorMsg: (BOOL)error msg: (NSString *)errMsg
{
    if (error)
    {
        [self.errorMsgBkg setHidden: NO];
        [self.errorMessage setHidden: NO];
        [self.errorMessage setText: errMsg];
    }
    else
    {
        [self.errorMsgBkg setHidden: YES];
        [self.errorMessage setHidden: YES];
    }
}

- (void)updateInviterCompleted:(BOOL)suc errMsg:(NSString *)errMsg
{
    [self hideLoading];
    if (suc)
    {
        // 发送成功
        [self setInvitedPeople: _invitedPeopleTextfield.text];
        [self updateInvitersControls: YES];
        [self updateErrorMsg: NO msg: nil];
        
        UIGetRedBagAlertView* getMoneyAlertView = [UIGetRedBagAlertView sharedInstance];
        [getMoneyAlertView setRMBString:[NSString stringWithFloatRoundToPrecision:2 precision:2 ignoreBackZeros:YES]];
        [getMoneyAlertView setLevel:3];
        [getMoneyAlertView setTitle:@"邀请码红包"];
        [getMoneyAlertView setShowCurrentBanlance:[[LoginAndRegister sharedInstance] getBalance] andIncrease:200];
        [getMoneyAlertView show];
        
        // 给用户加二块钱
        [[LoginAndRegister sharedInstance] increaseBalance:200];
        [BaseTaskTableViewController setNeedReloadTaskList];
    }
    else
    {
        // 发送失败
        if (errMsg == nil)
        {
            [self updateErrorMsg: YES msg: @"绑定邀请人失败"];
        }
        else
        {
            [self updateErrorMsg: YES msg: errMsg];
        }
    }
}


- (void)setInvitedPeople: (NSString *)invitedPeople
{
    _invitedPeopleTextfield.text = invitedPeople;
}

- (void)updateInvitersControls: (BOOL)hasInviter
{
    if (hasInviter)
    {
        _invitedPeopleTextfield.enabled = NO;
        invitedButton.hidden = YES;
    }
    else
    {
        _invitedPeopleTextfield.enabled = YES;
        invitedButton.hidden = NO;
    }
}


@end
