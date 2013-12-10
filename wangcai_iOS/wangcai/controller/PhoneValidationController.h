//
//  PhoneValidationController.h
//  wangcai
//
//  Created by 1528 on 13-12-9.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhoneValidation.h"

@interface PhoneValidationController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate, PhoneValidationDelegate> {
    IBOutlet UIView* viewInputNum;
    IBOutlet UIView* viewCheckNum;
    
    IBOutlet UITextField* textNum;
    IBOutlet UIButton* nextNumBtn;
    
    IBOutlet UITextField* textCheck1;
    IBOutlet UITextField* textCheck2;
    IBOutlet UITextField* textCheck3;
    IBOutlet UITextField* textCheck4;
    IBOutlet UITextField* textCheck5;
    IBOutlet UITextField* textCheck6;
    
    IBOutlet UIButton* btnCheckNum;
    
    NSString*  _phoneNum;
    NSString*  _token;
    
    CGFloat    keyboardTop;
    int        alertState;
    int        curState;
    CGRect     btnRect;
    
    PhoneValidation* phoneValidation;
}

@property (nonatomic, retain) UIView* viewInputNum;
@property (nonatomic, retain) UITextField* textNum;
@property (nonatomic, retain) UIButton* nextNumBtn;
@property (nonatomic, retain) UIView* viewCheckNum;
@property (nonatomic, retain) UITextField* textCheck1;
@property (nonatomic, retain) UITextField* textCheck2;
@property (nonatomic, retain) UITextField* textCheck3;
@property (nonatomic, retain) UITextField* textCheck4;
@property (nonatomic, retain) UITextField* textCheck5;
@property (nonatomic, retain) UITextField* textCheck6;
@property (nonatomic, retain) UIButton* btnCheckNum;

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text

- (IBAction)clickNext:(id)sender;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void) sendSMSCompleted : (BOOL) suc errMsg:(NSString*) errMsg token:(NSString*) token;
- (void) checkSmsCodeCompleted : (BOOL) suc errMsg:(NSString*) errMsg UserId:(NSString*) userId Nickname:(NSString*)nickname;
@end
