//
//  PhoneValidationController.h
//  wangcai
//
//  Created by 1528 on 13-12-9.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhoneValidation.h"
#import "TabController.h"

@interface PhoneValidationController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate, PhoneValidationDelegate> {
    UIView* _mainView;
    IBOutlet UIView* _viewInputNum;
    IBOutlet UIView* _viewCheckNum;
    IBOutlet UIView* _viewRegSuccess;
    
    // TAB
    UIImageView* _tab1;
    UIImageView* _tab2;
    UIImageView* _tab3;
    
    // 输入手机号
    IBOutlet UITextField* textNum;
    IBOutlet UIButton* nextNumBtn;
    IBOutlet UIImageView* _imageArrow;
    
    // 输入验证码
    IBOutlet UITextField* textCheck1;
    IBOutlet UITextField* textCheck2;
    IBOutlet UITextField* textCheck3;
    IBOutlet UITextField* textCheck4;
    IBOutlet UITextField* textCheck5;
    int        _nTime;
    IBOutlet UIButton* btnCheckNum;
    UILabel* _phoneLabel;
    
    NSTimer*    _timer;
    
    NSString*  _phoneNum;
    NSString*  _token;
    
    int        alertState;
    int        curState;
    
    PhoneValidation* phoneValidation;
    TabController* _tabController;
}

@property (nonatomic, retain) IBOutlet UIView* _viewInputNum;
@property (nonatomic, retain) IBOutlet UIView* _viewCheckNum;
@property (nonatomic, retain) IBOutlet UIView* _viewRegSuccess;

@property (nonatomic, retain) IBOutlet UITextField* textNum;
@property (nonatomic, retain) IBOutlet UIButton* nextNumBtn;
@property (nonatomic, retain) IBOutlet UITextField* textCheck1;
@property (nonatomic, retain) IBOutlet UITextField* textCheck2;
@property (nonatomic, retain) IBOutlet UITextField* textCheck3;
@property (nonatomic, retain) IBOutlet UITextField* textCheck4;
@property (nonatomic, retain) IBOutlet UITextField* textCheck5;

@property (nonatomic, retain) IBOutlet UIButton* btnCheckNum;
@property (nonatomic, retain) IBOutlet UIImageView* _imageArrow;

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text

- (IBAction)clickNext:(id)sender;
- (IBAction)clickBack:(id)sender;
- (IBAction)clickResend:(id)sender;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void) sendSMSCompleted : (BOOL) suc errMsg:(NSString*) errMsg token:(NSString*) token;
- (void) checkSmsCodeCompleted : (BOOL) suc errMsg:(NSString*) errMsg UserId:(NSString*) userId Nickname:(NSString*)nickname;
@end
