//
//  PhoneValidationController.m
//  wangcai
//
//  Created by 1528 on 13-12-9.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "PhoneValidationController.h"
#import "MBHUDView.h"

@interface PhoneValidationController ()
@end

@implementation PhoneValidationController

@synthesize viewCheckNum;
@synthesize viewInputNum;
@synthesize textNum;
@synthesize nextNumBtn;
@synthesize textCheck1;
@synthesize textCheck2;
@synthesize textCheck3;
@synthesize textCheck4;
@synthesize textCheck5;
@synthesize textCheck6;
@synthesize btnCheckNum;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"绑定手机";

        [self showFirstPage];
        
        self.textNum.delegate = self;
        self.textNum.textAlignment = UITextAlignmentCenter;
        self.nextNumBtn.enabled = NO;
        
        self.textCheck1.delegate = self;
        self.textCheck2.delegate = self;
        self.textCheck3.delegate = self;
        self.textCheck4.delegate = self;
        self.textCheck5.delegate = self;
        self.textCheck6.delegate = self;
     
        self.textCheck1.clearsOnBeginEditing = YES;
        self.textCheck2.clearsOnBeginEditing = YES;
        self.textCheck3.clearsOnBeginEditing = YES;
        self.textCheck4.clearsOnBeginEditing = YES;
        self.textCheck5.clearsOnBeginEditing = YES;
        self.textCheck6.clearsOnBeginEditing = YES;
 
        self.btnCheckNum.enabled = NO;
        
        self->phoneValidation = [[PhoneValidation alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) dealloc {
    [self->phoneValidation dealloc];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {    // Called when the view is about to made visible. Default does nothing
    // 绑定键盘事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fieldTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated { // Called when the view is dismissed, covered or otherwise hidden. Default does nothing
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow: (NSNotification*) notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    self->keyboardTop = keyboardRect.size.height;
    CGRect newBtnViewFrame;
    
    if ( self->curState == 0 ) {
        newBtnViewFrame = self.nextNumBtn.frame;
        newBtnViewFrame.origin.y = self.nextNumBtn.frame.origin.y - keyboardTop;
    } else if ( self->curState == 1 ) {
        // 进入第二步
        newBtnViewFrame = self.btnCheckNum.frame;
        newBtnViewFrame.origin.y = self.btnCheckNum.frame.origin.y - keyboardTop;
    }
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    if ( self->curState == 0 ) {
        self.nextNumBtn.frame = newBtnViewFrame;
    } else if ( self->curState == 1 ) {
        self.btnCheckNum.frame = newBtnViewFrame;
    }
    
    btnRect = newBtnViewFrame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide: (NSNotification*) notification {
    NSDictionary* userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    CGRect newBtnViewFrame;
    
    if ( self->curState == 0 ) {
        newBtnViewFrame = self.nextNumBtn.frame;
        newBtnViewFrame.origin.y = keyboardTop + self.nextNumBtn.frame.origin.y;
    
        [self.nextNumBtn setFrame:newBtnViewFrame];
    } else {
        newBtnViewFrame = self.btnCheckNum.frame;
        newBtnViewFrame.origin.y = keyboardTop + self.btnCheckNum.frame.origin.y;
        
        [self.btnCheckNum setFrame:newBtnViewFrame];
    }
    
    [UIView commitAnimations];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {  // return NO to not change text
    if ( self->curState == 0 ) {
        if ( [string isEqualToString:@""] ) {
            self.nextNumBtn.enabled = NO;
            return YES;
        }
        
        if ( self.textNum.text.length + string.length <= 11 ) {
            if ( self.textNum.text.length + string.length == 11 ) {
                self.nextNumBtn.enabled = YES;
            } else {
                self.nextNumBtn.enabled = NO;
            }
            
            return YES;
        }
    } else if ( self->curState == 1 ) {
        if ( string.length > 1 || range.location >= 1 ) {
            return NO;
        }
        
        return YES;
    }

    return NO;
}

- (BOOL) checkPhoneNum : phoneNum {
    if ( [phoneNum length] != 11 ) {
        // 长度不对
        return NO;
    }
    
    for (NSUInteger i = 0; i < [phoneNum length]; i ++ ) {
        unichar uc = [phoneNum characterAtIndex:i];
        if ( !isnumber(uc) ) {
            return NO;
        }
    }
    
    return YES;
}

- (IBAction)clickNext:(id)sender {
    if ( self->curState == 0 ) {
        NSString* phoneNum = self.textNum.text;
        if ( [self checkPhoneNum : phoneNum] ) {
            // 发送验证码，进入loading
            [self->phoneValidation sendCheckNumToPhone:phoneNum delegate:self ];
            [self showLoading];
        
            return ;
        }
    
        self->_phoneNum = phoneNum;
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入有效的手机号码" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    } else if ( self->curState == 1 ) {
        NSString* checkNum = [self getCheckCode];
        
        if ( checkNum.length != 6 ) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入6位数的验证码" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        } else {
            //
            [self showLoading];
            // 给服务器发送验证请求
            [self->phoneValidation checkSmsCode:self->_phoneNum smsCode:checkNum Token:self->_token delegate:self];
        }
    }
}

- (void) showLoading {
    [MBHUDView hudWithBody:@"请等待..." type:MBAlertViewHUDTypeActivityIndicator hidesAfter:-1 show:YES];
}

- (void) hideLoading {
    [MBHUDView dismissCurrentHUD];
}

- (NSString*) getCheckCode {
    NSString* checkNum = @"";
    if ( self.textCheck1.text.length == 1 ) {
        checkNum = [checkNum stringByAppendingString:self.textCheck1.text];
    }
    
    if ( self.textCheck2.text.length == 1 ) {
        checkNum = [checkNum stringByAppendingString:self.textCheck2.text];
    }
    
    if ( self.textCheck3.text.length == 1 ) {
        checkNum = [checkNum stringByAppendingString:self.textCheck3.text];
    }
    
    if ( self.textCheck4.text.length == 1 ) {
        checkNum = [checkNum stringByAppendingString:self.textCheck4.text];
    }
    
    if ( self.textCheck5.text.length == 1 ) {
        checkNum = [checkNum stringByAppendingString:self.textCheck5.text];
    }
    
    if ( self.textCheck6.text.length == 1 ) {
        checkNum = [checkNum stringByAppendingString:self.textCheck6.text];
    }
    
    return checkNum;
}

- (void)fieldTextChanged: (NSNotification*) notification {
    if ( self->curState == 1 ) {
        UITextField* field =  notification.object;
        if ( field.text.length >= 1 ) {
            if ( [field isEqual:self.textCheck1] ) {
                [self.textCheck2 becomeFirstResponder];
            } else if ( [field isEqual:self.textCheck2] ) {
                [self.textCheck3 becomeFirstResponder];
            } else if ( [field isEqual:self.textCheck3] ) {
                [self.textCheck4 becomeFirstResponder];
            } else if ( [field isEqual:self.textCheck4] ) {
                [self.textCheck5 becomeFirstResponder];
            } else if ( [field isEqual:self.textCheck5] ) {
                [self.textCheck6 becomeFirstResponder];
            }
        }
        
        NSString* code = [self getCheckCode];
        if ( code.length == 6 ) {
            self.btnCheckNum.enabled = YES;
        } else {
            self.btnCheckNum.enabled = NO;
        }
    }
}

- (void) showFirstPage {
    self->curState = 0;
    self.view = [[[NSBundle mainBundle] loadNibNamed:@"PhoneValidationController" owner:self options:nil] firstObject];
}

- (void) showSecondPage {
    self->curState = 1;
    [self.view addSubview:self.viewCheckNum];
}

- (void) sendSMSCompleted : (BOOL) suc errMsg:(NSString*) errMsg  token:(NSString*) token {
    [self hideLoading];
    if ( suc ) {
        // 发送完成，进入下一步
        self->_token = [token copy];
        [self showSecondPage];
    } else {
        // 发送失败，错误提示
        if ( errMsg == nil ) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"发送验证短信失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:errMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
}

- (void) checkSmsCodeCompleted : (BOOL) suc errMsg:(NSString*) errMsg UserId:(NSString*) userId Nickname:(NSString*)nickname {
    [self hideLoading];
    if ( suc ) {
        // 发送完成，进入下一步
        //[self showSecondPage];
    } else {
        // 发送失败，错误提示
        if ( errMsg == nil ) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"发送验证短信失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:errMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
}

@end
