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
    
    UIView* _viewInputNum;
    UIView* _viewCheckNum;
    UIView* _viewRegSuccess;
    
    // TAB
    UIImageView* _tab1;
    UIImageView* _tab2;
    UIImageView* _tab3;
    
    // 输入手机号
    UITextField* textNum;
    UIButton* nextNumBtn;
    IBOutlet UIImageView* _imageArrow;
    
    // 输入验证码
    UITextField* textCheck1;
    UITextField* textCheck2;
    UITextField* textCheck3;
    UITextField* textCheck4;
    UITextField* textCheck5;
    int        _nTime;
    UIButton* btnCheckNum;
    UILabel* _phoneLabel;
    
    NSTimer*    _timer;
    
    NSString*  _phoneNum;
    NSString*  _token;
    
    int        alertState;
    int        curState;
    
    PhoneValidation* phoneValidation;
    TabController* _tabController;
    
    BOOL          _bSend;
}

@property (nonatomic, retain) IBOutlet UIImageView* _imageArrow;

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text

- (IBAction)clickNext:(id)sender;
- (IBAction)clickBack:(id)sender;
- (IBAction)clickResend:(id)sender;

- (void)setBackType:(BOOL)bSend;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

-(void) attachPhoneCompleted : (BOOL) suc Token:(NSString*)token errMsg:(NSString*)errMsg;
- (void) sendSMSCompleted : (BOOL) suc errMsg:(NSString*) errMsg token:(NSString*) token;
- (void) checkSmsCodeCompleted : (BOOL) suc errMsg:(NSString*) errMsg UserId:(NSString*) userId Nickname:(NSString*)nickname;

-(void)attachEvent;
-(void)detachEvent;
@end
