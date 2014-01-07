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
#import "UICustomAlertView.h"

@interface TransferToAlipayAndPhoneController : UIViewController<UITextFieldDelegate> {
    BOOL _bAlipay;
    float _price;
    UICustomAlertView* _alertView;
}

@property (assign, nonatomic) UIView *_completeView;
@property (assign, nonatomic) UIView *_containerView;
@property (assign, nonatomic) UITextField *_textField;
@property (assign, nonatomic) UITextField *_textCheck;

@property (assign, nonatomic) UILabel *_textFieldTip;
@property (assign, nonatomic) UILabel *_textCheckTip;

- (id) init:(BOOL) isAlipay Price:(float) price;

- (IBAction)clickBack:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)clickNext:(id)sender;

- (IBAction)clickOrderInfo:(id)sender;

- (IBAction)clickCancel:(id)sender;
- (IBAction)clickContinue:(id)sender;
@end
